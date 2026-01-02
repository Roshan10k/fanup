import 'package:fanup/core/services/hive_service.dart';
import 'package:fanup/features/auth/data/datasources/auth_datasource.dart';
import 'package:fanup/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider implementation of IAuthDataSource
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return AuthLocalDatasource(hiveService: hiveService);
});

class AuthLocalDatasource implements IAuthDataSource {
  final HiveService _hiveService;
  AuthLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

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
        // Save as current user after successful login
        await _hiveService.saveCurrentUser(user);
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
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> register(AuthHiveModel model) async {
    try {
      // Register the user
      await _hiveService.registerUser(model);
      // Save as current user after successful registration
      await _hiveService.saveCurrentUser(model);
      return true;
    } catch (e) {
      print('Registration error: $e'); // Add logging to debug
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