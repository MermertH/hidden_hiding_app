import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:hidden_hiding_app/screens/SecretVault/models/storage_item.dart';
import 'package:hidden_hiding_app/screens/SecretVault/services/storage_service.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:path_provider/path_provider.dart';

class FilePickerService {
  var storageService = StorageService();

  // Get App File Location
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Create Media Folder in App Location
  Future<Directory> _createNFolder() async {
    const folderName = "MediaFiles";
    final path = Directory("${await _localPath}/$folderName");
    if ((await path.exists())) {
      debugPrint("exist");
      debugPrint("created folder location: ${path.path}");
      return path;
    } else {
      debugPrint("not exist");
      path.create();
      debugPrint("created folder location: ${path.path}");
      return path;
    }
  }

  // Add file to the MediaFolder location
  Future<File> _addToLocalFolder(String root, String pathFile) async {
    final path = "$root/$pathFile";
    return File(path).create(recursive: true);
  }

  // Move file to the app location
  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      // prefer using rename as it is probably faster
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      debugPrint("$e");
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    }
  }

  // Delete file from Gallery
  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        print("entered delete function");
        await file.delete(recursive: true);
      } else {
        print("no file found to delete");
      }
    } catch (e) {
      debugPrint("tried but failed with error!");
      debugPrint("$e");
      // Error in getting access to the file.
    }
  }

  // Delete files from app location
  Future<void> deleteFilesFormApp() async {
    var mediaFilesDirectory = await _createNFolder();
    var appMediaFilesList =
        mediaFilesDirectory.listSync(recursive: true, followLinks: false);
    try {
      for (var userMediaToDelete in appMediaFilesList) {
        await deleteFile(File(userMediaToDelete.path));
      }
    } catch (e) {
      debugPrint("tried but failed with error!");
      debugPrint("$e");
      // Error in getting access to the file.
    }
  }

  // Single File
  Future<void> getSingleFile() async {
    String absolutePath = "";
    String fileDetails = "";
    var mediaFilesDirectory = await _createNFolder();
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile fileData = result.files.first;
      fileDetails =
          "${fileData.name},${fileData.extension},${fileData.size},${fileData.bytes}";
      debugPrint(
          "absolute file path from uri: ${absolutePath = (await LecleFlutterAbsolutePath.getAbsolutePath(fileData.identifier!))!}");
      File file = File(result.files.single.path!);
      file = await moveFile(
          file,
          (await _addToLocalFolder(
            mediaFilesDirectory.path,
            file.path.split("/").last,
          ))
              .path);
      storageService.writeSecureData(StorageItem(file.path, fileDetails));
      // await deleteFile(File(absolutePath));
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

  Future<void> getDir() async {
    //TODO delete after vault is done
    List<FileSystemEntity> _folders;
    final directory = await getApplicationDocumentsDirectory();
    final myDir = Directory('${directory.path}/');
    _folders = myDir.listSync(recursive: true, followLinks: false);
    debugPrint("$_folders");
  }
}
