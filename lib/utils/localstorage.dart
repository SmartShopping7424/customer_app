import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class LocalStorage {
  // function to set local storage value
  static setLocalStorage(key, value) async {
    await storage.write(key: key, value: value);
  }

  // function to get local storage value
  static getLocalStorage(key) async {
    var value = await storage.read(key: key);
    return value;
  }

  // function to clear local storage value
  static clearLocalStorage(key) async {
    await storage.delete(key: key);
  }

  // function to clear all local storage key
  static clearAllLocalStorage() async {
    var allKey = await storage.readAll();
    allKey.forEach((key, value) async {
      if (key != 'route_name') {
        await clearLocalStorage(key);
      }
    });
  }
}
