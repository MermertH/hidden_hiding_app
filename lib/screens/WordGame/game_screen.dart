import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/controller/game_controller.dart';
import 'package:hidden_hiding_app/global.dart';
import 'package:hidden_hiding_app/models/accepted_words.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/game_button.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameController _gameCont = Get.find();

  @override
  void initState() {
    super.initState();
    if (_gameCont.getIsAppOpenedFirstTime.value) {
      Preferences().setIsPasswordSetMode = true;
      Timer(const Duration(seconds: 3), () {
        _gameCont.setIsSafeToSkipTutorial = true;
        setState(() {});
      });
    }
    if (Preferences().getIsPasswordSetMode) {
      _gameCont.setIsCombinationTriggered = true;
      _gameCont.setStatusMessage("combinationSet");
    }
    Global.removeFlag();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _gameCont.setMiddleButtonChar();
    _gameCont.setButtonCharsExceptMiddleButton();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _gameCont.userInputController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Stack(
          children: [
            GestureDetector(
              onTap: () => _gameCont.resetVaultAuthMode(),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.amber[100],
                appBar: AppBar(
                  actions: [
                    Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          onPressed: () {
                            _gameCont.setIsDeleteTriggered = false;
                            _gameCont.setIsNewGameTriggered = false;
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
                          itemCount: _gameCont.acceptedWords.length,
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
                                        (_gameCont.acceptedWords[index].order +
                                                1)
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
                                _gameCont.acceptedWords[index].word,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: "Abel",
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              trailing: Text(
                                "point: ${_gameCont.acceptedWords[index].score.toString()}",
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
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.orange[400],
                                textStyle: const TextStyle(
                                  fontFamily: "Abel",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            onPressed: () => _gameCont.newGameButtonFunctions(),
                            child: const Text("New Game"),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Obx(
                        () => Text(
                          _gameCont.getStatusMessage.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: _gameCont.getIsGameOver.value ? 30 : 20,
                              color: Colors.black),
                        ),
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
                        controller: _gameCont.userInputController,
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
                            GameButton(
                              buttonValue: _gameCont.selectedLetters[0],
                              buttonName: "LeftTop",
                            ),
                            GameButton(
                              buttonValue: _gameCont.selectedLetters[1],
                              buttonName: "LeftBottom",
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GameButton(
                              buttonValue: _gameCont.selectedLetters[2],
                              buttonName: "Top",
                            ),
                            GameButton(
                              buttonValue: _gameCont.getMiddleButtonChar.value,
                              buttonName: "Middle",
                            ),
                            GameButton(
                              buttonValue: _gameCont.selectedLetters[3],
                              buttonName: "Bottom",
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GameButton(
                              buttonValue: _gameCont.selectedLetters[4],
                              buttonName: "RightTop",
                            ),
                            GameButton(
                              buttonValue: _gameCont.selectedLetters[5],
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
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.orange[500],
                                textStyle: const TextStyle(
                                  fontFamily: "Abel",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            onPressed: () =>
                                _gameCont.resetCombinationOrDeleteInput(),
                            child: Obx(
                              () => Text(
                                _gameCont.getIsCombinationTriggered.value
                                    ? "Reset"
                                    : "Delete",
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.orange[300],
                                shape: const CircleBorder()),
                            onPressed: () => _gameCont.shuffleLetters(),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Icon(Icons.shuffle),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.orange[500],
                                textStyle: const TextStyle(
                                  fontFamily: "Abel",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            onPressed: () =>
                                _gameCont.submitCombinationOrGameTextInput(),
                            child: Obx(
                              () => Text(
                                _gameCont.getIsCombinationTriggered.value
                                    ? "Apply"
                                    : "Submit",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_gameCont.getIsAppOpenedFirstTime.value)
              GestureDetector(
                onTap: () async => await _gameCont.moveToNextTutorial(),
                child: Obx(
                  () => Container(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    color: Colors.black.withOpacity(0.2),
                    child: Stack(
                      children: [
                        _gameCont
                            .tutorialWidgets[_gameCont.getTutorialWidgetIndex],
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Colors.black.withOpacity(0.4),
                            width: double.maxFinite,
                            child: Text(
                              _gameCont.getIsSafeToSkipTutorial.value
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
              ),
          ],
        ),
      ),
    );
  }
}
