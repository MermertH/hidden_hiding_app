import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PinDialog extends StatefulWidget {
  final bool isPasswordSet;
  const PinDialog({
    Key? key,
    required this.isPasswordSet,
  }) : super(key: key);

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  var digit1 = TextEditingController();
  var digit2 = TextEditingController();
  var digit3 = TextEditingController();
  var digit4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(widget.isPasswordSet
                ? "Please enter four digits to create your secret pin"
                : "Please enter your secret pin"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              pinInputFields(digit1),
              pinInputFields(digit2),
              pinInputFields(digit3),
              pinInputFields(digit4),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              interactionButtons("Clear"),
              interactionButtons("Submit"),
            ],
          ),
        ],
      ),
    );
  }

  Widget interactionButtons(String buttonName) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          textStyle: GoogleFonts.abel(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          primary: Colors.orange[500],
          onPrimary: Colors.black),
      onPressed: () {
        switch (buttonName) {
          case "Clear":
            break;
          case "Submit":
            break;
          default:
            return;
        }
      },
      child: Text(buttonName),
    );
  }

  Widget pinInputFields(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: GoogleFonts.abel(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        cursorColor: Colors.black,
        cursorWidth: 3,
        decoration: InputDecoration(
          constraints: const BoxConstraints(
            maxWidth: 50,
          ),
          filled: true,
          fillColor: const Color(0xFFF2F2F2),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.amber[700]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.amber[700]!),
          ),
        ),
      ),
    );
  }
}
