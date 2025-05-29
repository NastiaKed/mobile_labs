import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/features/usb/usb_manager.dart';
import 'package:mobile_labs/features/usb/usb_service.dart';
import 'package:usb_serial/usb_serial.dart';

part 'qr_scanner_state.dart';

class QRScannerCubit extends Cubit<QRScannerState> {
  final UsbManager _usbManager;
  bool hasScanned = false;

  QRScannerCubit()
      : _usbManager = UsbManager(UsbService()),
        super(QRScannerInitial());

  Future<void> sendToArduino(String code) async {
    if (hasScanned) return;
    hasScanned = true;

    emit(QRScannerLoading());

    final port = await _usbManager.selectDevice();
    if (port == null) {
      emit(QRScannerError('❌ Arduino не знайдено'));
      return;
    }

    await _usbManager.sendData('$code\n');

    final response = await _waitForArduinoResponse(port);
    emit(QRScannerSuccess(code, response));
  }

  Future<String> _waitForArduinoResponse(
      UsbPort port, {
        Duration timeout = const Duration(seconds: 2),
      }) async {
    final completer = Completer<String>();
    String buffer = '';
    late StreamSubscription<Uint8List> sub;

    sub = port.inputStream!.listen(
          (event) {
        buffer += String.fromCharCodes(event);
        if (buffer.contains('\n')) {
          completer.complete(buffer.trim());
          sub.cancel();
        }
      },
      onError: (Object error) {
        sub.cancel();
        completer.completeError('❌ Помилка читання: $error');
      },
      cancelOnError: true,
    );

    return completer.future.timeout(
      timeout,
      onTimeout: () {
        sub.cancel();
        return '⏱ Arduino не відповів';
      },
    );
  }
}
