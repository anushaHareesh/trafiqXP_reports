import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class GetStorageUtility {
  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static String read(String key, [String? defValue]) {
    return _prefsInstance!.getString(key) ?? defValue ?? "";
  }

  static Future<bool> write(String key, String value) async {
    var prefs = await _instance;
    return prefs.setString(key, value) ;
  }
}