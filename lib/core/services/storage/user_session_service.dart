import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Shared prefs Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError("Initialized in main");
});

//provider
final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  return UserSessionService(prefs: ref.read(sharedPreferencesProvider));
});

class UserSessionService {
  final SharedPreferences _prefs;

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  //keys for storing data
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyId = 'user_id';
  static const String _keyEmail = 'user_email';
  static const String _keyFullName = 'user_full_name';

  //store user session data
  Future<void> saveUserSession({
    required String authId,
    required String email,
    required String fullName,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyId, authId);
    await _prefs.setString(_keyEmail, email);
    await _prefs.setString(_keyFullName, fullName);
  }

  //clear user session data
  Future<void> clearUserSession() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyId);
    await _prefs.remove(_keyEmail);
    await _prefs.remove(_keyFullName);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  String? getUserId() {
    return _prefs.getString(_keyId);
  }

  String? getUserEmail() {
    return _prefs.getString(_keyEmail);
  }

  String? getUserFullName() {
    return _prefs.getString(_keyFullName);
  }
}
