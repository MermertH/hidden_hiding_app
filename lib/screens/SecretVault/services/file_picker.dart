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

  Future<String> get _safeLocalPath async {
    final directory = await getExternalStorageDirectory();
    return directory!.path;
  }

  // Create Media Folder in App Location
  Future<Directory> _createNFolder() async {
    const folderName = "MediaFiles";
    final path = Directory("${await _safeLocalPath}/$folderName");
    if ((await path.exists())) {
      debugPrint("exist");
      debugPrint("created folder location: ${path.path}");
      return path;
    } else {
      debugPrint("not exist");
      path.create();
      await addNewFileToGivenPath(path.path, ".nomedia");
      debugPrint("created folder location: ${path.path}");
      return path;
    }
  }

  // Create file
  Future<void> addNewFileToGivenPath(String root, String pathFile) async {
    final path = "$root/$pathFile";
    File(path).create(recursive: true);
  }

  // Add file to the MediaFolder location
  Future<File> joinFilePaths(String root, String pathFile) async {
    final path = "$root/$pathFile";
    return File(path).create(recursive: true);
  }

  // Move file to the app location
  Future<File> moveFile(File sourceFile, String newPath) async {
    try {
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    } on FileSystemException catch (e) {
      debugPrint("move file error worked: $e");
      return File(sourceFile.path); // return same path when move file is failed
    }
  }

  // Rename File
  Future<File> renameFile(File sourceFile, String newPath) async {
    try {
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (e) {
      debugPrint("the rename file error was: $e");
      return File(
          sourceFile.path); // return same path when rename file is failed
    }
  }

  // Delete file from Gallery
  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        debugPrint("entered delete function");
        await file.delete(recursive: true);
      } else {
        debugPrint("no file found to delete");
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

  // Multiple Files With Extension Filter
  Future<void> getFilesWithFilter() async {
    String absolutePath = "";
    String fileDetails = "";
    var mediaFilesDirectory = await _createNFolder();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'gif', 'mp4'],
    );
    if (result != null) {
      List<Future<StorageItem>> files = result.files.map((file) async {
        PlatformFile fileData = file;
        absolutePath = (await LecleFlutterAbsolutePath.getAbsolutePath(
            fileData.identifier!))!;
        debugPrint("absolute file path from uri: $absolutePath");
        await deleteFile(File(absolutePath));
        File modifiedFile = File(file.path!);
        modifiedFile = await moveFile(
            modifiedFile,
            (await joinFilePaths(
              mediaFilesDirectory.path,
              modifiedFile.path.split("/").last,
            ))
                .path);
        fileDetails =
            "${modifiedFile.path.split("/").last},${fileData.extension},${fileData.size},${DateTime.now()}";
        return StorageItem(modifiedFile.path, fileDetails);
      }).toList();
      for (var storageItem in files) {
        await storageService.writeSecureData(await storageItem);
      }
    } else {
      // User canceled the picker
    }
  }

  Future<void> getDir() async {
    //TODO delete after vault is done
    List<FileSystemEntity> _folders;
    List<FileSystemEntity> _safeFolders;
    final directory = await _localPath;
    final topLevelStorageDir = await _safeLocalPath;
    final myDir = Directory('$directory/');
    final safeDir = Directory('$topLevelStorageDir/');
    _folders = myDir.listSync(recursive: true, followLinks: false);
    _safeFolders = safeDir.listSync(recursive: true, followLinks: true);
    debugPrint(topLevelStorageDir);
    debugPrint("$_safeFolders");
  }
}
