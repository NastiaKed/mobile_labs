import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/core/utils/validators.dart';
import 'package:mobile_labs/features/auth/cubit/auth_cubit.dart';
import 'package:mobile_labs/features/auth/cubit/auth_state.dart';
import 'package:mobile_labs/features/auth/logic/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  void _onLoginSuccess(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(AuthController()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Вхід')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                String? error;
                if (state is AuthFailure) {
                  error = state.error;
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (error != null)
                      Text(error, style: const TextStyle(color: Colors.red)),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (val) => Validators.validateEmail(val!),
                    ),
                    TextFormField(
                      controller: _password,
                      decoration: const InputDecoration(labelText: 'Пароль'),
                      obscureText: true,
                      validator: (val) => Validators.validatePassword(val!),
                    ),
                    const SizedBox(height: 20),
                    if (state is AuthLoading)
                      const CircularProgressIndicator()
                    else
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(
                              context,
                              _email.text,
                              _password.text,
                                  () => _onLoginSuccess(context),
                            );
                          }
                        },
                        child: const Text('Увійти'),
                      ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                      child: const Text('Немає акаунта? Зареєструватися'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
