import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/features/scanner/cubit/qr_scanner_cubit.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QRScannerCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Сканування QR-коду')),
        body: Stack(
          children: [
            BlocBuilder<QRScannerCubit, QRScannerState>(
              builder: (context, state) {
                return MobileScanner(
                  onDetect: (capture) {
                    final cubit = context.read<QRScannerCubit>();
                    if (cubit.hasScanned) return;

                    final barcode = capture.barcodes.first;
                    final code = barcode.rawValue;
                    if (code != null) {
                      cubit.sendToArduino(code);
                      Future.delayed(const Duration(seconds: 3), () {
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                );
              },
            ),
            BlocListener<QRScannerCubit, QRScannerState>(
              listener: (context, state) {
                if (state is QRScannerError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is QRScannerSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('✅ QR: ${state.code}\n📬 '
                          'Відповідь: ${state.response}'),
                    ),
                  );
                }
              },
              child: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
