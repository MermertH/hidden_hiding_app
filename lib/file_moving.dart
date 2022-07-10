import 'package:flutter/cupertino.dart';

class FileMoving with ChangeNotifier {
  // ignore: prefer_final_fields
  bool _isMoving = false;

  bool get moving => _isMoving;

  void isFileMoving(bool isMoving) {
    _isMoving = isMoving;
    notifyListeners();
  }
}
