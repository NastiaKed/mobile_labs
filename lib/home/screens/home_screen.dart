import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final bool showOfflineWarning;
  const HomeScreen({super.key, this.showOfflineWarning = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> crochetProjects = const [
    '🌸 Ковдра з бабусиних квадратів',
    '🧣 Теплий зимовий шарф',
    '🧶 Амігурумі зайчик',
    '👜 В’яжена бохо-сумка',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.showOfflineWarning) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '⚠️ Немає підключення до Інтернету. '
                    'Деякі функції можуть бути недоступні.',
              ),
            ),
          );
        }
      });
    }
  }

  Future<bool> _confirmExit() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Вихід з додатку'),
        content: const Text('Ви справді хочете вийти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Скасувати'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Вийти'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          final shouldExit = await _confirmExit();
          if (!context.mounted) return;
          if (shouldExit && mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
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
                          SnackBar(
                            content: Text(
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Функціонал додавання '
                                'проекту в розробці'),
                          ),
                        );
                      },
                      child: const Text('➕ Додати проєкт'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/counter'),
                      child: const Text('🧵 Сенсор петель'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
