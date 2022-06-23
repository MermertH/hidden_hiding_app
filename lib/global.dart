import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:hidden_hiding_app/screens/SecretVault/models/storage_item.dart';
import 'package:video_compress/video_compress.dart';
import 'package:http/http.dart' as http;

class Global {
  static final Global _instance = Global._internal();
  factory Global() => _instance;
  Global._internal();

// VARIABLES
// hidden vault variables
  List<StorageItem> items = [];
  bool isOnce = true;
  String currentPath = "";

// game screen variables
  String middleButtonChar = "";
  List<String> selectedLetters = [];
  String statusMessage = "notSubmitted";
  bool isCombinationTriggered = false;
  bool gameOver = false;
  var combinationButtons = {
    "LeftTop": false,
    "LeftBottom": false,
    "Top": false,
    "Middle": false,
    "Bottom": false,
    "RightTop": false,
    "RightBottom": false,
  };

// FUNCTIONS
// game screen functions

  void setCombinationButtonStatus(bool buttonStatus, String buttonName) {
    combinationButtons[combinationButtons.entries
        .firstWhere((button) => button.key == buttonName)
        .key] = buttonStatus;
  }

  bool getCombinationButtonStatus(String buttonName) {
    return combinationButtons[combinationButtons.entries
        .firstWhere((button) => button.key == buttonName)
        .key]!;
  }

  Future<bool> checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi) {
      return true;
    } else if (result == ConnectivityResult.mobile) {
      return true;
    } else {
      return false;
    }
  }

  String getStatusMessage(String key) {
    switch (key) {
      case "notSubmitted":
        return "Enter your word here";
      case "noInputFound":
        return "Field cannot be blank!";
      case "middleButtonNotPressed":
        return "The middle button must be pressed at least once!";
      case "wordNotFound":
        return "Submitted word not found";
      case "sameWordWarning":
        return "This word is already found";
      case "waitingResponse":
        return "Checking word...";
      case "rateLimitExceed":
        return "Too much request made frequently, please wait a bit and try again";
      case "gameLimitReached":
        return "Game Over!";
      case "noConnection":
        return "No internet connection, please connect and try again";
      case "combinationSet":
        return "Please tap each hexagon button once to create your unique combination";
      default:
        return "An error occured";
    }
  }

  void getMiddleButtonChar() {
    List<String> vowels = [];
    var rng = Random();
    vowels.addAll(["a", "e", "i", "o", "u"]);
    middleButtonChar = vowels.elementAt(rng.nextInt(vowels.length));
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
      Global().statusMessage = "rateLimitExceed";
      return false;
    } else {
      return false;
    }
  }

  void getButtonCharsExceptMiddleButton() {
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
    englishAlphabet.remove(middleButtonChar);
    for (int count = 0; count < 6; count++) {
      currentRngIndex = rng.nextInt(englishAlphabet.length);
      selectedLetters.add(englishAlphabet[currentRngIndex]);
      englishAlphabet.removeAt(currentRngIndex);
    }
  }

// hidden vault functions
  dynamic getFileInfo(List<String> fileData, String dataType) {
    switch (dataType) {
      case "name":
        return fileData[0];
      case "extension":
        return fileData[1];
      case "size":
        return fileData[2];
      case "date":
        return DateTime.parse(fileData[3]);
      default:
        return "Not Found";
    }
  }

  List<StorageItem> applySelectedSort(List<StorageItem> list, String sortType) {
    List<StorageItem> folderList = [];
    List<StorageItem> fileList = [];
    folderList = list
        .where((folderCandidate) =>
            folderCandidate.key.statSync().type ==
            FileSystemEntityType.directory)
        .toList();
    fileList = list
        .where((fileCandidate) =>
            fileCandidate.key.statSync().type == FileSystemEntityType.file)
        .toList();
    switch (sortType) {
      case "A_Z":
        folderList.sort((a, b) =>
            a.value[0].toLowerCase().compareTo(b.value[0].toLowerCase()));
        fileList.sort((a, b) =>
            a.value[0].toLowerCase().compareTo(b.value[0].toLowerCase()));
        list = [...folderList, ...fileList];
        return list;
      case "Z_A":
        folderList.sort((a, b) =>
            a.value[0].toLowerCase().compareTo(b.value[0].toLowerCase()));
        fileList.sort((a, b) =>
            a.value[0].toLowerCase().compareTo(b.value[0].toLowerCase()));
        list = [...folderList.reversed.toList(), ...fileList.reversed.toList()];
        return list;
      case "firstDate":
        folderList.sort((a, b) => a.value[3].compareTo(b.value[3]));
        fileList.sort((a, b) => a.value[3].compareTo(b.value[3]));
        list = [...folderList.reversed.toList(), ...fileList.reversed.toList()];
        return list;
      case "lastDate":
        folderList.sort((a, b) => a.value[3].compareTo(b.value[3]));
        fileList.sort((a, b) => a.value[3].compareTo(b.value[3]));
        list = [...folderList, ...fileList];
        return list;
      case "sizeAscending":
        folderList.sort((a, b) =>
            double.parse(a.value[2]).compareTo(double.parse(b.value[2])));
        fileList.sort((a, b) =>
            double.parse(a.value[2]).compareTo(double.parse(b.value[2])));
        list = [...folderList, ...fileList];
        return list;
      case "sizeDescending":
        folderList.sort((a, b) =>
            double.parse(a.value[2]).compareTo(double.parse(b.value[2])));
        fileList.sort((a, b) =>
            double.parse(a.value[2]).compareTo(double.parse(b.value[2])));
        list = [...folderList.reversed.toList(), ...fileList.reversed.toList()];
        return list;
      default:
        return list;
    }
  }

  List<StorageItem> applyExtensionFilter(List<StorageItem> list) {
    if (Preferences().getExtensionsBool("any")) {
      return list;
    }
    if (Preferences.extensionTypes.keys
        .toList()
        .any((extension) => Preferences().getExtensionsBool(extension))) {
      List<String> activeExtensionFilters = Preferences.extensionTypes.keys
          .where((extension) => Preferences().getExtensionsBool(extension))
          .toList();
      return list
          .where((listItem) => activeExtensionFilters.any((extension) =>
              extension.contains(listItem.value[0].split(".").last)))
          .toList();
    }
    return list;
  }

  // Future<List<StorageItem>> getVideoThumbnails(List<StorageItem> list) async {
  //   List<StorageItem> videoFiles = [];
  //   List<StorageItem> otherMedia = [];
  //   videoFiles = list.where((media) => media.value[1] == "mp4").toList();
  //   otherMedia = list.where((media) => media.value[1] != "mp4").toList();
  //   for (var video in videoFiles) {
  //     video.thumbnail = await videoThumbnail(video.key.path);
  //   }
  //   return [...videoFiles, ...otherMedia];
  // }

  Future<Uint8List> videoThumbnail(String path) async {
    final uint8list = await VideoCompress.getByteThumbnail(path,
        quality: 100, // default(100)
        position: -1 // default(-1)
        );
    return uint8list!;
  }

  static String getFileSizeFormat({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  Future<String> getDirectoryToExportMediaFile() async {
    String? exportPath = await FilePicker.platform.getDirectoryPath();
    if (exportPath == null) {
      // User canceled the picker
      return "none";
    } else {
      return exportPath;
    }
  }

  // global functions
  applyFlag() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  removeFlag() async {
    await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
