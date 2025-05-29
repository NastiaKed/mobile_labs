import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/domain/models/user.dart';
import 'package:mobile_labs/features/auth/cubit/auth_state.dart';
import 'package:mobile_labs/features/auth/logic/auth_controller.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthController _authController;

  AuthCubit(this._authController) : super(AuthInitial());

  Future<void> login(BuildContext context, String email, String password,
      Function onSuccess,) async {
    emit(AuthLoading());

    final User? user = await _authController.login(
      context,
      email,
      password,
    );

    if (user != null) {
      emit(AuthSuccess());
      onSuccess();
    } else {
      emit(AuthFailure('Невірний email або пароль'));
    }
  }


  Future<void> register(String name, String email, String password,
      Function onSuccess,) async {
    emit(AuthLoading());

    final String? error = await _authController.register(name, email, password);

    if (error == null) {
      emit(AuthSuccess());
      onSuccess();
    } else {
      emit(AuthFailure(error));
    }
  }

}
