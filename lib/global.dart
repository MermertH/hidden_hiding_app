import 'package:file_picker/file_picker.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:hidden_hiding_app/screens/SecretVault/models/storage_item.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/storage_service.dart';
import 'dart:math';

class Global {
  static final Global _instance = Global._internal();
  factory Global() => _instance;
  Global._internal();
  var storageService = StorageService();

  List<StorageItem> items = [];

  dynamic getFileInfo(String fileData, String dataType) {
    switch (dataType) {
      case "name":
        return fileData.split(",")[0];
      case "extension":
        return fileData.split(",")[1];
      case "size":
        return fileData.split(",")[2];
      case "date":
        return DateTime.parse(fileData.split(",")[3]);
      default:
        return "Not Found";
    }
  }

  List<StorageItem> applySelectedSort(List<StorageItem> list, String sortType) {
    switch (sortType) {
      case "A_Z":
        list.sort((a, b) => a.value
            .split(",")[0]
            .toLowerCase()
            .compareTo(b.value.split(",")[0].toLowerCase()));
        return list;
      case "Z_A":
        list.sort((a, b) => a.value
            .split(",")[0]
            .toLowerCase()
            .compareTo(b.value..split(",")[0].toLowerCase()));
        return list.reversed.toList();
      case "firstDate":
        list.sort(
            (a, b) => a.value.split(",")[3].compareTo(b.value.split(",")[3]));
        return list.reversed.toList();
      case "lastDate":
        list.sort(
            (a, b) => a.value.split(",")[3].compareTo(b.value.split(",")[3]));
        return list;
      case "sizeAscending":
        list.sort((a, b) => double.parse(a.value.split(",")[2])
            .compareTo(double.parse(b.value.split(",")[2])));
        return list;
      case "sizeDescending":
        list.sort((a, b) => double.parse(a.value.split(",")[2])
            .compareTo(double.parse(b.value.split(",")[2])));
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
              extension.contains(listItem.value.split(",")[0].split(".").last)))
          .toList();
    }
    return list;
  }

  String sizeFormat(double size) {
    if (size.toString().length < 4) {
      return "${size}byte";
    } else if (size.toString().length >= 4 && size.toString().length <= 7) {
      return "${(size / pow(10, 3)).toStringAsFixed(3)}kB";
    } else if (size.toString().length >= 8 && size.toString().length <= 11) {
      return "${(size / pow(10, 6)).toStringAsFixed(3)}MB";
    } else if (size.toString().length >= 12 && size.toString().length <= 15) {
      return "${(size / pow(10, 9)).toStringAsFixed(3)}GB";
    } else {
      return size.toString();
    }
  }

  String setNewFileName(String name, int index) {
    return "$name,${Global().getFileInfo(Global().items[index].value, "extension")},${Global().getFileInfo(Global().items[index].value, "size")},${Global().getFileInfo(Global().items[index].value, "date")}";
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
