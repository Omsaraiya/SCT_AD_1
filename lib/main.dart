import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData.dark(useMaterial3: true),
      home: const CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<CalculatorHome> createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
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
                      // Logic will go here
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

  // Helper method for Button Colors
  Color _getButtonColor(String x) {
    if (x == 'C') return Colors.redAccent.withOpacity(0.8);
    if (x == 'DEL') return Colors.orangeAccent.withOpacity(0.8);
    if (x == '=' || x == '+' || x == '-' || x == 'x' || x == '/' || x == '%')
      return Colors.deepPurpleAccent.withOpacity(0.8);
    return Colors.grey[900]!;
  }

  // Helper method for Text Colors
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
