import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/domain/models/user.dart';
import 'package:mobile_labs/features/profile/cubit/profile_state.dart';
import 'package:mobile_labs/features/profile/logic/profile_controller.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileController _controller;

  ProfileCubit(this._controller) : super(ProfileInitial()) {
    loadUser();
  }

  void loadUser() async {
    emit(ProfileLoading());
    final user = await _controller.getUser();
    if (user != null) {
      emit(ProfileLoaded(user));
    } else {
      emit(ProfileError('Користувача не знайдено'));
    }
  }

  void toggleEdit() {
    if (state is ProfileLoaded) {
      final current = state as ProfileLoaded;
      emit(ProfileLoaded(current.user, editing: !current.editing));
    }
  }

  void updateUser(User updatedUser) async {
    emit(ProfileLoading());
    await _controller.updateUser(updatedUser);
    emit(ProfileLoaded(updatedUser));
  }

  Future<void> logout(Function onSuccess) async {
    await _controller.logout();
    onSuccess();
  }
}
