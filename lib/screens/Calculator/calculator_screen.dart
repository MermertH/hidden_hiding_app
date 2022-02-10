import 'package:flutter/material.dart';
import 'package:hidden_hiding_app/screens/Calculator/calculator_buttons.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:google_fonts/google_fonts.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  var userInput = '';
  var answer = '';

// Array of button
  final List<String> buttons = [
    'C',
    '+/-',
    '%',
    'DEL',
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    'x',
    '1',
    '2',
    '3',
    '-',
    '0',
    '.',
    '=',
    '+',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Calculator",
                      style: GoogleFonts.aldrich(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(45),
                      bottomRight: Radius.circular(45),
                    )),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  // boxShadow: const [
                  //   BoxShadow(
                  //     offset: Offset(0, 0),
                  //     blurRadius: 1,
                  //     color: Colors.black12,
                  //     spreadRadius: 1,
                  //   ),
                  // ],
                  border: Border.all(
                    width: 5,
                    color: Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(35),
                            topLeft: Radius.circular(35),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.centerRight,
                        child: Text(
                          userInput,
                          style: GoogleFonts.aldrich(
                            fontSize: 30,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        alignment: Alignment.centerRight,
                        child: Text(answer,
                            style: GoogleFonts.aldrich(
                              fontSize: 45,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                      )
                    ]),
              ),
            ),
            Expanded(
              flex: 7,
              child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    // Clear Button
                    if (index == 0) {
                      return CalculatorButtons(
                        buttontapped: () {
                          setState(() {
                            userInput = '';
                            answer = '0';
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.grey[800],
                        textColor: Colors.white,
                      );
                    }

                    // +/- button
                    else if (index == 1) {
                      return CalculatorButtons(
                        buttonText: buttons[index],
                        color: Colors.grey[800],
                        textColor: Colors.white,
                      );
                    }
                    // % Button
                    else if (index == 2) {
                      return CalculatorButtons(
                        buttontapped: () {
                          setState(() {
                            userInput += buttons[index];
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.grey[800],
                        textColor: Colors.white,
                      );
                    }
                    // Delete Button
                    else if (index == 3) {
                      return CalculatorButtons(
                        buttontapped: () {
                          setState(() {
                            userInput =
                                userInput.substring(0, userInput.length - 1);
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.grey[800],
                        textColor: Colors.white,
                      );
                    }
                    // Equal_to Button
                    else if (index == 18) {
                      return CalculatorButtons(
                        buttontapped: () {
                          setState(() {
                            equalPressed();
                          });
                        },
                        buttonText: buttons[index],
                        color: Colors.black87,
                        textColor: Colors.white,
                      );
                    }

                    // other buttons
                    else {
                      return CalculatorButtons(
                        buttontapped: () {
                          setState(() {
                            userInput += buttons[index];
                          });
                        },
                        buttonText: buttons[index],
                        color: isOperator(buttons[index])
                            ? Colors.black87
                            : Colors.grey[200],
                        textColor: isOperator(buttons[index])
                            ? Colors.white
                            : Colors.black,
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  bool isOperator(String x) {
    if (x == '/' || x == 'x' || x == '-' || x == '+' || x == '=') {
      return true;
    }
    return false;
  }

// function to calculate the input operation
  void equalPressed() {
    String finaluserinput = userInput;
    finaluserinput = userInput.replaceAll('x', '*');

    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    answer = eval.toString();
  }
}
