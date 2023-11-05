import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/controller/game_controller.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/hexagon_button_shape.dart';
import 'package:hidden_hiding_app/screens/WordGame/widgets/hexagon_clipper.dart';

class GameButton extends StatelessWidget {
  final String buttonValue;
  final String buttonName;
  const GameButton(
      {Key? key, required this.buttonValue, required this.buttonName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameController _gameCont = Get.find();
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
                      colors:
                          _gameCont.getCombinationButtonStatus(buttonName).value
                              ? [Colors.red[600]!, Colors.amber[200]!]
                              : [Colors.amber[600]!, Colors.amber[200]!],
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
          ),
          Positioned.fill(
            child: ClipPath(
              clipper: HexagonClipper(),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.find<GameController>().onHexagonButtonTapped(
                    buttonName: buttonName,
                    buttonValue: buttonValue,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
