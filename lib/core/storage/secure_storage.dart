import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecureStorage {
  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  String? getToken() {
    return _prefs.getString('auth_token');
  }

  Future<void> removeToken() async {
    await _prefs.remove('auth_token');
  }

  Future<void> saveUserData(String userData) async {
    await _prefs.setString('user_data', userData);
  }

  String? getUserData() {
    return _prefs.getString('user_data');
  }

  Future<void> removeUserData() async {
    await _prefs.remove('user_data');
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}

final secureStorageProvider = Provider<SecureStorage>((ref) {
  final storage = SecureStorage();
  return storage;
});