import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localStorageProvider = Provider<LocalStorage>((ref) {
  return LocalStorage();
});

class LocalStorage {
  final _secureStorage = const FlutterSecureStorage();
  
  static const _tokenKey = 'auth_token';
  static const _userTypeKey = 'user_type'; // 'customer' or 'merchant'

  // --- Secure Storage for Sensitive Data ---
  
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  // --- Shared Preferences for General App Settings ---

  Future<void> saveUserType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTypeKey, type);
  }

  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey);
  }
  
  Future<void> clearAll() async {
    await deleteToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
