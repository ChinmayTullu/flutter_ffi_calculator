import 'package:flutter/material.dart';
import 'rust_bridge.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rust FFI Calculator',
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  String _result = '';

  double _parse(String text) => double.tryParse(text) ?? 0;

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
      appBar: AppBar(title: Text('Rust Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _controller1, decoration: InputDecoration(labelText: 'First number'), keyboardType: TextInputType.number),
            TextField(controller: _controller2, decoration: InputDecoration(labelText: 'Second number'), keyboardType: TextInputType.number),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['+', '-', '*', '/'].map((op) {
                return ElevatedButton(
                  onPressed: () => _calculate(op),
                  child: Text(op, style: TextStyle(fontSize: 20)),
                );
              }).toList(),
            ),
            SizedBox(height: 24),
            Text('Result: $_result', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
