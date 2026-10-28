import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    }
  }

  Future<String?> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool?> readBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  // ✅ حذف قيمة واحدة
  Future<void> remove(String key) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(key);
  }

  // ✅ حذف كل القيم
  Future<void> clear() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.clear();
  }
}
