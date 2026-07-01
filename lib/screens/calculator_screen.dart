import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // Math package import kiya

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  var userInput = '';
  var answer = '0';

  final List<String> buttons = [
    'C',
    'DEL',
    '%',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '00',
    '0',
    '.',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Display Area
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    userInput,
                    style: const TextStyle(fontSize: 32, color: Colors.white54),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    answer,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white24),
          // Keypad Area
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      _onButtonPressed(buttons[index]);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getButtonColor(buttons[index]),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          buttons[index],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _getTextColor(buttons[index]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  BUTTON LOGIC
  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        userInput = '';
        answer = '0';
      } else if (buttonText == 'DEL') {
        if (userInput.isNotEmpty) {
          userInput = userInput.substring(0, userInput.length - 1);
        }
      } else if (buttonText == '=') {
        _calculateMath();
      } else {
        userInput += buttonText;
      }
    });
  }

  //  MATH CALCULATION LOGIC
  void _calculateMath() {
    try {
      String finalUserInput = userInput;
      finalUserInput = finalUserInput.replaceAll(
        'x',
        '*',
      ); // 'x' ko math wale '*' se replace kiya

      Parser p = Parser();
      Expression exp = p.parse(finalUserInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        answer = eval.toString();
        // Agar answer '5.0' jaisa hai, toh '.0' hata do clean dikhne ke liye
        if (answer.endsWith('.0')) {
          answer = answer.substring(0, answer.length - 2);
        }
      });
    } catch (e) {
      setState(() {
        answer = "Error"; // Agar user galat format dale jaise "++8"
      });
    }
  }

  //  UI COLORS HELPER
  Color _getButtonColor(String x) {
    if (x == 'C') return Colors.redAccent.withOpacity(0.8);
    if (x == 'DEL') return Colors.orangeAccent.withOpacity(0.8);
    if (x == '=' || x == '+' || x == '-' || x == 'x' || x == '/' || x == '%')
      return Colors.deepPurpleAccent.withOpacity(0.8);
    return Colors.grey[900]!;
  }

  Color _getTextColor(String x) {
    if (x == 'C' ||
        x == 'DEL' ||
        x == '=' ||
        x == '+' ||
        x == '-' ||
        x == 'x' ||
        x == '/' ||
        x == '%')
      return Colors.white;
    return Colors.white70;
  }
}
