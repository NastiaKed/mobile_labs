import 'package:flutter/material.dart';
import 'package:mobile_labs/services/mqtt_service.dart';

class StitchCounterScreen extends StatefulWidget {
  const StitchCounterScreen({super.key});

  @override
  State<StitchCounterScreen> createState() => _StitchCounterScreenState();
}

class _StitchCounterScreenState extends State<StitchCounterScreen> {
  late MQTTClientWrapper _mqttClient;
  int _stitchCount = 0;

  @override
  void initState() {
    super.initState();

    _mqttClient = MQTTClientWrapper(
      host: 'url',
      clientIdentifier: 'flutter_stitch_${
          DateTime.now().millisecondsSinceEpoch}',
      username: 'admin',
      password: 'pas',
      onData: ({int? stitch}) {
        if (stitch != null) {
          setState(() {
            _stitchCount = stitch;
          });
        }
      },
    );

    _mqttClient.prepareMqttClient();
  }

  void _resetCounter() {
    setState(() {
      _stitchCount = 0;
    });
  }

  @override
  void dispose() {
    _mqttClient.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Лічильник петель')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '📡 Отримання даних з сенсора...',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              'Петель: $_stitchCount',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetCounter,
              child: const Text('🔁 Скинути'),
            ),
          ],
        ),
      ),
    );
  }
}
