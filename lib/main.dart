import 'package:flutter/material.dart';

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

void main() {
  runApp(const CrochetApp());
}

class CrochetApp extends StatelessWidget {
  const CrochetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crochet',
      theme: ThemeData(
        scaffoldBackgroundColor: customPink.shade100,
        primarySwatch: customPink,
        useMaterial3: false,
      ),
      initialRoute: '/',
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
      appBar: AppBar(title: const Text('Log In')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Log In', style: TextStyle(fontSize: 24)),
            const TextField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/home'),
              child: const Text('Log In'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Go to Register'),
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
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Register', style: TextStyle(fontSize: 24)),
            const TextField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            const TextField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Register'),
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
  String nickname = 'User123';
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
      appBar: AppBar(title: const Text('Profile')),
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
                      if (isEditing) TextField(
                        controller: _nicknameController,
                        decoration: const InputDecoration(
                          labelText: 'Enter new nickname',
                        ),
                      ) else Text(
                        nickname,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _toggleEditing,
                        child: Text(isEditing ? 'Save' : 'Change Nickname'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Align(
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/home'),
                child: const Text('Go to Home'),
              ),
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
              '💡 Порада дня: використовуйте маркери петель, щоб не збитися '
                  'в узорі.',
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
                    onTap: () {
                      // Майбутня навігація до деталей проєкту
                    },
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
                      const SnackBar(content: Text('Додавання нового проєкту в '
                          'розробці'),),
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
