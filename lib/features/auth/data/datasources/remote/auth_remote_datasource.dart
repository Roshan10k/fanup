
import 'package:fanup/core/api/api_client.dart';
import 'package:fanup/core/api/api_endpoints.dart';
import 'package:fanup/core/services/storage/user_session_service.dart';
import 'package:fanup/features/auth/data/datasources/auth_datasource.dart';
import 'package:fanup/features/auth/data/models/auth_api_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

//create Provider 
final authRemoteDataSourceProvider = Provider<IRemoteAuthDataSource>((ref){
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider), 
    userSessionService: ref.read(userSessionServiceProvider));
});

class AuthRemoteDatasource implements IRemoteAuthDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({required ApiClient apiClient, required UserSessionService userSessionService}):
    _apiClient = apiClient,
    _userSessionService = userSessionService;


  
  @override
  Future<AuthApiModel?> getUserById(String authId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> loginUserRemote(String email, String password)  async{
    final response = await  _apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    if(response.data['success']==true){
      final data = response.data['data'] as Map<String, dynamic>;
      final loggedInUser = AuthApiModel.fromJson(data);
      // Save to session
      await _userSessionService.saveUserSession(authId: loggedInUser.authId!, email: email, fullName: loggedInUser.fullName);
      return loggedInUser;
    }
    return null;
  }

  @override
  Future<AuthApiModel> registerRemote(AuthApiModel model) async{
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data : model.toJson(),

    );

    if(response.data['success']==true){
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = AuthApiModel.fromJson(data);
      return registeredUser;
    }
    return model;
  }

}