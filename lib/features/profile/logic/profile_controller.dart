import 'package:mobile_labs/data/local/shared_prefs_user_repository.dart';
import 'package:mobile_labs/domain/models/user.dart';

class ProfileController {
  final repo = SharedPrefsUserRepository();

  Future<User?> getUser() async {
    return await repo.getCurrentUser();
  }

  Future<void> updateUser(User user) async {
    await repo.updateUser(user);
  }

  Future<void> logout() async {
    await repo.logoutUser();
  }
}
