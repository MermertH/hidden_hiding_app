import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidden_hiding_app/preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';
import '../screens/SecretVault/models/storage_item.dart';
import '../screens/SecretVault/services/file_picker.dart';
import '../screens/SecretVault/widgets/dialogs/permission_warning_dialog.dart';

class SecretVaultController extends GetxController {
  // VARIABLES
// hidden vault variables
  final RxList<StorageItem> items = <StorageItem>[].obs;
  bool _isOnce = true;
  String _currentPath = "";
  final _isExpanded = false.obs;
  final _isLabelVisible = false.obs;
  final _isFilterMode = false.obs;
  final _isFlexible = false.obs;
  final _isDefaultPath = true.obs;
  final _isFileMoving = false.obs;
  final _fileView = true.obs;
  final _currentSort = "".obs;
  late AndroidDeviceInfo android;
  final extensionTypes = {
    "any": true.obs,
    "jpg": false.obs,
    "png": false.obs,
    "gif": false.obs,
    "mp4": false.obs,
  };

  double animationHeight = 0;
  var textKeyController = TextEditingController();
  var folderNameController = TextEditingController();
  final ScrollController filterController = ScrollController();
  final ScrollController fileController = ScrollController();
  final ScrollController listController = ScrollController();

  // getters
  bool get getIsOnce => _isOnce;
  String get getCurrentPath => _currentPath;
  RxBool get getIsExpanded => _isExpanded;
  RxBool get getIsLabelVisible => _isLabelVisible;
  RxBool get getIsFilterMode => _isFilterMode;
  RxBool get getIsFlexible => _isFlexible;
  RxBool get getIsDefaultPath => _isDefaultPath;
  RxBool get getIsFileMoving => _isFileMoving;
  RxBool get getFileView => _fileView;
  RxString get getCurrentSort => _currentSort;

  // setters
  set setIsOnce(bool condition) => _isOnce = condition;
  set setCurrentPath(String path) => _currentPath = path;
  set setIsExpanded(bool condition) => _isExpanded.value = condition;
  set setIsLabelVisible(bool condition) => _isLabelVisible.value = condition;
  set setIsFilterMode(bool condition) => _isFilterMode.value = condition;
  set setIsFlexible(bool condition) => _isFlexible.value = condition;
  set setIsDefaultPath(bool condition) => _isDefaultPath.value = condition;
  set setIsFileMoving(bool condition) => _isFileMoving.value = condition;
  set setFileView(bool value) => _fileView.value = value;
  set setCurrentSort(String value) => _currentSort.value = value;

  @override
  void onInit() async {
    setFileView = Preferences().getViewStyle;
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    android = await plugin.androidInfo;
    setCurrentSort = Preferences().getSort;
    setSavedExtensionChoices();
    super.onInit();
  }

  // FUNCTIONS
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

  void setSavedExtensionChoices() {
    for (int index = 0; index < extensionTypes.length; index++) {
      extensionTypes.values.elementAt(index).value =
          getExtensionsBool(extensionTypes.keys.elementAt(index));
    }
  }

  Future<void> setActiveExtensionsAndUpdateItems(int index) async {
    if (extensionTypes.keys.toList()[index] != "any") {
      setExtensionTypeAny(false);
      setExtensionType(index);
      setCheckExtensionTypeExceptAny(true);
    } else {
      setExtensionTypeAny(true);
      setExtensionTypeExceptAny(false);
    }
    setSavedExtensionChoices();
    print(extensionTypes);
    await getStorageItems();
  }

  void setExtensionType(int index) {
    var changedExtensionStatus =
        !getExtensionsBool(extensionTypes.keys.toList().elementAt(index));
    Preferences().setBool(
        extensionTypes.keys.toList().elementAt(index), changedExtensionStatus);
  }

  void setExtensionTypeAny(bool isAny) {
    Preferences().setBool(extensionTypes.keys.elementAt(0), isAny);
  }

  void setCheckExtensionTypeExceptAny(bool isAny) {
    // if no filter selected then make 'any' filter true
    bool checkResult = false;
    for (int index = 1; index < extensionTypes.length; index++) {
      checkResult =
          getExtensionsBool(extensionTypes.keys.toList().elementAt(index));

      if (checkResult) {
        break;
      }
    }
    if (!checkResult) {
      Preferences().setBool(extensionTypes.keys.elementAt(0), isAny);
    }
  }

