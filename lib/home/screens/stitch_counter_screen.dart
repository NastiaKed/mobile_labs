import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/home/cubit/stitch_counter_cubit.dart';
import 'package:mobile_labs/services/mqtt_service.dart';

class StitchCounterScreen extends StatelessWidget {
  const StitchCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = StitchCounterCubit();
        final mqtt = MQTTClientWrapper(
          host: 'URL',
          clientIdentifier:
          'flutter_stitch_${DateTime.now().millisecondsSinceEpoch}',
          username: 'admin',
          password: 'PASS',
          onData: ({int? stitch}) {
            if (stitch != null) {
              cubit.updateStitchCount(stitch);
            }
          },
        );
        mqtt.prepareMqttClient();

        cubit.stream.listen((_) {}).onDone(mqtt.disconnect);

        return cubit;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Лічильник петель')),
        body: Center(
          child: BlocBuilder<StitchCounterCubit, StitchCounterState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '📡 Отримання даних з сенсора...',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Петель: ${state.count}',
                    style: const TextStyle(fontSize: 48,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.read<StitchCounterCubit>().reset(),
                    child: const Text('🔁 Скинути'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
