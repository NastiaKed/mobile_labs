import 'package:flutter/material.dart';
import 'package:mobile_labs/data/local/shared_prefs_user_repository.dart';
import 'package:mobile_labs/features/auth/screens/login_screen.dart';
import 'package:mobile_labs/features/auth/screens/register_screen.dart';
import 'package:mobile_labs/features/profile/screens/profile_screen.dart';
import 'package:mobile_labs/home/screens/home_screen.dart';
import 'package:mobile_labs/theme/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repo = SharedPrefsUserRepository();
  final user = await repo.getCurrentUser();

  runApp(CrochetApp(isLoggedIn: user != null));
}

class CrochetApp extends StatelessWidget {
  final bool isLoggedIn;
  const CrochetApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crochet',
      theme: ThemeData(
        scaffoldBackgroundColor: customPink.shade100,
        primarySwatch: customPink,
        useMaterial3: false,
      ),
      initialRoute: isLoggedIn ? '/home' : '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
