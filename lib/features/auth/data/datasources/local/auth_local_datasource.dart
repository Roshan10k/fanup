import 'package:fanup/core/services/hive/hive_service.dart';
import 'package:fanup/core/services/storage/user_session_service.dart';
import 'package:fanup/features/auth/data/datasources/auth_datasource.dart';
import 'package:fanup/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider implementation of IAuthDataSource
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
  );
});

class AuthLocalDatasource implements IAuthDataSource {
  final HiveService _hiveService;
  final UserSessionService _userSessionService;
  AuthLocalDatasource({
    required HiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  @override
  Future<AuthHiveModel?> getCurrentUser() async {
    try {
      final user = await _hiveService.getCurrentUser();
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    try {
      final user = await _hiveService.loginUser(email, password);
      if (user != null) {
        // Save as current user after successful login in shared preferences
        await _userSessionService.saveUserSession(
          authId: user.authId ?? "",
          email: user.email,
          fullName: user.fullName,
        );
      }
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _hiveService.logoutUser();
      await _userSessionService.clearUserSession(); // clearing session after logging out
      return true;
    } catch (e) {
      debugPrint('Logout error: $e');
      return false;
    }
  }

  @override
  Future<bool> register(AuthHiveModel model) async {
    try {
      // Validate before registering
      if (model.authId == null || model.authId!.isEmpty) {
        throw Exception('Invalid user data');
      }
      
      await _hiveService.registerUser(model);
      await _hiveService.saveCurrentUser(model);
      
      // Save session for consistency with login
      await _userSessionService.saveUserSession(
        authId: model.authId!,
        email: model.email,
        fullName: model.fullName,
      );
      
      return true;
    } catch (e) {
      debugPrint('Registration error: $e');
      return false;
    }
  }


  @override
  Future<bool> isEmailRegistered(String email) async {
    try {
      final isRegistered = await _hiveService.isEmailRegistered(email);
      return isRegistered;
    } catch (e) {
      return false;
    }
  }
}
