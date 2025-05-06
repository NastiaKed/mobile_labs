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

  Future<User?> login(String email, String password) async {
    return await repo.loginUser(email, password);
  }
}
