import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/core/utils/validators.dart';
import 'package:mobile_labs/features/auth/cubit/auth_cubit.dart';
import 'package:mobile_labs/features/auth/cubit/auth_state.dart';
import 'package:mobile_labs/features/auth/logic/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  void _onRegisterSuccess(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(AuthController()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Реєстрація')),
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
                  children: [
                    if (error != null)
                      Text(error, style: const TextStyle(color: Colors.red)),
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(labelText: 'Ім’я'),
                      validator: (val) => Validators.validateName(val!),
                    ),
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
                            context.read<AuthCubit>().register(
                              _name.text,
                              _email.text,
                              _password.text,
                                  () => _onRegisterSuccess(context),
                            );
                          }
                        },
                        child: const Text('Зареєструватися'),
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
