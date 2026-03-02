import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//provider
final tokenServiceProvider = Provider<TokenService>((ref) {
  return TokenService();
});

/// Stores the JWT in [FlutterSecureStorage] (encrypted at rest) and keeps an
/// in-memory cache so the Dio auth interceptor can read it synchronously.
class TokenService {
  final FlutterSecureStorage _storage;
  static const String _tokenKey = 'auth_token';

  /// In-memory cache so [getToken] stays synchronous for the interceptor.
  String? _cachedToken;

  TokenService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Must be called once at app startup (before any API call) to hydrate the
  /// in-memory cache from secure storage.
  Future<void> init() async {
    _cachedToken = await _storage.read(key: _tokenKey);
  }

  //save token
  Future<void> saveToken(String token) async {
    _cachedToken = token;
    await _storage.write(key: _tokenKey, value: token);
  }

  //get token (synchronous — reads from memory cache)
  String? getToken() {
    return _cachedToken;
  }

  //delete token
  Future<void> deleteToken() async {
    _cachedToken = null;
    await _storage.delete(key: _tokenKey);
  }
}
