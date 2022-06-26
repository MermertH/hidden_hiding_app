import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_hiding_app/global.dart';
import 'package:hidden_hiding_app/models/user_data.dart';
import 'package:hidden_hiding_app/screens/SecretVault/vault_main_screen.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/secret_words_dialog.dart';
import 'package:hidden_hiding_app/services/storage_service.dart';

class PinDialog extends StatefulWidget {
  final bool isPasswordSet;
  final bool isInVault;
  final bool isTutorial;
  const PinDialog({
    Key? key,
    required this.isPasswordSet,
    required this.isInVault,
    required this.isTutorial,
  }) : super(key: key);

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  var encryptedStorage = StorageService();
  List<FocusNode> inputFocus = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  List<TextEditingController> digits = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  int wrongPinCount = 0;

  @override
  void dispose() {
    for (var focus in inputFocus) {
      focus.dispose();
    }
    super.dispose();
  }

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
                pinInputFields(digits[0], 0),
                pinInputFields(digits[1], 1),
                pinInputFields(digits[2], 2),
                pinInputFields(digits[3], 3),
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
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return GoogleFonts.abel(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              );
            }
            return GoogleFonts.abel(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            );
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            var color = widget.isInVault ? Colors.white : Colors.black;
            if (states.contains(MaterialState.disabled)) {
              return color;
            }
            return color;
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            var color =
                widget.isInVault ? Colors.grey[600] : Colors.orange[500];
            if (states.contains(MaterialState.disabled)) {
              return color!;
            }
            return color!;
          },
        ),
      ),
      onPressed: !widget.isTutorial
          ? () async {
              switch (buttonName) {
                case "Cancel":
                  Navigator.of(context).pop();
                  break;
                case "Clear":
                  for (var controller in digits) {
                    controller.clear();
                  }
                  break;
                case "Submit":
                  if (widget.isPasswordSet) {
                    if (digits[0].text.isNotEmpty &&
                        digits[1].text.isNotEmpty &&
                        digits[2].text.isNotEmpty &&
                        digits[3].text.isNotEmpty) {
                      await encryptedStorage.writeSecureData(UserData(
                          key: "secretPin",
                          value:
                              "${digits[0].text},${digits[1].text},${digits[2].text},${digits[3].text}"));
                      if (!widget.isInVault) {
                        showDialog(
                            context: context,
                            builder: (context) => SecretWordsDialog(
                                  isPasswordSet: widget.isPasswordSet,
                                  isRecoveryMode: false,
                                  isTutorial: false,
                                ));
                      } else {
                        Navigator.of(context).pop();
                      }
                    }
                  } else {
                    await encryptedStorage
                        .readSecureData("secretPin")
                        .then((secretPin) {
                      if (secretPin!.split(",")[0] == digits[0].text &&
                          secretPin.split(",")[1] == digits[1].text &&
                          secretPin.split(",")[2] == digits[2].text &&
                          secretPin.split(",")[3] == digits[3].text) {
                        Global().isCombinationTriggered = false;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const VaultMainScreen()),
                          (Route<dynamic> route) => false,
                        );
                      } else {
                        wrongPinCount++;
                        if (wrongPinCount == 3) {
                          wrongPinCount = 0;
                          showDialog(
                              context: context,
                              builder: (context) => const SecretWordsDialog(
                                    isPasswordSet: false,
                                    isRecoveryMode: true,
                                    isTutorial: false,
                                  ));
                        }
                      }
                    });
                  }
                  break;
                default:
                  return;
              }
            }
          : null,
      child: Text(buttonName),
    );
  }

  Widget pinInputFields(TextEditingController controller, int fieldIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        obscureText: true,
        focusNode: inputFocus[fieldIndex],
        autofocus: true,
        readOnly: widget.isTutorial,
        maxLength: 1,
        cursorColor: Colors.black,
        cursorWidth: 3,
        onChanged: (_) {
          if (fieldIndex + 1 < inputFocus.length) {
            setState(() {
              inputFocus[fieldIndex + 1].requestFocus();
            });
          }
        },
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
          counter: const SizedBox.shrink(),
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
