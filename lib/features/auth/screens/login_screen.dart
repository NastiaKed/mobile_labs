import 'package:flutter/material.dart';
import 'package:mobile_labs/core/utils/validators.dart';
import 'package:mobile_labs/domain/models/user.dart';
import 'package:mobile_labs/features/auth/logic/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  final _auth = AuthController();
  String? _error;
  bool _loading = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _error = null;
      });

      final User? user = await _auth.login(context,
          _email.text, _password.text,);

      if (!mounted) return;

      setState(() => _loading = false);

      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          _error = 'Невірний email або пароль';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вхід')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_error != null)
                Text(_error!, style: const TextStyle(color: Colors.red)),
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
              if (_loading) const CircularProgressIndicator()
              else ElevatedButton(
                onPressed: _submit,
                child: const Text('Увійти'),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text('Немає акаунта? Зареєструватися'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
