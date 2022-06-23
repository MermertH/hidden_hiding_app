import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_hiding_app/global.dart';
import 'package:hidden_hiding_app/models/accepted_words.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/hexagon_button_shape.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/hexagon_clipper.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  var userInputController = TextEditingController();
  List<AcceptedWords> acceptedWords = [];
  bool isMiddleButtonPressed = false;

  @override
  void initState() {
    super.initState();
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
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.amber[100],
        appBar: AppBar(
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(
                    Icons.list,
                    size: 30,
                    color: Colors.black,
                  ),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                );
              },
            ),
          ],
          backgroundColor: Colors.amber[500],
          title: const Text("Find&Score"),
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
              ListView.builder(
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
                        Global().getMiddleButtonChar();
                        Global().getButtonCharsExceptMiddleButton();
                        userInputController.clear();
                        isMiddleButtonPressed = false;
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
            Text(
              Global().getStatusMessage(Global().statusMessage),
              style: GoogleFonts.abel(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
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
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 3, color: Colors.amber[700]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 3, color: Colors.amber[700]!),
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
                        buttonName: "LeftTop"),
                    gameButtons(
                        buttonValue: Global().selectedLetters[1],
                        buttonName: "LeftBottom"),
                  ],
                ),
                Column(
                  children: [
                    gameButtons(
                        buttonValue: Global().selectedLetters[2],
                        buttonName: "Top"),
                    gameButtons(
                        buttonValue: Global().middleButtonChar,
                        buttonName: "Middle"),
                    gameButtons(
                        buttonValue: Global().selectedLetters[3],
                        buttonName: "Bottom"),
                  ],
                ),
                Column(
                  children: [
                    gameButtons(
                        buttonValue: Global().selectedLetters[4],
                        buttonName: "RightTop"),
                    gameButtons(
                        buttonValue: Global().selectedLetters[5],
                        buttonName: "RightBottom"),
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
                        if (userInputController.text.isNotEmpty) {
                          userInputController.text = userInputController.text
                              .substring(
                                  0, userInputController.text.length - 1);
                          isMiddleButtonPressed = userInputController.text
                              .contains(Global().middleButtonChar);
                        }
                      });
                    },
                    child: const Text("Delete"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        primary: Colors.orange[300],
                        onPrimary: Colors.black),
                    onPressed: () {
                      setState(() {
                        if (Global().gameOver == true) return;
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
                      checkAndSubmitUserInput();
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget gameButtons(
      {required String buttonValue, required String buttonName}) {
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
                    colors: [Colors.amber[600]!, Colors.amber[200]!],
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
          // if (buttonName == "Middle")
          //   Positioned.fill(
          //     child: ClipPath(
          //       clipper: HexagonClipper(),
          //       child: Container(
          //         decoration: BoxDecoration(
          //           gradient: LinearGradient(
          //             begin: Alignment.topRight,
          //             end: Alignment.bottomLeft,
          //             colors: [
          //               Colors.amber[200]!,
          //               Colors.orange[700]!,
          //               Colors.amber[200]!
          //             ],
          //           ),
          //         ),
          //         child: Center(
          //           child: Text(
          //             buttonValue.toUpperCase(),
          //             style: GoogleFonts.abel(
          //                 fontWeight: FontWeight.bold,
          //                 fontSize: 30,
          //                 color: Colors.black),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          Positioned.fill(
            child: ClipPath(
              clipper: HexagonClipper(),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (Global().gameOver == true) return;
                    setState(() {
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
                          isMiddleButtonPressed = true;
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
    } else if (!isMiddleButtonPressed) {
      Global().statusMessage = "middleButtonNotPressed";
    } else {
      setState(() {
        Global().statusMessage = "waitingResponse";
      });
      if (await Global().checkConnectivityState()) {
        if (await Global().wordExists(word: userInputController.text)) {
          acceptedWords.add(AcceptedWords(
              word: userInputController.text,
              score: userInputController.text.length));
          isMiddleButtonPressed = false;
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
