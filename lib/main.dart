import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

MaterialColor customPink = const MaterialColor(
  0xFFF48FB1,
  <int, Color>{
    50: Color(0xFFFCE4EC),
    100: Color(0xFFF8BBD0),
    200: Color(0xFFF48FB1),
    300: Color(0xFFF06292),
    400: Color(0xFFEC407A),
    500: Color(0xFFE91E63),
    600: Color(0xFFD81B60),
    700: Color(0xFFC2185B),
    800: Color(0xFFAD1457),
    900: Color(0xFF880E4F),
  },
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final loggedIn = prefs.getBool('loggedIn') ?? false;

  runApp(CrochetApp(loggedIn: loggedIn));
}

class CrochetApp extends StatelessWidget {
  final bool loggedIn;
  const CrochetApp({required this.loggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crochet',
      theme: ThemeData(
        scaffoldBackgroundColor: customPink.shade100,
        primarySwatch: customPink,
        useMaterial3: false,
      ),
      initialRoute: loggedIn ? '/home' : '/',
      routes: {
        '/': (context) => const LogIn(),
        '/register': (context) => const Register(),
        '/profile': (context) => const UserProfile(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вхід')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Вхід', style: TextStyle(fontSize: 24)),
            const TextField(
              decoration: InputDecoration(labelText: 'Логін'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('loggedIn', true);
                if (context.mounted) {
                  Navigator.pushNamed(context, '/home');
                }
              },
              child: const Text('Увійти'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Перейти до реєстрації'),
            ),
          ],
        ),
      ),
    );
  }
}

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Реєстрація')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Реєстрація', style: TextStyle(fontSize: 24)),
            const TextField(
              decoration: InputDecoration(labelText: 'Логін'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('loggedIn', true);
                if (context.mounted) {
                  Navigator.pushNamed(context, '/home');
                }
              },
              child: const Text('Зареєструватися'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String nickname = 'Користувач';
  bool isEditing = false;
  final TextEditingController _nicknameController = TextEditingController();

  void _toggleEditing() {
    setState(() {
      isEditing = !isEditing;
      if (isEditing) {
        _nicknameController.text = nickname;
      } else {
        nickname = _nicknameController.text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профіль')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/image/avatar.png'),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isEditing)
                        TextField(
                          controller: _nicknameController,
                          decoration: const InputDecoration(
                            labelText: 'Новий нікнейм',
                          ),
                        )
                      else
                        Text(
                          nickname,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _toggleEditing,
                        child: Text(isEditing ? 'Зберегти' : 'Змінити нікнейм'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('loggedIn');
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                }
              },
              child: const Text('🚪 Вийти з профілю'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<String> crochetProjects = const [
    '🌸 Ковдра з бабусиних квадратів',
    '🧣 Теплий зимовий шарф',
    '🧶 Амігурумі зайчик',
    '👜 В’яжена бохо-сумка',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Головна')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ласкаво просимо у світ в’язання гачком!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '💡 Порада дня: використовуйте маркери петель, '
                  'щоб не збитися в узорі.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text('Поточні проєкти:', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: crochetProjects.length,
                itemBuilder: (context, index) => Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(crochetProjects[index]),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Додавання нового '
                          'проєкту в розробці'),),
                    );
                  },
                  child: const Text('➕ Додати проєкт'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                  child: const Text('👤 Профіль'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
