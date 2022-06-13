import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _instance = Preferences._internal();
  static SharedPreferences? sharedPreferences;

  static final defaultSettings = {
    "isExportPathSelected": false,
    "fileView": "file",
    "sort": "A_Z",
    "exportPath": "none",
  };

  static final sortTypes = {
    "A_Z": "A_Z",
    "Z_A": "Z_A",
    "firstDate": "firstDate",
    "lastDate": "lastDate",
  };

  factory Preferences() => _instance;
  Preferences._internal();
  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

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

  get getIsExportPathSelected => getBool('isExportPathSelected');
  set setIsExportPathSelected(bool isExportPathSelected) =>
      setBool('isExportPathSelected', isExportPathSelected);

  get getExportPath => getString("exportPath");
  set setExportPath(String exportPath) => setString('exportPath', exportPath);

  get getViewStyle => getString('fileView');
  set setViewStyle(String fileView) => setString('fileView', fileView);

  get getSort => getString('sort');
  get getSortData => sortTypes[getSort];
  set setSort(String sort) => setString('sort', sort);
}
