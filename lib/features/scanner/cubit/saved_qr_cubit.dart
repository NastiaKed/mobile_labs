import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/features/usb/usb_manager.dart';
import 'package:mobile_labs/features/usb/usb_service.dart';
import 'package:usb_serial/usb_serial.dart';

part 'saved_qr_state.dart';

class SavedQrCubit extends Cubit<SavedQrState> {
  final UsbManager _usbManager;

  SavedQrCubit() : _usbManager = UsbManager(UsbService()),
        super(SavedQrLoading()) {
    readMessage();
  }

  Future<void> readMessage() async {
    emit(SavedQrLoading());

    await _usbManager.dispose();
    final port = await _usbManager.selectDevice();

    if (port == null) {
      emit(SavedQrError('❌ Arduino не знайдено'));
      return;
    }

    await Future<void>.delayed(const Duration(milliseconds: 500));

    try {
      final response = await _readFromArduino(port);
      emit(SavedQrSuccess(response));
    } catch (e) {
      emit(SavedQrError(e.toString()));
    }
  }

  Future<String> _readFromArduino(UsbPort port) async {
    final completer = Completer<String>();
    String buffer = '';

    StreamSubscription<Uint8List>? sub;
    sub = port.inputStream?.listen(
          (data) {
        buffer += String.fromCharCodes(data);
        if (buffer.contains('\n')) {
          sub?.cancel();
          completer.complete(buffer.trim());
        }
      },
      onError: (Object error) {
        sub?.cancel();
        completer.completeError('❌ Помилка читання: $error');
      },
      cancelOnError: true,
    );

    return completer.future.timeout(
      const Duration(seconds: 3),
      onTimeout: () {
        sub?.cancel();
        return '⏱ Немає відповіді від Arduino';
      },
    );
  }
}
