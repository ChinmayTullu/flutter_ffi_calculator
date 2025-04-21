import 'package:flutter/material.dart';
import 'rust_bridge.dart'; // FFI bindings to Rust functions

void main() {
  runApp(const CalculatorApp());
}

/// Root widget for the app
class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rust FFI Calculator',
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Public StatefulWidget for the calculator screen
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  CalculatorScreenState createState() => CalculatorScreenState();
}

/// Public State class (was private before) for CalculatorScreen
class CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  String _result = '';

  /// Parse text input to double, fallback to 0 if invalid
  double _parse(String text) => double.tryParse(text) ?? 0;

  /// Calls the appropriate Rust function based on the operation symbol
  void _calculate(String op) {
    final a = _parse(_controller1.text);
    final b = _parse(_controller2.text);
    double res;

    switch (op) {
      case '+':
        res = add(a, b);
        break;
      case '-':
        res = subtract(a, b);
        break;
      case '*':
        res = multiply(a, b);
        break;
      case '/':
        res = divide(a, b);
        break;
      default:
        res = double.nan;
    }

    setState(() {
      _result = res.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rust Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller1,
              decoration: const InputDecoration(labelText: 'First number'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _controller2,
              decoration: const InputDecoration(labelText: 'Second number'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['+', '-', '*', '/'].map((op) {
                return ElevatedButton(
                  onPressed: () => _calculate(op),
                  child: Text(op, style: const TextStyle(fontSize: 20)),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Result: $_result',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
