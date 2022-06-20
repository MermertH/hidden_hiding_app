import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hidden_hiding_app/models/user_data.dart';

class StorageService {
  final _secureStorage = const FlutterSecureStorage();

  // write data
  Future<void> writeSecureData(UserData newItem) async {
    await _secureStorage.write(
        key: newItem.key, value: newItem.value, aOptions: _getAndroidOptions());
  }

  // read data
  Future<String?> readSecureData(String key) async {
    var readData =
        await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
    return readData;
  }

  // delete data
  Future<void> deleteSecureData(UserData item) async {
    await _secureStorage.delete(key: item.key, aOptions: _getAndroidOptions());
  }

  // contains key
  Future<bool> containsKeyInSecureData(String key) async {
    var containsKey = await _secureStorage.containsKey(
        key: key, aOptions: _getAndroidOptions());
    return containsKey;
  }

  // read all data
  Future<List<UserData>> readAllSecureData() async {
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions());
    List<UserData> list = allData.entries
        .map((e) => UserData(key: e.key, value: e.value))
        .toList();
    return list;
  }

  // delete all data
  Future<void> deleteAllSecureData() async {
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
}
