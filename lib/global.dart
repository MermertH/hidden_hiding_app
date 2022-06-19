import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:hidden_hiding_app/screens/SecretVault/models/storage_item.dart';
import 'dart:math';

import 'package:video_thumbnail/video_thumbnail.dart';

class Global {
  static final Global _instance = Global._internal();
  factory Global() => _instance;
  Global._internal();

  List<StorageItem> items = [];
  bool isOnce = true;
  String currentPath = "";

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
    switch (sortType) {
      case "A_Z":
        list.sort((a, b) =>
            a.value[0].toLowerCase().compareTo(b.value[0].toLowerCase()));
        return list;
      case "Z_A":
        list.sort((a, b) =>
            a.value[0].toLowerCase().compareTo(b.value[0].toLowerCase()));
        return list.reversed.toList();
      case "firstDate":
        list.sort((a, b) => a.value[3].compareTo(b.value[3]));
        return list.reversed.toList();
      case "lastDate":
        list.sort((a, b) => a.value[3].compareTo(b.value[3]));
        return list;
      case "sizeAscending":
        list.sort((a, b) =>
            double.parse(a.value[2]).compareTo(double.parse(b.value[2])));
        return list;
      case "sizeDescending":
        list.sort((a, b) =>
            double.parse(a.value[2]).compareTo(double.parse(b.value[2])));
        return list.reversed.toList();
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

  Future<Uint8List> videoThumbnail(String path) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      quality: 100,
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
}
