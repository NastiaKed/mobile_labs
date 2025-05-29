part of 'saved_qr_cubit.dart';

abstract class SavedQrState {}

class SavedQrLoading extends SavedQrState {}

class SavedQrSuccess extends SavedQrState {
  final String message;
  SavedQrSuccess(this.message);
}

class SavedQrError extends SavedQrState {
  final String error;
  SavedQrError(this.error);
}
