import 'package:flutter/material.dart';
import 'package:mobile_labs/core/utils/validators.dart';
import 'package:mobile_labs/features/auth/logic/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  final _auth = AuthController();
  String? _error;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final error = await _auth.register(
        _name.text,
        _email.text,
        _password.text,
      );
      if(!mounted) return;
      if (error != null) {
        setState(() => _error = error);
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Реєстрація')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
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
            ElevatedButton(onPressed: _submit, child: const Text(
                'Зареєструватися',
            ),
            ),
          ],),
        ),
      ),
    );
  }
}
