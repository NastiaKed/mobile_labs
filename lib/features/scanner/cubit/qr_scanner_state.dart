part of 'qr_scanner_cubit.dart';

abstract class QRScannerState {}

class QRScannerInitial extends QRScannerState {}

class QRScannerLoading extends QRScannerState {}

class QRScannerSuccess extends QRScannerState {
  final String code;
  final String response;
  QRScannerSuccess(this.code, this.response);
}

class QRScannerError extends QRScannerState {
  final String message;
  QRScannerError(this.message);
}
