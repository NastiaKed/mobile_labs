import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/core/utils/validators.dart';
import 'package:mobile_labs/domain/models/user.dart';
import 'package:mobile_labs/features/profile/cubit/profile_cubit.dart';
import 'package:mobile_labs/features/profile/cubit/profile_state.dart';
import 'package:mobile_labs/features/profile/logic/profile_controller.dart';
import 'package:mobile_labs/features/scanner/qr_scanner_screen.dart';
import 'package:mobile_labs/features/scanner/saved_qr_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _setControllers(User user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _passwordController.text = user.password;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(ProfileController()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Профіль')),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileError) {
              return Center(child: Text(state.message));
            }

            if (state is ProfileLoaded) {
              final cubit = context.read<ProfileCubit>();
              final user = state.user;
              final editing = state.editing;

              _setControllers(user);

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (editing)
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Ім’я'),
                          validator: (val) =>
                              Validators.validateName(val ?? ''),
                        )
                      else
                        Text('👤 Ім’я: ${user.name}',
                            style: const TextStyle(fontSize: 18),),

                      const SizedBox(height: 10),

                      if (editing)
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (val) =>
                              Validators.validateEmail(val ?? ''),
                        )
                      else
                        Text('📧 Email: ${user.email}',
                            style: const TextStyle(fontSize: 18),),

                      const SizedBox(height: 10),

                      if (editing)
                        TextFormField(
                          controller: _passwordController,
                          decoration:
                          const InputDecoration(labelText: 'Пароль'),
                          obscureText: true,
                          validator: (val) =>
                              Validators.validatePassword(val ?? ''),
                        ),

                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (editing) {
                                if (_formKey.currentState!.validate()) {
                                  final updatedUser = User(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                  cubit.updateUser(updatedUser);
                                }
                              } else {
                                cubit.toggleEdit();
                              }
                            },
                            child: Text(editing
                                ? '💾 Зберегти'
                                : '✏️ Редагувати',),
                          ),
                          ElevatedButton(
                            onPressed: () => cubit.logout(() {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/', (_) => false,);
                            }),
                            child: const Text('🚪 Вийти'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                                builder: (_) => const QRScannerScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text('Відсканувати QR'),
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                                builder: (_) => const SavedQrScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.save_alt),
                        label:
                        const Text('Переглянути збережене повідомлення'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
