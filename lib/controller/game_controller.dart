import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/global.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:http/http.dart' as http;
import '../models/accepted_words.dart';
import '../screens/WordGame/widgets/pin_dialog.dart';
import '../screens/WordGame/widgets/secret_words_dialog.dart';

class GameController extends GetxController {
  // Variables
  final userInputController = TextEditingController();
  final List<AcceptedWords> acceptedWords = [];
  final Map<String, int> buttonCombinationOrderList = {};
  final RxList<String> selectedLetters = <String>[].obs;
  bool _isNewGameTriggered = false;
  bool _isDeleteTriggered = false;
  final _isCombinationTriggered = false.obs;
  final _isGameOver = false.obs;
  final _isSafeToSkipTutorial = false.obs;
  int _combinationOrderCount = 0;
  int _wrongPinCount = 0;
  int _tutorialWidgetIndex = 0;
  final _middleButtonChar = "".obs;
  final _statusMessage = "None".obs;
  final _isAppOpenedFirstTime = false.obs;
  final Map<String, RxBool> _combinationButtons = {
    "LeftTop": false.obs,
    "LeftBottom": false.obs,
    "Top": false.obs,
    "Middle": false.obs,
    "Bottom": false.obs,
    "RightTop": false.obs,
    "RightBottom": false.obs,
  };

  // getters
  bool get getIsNewGameTrigerred => _isNewGameTriggered;
  bool get getIsDeleteTriggered => _isDeleteTriggered;
  RxBool get getIsCombinationTriggered => _isCombinationTriggered;
  RxBool get getIsGameOver => _isGameOver;
  RxBool get getIsSafeToSkipTutorial => _isSafeToSkipTutorial;
  int get getCombinationOrderCount => _combinationOrderCount;
  int get getWrongPinCount => _wrongPinCount;
  int get getTutorialWidgetIndex => _tutorialWidgetIndex;
  RxString get getMiddleButtonChar => _middleButtonChar;
  RxString get getStatusMessage => _statusMessage;
  RxBool get getIsAppOpenedFirstTime => _isAppOpenedFirstTime;
  Map<String, RxBool> get getCombinationButtons => _combinationButtons;

  // setters
  set setIsNewGameTriggered(bool condition) => _isNewGameTriggered = condition;
  set setIsDeleteTriggered(bool condition) => _isDeleteTriggered = condition;
  set setIsCombinationTriggered(bool condition) =>
      _isCombinationTriggered.value = condition;
  set setIsGameOver(bool condition) => _isGameOver.value = condition;
  set setIsSafeToSkipTutorial(bool condition) =>
      _isSafeToSkipTutorial.value = condition;
  set setCombinationOrderCount(int count) => _combinationOrderCount = count;
  set setWrongPinCount(int count) => _wrongPinCount = count;
  set setTutorialWidgetIndex(int count) => _tutorialWidgetIndex = count;
  set setMiddleButtonCharValue(String msg) => _middleButtonChar.value = msg;
  set setStatusMessageValue(String msg) => _statusMessage.value = msg;
  set setIsAppOpenedFirstTime(bool value) =>
      _isAppOpenedFirstTime.value = value;

  @override
  void onInit() {
    setIsAppOpenedFirstTime = Preferences().getFirstTime;
    debugPrint("is app opened first time? => ${getIsAppOpenedFirstTime.value}");
    setStatusMessage("notSubmitted");
    super.onInit();
  }

  // Functions
  // game screen functions
  void setCombinationButtonStatus(bool buttonStatus, String buttonName) {
    _combinationButtons[_combinationButtons.entries
            .firstWhere((button) => button.key == buttonName)
            .key]!
        .value = buttonStatus;
  }

  RxBool getCombinationButtonStatus(String buttonName) {
    return _combinationButtons[_combinationButtons.entries
        .firstWhere((button) => button.key == buttonName)
        .key]!;
  }

  void setStatusMessage(String key) {
    switch (key) {
      case "notSubmitted":
        setStatusMessageValue = "Enter your word here";
        break;
      case "noInputFound":
        setStatusMessageValue = "Field cannot be blank!";
        break;
      case "wordNotFound":
        setStatusMessageValue = "Submitted word not found";
        break;
      case "sameWordWarning":
        setStatusMessageValue = "This word is already found";
        break;
      case "waitingResponse":
        setStatusMessageValue = "Checking word...";
        break;
      case "rateLimitExceed":
        setStatusMessageValue =
            "Too much request made frequently, please wait a bit and try again";
        break;
      case "gameLimitReached":
        setStatusMessageValue = "Game Over!";
        break;
      case "noConnection":
        setStatusMessageValue =
            "No internet connection, please connect and try again";
        break;
      case "combinationSet":
        setStatusMessageValue =
            "Please tap each hexagon button once to create your unique combination";
        break;
      default:
        setStatusMessageValue = "An error occured";
    }
  }

