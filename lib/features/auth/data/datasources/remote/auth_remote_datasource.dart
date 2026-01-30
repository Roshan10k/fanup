import 'package:dio/dio.dart';
import 'package:fanup/core/api/api_client.dart';
import 'package:fanup/core/api/api_endpoints.dart';
import 'package:fanup/core/services/storage/token_service.dart';
import 'package:fanup/core/services/storage/user_session_service.dart';
import 'package:fanup/features/auth/data/datasources/auth_datasource.dart';
import 'package:fanup/features/auth/data/models/auth_api_model.dart';
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
  }) : _apiClient = apiClient,
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

      //save token
      final token = response.data['token'] as String?;
      await _tokenService.saveToken(token!);

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
  Future<AuthApiModel?> getUserById(String authId) {
    throw UnimplementedError();
  }

  Future<String> uploadProfilePhoto(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(filePath),
      });

      // Don't set Content-Type header for multipart, let dio handle it
      final options = Options(
        contentType: 'multipart/form-data',
      );

      final response = await _apiClient.uploadFile(
        ApiEndpoints.uploadProfilePhoto,
        formData: formData,
        options: options,
      );

      if (response.data['success'] == true) {
        // Get the profilePicture filename from the response
        final profilePictureFilename = response.data['data']['profilePicture'] ?? '';
        if (profilePictureFilename.isEmpty) {
          throw Exception('No profile picture filename in response');
        }
        // Return just the filename, the repository will build the full URL
        return profilePictureFilename;
      }

      throw Exception('Failed to upload photo');
    } catch (e) {
      throw Exception('Photo upload failed: $e');
    }
  }
}