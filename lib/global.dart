import 'package:file_picker/file_picker.dart';
import 'package:hidden_hiding_app/screens/SecretVault/models/storage_item.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/storage_service.dart';

class Global {
  static final Global _instance = Global._internal();
  factory Global() => _instance;
  Global._internal();
  var storageService = StorageService();

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