  void setMiddleButtonChar() {
    List<String> vowels = [];
    var rng = Random();
    vowels.addAll(["a", "e", "i", "o", "u"]);
    setMiddleButtonCharValue = vowels.elementAt(rng.nextInt(vowels.length));
  }

  Future<bool> wordExists({required word}) async {
    final client = http.Client();
    final res = await client.get(
        Uri.parse("https://owlbot.info/api/v4/dictionary/$word"),
        headers: {
          'Authorization': 'Token be353ca47454bc2a0b9ec0cf699ac848ded01214'
        });
    if (res.statusCode == 200) {
      return true;
    } else if (res.statusCode == 429) {
      setStatusMessage("rateLimitExceed");
      return false;
    } else {
      return false;
    }
  }

  void setButtonCharsExceptMiddleButton() {
    selectedLetters.clear();
    List<String> englishAlphabet = [];
    var rng = Random();
    int currentRngIndex = 0;
    englishAlphabet.addAll([
      "a",
      "b",
      "c",
      "d",
      "e",
      "f",
      "g",
      "h",
      "i",
      "j",
      "k",
      "l",
      "m",
      "n",
      "o",
      "p",
      "q",
      "r",
      "s",
      "t",
      "u",
      "v",
      "w",
      "x",
      "y",
      "z"
    ]);
    englishAlphabet.remove(getMiddleButtonChar.value);
    for (int count = 0; count < 6; count++) {
      currentRngIndex = rng.nextInt(englishAlphabet.length);
      selectedLetters.add(englishAlphabet[currentRngIndex]);
      englishAlphabet.removeAt(currentRngIndex);
    }
  }

  void resetCombinationButtons() {
    for (RxBool status in _combinationButtons.values) {
      status.value = false;
    }
  }

  Future<void> moveToNextTutorial() async {
    if (getIsSafeToSkipTutorial.value) {
      if (getTutorialWidgetIndex < tutorialWidgets.length - 1) {
        setTutorialWidgetIndex = getTutorialWidgetIndex + 1;
        if (getTutorialWidgetIndex == 7) {
          resetCombinationButtons();
        }
        setIsSafeToSkipTutorial = false;
        if (getTutorialWidgetIndex == 6) {
          while (getTutorialWidgetIndex == 6) {
            List<String> comButNames = _combinationButtons.keys.toList();
            var rng = Random();
            int rngIndex = 0;
            await Future.delayed(const Duration(seconds: 1));
            for (int index = 0; index < _combinationButtons.length; index++) {
              if (getTutorialWidgetIndex != 6) break;
              rngIndex = rng.nextInt(comButNames.length);
              if (!getCombinationButtonStatus(comButNames[rngIndex]).value) {
                setCombinationButtonStatus(true, comButNames[rngIndex]);
                comButNames.remove(comButNames[rngIndex]);
              }
              update();
              await Future.delayed(const Duration(seconds: 1));
            }
            resetCombinationButtons();
            setIsSafeToSkipTutorial = true;
          }
        }
        if (getTutorialWidgetIndex != 6) {
          Timer(const Duration(seconds: 3), () {
            setIsSafeToSkipTutorial = true;
            debugPrint("safe to skip tutorial: $getIsSafeToSkipTutorial");
          });
        }
      } else {
        setTutorialWidgetIndex = 0;
        Preferences().setFirstTime = false;
        setIsAppOpenedFirstTime = false;
        update();
      }
    }
  }

  void submitCombinationOrGameTextInput() {
    if (getIsGameOver.value) return;
    setIsDeleteTriggered = false;
    setIsNewGameTriggered = false;
    if (getIsCombinationTriggered.value) {
      if (Preferences().getIsPasswordSetMode) {
        if (buttonCombinationOrderList.length == 7) {
          for (int index = 0;
              index < buttonCombinationOrderList.length;
              index++) {
            Preferences().setCombinationCount(
                buttonCombinationOrderList.keys.elementAt(index),
                buttonCombinationOrderList.values.elementAt(index));
          }
          resetCombinationButtons();
          buttonCombinationOrderList.clear();
          setCombinationOrderCount = 0;
          Get.dialog(
            const PinDialog(
              isPasswordSet: true,
              isInVault: false,
              isTutorial: false,
            ),
            barrierDismissible: false,
            barrierColor: Colors.black.withOpacity(0.4),
          );
        }
      }

      if (buttonCombinationOrderList.length == 7) {
        bool isValid = buttonCombinationOrderList.entries.every((item) =>
            Preferences().getCombinationCount(item.key) == item.value);
        if (isValid) {
          Get.dialog(
            const PinDialog(
              isPasswordSet: false,
              isInVault: false,
              isTutorial: false,
            ),
            barrierDismissible: false,
            barrierColor: Colors.black.withOpacity(0.4),
          );
        } else {
          setWrongPinCount = getWrongPinCount + 1;
          if (getWrongPinCount == 3) {
            setWrongPinCount = 0;
            Get.dialog(
              const SecretWordsDialog(
                isPasswordSet: false,
                isRecoveryMode: true,
                isTutorial: false,
              ),
              barrierDismissible: false,
              barrierColor: Colors.black.withOpacity(0.4),
            );
          }
        }
        resetCombinationButtons();
        buttonCombinationOrderList.clear();
        setCombinationOrderCount = 0;
      }
      update();
    } else {
      checkAndSubmitUserInput();
    }
  }

