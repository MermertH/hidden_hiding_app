import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _instance = Preferences._internal();
  static SharedPreferences? sharedPreferences;
  factory Preferences() => _instance;
  Preferences._internal();
  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static final defaultSettings = {
    "firstTime": true,
    "IsPasswordSetMode": false,
    "isExportPathSelected": false,
    "fileView": true,
    "sort": "A_Z",
    "exportPath": "none",
  };

  static final buttonCombinations = {
    "LeftTop": 0,
    "LeftBottom": 0,
    "Top": 0,
    "Middle": 0,
    "Bottom": 0,
    "RightTop": 0,
    "RightBottom": 0,
  };

  static final extensionTypes = {
    "any": true,
    "jpg": false,
    "png": false,
    "gif": false,
    "mp4": false,
  };

  static final sortTypes = {
    "A_Z": "A_Z",
    "Z_A": "Z_A",
    "firstDate": "firstDate",
    "lastDate": "lastDate",
    "sizeDescending": "sizeDescending",
    "sizeAscending": "sizeAscending",
  };

  String getString(String key) =>
      (sharedPreferences?.getString(key) ?? '${defaultSettings[key]}');
  Future<bool>? setString(String key, String value) =>
      sharedPreferences?.setString(key, value);
  int getInt(String key) =>
      (sharedPreferences?.getInt(key) ?? (defaultSettings[key] as int));
  Future<bool>? setInt(String key, int value) =>
      sharedPreferences?.setInt(key, value);
  bool getBool(String key) =>
      (sharedPreferences?.getBool(key) ?? (defaultSettings[key] as bool));
  Future<bool>? setBool(String key, bool value) =>
      sharedPreferences?.setBool(key, value);

// to get desired extension's status
  bool getExtensionsBool(String key) =>
      (sharedPreferences?.getBool(key) ?? (extensionTypes[key] as bool));

// to Set combination or check if saved combination is same as user selection
  int getCombinationCount(String key) =>
      (sharedPreferences?.getInt(key) ?? (buttonCombinations[key] as int));
  Future<bool>? setCombinationCount(String key, int value) =>
      sharedPreferences?.setInt(key, value);

// Works when app opened first time
  get getFirstTime => getBool('firstTime');
  set setFirstTime(bool firstTime) => setBool('firstTime', firstTime);

// Works when app is in change password mode
  get getIsPasswordSetMode => getBool('IsPasswordSetMode');
  set setIsPasswordSetMode(bool isPasswordSetMode) =>
      setBool('IsPasswordSetMode', isPasswordSetMode);

// Export Path
  get getIsExportPathSelected => getBool('isExportPathSelected');
  set setIsExportPathSelected(bool isExportPathSelected) =>
      setBool('isExportPathSelected', isExportPathSelected);

  get getExportPath => getString("exportPath");
  set setExportPath(String exportPath) => setString('exportPath', exportPath);

// View Style
  get getViewStyle => getBool('fileView');
  set setViewStyle(bool fileView) => setBool('fileView', fileView);

// Sorting
  get getSort => getString('sort');
  get getSortData => sortTypes[getSort];
  set setSort(String sort) => setString('sort', sort);

// Extension Filter
  set setExtensionType(int index) {
    setBool(
        extensionTypes.keys.toList().elementAt(index),
        extensionTypes.values.toList()[index] =
            !getExtensionsBool(extensionTypes.keys.toList().elementAt(index)));
  }

  set setExtensionTypeAny(bool isAny) {
    setBool(extensionTypes.keys.toList().elementAt(0), isAny);
  }

  set setCheckExtensionTypeExceptAny(bool isAny) {
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
      setBool(extensionTypes.keys.toList().elementAt(0), isAny);
    }
  }

  set setExtensionTypeExceptAny(bool isAny) {
    for (int index = 1; index < extensionTypes.length; index++) {
      setBool(extensionTypes.keys.toList().elementAt(index), isAny);
    }
  }
}
