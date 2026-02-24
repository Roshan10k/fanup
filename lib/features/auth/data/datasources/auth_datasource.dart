import 'dart:io';

import 'package:fanup/features/auth/data/models/auth_api_model.dart';
import 'package:fanup/features/auth/data/models/auth_hive_model.dart';

abstract interface class IAuthDataSource {
  Future<bool> register(AuthHiveModel model);
  Future<AuthHiveModel?> loginUser(String email, String password);
  Future<AuthHiveModel?> getCurrentUser();
  Future<bool> logout();
  Future<bool> isEmailRegistered(String email);
  Future<bool> updateProfilePicture(String profileImageUrl);
  Future<bool> updateLocalUser({String? fullName, String? phone, String? profilePicture});
}

abstract interface class IRemoteAuthDataSource {
  Future<AuthApiModel> registerRemote(AuthApiModel model);
  Future<AuthApiModel?> loginUserRemote(String email, String password);
  Future<AuthApiModel?> getUserById(String authId);
  Future<String> uploadProfilePhoto(File photo);
}