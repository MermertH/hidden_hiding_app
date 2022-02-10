import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// creating Stateless Widget for buttons
class CalculatorButtons extends StatelessWidget {
// declaring variables
  final color;
  final textColor;
  final String? buttonText;
  final buttontapped;

//Constructor
  const CalculatorButtons({
    Key? key,
    this.color,
    this.textColor,
    this.buttonText,
    this.buttontapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttontapped,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                offset: Offset(10, 10),
                blurRadius: 5,
                color: Colors.grey,
                spreadRadius: 0.1,
              ),
            ],
            color: color,
          ),
          child: Center(
            child: Text(
              buttonText!,
              style: GoogleFonts.aldrich(
                color: textColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
