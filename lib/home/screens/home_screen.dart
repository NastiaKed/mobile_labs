import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/home/cubit/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  final bool showOfflineWarning;
  const HomeScreen({super.key, this.showOfflineWarning = false});

  Future<bool> _confirmExit(BuildContext context) async {
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
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<HomeCubit>();

          if (showOfflineWarning) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    '⚠️ Немає підключення до Інтернету. '
                        'Деякі функції можуть бути недоступні.',
                  ),
                ),
              );
            });
          }

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (!didPop) {
                final shouldExit = await _confirmExit(context);
                if (context.mounted && shouldExit) {
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
                      style: TextStyle(fontSize: 24,
                          fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '💡 Порада дня: використовуйте маркери '
                          'петель, щоб не збитися в узорі.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text('Поточні проєкти:', style:
                    TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          return ListView.builder(
                            itemCount: state.projects.length,
                            itemBuilder: (context, index) => Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: ListTile(
                                title: Text(state.projects[index]),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  cubit.selectProject(state.projects[index]);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Ви вибрали: ${state.projects[index]}',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
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
                                  content: Text
                                    ('Функціонал додавання проекту в розробці'),
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
        },
      ),
    );
  }
}
