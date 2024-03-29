import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hidden_hiding_app/file_moving.dart';
import 'package:hidden_hiding_app/global.dart';
import 'package:hidden_hiding_app/screens/SecretVault/models/storage_item.dart';
import 'package:lecle_flutter_absolute_path/lecle_flutter_absolute_path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class FilePickerService {
  // Get App Hidden File Location
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Create Media Folder in App Location
  Future<Directory> createNFolder() async {
    const folderName = "MediaFiles";
    final path = Directory("${await _localPath}/$folderName");
    if ((await path.exists())) {
      debugPrint("exist");
      // debugPrint("created folder location: ${path.path}");
      return path;
    } else {
      debugPrint("not exist");
      path.create();
      debugPrint("created folder location: ${path.path}");
      return path;
    }
  }

  // Create Folder In Given Path
  Future<void> createFolderInGivenPath(
      String folderName, String currentPath, BuildContext context) async {
    final path = Directory("$currentPath/$folderName");
    if ((await path.exists())) {
      debugPrint("exist");
      debugPrint("this folder already exists: ${path.path}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('This folder already exists!'),
      ));
    } else {
      debugPrint("not exist");
      path.create();
      debugPrint("created folder location: ${path.path}");
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
  Future<FileSystemEntity> renameFileOrFolder(
      FileSystemEntity media, String newFileName) async {
    var path = media.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return media.statSync().type == FileSystemEntityType.file
        ? (media as File).renameSync(newPath)
        : (media as Directory).renameSync(newPath);
  }

  // Delete file from Gallery
  Future<void> deleteMedia(FileSystemEntity media) async {
    try {
      if (await media.exists()) {
        debugPrint("entered delete function");
        media.deleteSync(recursive: true);
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
    var mediaFilesDirectory = await createNFolder();
    var appMediaFilesList =
        mediaFilesDirectory.listSync(recursive: true, followLinks: false);
    try {
      for (var userMediaToDelete in appMediaFilesList) {
        await deleteMedia(
            userMediaToDelete.statSync().type == FileSystemEntityType.file
                ? File(userMediaToDelete.path)
                : Directory(userMediaToDelete.path));
      }
    } catch (e) {
      debugPrint("tried but failed with error!");
      debugPrint("$e");
      // Error in getting access to the file.
    }
  }

  // Multiple Files With Extension Filter
  Future<void> getFilesWithFilter(BuildContext context) async {
    bool absolutePathFailed = false;
    String absolutePath = "";
    var mediaFilesDirectory = Directory(Global().currentPath);
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'gif', 'mp4'],
      onFileLoading: (p0) {
        var fileStatus = Provider.of<FileMoving>(context, listen: false);
        if (p0 == FilePickerStatus.picking) {
          fileStatus.isFileMoving(true);
        } else {
          fileStatus.isFileMoving(false);
        }
      },
    );
    if (result != null) {
      for (PlatformFile file in result.files) {
        PlatformFile fileData = file;
        absolutePath = (await LecleFlutterAbsolutePath.getAbsolutePath(
                fileData.identifier!)
            .onError((error, stackTrace) {
          absolutePathFailed = true;
          return error.toString();
        }))!;
        debugPrint("absolute file path from uri: $absolutePath");
        if (absolutePathFailed) {
          // do not delete from absolutePath
          absolutePathFailed = false;
        } else {
          await deleteMedia(File(absolutePath));
        }
        File modifiedFile = File(file.path!);
        modifiedFile = await moveFile(
            modifiedFile,
            (await joinFilePaths(
              mediaFilesDirectory.path,
              modifiedFile.path.split("/").last,
            ))
                .path);
      }
    } else {
      // User canceled the picker
    }
  }

  // Get Dir Media items
  Future<void> getDir() async {
    List<FileSystemEntity> _folders;
    final directory = Directory(Global().currentPath);
    _folders = directory.listSync(recursive: true, followLinks: false);
    debugPrint("$_folders");
  }

  // Get Media to show in UI
  Future<List<StorageItem>> getDirMedia(Directory pathDirectory) async {
    List<FileSystemEntity> folders = [];
    debugPrint("current path directory to be listed: ${pathDirectory.path}");
    final directory = pathDirectory;
    folders = directory.listSync(followLinks: false);
    List<StorageItem> files = folders.map((item) {
      // Uint8List? thumbnailData;
      if (item.statSync().type == FileSystemEntityType.directory ||
          item.statSync().type == FileSystemEntityType.file) {
        List<String> mediaData = [];
        mediaData.add(item.path.split("/").last);
        mediaData.add(item.path.split(".").last.isNotEmpty
            ? item.path.split(".").last
            : '');
        mediaData.add(item.statSync().size.toString());
        mediaData.add(item.statSync().accessed.toString());
        return StorageItem(key: item, value: mediaData);
      } else {
        FileSystemEntity dummy = File("null");
        return StorageItem(key: dummy, value: []);
      }
    }).toList();
    files.removeWhere((element) =>
        element.key.path == "null" &&
        element.value.isEmpty); // remove dummy files
    return files;
  }
}
