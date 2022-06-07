import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:hidden_hiding_app/screens/SecretVault/models/storage_item.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/storage_service.dart';

class FilePickerService {
  var storageService = StorageService();

  // Single File
  Future<void> getSingleFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile fileData = result.files.first;
      File file = File(result.files.single.path!);
      storageService.writeSecureData(StorageItem(file.path, fileData.name));
    } else {
      // User canceled the picker
    }
  }

  // Single File With Extension Filter
  Future<void> getFileWithFilter() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (result != null) {
      PlatformFile fileData = result.files.first;
      File file = File(result.files.single.path!);
      storageService.writeSecureData(StorageItem(file.path, fileData.name));
    } else {
      // User canceled the picker
    }
  }

  // Multiple Files
  Future<void> getMultipleFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<StorageItem> files = result.files
          .map((file) => StorageItem(file.path!, file.name))
          .toList();
      for (var item in files) {
        await storageService.writeSecureData(item);
      }
    } else {
      // User canceled the picker
    }
  }

  // Multiple Files With Extension Filter
  Future<void> getFilesWithFilter() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      List<StorageItem> files = result.files
          .map((file) => StorageItem(file.path!, file.name))
          .toList();
      for (var item in files) {
        await storageService.writeSecureData(item);
      }
    } else {
      // User canceled the picker
    }
  }

  // Pick a Directory
  Future<String> pickDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory == null) {
      // User canceled the picker
      return selectedDirectory!;
    } else {
      return "";
    }
  }

  // // Save-File / Save-as Dialog
  // Future<String> saveFile() async {
  //   String? outputFile = await FilePicker.platform.saveFile(
  //     dialogTitle: 'Please select an output file:',
  //     fileName: 'output-file.pdf',
  //   );

  //   if (outputFile == null) {
  //     // User canceled the picker
  //     return "";
  //   } else {
  //     return outputFile;
  //   }
  // }

  // Load Result and File Details
  void getResultAndFileDetails() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
    } else {
      // User canceled the picker
    }
  }
}
