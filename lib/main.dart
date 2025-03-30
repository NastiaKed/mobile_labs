import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CounterApp',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int _counter = 0;
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<Color?> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _backgroundAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.green[100],
    ).animate(_animationController);
  }

  void _incrementCounter() {
    setState(() {
      final String inputText = _controller.text.trim();

      if (inputText == 'Avada Kedavra') {
        _counter = 0;
      } else {
        final int? value = int.tryParse(inputText);
        if (value != null) {
          _counter += value;
        }
      }

      if (_counter > 50) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  String? _getMessage() {
    if (_counter >= 20 && _counter < 40) {
      return 'Обережно, не переборщи';
    } else if (_counter >= 40 && _counter < 80) {
      return 'Ти вже на грані';
    } else if (_counter >= 80 && _counter < 200) {
      return 'Ти колись зупинишся чи нє!?!?!?';
    } else if (_counter >= 200 && _counter < 300) {
      return 'Я зараз почну погрожувати!!!!';
    } else if (_counter >= 300 && _counter < 1000) {
      return 'Тільки не дійди до 2000';
    } else if (_counter >= 2000 && _counter < 100000) {
      return 'Ну все...Гайки....Ти викликав їжака';
    }
    return null;
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _backgroundAnimation.value,
          appBar: AppBar(title: const Text('Мемний лічильник')),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Лічильник: $_counter',
                  style: const TextStyle(fontSize: 24),
                ),
                if (_getMessage() != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      _getMessage()!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (_counter >= 2000 && _counter < 100000)
                  Image.asset('assets/image/hedgehog.png', height: 150),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Введіть число або "Avada Kedavra"',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: const Text('Додати до лічильника'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
