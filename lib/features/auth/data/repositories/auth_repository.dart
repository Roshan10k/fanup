import 'package:dartz/dartz.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/auth/data/datasources/auth_datasource.dart';
import 'package:fanup/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:fanup/features/auth/data/models/auth_hive_model.dart';
import 'package:fanup/features/auth/domain/entities/auth_entity.dart';
import 'package:fanup/features/auth/domain/repositories/auth.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//provider implementation of IAuthRepository
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDataSource = ref.read(authLocalDatasourceProvider);
  return AuthRepository(authDataSource: authDataSource);
});

class AuthRepository implements IAuthRepository {
  final IAuthDataSource _authDataSource;
  AuthRepository({required IAuthDataSource authDataSource})
    : _authDataSource = authDataSource; 
  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async{
    try{
      final user = await _authDataSource.getCurrentUser();
      if(user != null){
        //convert model to entity
        final entity = user.toEntity();
        return Future.value(Right(entity));
      }
        return Future.value(Left(LocalDatabaseFailure(message: "No current user found")));
      
      

    }catch(e){
      return Future.value(Left(LocalDatabaseFailure(message: e.toString())));
    
  }
  }

  @override
  Future<Either<Failure, bool>> loginUser(String email, String password) async{
    try{
      final user = await _authDataSource.loginUser(email, password);
      if(user != null){
        return Future.value(Right(true));
      }
        return Future.value(Left(LocalDatabaseFailure(message: "Login failed")));
      
      

    }catch(e){
      return Future.value(Left(LocalDatabaseFailure(message: e.toString())));
  }
  }

  @override
  Future<Either<Failure, bool>> logoutUser() async{
    try{
      final result = await _authDataSource.logout();
      if(result){
        return Future.value(Right(true));
      }
        return Future.value(Left(LocalDatabaseFailure(message: "Logout failed")));
      
      

    }catch(e){
      return Future.value(Left(LocalDatabaseFailure(message: e.toString())));
    
  }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async{
    try{
      //converting entity to model
      final model = AuthHiveModel.fromEntity(entity);
      final result = await _authDataSource.register(model);
      if(result){
        return Future.value(Right(true));
      }
        return Future.value(Left(LocalDatabaseFailure(message: "Registration failed")));
      
      

    }catch(e){
      return Future.value(Left(LocalDatabaseFailure(message: e.toString())));
  }
  }
}