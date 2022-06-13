import 'package:file_picker/file_picker.dart';
import 'package:hidden_hiding_app/screens/SecretVault/models/storage_item.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/storage_service.dart';

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
            .compareTo(b.value..split(",")[0].toLowerCase()));
        return list;
      case "Z_A":
        list.sort((a, b) => a.value
            .split(",")[0]
            .toLowerCase()
            .compareTo(b.value..split(",")[0].toLowerCase()));
        return list.reversed.toList();
      case "firstDate":
        list.sort(
            (a, b) => a.value.split(",")[3].compareTo(b.value..split(",")[3]));
        return list.reversed.toList();
      case "lastDate":
        list.sort(
            (a, b) => a.value.split(",")[3].compareTo(b.value..split(",")[3]));
        return list;
      default:
        return list;
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