  void shuffleLetters() {
    if (getIsGameOver.value) return;
    setIsDeleteTriggered = false;
    setIsNewGameTriggered = false;
    selectedLetters.shuffle();
    update();
  }

  void resetCombinationOrDeleteInput() {
    if (getIsGameOver.value) return;
    setIsDeleteTriggered = true;
    if (getIsDeleteTriggered && getIsNewGameTrigerred) {
      setIsCombinationTriggered = true;
    }
    if (getIsCombinationTriggered.value) {
      resetCombinationButtons();
      buttonCombinationOrderList.clear();
      setCombinationOrderCount = 0;
    }
    if (userInputController.text.isNotEmpty) {
      userInputController.text = userInputController.text
          .substring(0, userInputController.text.length - 1);
    }
    update();
  }

  void resetVaultAuthMode() {
    if (!Preferences().getIsPasswordSetMode) {
      setIsCombinationTriggered = false;
      resetCombinationButtons();
      buttonCombinationOrderList.clear();
      setCombinationOrderCount = 0;
      setWrongPinCount = 0;
      setIsNewGameTriggered = false;
      setIsDeleteTriggered = false;
      update();
    }
  }

  void newGameButtonFunctions() {
    if (!Preferences().getIsPasswordSetMode) {
      setIsGameOver = false;
      setIsNewGameTriggered = true;
      setMiddleButtonChar();
      setButtonCharsExceptMiddleButton();
      userInputController.clear();
      AcceptedWords.totalScore = 0;
      AcceptedWords.totalWordCount = 0;
      acceptedWords.clear();
      setStatusMessage("notSubmitted");
      update();
    }
  }

  void onHexagonButtonTapped({
    required String buttonValue,
    required String buttonName,
  }) {
    if (getIsGameOver.value) return;
    setIsDeleteTriggered = false;
    setIsNewGameTriggered = false;
    if (getIsCombinationTriggered.value) {
      if (getCombinationButtonStatus(buttonName).value == false) {
        setCombinationOrderCount = getCombinationOrderCount + 1;
        buttonCombinationOrderList
            .addEntries([MapEntry(buttonName, getCombinationOrderCount)]);
      }
      setCombinationButtonStatus(true, buttonName);
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
    update();
  }

  Future<void> checkAndSubmitUserInput() async {
    if (userInputController.text.isEmpty) {
      setStatusMessage("noInputFound");
    } else if (acceptedWords
        .any((acceptedWord) => acceptedWord.word == userInputController.text)) {
      setStatusMessage("sameWordWarning");
    } else {
      setStatusMessage("waitingResponse");
      update();
      if (await Global.checkConnectivityState()) {
        if (await wordExists(word: userInputController.text)) {
          acceptedWords.add(AcceptedWords(
              word: userInputController.text,
              score: userInputController.text.length));

          if (AcceptedWords.totalWordCount == 25) {
            setStatusMessage("gameLimitReached");
            setIsGameOver = true;
          } else {
            setStatusMessage("notSubmitted");
          }
        } else {
          setStatusMessage("wordNotFound");
        }
      } else {
        setStatusMessage("noConnection");
      }
    }
    userInputController.clear();
    update();
  }

  // Tutorial Widgets
  final List<Widget> tutorialWidgets = [
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
            left: 47,
            child: Icon(
              Icons.arrow_downward,
              size: 60,
            ),
          ),
          const Positioned(
            bottom: -40,
            left: 168,
            child: Icon(
              Icons.arrow_downward,
              size: 60,
            ),
          ),
          const Positioned(
            bottom: -50,
            right: 45,
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
            isPasswordSet: true,
            isInVault: false,
            isTutorial: true,
          ),
        ),
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
          isPasswordSet: true,
          isRecoveryMode: false,
          isTutorial: true,
        ),
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
}
