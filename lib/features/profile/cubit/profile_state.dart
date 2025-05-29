import 'package:mobile_labs/domain/models/user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  final bool editing;

  ProfileLoaded(this.user, {this.editing = false});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
