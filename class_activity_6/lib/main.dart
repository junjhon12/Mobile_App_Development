import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:window_size/window_size.dart';

void main() {
  setupWindow();

  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;

const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();

    setWindowTitle('Provider Counter');

    setWindowMinSize(const Size(windowWidth, windowHeight));

    setWindowMaxSize(const Size(windowWidth, windowHeight));

    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

/// Simplest possible model, with just one field.
class Counter with ChangeNotifier {
  int value = 0;

  final int minValue = 0;
  final int maxValue = 10;

  void increment() {
    if (value < maxValue) {
      value += 1;
      notifyListeners();
    }
  }

  void decrement() {
    if (value > minValue) {
      value -= 1;
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You have pushed the button this many times:'),
            Consumer<Counter>(
              builder: (context, counter, child) => Text(
                '${counter.value}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    var counter = context.read<Counter>();
                    counter.decrement();
                  },
                  tooltip: 'Decrement',
                  icon: const Icon(Icons.remove),
                ),
                IconButton(
                  onPressed: () {
                    var counter = context.read<Counter>();
                    counter.increment();
                  },
                  tooltip: 'Increment',
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            Consumer<Counter>(
              builder: (context, counter, child) => Text(
                counter.value == counter.maxValue
                    ? "You've reached the max limit"
                    : counter.value == counter.minValue
                        ? "You've reached the min limit"
                        : '',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var counter = context.read<Counter>();
          counter.increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
