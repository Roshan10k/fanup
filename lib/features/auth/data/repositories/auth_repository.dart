import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:fanup/core/error/failures.dart';
import 'package:fanup/core/services/connectivity/network_info.dart';
import 'package:fanup/features/auth/data/datasources/auth_datasource.dart';
import 'package:fanup/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:fanup/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:fanup/features/auth/data/models/auth_api_model.dart';
import 'package:fanup/features/auth/data/models/auth_hive_model.dart';
import 'package:fanup/features/auth/domain/entities/auth_entity.dart';
import 'package:fanup/features/auth/domain/repositories/auth.repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDataSource = ref.read(authLocalDatasourceProvider);
  final authRemoteDataSource = ref.read(authRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AuthRepository(
    authDataSource: authDataSource,
    authRemoteDatasource: authRemoteDataSource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthDataSource _authDataSource;
  final IRemoteAuthDataSource _authRemoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthDataSource authDataSource,
    required IRemoteAuthDataSource authRemoteDatasource,
    required NetworkInfo networkInfo,
  }) : _authDataSource = authDataSource,
       _authRemoteDataSource = authRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final user = await _authDataSource.getCurrentUser();
      if (user != null) {
        return Right(user.toEntity());
      }
      return const Left(LocalDatabaseFailure(message: "No current user found"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> loginUser(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDataSource.loginUserRemote(
          email,
          password,
        );

        if (apiModel == null) {
          return const Left(ApiFailure(message: "Invalid email or password"));
        }

        final hiveModel = AuthHiveModel(
          authId: apiModel.authId ?? '',
          fullName: apiModel.fullName ?? '',
          email: apiModel.email ?? '',
          password: password,
          profilePicture:
              apiModel.profilePicture, // Profile image is saved here
        );

        await _authDataSource.register(hiveModel);

        debugPrint(
          'Login successful, profile picture: ${apiModel.profilePicture}',
        );

        return Right(apiModel.toEntity());
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? "Login failed",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    }

    // Offline login
    if (email.isEmpty || password.isEmpty) {
      return const Left(
        LocalDatabaseFailure(message: "Email and password are required"),
      );
    }

    try {
      final user = await _authDataSource.loginUser(email, password);
      if (user != null) {
        return Right(user.toEntity());
      }

      return const Left(
        LocalDatabaseFailure(message: "Invalid email or password"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    if (entity.email.isEmpty ||
        entity.password.isEmpty ||
        entity.fullName.isEmpty) {
      return const Left(
        LocalDatabaseFailure(message: "All fields are required"),
      );
    }

    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(entity);
        final registeredUser = await _authRemoteDataSource.registerRemote(
          apiModel,
        );

        final hiveModel = AuthHiveModel(
          authId: registeredUser.authId ?? '',
          fullName: registeredUser.fullName ?? '',
          email: registeredUser.email ?? '',
          password: entity.password,
          profilePicture: registeredUser.profilePicture,
        );

        await _authDataSource.register(hiveModel);
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? "Registration failed",
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    }

    // Offline registration
    try {
      final isRegistered = await _authDataSource.isEmailRegistered(
        entity.email,
      );

      if (isRegistered == true) {
        return const Left(
          LocalDatabaseFailure(message: "Email is already registered"),
        );
      }

      final hiveModel = AuthHiveModel(
        fullName: entity.fullName,
        email: entity.email,
        password: entity.password,
        profilePicture: entity.profilePicture,
      );

      await _authDataSource.register(hiveModel);
      return const Right(true);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logoutUser() async {
    try {
      final result = await _authDataSource.logout();
      return result
          ? const Right(true)
          : const Left(LocalDatabaseFailure(message: "Failed to logout"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePhoto(File file) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: "No internet connection"));
    }

    try {
      debugPrint('Starting profile photo upload...');

      // Upload to backend and get filename
      final filename = await _authRemoteDataSource.uploadProfilePhoto(file);

      debugPrint('Upload successful, filename: $filename');

      final updateSuccess = await _authDataSource.updateProfilePicture(
        filename,
      );

      if (!updateSuccess) {
        debugPrint('Failed to update local storage');
        return const Left(
          LocalDatabaseFailure(
            message: "Failed to update local profile picture",
          ),
        );
      }

      debugPrint('Local storage updated successfully with filename: $filename');

      // Return the filename (not the full URL)
      return Right(filename);
    } on DioException catch (e) {
      debugPrint('Upload DioException: ${e.message}');
      return Left(
        ApiFailure(
          message: e.response?.data['message'] ?? 'Upload failed: ${e.message}',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      debugPrint('Upload error: $e');
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
