import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_hiding_app/models/user_data.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:hidden_hiding_app/screens/SecretVault/vault_main_screen.dart';
import 'package:hidden_hiding_app/screens/WordGame/src/recovery_words.dart';
import 'package:hidden_hiding_app/services/storage_service.dart';

import '../../../controller/game_controller.dart';

class SecretWordsDialog extends StatefulWidget {
  final bool isPasswordSet;
  final bool isRecoveryMode;
  final bool isTutorial;
  const SecretWordsDialog({
    Key? key,
    required this.isPasswordSet,
    required this.isRecoveryMode,
    required this.isTutorial,
  }) : super(key: key);

  @override
  State<SecretWordsDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<SecretWordsDialog> {
  final GameController _gameCont = Get.find();
  var encryptedStorage = StorageService();
  var dialogController = ScrollController();
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
      List<String> list = SecretWords.nouns;
      int rngIndex = rng.nextInt(list.length);
      selectedRecoveryWords.add(list[rngIndex]);
      list.removeAt(rngIndex);
    }
    super.initState();
  }

  @override
  void dispose() {
    dialogController.dispose();
    for (var controller in recoveryFields) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: widget.isTutorial ? const Alignment(0, 0.9) : Alignment.center,
      backgroundColor: Colors.amber[300],
      child: RawScrollbar(
        thumbColor: Colors.deepOrange,
        thumbVisibility: true,
        thickness: 5,
        controller: dialogController,
        child: SingleChildScrollView(
          controller: dialogController,
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
                        ? "Please backup all of the given words in order to be able to recover your vault in case you forgot your combination or secret pin, if you lost it you cannot recover any data, so be aware of that"
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
                        alignment: WrapAlignment.center,
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
                      alignment: WrapAlignment.center,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "keys are not correct! Please try again",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.abel(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (widget.isRecoveryMode)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.orange[500],
                          textStyle: GoogleFonts.abel(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Try Again"),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
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
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            var color = Colors.black;
                            if (states.contains(MaterialState.disabled)) {
                              return color;
                            }
                            return color;
                          },
                        ),
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            var color = Colors.orange[500];
                            if (states.contains(MaterialState.disabled)) {
                              return color!;
                            }
                            return color!;
                          },
                        ),
                      ),
                      onPressed: !widget.isTutorial
                          ? () async {
                              if (widget.isPasswordSet) {
                                await encryptedStorage.writeSecureData(UserData(
                                    key: "recoveryKeys",
                                    value:
                                        "${selectedRecoveryWords[0]},${selectedRecoveryWords[1]},${selectedRecoveryWords[2]},${selectedRecoveryWords[3]},${selectedRecoveryWords[4]},${selectedRecoveryWords[5]},${selectedRecoveryWords[6]},${selectedRecoveryWords[7]}"));
                                Preferences().setIsPasswordSetMode = false;
                                _gameCont.setIsCombinationTriggered = false;
                                _gameCont.setStatusMessage("notSubmitted");
                                Get.offAll(() => const VaultMainScreen());
                              } else {
                                await encryptedStorage
                                    .readSecureData("recoveryKeys")
                                    .then((recoveryKeys) {
                                  if (recoveryKeys!.split(",")[0] ==
                                          recoveryFields[0].text.trim() &&
                                      recoveryKeys.split(",")[1] ==
                                          recoveryFields[1].text.trim() &&
                                      recoveryKeys.split(",")[2] ==
                                          recoveryFields[2].text.trim() &&
                                      recoveryKeys.split(",")[3] ==
                                          recoveryFields[3].text.trim() &&
                                      recoveryKeys.split(",")[4] ==
                                          recoveryFields[4].text.trim() &&
                                      recoveryKeys.split(",")[5] ==
                                          recoveryFields[5].text.trim() &&
                                      recoveryKeys.split(",")[6] ==
                                          recoveryFields[6].text.trim() &&
                                      recoveryKeys.split(",")[7] ==
                                          recoveryFields[7].text.trim()) {
                                    _gameCont.setIsCombinationTriggered = false;
                                    Preferences().setIsPasswordSetMode = true;
                                    Get.offAll(() => const VaultMainScreen());
                                  } else {
                                    setState(() {
                                      isNotValid = true;
                                    });
                                  }
                                });
                              }
                            }
                          : null,
                      child:
                          Text(widget.isPasswordSet ? "Understood" : "Recover"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget recoveryInputFields(
      TextEditingController controller, String fieldName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller,
        autofocus: true,
        cursorColor: Colors.black,
        cursorWidth: 3,
        textInputAction:
            fieldName == "digit4" ? TextInputAction.done : TextInputAction.next,
        keyboardType: TextInputType.name,
        textAlign: TextAlign.center,
        style: GoogleFonts.abel(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          constraints: const BoxConstraints(
            maxWidth: 100,
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
