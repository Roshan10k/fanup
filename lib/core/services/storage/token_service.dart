import 'package:fanup/core/services/storage/user_session_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

//provider
final tokenServiceProvider = Provider<TokenService>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return TokenService(sharedPreferences: sharedPreferences);
});

class TokenService {
  final SharedPreferences _prefs;
  static const String _tokenKey = 'auth_token';

  TokenService({required SharedPreferences sharedPreferences})
    : _prefs = sharedPreferences;

  //save token
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  //get token
  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  //delete token
  Future<void> deleteToken() async {
    await _prefs.remove(_tokenKey);
  }
}
