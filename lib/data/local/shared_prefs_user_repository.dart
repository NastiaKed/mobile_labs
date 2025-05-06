import 'dart:convert';

import 'package:mobile_labs/core/interfaces/user_repository.dart';
import 'package:mobile_labs/domain/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsUserRepository implements UserRepository {
  static const _userKey = 'user_data';

  @override
  Future<void> registerUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toMap()));
  }

  @override
  Future<User?> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data != null) {
      final user = User.fromMap(jsonDecode(data) as Map<String, dynamic>);
      if (user.email == email && user.password == password) {
        return user;
      }
    }
    return null;
  }

  @override
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data != null) {
      return User.fromMap(jsonDecode(data) as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Future<void> logoutUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  @override
  Future<void> updateUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toMap()));
  }
}
