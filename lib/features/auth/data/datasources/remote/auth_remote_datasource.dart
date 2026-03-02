import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fanup/core/api/api_client.dart';
import 'package:fanup/core/api/api_endpoints.dart';
import 'package:fanup/core/services/storage/token_service.dart';
import 'package:fanup/core/services/storage/user_session_service.dart';
import 'package:fanup/features/auth/data/datasources/auth_datasource.dart';
import 'package:fanup/features/auth/data/models/auth_api_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDataSourceProvider = Provider<IRemoteAuthDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthRemoteDatasource implements IRemoteAuthDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _userSessionService = userSessionService,
        _tokenService = tokenService;

  @override
  Future<AuthApiModel?> loginUserRemote(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    if (response.data['success'] == true) {
      final loggedInUser = AuthApiModel.fromJson(response.data);

      // Save session safely
      await _userSessionService.saveUserSession(
        authId: loggedInUser.authId ?? '',
        email: loggedInUser.email ?? '',
        fullName: loggedInUser.fullName ?? '',
      );

      // Save token
      final token = response.data['token'] as String?;
      if (token != null) {
        await _tokenService.saveToken(token);
      }

      return loggedInUser;
    }

    return null;
  }

  @override
  Future<AuthApiModel> registerRemote(AuthApiModel model) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: model.toJson(),
    );

    if (response.data['success'] == true) {
      return AuthApiModel.fromJson(response.data);
    }

    throw Exception('Registration failed');
  }

  @override
  Future<AuthApiModel?> loginWithGoogle(String idToken) async {
    final response = await _apiClient.post(
      ApiEndpoints.googleLogin,
      data: {'credential': idToken},
    );

    if (response.data['success'] == true) {
      final user = AuthApiModel.fromJson(response.data);

      // Save session
      await _userSessionService.saveUserSession(
        authId: user.authId ?? '',
        email: user.email ?? '',
        fullName: user.fullName ?? '',
      );

      // Save token
      final token = response.data['token'] as String?;
      if (token != null) {
        await _tokenService.saveToken(token);
      }

      return user;
    }

    return null;
  }

  @override
  Future<AuthApiModel?> getUserById(String authId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.whoami,
      );

      if (response.data['success'] == true) {
        return AuthApiModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      debugPrint('Get user error: $e');
      return null;
    }
  }

  @override
  Future<String> uploadProfilePhoto(File photo) async {
    try {
      // Create multipart file from the File object
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          photo.path,
          filename: photo.path.split('/').last,
        ),
      });

      debugPrint('Uploading profile photo: ${photo.path}');

      // Upload using the API client
      final response = await _apiClient.uploadFile(
        ApiEndpoints.uploadProfilePhoto,
        formData: formData,
      );

      debugPrint('Upload response: ${response.data}');

      if (response.data['success'] == true) {
        // Get the profilePicture filename from the response
        // Adjust this based on your backend response structure
        final profilePictureFilename = 
            response.data['data']?['profilePicture'] ?? 
            response.data['data']?['filename'] ??
            response.data['profilePicture'] ??
            response.data['filename'] ??
            '';
            
        if (profilePictureFilename.isEmpty) {
          throw Exception('No profile picture filename in response');
        }
        
        debugPrint('Profile picture filename: $profilePictureFilename');
        
        // Return just the filename, the repository will build the full URL
        return profilePictureFilename;
      }

      throw Exception('Upload failed: ${response.data['message'] ?? 'Unknown error'}');
    } on DioException catch (e) {
      debugPrint('Upload DioException: ${e.message}');
      debugPrint('Response: ${e.response?.data}');
      throw Exception('Photo upload failed: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      debugPrint('Upload error: $e');
      throw Exception('Photo upload failed: $e');
    }
  }
}