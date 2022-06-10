import 'package:hidden_hiding_app/screens/SecretVault/models/storage_item.dart';

class Global {
  static final Global _instance = Global._internal();
  factory Global() => _instance;
  Global._internal();

  List<StorageItem> items = [];

  String getFileInfo(String fileData, String dataType) {
    switch (dataType) {
      case "name":
        return fileData.split(",")[0];
      case "extension":
        return fileData.split(",")[1];
      case "size":
        return fileData.split(",")[2];
      default:
        return "Not Found";
    }
  }

  String setNewFileName(String name, int index) {
    return "$name,${Global().getFileInfo(Global().items[index].value, "extension")},${Global().getFileInfo(Global().items[index].value, "size")}";
  }
}
