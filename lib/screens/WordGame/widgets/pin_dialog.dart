import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_hiding_app/models/user_data.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/secret_words_dialog.dart';
import 'package:hidden_hiding_app/services/storage_service.dart';

class PinDialog extends StatefulWidget {
  final bool isPasswordSet;
  final bool isInVault;
  const PinDialog({
    Key? key,
    required this.isPasswordSet,
    required this.isInVault,
  }) : super(key: key);

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  var encryptedStorage = StorageService();
  var digit1 = TextEditingController();
  var digit2 = TextEditingController();
  var digit3 = TextEditingController();
  var digit4 = TextEditingController();
  int wrongPinCount = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: widget.isInVault ? null : Colors.amber[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.isPasswordSet && !widget.isInVault
                  ? "Please enter four digits to create your secret pin"
                  : widget.isInVault
                      ? "Enter your new secret pin"
                      : "Please enter your secret pin",
              textAlign: TextAlign.center,
              style: GoogleFonts.abel(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: widget.isInVault ? Colors.white : Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                pinInputFields(digit1, "digit1"),
                pinInputFields(digit2, "digit2"),
                pinInputFields(digit3, "digit3"),
                pinInputFields(digit4, "digit4"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                interactionButtons("Cancel"),
                interactionButtons("Clear"),
                interactionButtons("Submit"),
              ],
            ),
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
          primary: widget.isInVault ? Colors.grey[600] : Colors.orange[500],
          onPrimary: widget.isInVault ? Colors.white : Colors.black),
      onPressed: () async {
        switch (buttonName) {
          case "Cancel":
            Navigator.of(context).pop();
            break;
          case "Clear":
            digit1.clear();
            digit2.clear();
            digit3.clear();
            digit4.clear();
            break;
          case "Submit":
            if (widget.isPasswordSet) {
              await encryptedStorage.writeSecureData(UserData(
                  key: "secretPin",
                  value:
                      "${digit1.text},${digit2.text},${digit3.text},${digit4.text}"));
              showDialog(
                  context: context,
                  builder: (context) => SecretWordsDialog(
                        isPasswordSet: widget.isPasswordSet,
                        isRecoveryMode: false,
                      ));
            } else {
              await encryptedStorage
                  .readSecureData("secretPin")
                  .then((secretPin) {
                if (secretPin!.split(",")[0] == digit1.text &&
                    secretPin.split(",")[1] == digit2.text &&
                    secretPin.split(",")[2] == digit3.text &&
                    secretPin.split(",")[3] == digit4.text) {
                  Navigator.of(context).pushNamed("/VaultMainScreen");
                } else {
                  wrongPinCount++;
                  if (wrongPinCount == 3) {
                    wrongPinCount = 0;
                    showDialog(
                        context: context,
                        builder: (context) => const SecretWordsDialog(
                              isPasswordSet: false,
                              isRecoveryMode: true,
                            ));
                  }
                }
              });
            }
            break;
          default:
            return;
        }
      },
      child: Text(buttonName),
    );
  }

  Widget pinInputFields(TextEditingController controller, String fieldName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        obscureText: true,
        autofocus: true,
        cursorColor: Colors.black,
        cursorWidth: 3,
        textInputAction:
            fieldName == "digit4" ? TextInputAction.done : TextInputAction.next,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: GoogleFonts.abel(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          constraints: const BoxConstraints(
            maxWidth: 50,
          ),
          filled: true,
          fillColor: const Color(0xFFF2F2F2),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 2,
                color: widget.isInVault ? Colors.grey : Colors.amber[700]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 2,
                color: widget.isInVault ? Colors.grey : Colors.amber[700]!),
          ),
        ),
      ),
    );
  }
}
