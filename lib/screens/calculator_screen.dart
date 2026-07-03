import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  var userInput = '';
  var answer = '0';
  bool isCalculated =
      false; // Yeh naya variable track karega ki '=' press hua ya nahi

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
      backgroundColor: const Color(0xFF121212),
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
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
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

                  // --- THE POP-OUT ANIMATION EFFECT ---
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontSize: isCalculated ? 56 : 32,
                        fontWeight: isCalculated
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCalculated ? Colors.white : Colors.white38,
                      ),
                      child: Text(answer),
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

  // --- BUTTON LOGIC ---
  void _onButtonPressed(String buttonText) {
    HapticFeedback.lightImpact();

    setState(() {
      if (buttonText == 'C') {
        userInput = '';
        answer = '0';
        isCalculated = false;
      } else if (buttonText == 'DEL') {
        if (userInput.isNotEmpty) {
          userInput = userInput.substring(0, userInput.length - 1);
        }
        isCalculated = false;
        _calculateLivePreview();
      } else if (buttonText == '=') {
        _calculateMath(isFinal: true);
      } else {
        if (_isOperator(buttonText)) {
          if (userInput.isNotEmpty) {
            String lastChar = userInput[userInput.length - 1];
            if (_isOperator(lastChar)) {
              userInput =
                  userInput.substring(0, userInput.length - 1) + buttonText;
              isCalculated = false;
              return;
            }
          }
        }

        userInput += buttonText;
        isCalculated = false;
        _calculateLivePreview();
      }
    });
  }

  bool _isOperator(String x) {
    return x == '+' || x == '-' || x == 'x' || x == '/' || x == '%';
  }

  void _calculateLivePreview() {
    try {
      if (userInput.isEmpty) {
        answer = '0';
        return;
      }

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
    } catch (e) {}
  }

  void _calculateMath({bool isFinal = false}) {
    _calculateLivePreview();
    if (isFinal) {
      setState(() {
        isCalculated = true;
      });
    }
  }

  Color _getButtonColor(String x) {
    if (x == 'C' || x == 'DEL') {
      return const Color(0xFFD32F2F);
    } else if (x == '=' ||
        x == '+' ||
        x == '-' ||
        x == 'x' ||
        x == '/' ||
        x == '%') {
      return const Color(0xFF1976D2);
    }
    return const Color(0xFF1E1E1E);
  }

  Color _getTextColor(String x) {
    return Colors.white;
  }
}
