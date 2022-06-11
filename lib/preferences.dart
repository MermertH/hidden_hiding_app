import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static final Preferences _instance = Preferences._internal();
  static SharedPreferences? sharedPreferences;

  static final defaultSettings = {
    "isExportPathSelected": false,
    "exportPath": "none",
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
}
