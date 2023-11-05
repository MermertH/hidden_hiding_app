import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_hiding_app/controller/game_controller.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/hexagon_button_shape.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/hexagon_clipper.dart';

class SetCombinationDialog extends StatefulWidget {
  const SetCombinationDialog({Key? key}) : super(key: key);

  @override
  State<SetCombinationDialog> createState() => _SetCombinationDialogState();
}

class _SetCombinationDialogState extends State<SetCombinationDialog> {
  final GameController _gameCont = Get.find();
  Map<String, int> buttonCombinationOrderList = {};
  int tempData = 0;
  int combinationOrderCount = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Please set your combination order",
              textAlign: TextAlign.center,
              style: GoogleFonts.abel(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  gameButtons(
                    buttonValue: "",
                    buttonName: "LeftTop",
                  ),
                  gameButtons(
                    buttonValue: "",
                    buttonName: "LeftBottom",
                  ),
                ],
              ),
              Column(
                children: [
                  gameButtons(
                    buttonValue: "",
                    buttonName: "Top",
                  ),
                  gameButtons(
                    buttonValue: "",
                    buttonName: "Middle",
                  ),
                  gameButtons(
                    buttonValue: "",
                    buttonName: "Bottom",
                  ),
                ],
              ),
              Column(
                children: [
                  gameButtons(
                    buttonValue: "",
                    buttonName: "RightTop",
                  ),
                  gameButtons(
                    buttonValue: "",
                    buttonName: "RightBottom",
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: GoogleFonts.abel(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      backgroundColor: Colors.grey),
                  onPressed: () {
                    _gameCont.resetCombinationButtons();
                    buttonCombinationOrderList.clear();
                    combinationOrderCount = 0;
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: GoogleFonts.abel(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      backgroundColor: Colors.grey),
                  onPressed: () {
                    setState(() {
                      _gameCont.resetCombinationButtons();
                      buttonCombinationOrderList.clear();
                      combinationOrderCount = 0;
                    });
                  },
                  child: const Text("Reset"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: GoogleFonts.abel(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      backgroundColor: Colors.grey),
                  onPressed: () {
                    if (buttonCombinationOrderList.length == 7) {
                      for (int index = 0;
                          index < buttonCombinationOrderList.length;
                          index++) {
                        Preferences().setCombinationCount(
                            buttonCombinationOrderList.keys.elementAt(index),
                            buttonCombinationOrderList.values.elementAt(index));
                      }
                      _gameCont.resetCombinationButtons();
                      buttonCombinationOrderList.clear();
                      combinationOrderCount = 0;
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Apply"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget gameButtons({
    required String buttonValue,
    required String buttonName,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Stack(
        children: [
          CustomPaint(
            painter: HexagonButton(),
            child: const SizedBox(
              width: 50,
              height: 50,
            ),
          ),
          Positioned.fill(
            child: ClipPath(
              clipper: HexagonClipper(),
              child: Obx(
                () => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: const [
                        0.1,
                        0.9,
                      ],
                      colors: [
                        _gameCont.getCombinationButtonStatus(buttonName).value
                            ? Colors.green[600]!
                            : Colors.white,
                        Colors.grey[200]!
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _gameCont.getCombinationButtonStatus(buttonName).value
                          ? buttonCombinationOrderList.entries
                              .firstWhere(
                                  (element) => element.key == buttonName)
                              .value
                              .toString()
                          : buttonValue,
                      style: GoogleFonts.abel(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: ClipPath(
              clipper: HexagonClipper(),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (_gameCont
                            .getCombinationButtonStatus(buttonName)
                            .value ==
                        false) {
                      combinationOrderCount++;
                      buttonCombinationOrderList.addEntries(
                          [MapEntry(buttonName, combinationOrderCount)]);
                    }
                    _gameCont.setCombinationButtonStatus(true, buttonName);
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
