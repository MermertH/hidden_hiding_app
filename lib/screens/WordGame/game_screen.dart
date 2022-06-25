import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_hiding_app/global.dart';
import 'package:hidden_hiding_app/models/accepted_words.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/hexagon_button_shape.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/hexagon_clipper.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/pin_dialog.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/secret_words_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Variables
  var userInputController = TextEditingController();
  List<AcceptedWords> acceptedWords = [];
  Map<String, int> buttonCombinationOrderList = {};
  bool newGameTriggered = false;
  bool deleteTriggered = false;
  int combinationOrderCount = 0;
  int wrongPinCount = 0;

  // tutorial widgets
  List<Widget> tutorialWidgets = [
    Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.amber[200]!,
                Colors.amber[500]!,
                Colors.amber[200]!,
              ],
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Welcome to Word Bender",
                  style: GoogleFonts.abel(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "This tutorial aims to give you all of the information you need in order to use the app accordingly",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.abel(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    Align(
      alignment: const Alignment(0, -0.3),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.amber[200]!,
                    Colors.amber[500]!,
                    Colors.amber[200]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "By tapping these hexagon buttons, user tries to create a meaningful word",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.abel(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: 30,
            child: Transform.rotate(
              angle: -90,
              child: const Icon(
                Icons.arrow_back_outlined,
                size: 60,
              ),
            ),
          )
        ],
      ),
    )
  ];
  int tutorialWidgetIndex = 0;

  @override
  void initState() {
    super.initState();
    Preferences().setFirstTime = true;
    if (Preferences().getFirstTime) {
      Global().isCombinationTriggered = true;
      Preferences().setIsPasswordSetMode = true;
      Global().statusMessage = "combinationSet";
    }
    Global().removeFlag();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Global().getMiddleButtonChar();
    Global().getButtonCharsExceptMiddleButton();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                Global().isCombinationTriggered = false;
                newGameTriggered = false;
                deleteTriggered = false;
                Global().combinationButtons.updateAll((key, value) => false);
                buttonCombinationOrderList.clear();
                combinationOrderCount = 0;
                wrongPinCount = 0;
              });
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.amber[100],
              appBar: AppBar(
                actions: [
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            deleteTriggered = false;
                            newGameTriggered = false;
                          });
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: const Icon(
                          Icons.list,
                          size: 30,
                          color: Colors.black,
                        ),
                        tooltip: MaterialLocalizations.of(context)
                            .openAppDrawerTooltip,
                      );
                    },
                  ),
                ],
                backgroundColor: Colors.amber[500],
                title: const Text("Word Bender"),
                centerTitle: true,
                titleTextStyle: GoogleFonts.abel(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              endDrawer: Drawer(
                backgroundColor: Colors.amber[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Found Words List",
                      style: GoogleFonts.abel(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 4,
                      width: double.maxFinite,
                      color: Colors.amber[800],
                    ),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: acceptedWords.length,
                        itemBuilder: (context, index) => Card(
                          color: Colors.amber[300],
                          child: ListTile(
                            leading: Icon(
                              Icons.star,
                              color: Colors.red[300]!,
                            ),
                            title: Text(
                              acceptedWords[index].word,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.abel(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            trailing: Text(
                              "point: ${acceptedWords[index].score.toString()}",
                              style: GoogleFonts.abel(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Score: ${AcceptedWords.totalScore}",
                          style: GoogleFonts.abel(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: GoogleFonts.abel(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              primary: Colors.orange[400],
                              onPrimary: Colors.black),
                          onPressed: () {
                            setState(() {
                              Global().gameOver = false;
                              newGameTriggered = true;
                              Global().getMiddleButtonChar();
                              Global().getButtonCharsExceptMiddleButton();
                              userInputController.clear();

                              AcceptedWords.totalScore = 0;
                              AcceptedWords.totalWordCount = 0;
                              acceptedWords.clear();
                              Global().statusMessage = "notSubmitted";
                            });
                          },
                          child: const Text("New Game"),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      Global().getStatusMessage(Global().statusMessage),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.abel(
                          fontWeight: FontWeight.bold,
                          fontSize: Global().gameOver ? 35 : 24,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: GoogleFonts.abel(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      cursorColor: Colors.black,
                      cursorWidth: 3,
                      readOnly: true,
                      controller: userInputController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF2F2F2),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(width: 3, color: Colors.amber[700]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          borderSide:
                              BorderSide(width: 3, color: Colors.amber[700]!),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          gameButtons(
                            buttonValue: Global().selectedLetters[0],
                            buttonName: "LeftTop",
                          ),
                          gameButtons(
                            buttonValue: Global().selectedLetters[1],
                            buttonName: "LeftBottom",
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          gameButtons(
                            buttonValue: Global().selectedLetters[2],
                            buttonName: "Top",
                          ),
                          gameButtons(
                            buttonValue: Global().middleButtonChar,
                            buttonName: "Middle",
                          ),
                          gameButtons(
                            buttonValue: Global().selectedLetters[3],
                            buttonName: "Bottom",
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          gameButtons(
                            buttonValue: Global().selectedLetters[4],
                            buttonName: "RightTop",
                          ),
                          gameButtons(
                            buttonValue: Global().selectedLetters[5],
                            buttonName: "RightBottom",
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
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
                          onPressed: () {
                            setState(() {
                              if (Global().gameOver == true) return;
                              deleteTriggered = true;
                              if (deleteTriggered && newGameTriggered) {
                                Global().isCombinationTriggered = true;
                              }
                              if (Global().isCombinationTriggered) {
                                setState(() {
                                  Global()
                                      .combinationButtons
                                      .updateAll((key, value) => false);
                                  buttonCombinationOrderList.clear();
                                  combinationOrderCount = 0;
                                });
                              }
                              if (userInputController.text.isNotEmpty) {
                                userInputController.text =
                                    userInputController.text.substring(
                                        0, userInputController.text.length - 1);
                              }
                            });
                          },
                          child: Text(Global().isCombinationTriggered
                              ? "Reset"
                              : "Delete"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              primary: Colors.orange[300],
                              onPrimary: Colors.black),
                          onPressed: () {
                            setState(() {
                              if (Global().gameOver == true) return;
                              deleteTriggered = false;
                              newGameTriggered = false;
                              Global().selectedLetters.shuffle();
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.shuffle),
                          ),
                        ),
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
                            if (Global().gameOver == true) return;
                            deleteTriggered = false;
                            newGameTriggered = false;
                            if (Global().isCombinationTriggered) {
                              if (Preferences().getIsPasswordSetMode) {
                                if (buttonCombinationOrderList.length == 7) {
                                  for (int index = 0;
                                      index < buttonCombinationOrderList.length;
                                      index++) {
                                    Preferences().setCombinationCount(
                                        buttonCombinationOrderList.keys
                                            .elementAt(index),
                                        buttonCombinationOrderList.values
                                            .elementAt(index));
                                  }
                                  Global()
                                      .combinationButtons
                                      .updateAll((key, value) => false);
                                  buttonCombinationOrderList.clear();
                                  combinationOrderCount = 0;
                                  showDialog(
                                      context: context,
                                      builder: (context) => const PinDialog(
                                            isPasswordSet: true,
                                            isInVault: false,
                                          ));
                                }
                              }

                              if (buttonCombinationOrderList.length == 7) {
                                bool isValid = buttonCombinationOrderList
                                    .entries
                                    .every((item) =>
                                        Preferences()
                                            .getCombinationCount(item.key) ==
                                        item.value);
                                if (isValid) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => const PinDialog(
                                            isPasswordSet: false,
                                            isInVault: false,
                                          ));
                                } else {
                                  wrongPinCount++;
                                  if (wrongPinCount == 3) {
                                    wrongPinCount = 0;
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const SecretWordsDialog(
                                              isPasswordSet: false,
                                              isRecoveryMode: true,
                                            ));
                                  }
                                }
                                Global()
                                    .combinationButtons
                                    .updateAll((key, value) => false);
                                buttonCombinationOrderList.clear();
                                combinationOrderCount = 0;
                              }
                              setState(() {});
                            } else {
                              checkAndSubmitUserInput();
                            }
                          },
                          child: Text(Global().isCombinationTriggered
                              ? "Apply"
                              : "Submit"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (Preferences().getFirstTime)
            GestureDetector(
              onTap: () {
                setState(() {
                  if (tutorialWidgetIndex < tutorialWidgets.length) {
                    tutorialWidgetIndex++;
                  } else {
                    tutorialWidgetIndex = 0;
                    Preferences().setFirstTime = false;
                  }
                });
              },
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                color: Colors.black.withOpacity(0.3),
                child: Stack(
                  children: [
                    tutorialWidgets[tutorialWidgetIndex],
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Press anywhere to continue",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.abel(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
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
              width: 100,
              height: 100,
            ),
          ),
          Positioned.fill(
            child: ClipPath(
              clipper: HexagonClipper(),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: const [
                      0.1,
                      0.9,
                    ],
                    colors: [
                      Global().getCombinationButtonStatus(buttonName)
                          ? Colors.red[600]!
                          : Colors.amber[600]!,
                      Colors.amber[200]!
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    buttonValue.toUpperCase(),
                    style: GoogleFonts.abel(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black),
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
                    if (Global().gameOver == true) return;
                    setState(() {
                      deleteTriggered = false;
                      newGameTriggered = false;
                      if (Global().isCombinationTriggered) {
                        if (Global().getCombinationButtonStatus(buttonName) ==
                            false) {
                          combinationOrderCount++;
                          buttonCombinationOrderList.addEntries(
                              [MapEntry(buttonName, combinationOrderCount)]);
                        }
                        Global().setCombinationButtonStatus(true, buttonName);
                      } else {
                        switch (buttonName) {
                          case "LeftTop":
                            userInputController.text += buttonValue;
                            break;
                          case "LeftBottom":
                            userInputController.text += buttonValue;
                            break;
                          case "Top":
                            userInputController.text += buttonValue;
                            break;
                          case "Middle":
                            userInputController.text += buttonValue;
                            break;
                          case "Bottom":
                            userInputController.text += buttonValue;
                            break;
                          case "RightTop":
                            userInputController.text += buttonValue;
                            break;
                          case "RightBottom":
                            userInputController.text += buttonValue;
                            break;
                          default:
                            return;
                        }
                      }
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void checkAndSubmitUserInput() async {
    if (userInputController.text.isEmpty) {
      Global().statusMessage = "noInputFound";
    } else if (acceptedWords
        .any((acceptedWord) => acceptedWord.word == userInputController.text)) {
      Global().statusMessage = "sameWordWarning";
    } else {
      setState(() {
        Global().statusMessage = "waitingResponse";
      });
      if (await Global().checkConnectivityState()) {
        if (await Global().wordExists(word: userInputController.text)) {
          acceptedWords.add(AcceptedWords(
              word: userInputController.text,
              score: userInputController.text.length));

          if (AcceptedWords.totalWordCount == 50) {
            Global().statusMessage = "gameLimitReached";
            Global().gameOver = true;
          } else {
            Global().statusMessage = "notSubmitted";
          }
        } else {
          Global().statusMessage = "wordNotFound";
        }
      } else {
        Global().statusMessage = "noConnection";
      }
    }
    userInputController.clear();
    setState(() {});
  }
}
