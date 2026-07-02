import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:math_expressions/math_expressions.dart'; // For math logic
import 'package:intl/intl.dart'; // For formatting numbers with commas

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
      backgroundColor: const Color(
        0xFF121212,
      ), // Theme Color 1: Very Dark Grey Background
      body: Column(
        children: [
          // --- DISPLAY AREA ---
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Scrollable Input Area to prevent Overflow Error
                  Expanded(
                    child: SingleChildScrollView(
                      reverse:
                          true, // Automatically scrolls to show the latest typed number
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          userInput,
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white54,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Auto-Shrinking Answer Area
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      answer,
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Divider(color: Colors.white24, height: 1),

          // --- KEYPAD AREA ---
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
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getButtonColor(buttons[index]),
                        borderRadius: BorderRadius.circular(15),
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

  // --- LOGIC FUNCTIONS ---
  // --- BUTTON LOGIC ---
  void _onButtonPressed(String buttonText) {
    HapticFeedback.lightImpact();

    setState(() {
      if (buttonText == 'C') {
        userInput = '';
        answer = '0';
      } else if (buttonText == 'DEL') {
        if (userInput.isNotEmpty) {
          userInput = userInput.substring(0, userInput.length - 1);
        }
        _calculateLivePreview(); // Update preview on delete
      } else if (buttonText == '=') {
        _calculateMath(isFinal: true); // Show final answer
      } else {
        // --- BUG FIX: Prevent multiple operators (e.g., ++ or +x) ---
        if (_isOperator(buttonText)) {
          if (userInput.isNotEmpty) {
            String lastChar = userInput[userInput.length - 1];
            if (_isOperator(lastChar)) {
              // Agar last character bhi operator tha, toh usko naye wale se replace kar do
              userInput =
                  userInput.substring(0, userInput.length - 1) + buttonText;
              return;
            }
          }
        }

        userInput += buttonText;
        _calculateLivePreview(); // Update preview as user types
      }
    });
  }

  // Helper method to check if character is operator
  bool _isOperator(String x) {
    return x == '+' || x == '-' || x == 'x' || x == '/' || x == '%';
  }

  // --- LIVE PREVIEW LOGIC ---
  void _calculateLivePreview() {
    try {
      if (userInput.isEmpty) {
        answer = '0';
        return;
      }

      // Agar last character operator hai, toh preview mat dikhao (wait for number)
      if (_isOperator(userInput[userInput.length - 1])) {
        return;
      }

      String finalUserInput = userInput.replaceAll('x', '*');
      Parser p = Parser();
      Expression exp = p.parse(finalUserInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      if (eval % 1 == 0) {
        answer = NumberFormat.decimalPattern('en_US').format(eval.toInt());
      } else {
        answer = NumberFormat.decimalPattern('en_US').format(eval);
      }
    } catch (e) {
      // Live preview mein agar expression incomplete hai, toh error mat dikhao
    }
  }

  // --- FINAL EQUAL BUTTON LOGIC ---
  void _calculateMath({bool isFinal = false}) {
    _calculateLivePreview();
  }

  // --- UI THEME HELPER FUNCTIONS ---
  Color _getButtonColor(String x) {
    if (x == 'C' || x == 'DEL') {
      return const Color(
        0xFFD32F2F,
      ); // Theme Color 2: Muted Red for Clear/Delete
    } else if (x == '=' ||
        x == '+' ||
        x == '-' ||
        x == 'x' ||
        x == '/' ||
        x == '%') {
      return const Color(
        0xFF1976D2,
      ); // Theme Color 3: Professional Blue for Operators
    }
    return const Color(0xFF1E1E1E); // Basic Dark Grey for Numbers
  }

  Color _getTextColor(String x) {
    return Colors.white; // Uniform white text for readability
  }
}
