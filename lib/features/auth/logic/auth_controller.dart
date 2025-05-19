import 'package:flutter/material.dart';
import 'package:mobile_labs/core/utils/network_service.dart';
import 'package:mobile_labs/data/local/shared_prefs_user_repository.dart';
import 'package:mobile_labs/domain/models/user.dart';

class AuthController {
  final repo = SharedPrefsUserRepository();

  Future<String?> register(String name, String email, String password) async {
    final existingUser = await repo.getCurrentUser();
    if (existingUser != null && existingUser.email == email) {
      return 'Користувач вже існує';
    }
    await repo.registerUser(User(name: name, email: email, password: password));
    return null;
  }

  Future<User?> login(BuildContext context,
      String email, String password,) async {
    final hasConnection = await NetworkService().checkConnection();
    if (!context.mounted) return null;
    if (!hasConnection) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Немає підключення до Інтернету'),
        ),
      );
      return null;
    }

    return await repo.loginUser(email, password);
  }
}
