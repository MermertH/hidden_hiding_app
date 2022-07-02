import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool safeToSkipTutorial = false;
  int combinationOrderCount = 0;
  int wrongPinCount = 0;

  // tutorial widgets
  List<Widget> tutorialWidgets = [
    // introduction
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
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Welcome to Word Bender",
                  style: TextStyle(
                    fontFamily: "Abel",
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "This tutorial aims to give you all of the information you need in order to use the app accordingly",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Abel",
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
    // game buttons
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
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "By tapping these hexagon buttons, user tries to create a meaningful word",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Abel",
                    fontSize: 22,
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
              angle: -pi / 1.5,
              child: const Icon(
                Icons.arrow_back_outlined,
                size: 60,
              ),
            ),
          )
        ],
      ),
    ),
    // interact buttons
    Align(
      alignment: const Alignment(0, 0.6),
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
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "In game mode, users can delete, shuffle button letters and submit their words with these buttons whereas in combination mode, reset button resets combination, shuffle works same and apply checks your combination",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Abel",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: -50,
            left: 60,
            child: Icon(
              Icons.arrow_downward,
              size: 60,
            ),
          ),
          const Positioned(
            bottom: -50,
            left: 180,
            child: Icon(
              Icons.arrow_downward,
              size: 60,
            ),
          ),
          const Positioned(
            bottom: -50,
            right: 60,
            child: Icon(
              Icons.arrow_downward,
              size: 60,
            ),
          ),
        ],
      ),
    ),
    // accepted words list
    Align(
      alignment: const Alignment(0, -1),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 128, top: 8, left: 8),
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
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "User can see found words and each of their score by tapping this list",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Abel",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            top: 0,
            right: 45,
            child: Icon(
              Icons.arrow_forward,
              size: 60,
            ),
          ),
        ],
      ),
    ),
    // status message
    Align(
      alignment: const Alignment(0, -1),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 64, top: 8, left: 8),
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
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Here a status message will be shown for each situation",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Abel",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: -60,
            child: Icon(
              Icons.arrow_downward,
              size: 60,
            ),
          ),
        ],
      ),
    ),
    // trigger combination
    Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Align(
            alignment: Alignment.center,
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
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "By pressing new game button, user can reset the game. Also, by tapping new game and delete button respectively, user can trigger combination mode",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Abel",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment(0.75, -0.68),
          child: Icon(
            Icons.arrow_upward,
            size: 60,
          ),
        ),
        const Align(
          alignment: Alignment(-0.7, 0.8),
          child: Icon(
            Icons.arrow_downward,
            size: 60,
          ),
        ),
      ],
    ),
    // combination system
    Align(
      alignment: const Alignment(0, -0.7),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
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
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "After entering combination mode, user will create unique combination by tapping hexagon buttons in order, then apply to save if if they are sure. If not, user can reset the process by tapping reset",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Abel",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    // pin
    Stack(
      alignment: AlignmentDirectional.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Align(
            alignment: const Alignment(0, -0.7),
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
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "After applying, user will be asked to set a 4 digit secret pin as well",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Abel",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Align(
          alignment: Alignment(0, -0.45),
          child: Icon(
            Icons.arrow_downward,
            size: 60,
          ),
        ),
        const Align(
            alignment: Alignment(0, 0.2),
            child: PinDialog(
                isPasswordSet: true, isInVault: false, isTutorial: true)),
      ],
    ),
    // recovery
    Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Align(
            alignment: const Alignment(0, -0.9),
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
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "After pin, 8 recovery keys will be given in case user forget combination or secret pin. If user fails to apply combination or enter pin three times, these recovery keys will be asked to user. If user enters the keys correctly, user will enter hidden vault. Also, combination and pin will be reset",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Abel",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SecretWordsDialog(
            isPasswordSet: true, isRecoveryMode: false, isTutorial: true),
      ],
    ),
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
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Thanks for using Word Bender",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Abel",
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "The tutorial has been ended. After setting your combination and pin, you may use the app as you wish",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Abel",
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
  ];
  int tutorialWidgetIndex = 0;

  @override
  void initState() {
    super.initState();
    if (Preferences().getFirstTime) {
      Preferences().setIsPasswordSetMode = true;
      Timer(const Duration(seconds: 3), () {
        safeToSkipTutorial = true;
        setState(() {});
      });
    }
    if (Preferences().getIsPasswordSetMode) {
      Global().isCombinationTriggered = true;
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
    userInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (!Preferences().getIsPasswordSetMode) {
                setState(() {
                  Global().isCombinationTriggered = false;
                  newGameTriggered = false;
                  deleteTriggered = false;
                  Global().combinationButtons.updateAll((key, value) => false);
                  buttonCombinationOrderList.clear();
                  combinationOrderCount = 0;
                  wrongPinCount = 0;
                });
              }
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
                titleTextStyle: const TextStyle(
                  fontFamily: "Abel",
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
                    const Text(
                      "Found Words List",
                      style: TextStyle(
                        fontFamily: "Abel",
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
                            leading: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.red[300]!,
                                  size: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      (acceptedWords[index].order + 1)
                                          .toString(),
                                      style: const TextStyle(
                                        fontFamily: "Abel",
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ],
                            ),
                            title: Text(
                              acceptedWords[index].word,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: "Abel",
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            trailing: Text(
                              "point: ${acceptedWords[index].score.toString()}",
                              style: const TextStyle(
                                fontFamily: "Abel",
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
                          style: const TextStyle(
                            fontFamily: "Abel",
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                fontFamily: "Abel",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              primary: Colors.orange[400],
                              onPrimary: Colors.black),
                          onPressed: () {
                            if (!Preferences().getIsPasswordSetMode) {
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
                            }
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Global().gameOver ? 30 : 20,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: "Abel",
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
                              textStyle: const TextStyle(
                                fontFamily: "Abel",
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
                              textStyle: const TextStyle(
                                fontFamily: "Abel",
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
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => const PinDialog(
                                            isPasswordSet: true,
                                            isInVault: false,
                                            isTutorial: false,
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
                                      barrierDismissible: false,
                                      builder: (context) => const PinDialog(
                                            isPasswordSet: false,
                                            isInVault: false,
                                            isTutorial: false,
                                          ));
                                } else {
                                  wrongPinCount++;
                                  if (wrongPinCount == 3) {
                                    wrongPinCount = 0;
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) =>
                                            const SecretWordsDialog(
                                              isPasswordSet: false,
                                              isRecoveryMode: true,
                                              isTutorial: false,
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
              onTap: () async {
                if (safeToSkipTutorial) {
                  if (tutorialWidgetIndex < tutorialWidgets.length - 1) {
                    tutorialWidgetIndex++;
                    if (tutorialWidgetIndex == 7) {
                      Global()
                          .combinationButtons
                          .updateAll((key, value) => false);
                    }
                    setState(() {
                      safeToSkipTutorial = false;
                    });
                    if (tutorialWidgetIndex == 6) {
                      while (tutorialWidgetIndex == 6) {
                        List<String> comButNames =
                            Global().combinationButtons.keys.toList();
                        var rng = Random();
                        int rngIndex = 0;
                        await Future.delayed(const Duration(seconds: 1));
                        for (int index = 0;
                            index < Global().combinationButtons.length;
                            index++) {
                          if (tutorialWidgetIndex != 6) break;
                          rngIndex = rng.nextInt(comButNames.length);
                          if (Global().getCombinationButtonStatus(
                                  comButNames[rngIndex]) ==
                              false) {
                            Global().setCombinationButtonStatus(
                                true, comButNames[rngIndex]);
                            comButNames.remove(comButNames[rngIndex]);
                          }

                          setState(() {});
                          await Future.delayed(const Duration(seconds: 1));
                        }
                        Global()
                            .combinationButtons
                            .updateAll((key, value) => false);
                        setState(() {
                          safeToSkipTutorial = true;
                        });
                      }
                    }
                    if (tutorialWidgetIndex != 6) {
                      Timer(const Duration(seconds: 3), () {
                        setState(() {
                          safeToSkipTutorial = true;
                        });
                        debugPrint(
                            "safe to skip tutorial: $safeToSkipTutorial");
                      });
                    }
                  } else {
                    tutorialWidgetIndex = 0;
                    Preferences().setFirstTime = false;
                    setState(() {});
                  }
                }
              },
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                color: Colors.black.withOpacity(0.2),
                child: Stack(
                  children: [
                    tutorialWidgets[tutorialWidgetIndex],
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.black.withOpacity(0.4),
                        width: double.maxFinite,
                        child: Text(
                          safeToSkipTutorial
                              ? "Press anywhere to continue"
                              : "Wait a bit before continue",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: "Abel",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
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
                    style: const TextStyle(
                        fontFamily: "Abel",
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

          if (AcceptedWords.totalWordCount == 25) {
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
