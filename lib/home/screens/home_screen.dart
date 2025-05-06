import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final List<String> crochetProjects = const [
    '🌸 Ковдра з бабусиних квадратів',
    '🧣 Теплий зимовий шарф',
    '🧶 Амігурумі зайчик',
    '👜 В’яжена бохо-сумка',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Головна'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            icon: const Icon(Icons.account_circle),
          ),
        ],
      ),
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
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(
                            'Ви вибрали: ${crochetProjects[index]}',
                        ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                        'Функціонал додавання проекту в розробці',
                    ),
                    ),
                  );
                },
                child: const Text('➕ Додати проєкт'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
