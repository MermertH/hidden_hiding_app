import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecretWordsDialog extends StatefulWidget {
  final bool isPasswordSet;
  const SecretWordsDialog({
    Key? key,
    required this.isPasswordSet,
  }) : super(key: key);

  @override
  State<SecretWordsDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<SecretWordsDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.isPasswordSet
                  ? "Please backup all of the given words in order to be able to recover your vault in case you forgot your combination or secret pin"
                  : "Please enter your recovery keys respectively",
              textAlign: TextAlign.center,
            ),
          ),
          // TODO generate secret keys or get input from user to recover vault
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: GoogleFonts.abel(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    primary: Colors.orange[500],
                    onPrimary: Colors.black),
                onPressed: () {},
                child: const Text("Understood"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
