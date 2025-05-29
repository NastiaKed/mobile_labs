import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobile_labs/core/theme/colors.dart' show customPink;
import 'package:mobile_labs/core/utils/network_service.dart';
import 'package:mobile_labs/data/local/shared_prefs_user_repository.dart';

import 'package:mobile_labs/features/auth/screens/login_screen.dart';
import 'package:mobile_labs/features/auth/screens/register_screen.dart';
import 'package:mobile_labs/features/profile/screens/profile_screen.dart';
import 'package:mobile_labs/home/cubit/home_cubit.dart';
import 'package:mobile_labs/home/screens/home_screen.dart';
import 'package:mobile_labs/home/screens/stitch_counter_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userRepository = SharedPrefsUserRepository();
  final currentUser = await userRepository.getCurrentUser();
  final isLoggedIn = currentUser != null;

  final hasInternet = await NetworkService().checkConnection();

  runApp(CrochetApp(
    isLoggedIn: isLoggedIn,
    showOfflineWarning: isLoggedIn && !hasInternet,
  ),
  );
}

class CrochetApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool showOfflineWarning;

  const CrochetApp({
    required this.isLoggedIn,
    required this.showOfflineWarning,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: MaterialApp(
        title: 'Crochet',
        theme: ThemeData(
          scaffoldBackgroundColor: customPink.shade100,
          primarySwatch: customPink,
          useMaterial3: false,
        ),
        initialRoute: isLoggedIn ? '/home' : '/',
        routes: {
          '/': (context) =>  LoginScreen(),
          '/register': (context) =>  RegisterScreen(),
          '/profile': (context) =>  ProfileScreen(),
          '/home': (context) => const HomeScreen(),
          '/counter': (context) => const StitchCounterScreen(),
        },
      ),
    );
  }
}