  void setExtensionTypeExceptAny(bool isAny) {
    for (int index = 1; index < extensionTypes.length; index++) {
      Preferences()
          .setBool(extensionTypes.keys.toList().elementAt(index), isAny);
    }
  }

  Future<void> updateCurrentSortAndItems(String value) async {
    Preferences().setSort = value;
    setCurrentSort = value;
    await getStorageItems();
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
    if (getExtensionsBool("any")) {
      return list;
    }
    if (extensionTypes.keys
        .toList()
        .any((extension) => getExtensionsBool(extension))) {
      List<String> activeExtensionFilters = extensionTypes.keys
          .where((extension) => getExtensionsBool(extension))
          .toList();
      return list
          .where((listItem) => activeExtensionFilters.any((extension) =>
              extension.contains(listItem.value[0].split(".").last)))
          .toList();
    }
    return list;
  }

  // to get desired extension's saved status
  bool getExtensionsBool(String key) =>
      (Preferences.sharedPreferences?.getBool(key) ?? false);

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

  String getFileSizeFormat({required int bytes, int decimals = 0}) {
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

  Future<void> getInitDir() async {
    if (getIsOnce) {
      var initDir = await FilePickerService.createNFolder();
      setCurrentPath = initDir.path;
      setIsOnce = false;
    }
  }

  Future<void> getStorageItems() async {
    late bool permissionStatus;
    if (android.version.sdkInt < 33) {
      permissionStatus = await Permission.storage.status.isGranted &&
          await Permission.manageExternalStorage.status.isGranted;
    } else {
      permissionStatus = await Permission.photos.status.isGranted &&
          await Permission.manageExternalStorage.status.isGranted;
    }

    if (permissionStatus) {
      await getInitDir();
      items.clear();
      List<StorageItem> gatheredItems =
          await FilePickerService.getDirMedia(Directory(getCurrentPath));
      List<StorageItem> extensionFilteredItems =
          applyExtensionFilter(gatheredItems);
      // Global().items = await Global().getVideoThumbnails(Global().items);
      items.addAll(
          applySelectedSort(extensionFilteredItems, Preferences().getSortData));
      items.refresh();
    } else {
      debugPrint("Permissions NOT granted!");
    }
  }

  Future<void> requestPermission() async {
    var externalStoragePermissionStatus =
        await Permission.manageExternalStorage.status;
    if (!externalStoragePermissionStatus.isGranted) {
      await Permission.manageExternalStorage.request().then((permission) {
        if (permission.isDenied ||
            permission.isPermanentlyDenied ||
            !permission.isGranted) {
          debugPrint("Permissions not granted");
        }
      }).whenComplete(() async {
        if (await Permission.storage.status.isGranted &&
            await Permission.manageExternalStorage.status.isGranted) {
          await getStorageItems();
        }
      });
    }

    var storagePermissionStatus = await Permission.storage.status;
    debugPrint(android.version.sdkInt.toString());
    if (android.version.sdkInt < 33) {
      if (!storagePermissionStatus.isGranted) {
        await Permission.storage.request().then((permission) async {
          if (permission.isPermanentlyDenied ||
              (await Permission.manageExternalStorage.status.isDenied)) {
            Get.dialog(
              PermissionWarningDialog(
                isPermanentlyDenied: permission.isPermanentlyDenied,
                isExternalStoragePermanentlyDenied:
                    externalStoragePermissionStatus.isPermanentlyDenied,
              ),
              barrierDismissible: false,
            );
          }
        }).whenComplete(() async {
          if (await Permission.storage.status.isGranted &&
              await Permission.manageExternalStorage.status.isGranted) {
            await getStorageItems();
          }
        });
      } else {
        debugPrint("Storage permission is not granted!");
      }
    } else {
      await Permission.photos.request().then((photoPermission) async {
        if (photoPermission.isGranted) {
          await getStorageItems();
        } else if (photoPermission.isDenied ||
            photoPermission.isPermanentlyDenied) {
          Get.dialog(
            PermissionWarningDialog(
              isPermanentlyDenied: false,
              isExternalStoragePermanentlyDenied:
                  externalStoragePermissionStatus.isPermanentlyDenied,
              otherPermissionsDenied: true,
            ),
            barrierDismissible: false,
          );
        } else {
          debugPrint("missing condition found in photo permission logic!");
        }
      });
    }
  }
}
