import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amber[100],
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.list,
                size: 30,
                color: Colors.black,
              ),
            ),
          ],
          backgroundColor: Colors.amber[500],
          title: const Text("Find&Score"),
          titleTextStyle: GoogleFonts.abel(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                    onPressed: () {},
                    child: const Text("New Game"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: Text(
                "Enter your word here",
                style: GoogleFonts.abel(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
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
                    gameButtons(),
                    gameButtons(),
                  ],
                ),
                Column(
                  children: [
                    gameButtons(),
                    gameButtons(),
                    gameButtons(),
                  ],
                ),
                Column(
                  children: [
                    gameButtons(),
                    gameButtons(),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
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
                    onPressed: () {},
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

  Widget gameButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Stack(
        children: [
          CustomPaint(
            painter: HexagonButton(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 35),
              child: Text(
                "A",
                style: GoogleFonts.abel(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black),
              ),
            ),
          ),
          Positioned.fill(
            child: ClipPath(
              clipper: HexagonClipper(),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
