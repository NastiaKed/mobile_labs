import 'package:flutter/material.dart';

import 'package:mobile_labs/core/utils/validators.dart';
import 'package:mobile_labs/domain/models/user.dart';
import 'package:mobile_labs/features/profile/logic/profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _controller = ProfileController();
  User? _user;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final user = await _controller.getUser();
    if (user != null) {
      setState(() {
        _user = user;
        _nameController.text = user.name;
        _emailController.text = user.email;
        _passwordController.text = user.password;
      });
    }
  }

  void _toggleEdit() {
    setState(() => _editing = !_editing);
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedUser = User(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      await _controller.updateUser(updatedUser);
      _toggleEdit();
      _loadUser();
    }
  }

  void _logout() async {
    await _controller.logout();
    if (!mounted) return;
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            if (_editing)
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Ім’я'),
                validator: (val) => Validators.validateName(val!),
              )
            else
              Text('👤 Ім’я: ${_user!.name}', style: const TextStyle(
                  fontSize: 18,
              ),
              ),

            const SizedBox(height: 10),

            if (_editing)
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (val) => Validators.validateEmail(val!),
              )
            else
              Text('📧 Email: ${_user!.email}', style: const TextStyle(
                  fontSize: 18,
              ),
              ),

            const SizedBox(height: 10),

            if (_editing)
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Пароль'),
                validator: (val) => Validators.validatePassword(val!),
              ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _editing ? _saveChanges : _toggleEdit,
                  child: Text(_editing ? '💾 Зберегти' : '✏️ Редагувати'),
                ),
                ElevatedButton(
                  onPressed: _logout,
                  child: const Text('🚪 Вийти'),
                ),
              ],
            ),
          ],),
        ),
      ),
    );
  }
}
