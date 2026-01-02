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
  Future<AuthHiveModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> loginUser(String email, String password) async{
    try{
      final user = await _hiveService.loginUser(email, password);
      return Future.value(user);
    }catch(e){
      return Future.value(null);
    }
  }

  @override
  Future<bool> logout() async{
    try{
      await _hiveService.logoutUser(); 
      return Future.value(true);
    }catch(e){
      return Future.value(false);
    }
  }

  @override
  Future<bool> register(AuthHiveModel model) async{
    try{
      await _hiveService.registerUser(model);
      return Future.value(true);
    }catch(e){
      return Future.value(false);
    }
  }
  
  @override
  Future<bool> isEmailRegistered(String email) async{
    try{
      final isRegistered = await _hiveService.isEmailRegistered(email);
      return Future.value(isRegistered);
    }catch(e){
      return Future.value(false);
    }
}
} 