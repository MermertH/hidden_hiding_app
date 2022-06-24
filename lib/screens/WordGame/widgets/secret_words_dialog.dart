import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_hiding_app/models/user_data.dart';
import 'package:hidden_hiding_app/screens/WordGame/src/recovery_words.dart';
import 'package:hidden_hiding_app/services/storage_service.dart';

class SecretWordsDialog extends StatefulWidget {
  final bool isPasswordSet;
  final bool isRecoveryMode;
  const SecretWordsDialog({
    Key? key,
    required this.isPasswordSet,
    required this.isRecoveryMode,
  }) : super(key: key);

  @override
  State<SecretWordsDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<SecretWordsDialog> {
  var encryptedStorage = StorageService();
  List<String> selectedRecoveryWords = [];
  var rng = Random();
  bool isNotValid = false;
  List<TextEditingController> recoveryFields = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void initState() {
    for (int itemIndex = 0; itemIndex < 8; itemIndex++) {
      List<String> list = nouns;
      int rngIndex = rng.nextInt(list.length);
      selectedRecoveryWords.add(list[rngIndex]);
      list.removeAt(rngIndex);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.amber[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: const [
                  0.1,
                  0.9,
                ],
                colors: [Colors.amber[600]!, Colors.amber[200]!],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.isPasswordSet
                    ? "Please backup all of the given words in order to be able to recover your vault in case you forgot your combination or secret pin, if you lost it you cannot recover any data so be aware of that"
                    : "Please enter your recovery keys respectively",
                textAlign: TextAlign.center,
                style: GoogleFonts.abel(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          if (widget.isPasswordSet)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.amber[700]!,
                    width: 4,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    children: List.generate(
                        selectedRecoveryWords.length,
                        (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                selectedRecoveryWords[index],
                                style: GoogleFonts.abel(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            )),
                  ),
                ),
              ),
            ),
          if (widget.isRecoveryMode)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.amber[700]!,
                  width: 2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: List.generate(
                      selectedRecoveryWords.length,
                      (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: recoveryInputFields(
                                recoveryFields[index], "key$index"),
                          )),
                ),
              ),
            ),
          if (isNotValid)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "keys are not correct! Please try again",
                textAlign: TextAlign.center,
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (widget.isRecoveryMode)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: GoogleFonts.abel(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      primary: Colors.orange[500],
                      onPrimary: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Try Again"),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: GoogleFonts.abel(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      primary: Colors.orange[500],
                      onPrimary: Colors.black),
                  onPressed: () async {
                    if (widget.isPasswordSet) {
                      await encryptedStorage.writeSecureData(UserData(
                          key: "recoveryKeys",
                          value:
                              "${selectedRecoveryWords[0]},${selectedRecoveryWords[1]},${selectedRecoveryWords[2]},${selectedRecoveryWords[3]},${selectedRecoveryWords[4]},${selectedRecoveryWords[5]},${selectedRecoveryWords[6]},${selectedRecoveryWords[7]}"));
                      Navigator.of(context).pushNamed("/VaultMainScreen");
                    } else {
                      await encryptedStorage
                          .readSecureData("recoveryKeys")
                          .then((recoveryKeys) {
                        if (recoveryKeys!.split(",")[0] ==
                                recoveryFields[0].text &&
                            recoveryKeys.split(",")[1] ==
                                recoveryFields[1].text &&
                            recoveryKeys.split(",")[2] ==
                                recoveryFields[2].text &&
                            recoveryKeys.split(",")[3] ==
                                recoveryFields[3].text &&
                            recoveryKeys.split(",")[4] ==
                                recoveryFields[4].text &&
                            recoveryKeys.split(",")[5] ==
                                recoveryFields[5].text &&
                            recoveryKeys.split(",")[6] ==
                                recoveryFields[6].text &&
                            recoveryKeys.split(",")[7] ==
                                recoveryFields[7].text) {
                          Navigator.of(context).pushNamed("/VaultMainScreen");
                        } else {
                          setState(() {
                            isNotValid = true;
                          });
                        }
                      });
                    }
                  },
                  child: Text(widget.isPasswordSet ? "Understood" : "Recover"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget recoveryInputFields(
      TextEditingController controller, String fieldName) {
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
        keyboardType: TextInputType.name,
        textAlign: TextAlign.center,
        style: GoogleFonts.abel(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          constraints: const BoxConstraints(
            maxWidth: 90,
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
