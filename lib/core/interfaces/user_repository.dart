import 'package:mobile_labs/domain/models/user.dart';

abstract class UserRepository {
  Future<void> registerUser(User user);
  Future<User?> loginUser(String email, String password);
  Future<User?> getCurrentUser();
  Future<void> logoutUser();
  Future<void> updateUser(User user);
}
