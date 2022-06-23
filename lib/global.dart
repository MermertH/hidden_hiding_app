import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:hidden_hiding_app/screens/SecretVault/models/storage_item.dart';
import 'dart:math';
import 'package:video_compress/video_compress.dart';

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

// FUNCTIONS
// game screen functions
  void getMiddleButtonChar() {
    List<String> vowels = [];
    var rng = Random();
    vowels.addAll(["a", "e", "i", "o", "u"]);
    middleButtonChar =
        vowels.elementAt(rng.nextInt(vowels.length)).toUpperCase();
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
