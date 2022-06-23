import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_hiding_app/global.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/hexagon_button_shape.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/hexagon_clipper.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  var userInputController = TextEditingController();

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
                itemCount: 5,
                itemBuilder: (context, index) => Card(
                  color: Colors.amber[300],
                  child: ListTile(
                    leading: Icon(
                      Icons.star,
                      color: Colors.red[300]!,
                    ),
                    title: Text(
                      "Word",
                      style: GoogleFonts.abel(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Text(
                      "Point: ${Random().nextInt(20) + 1}",
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
                    "Score: 0",
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
                        Global().getMiddleButtonChar();
                        Global().getButtonCharsExceptMiddleButton();
                      });
                    },
                    child: const Text("New Game"),
                  ),
                ],
              ),
            ),
            Text(
              "Enter your word here",
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                cursorColor: Colors.black,
                cursorWidth: 3,
                onSubmitted: (_) {},
                controller: userInputController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF2F2F2),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 3, color: Colors.amber[700]!),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 3, color: Colors.black),
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
                    onPressed: () {},
                    child: const Text("Delete"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        primary: Colors.orange[300],
                        onPrimary: Colors.black),
                    onPressed: () {
                      setState(() {
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
                    onPressed: () {},
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
            child: SizedBox(
              width: 100,
              height: 100,
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
          Positioned.fill(
            child: ClipPath(
              clipper: HexagonClipper(),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
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
