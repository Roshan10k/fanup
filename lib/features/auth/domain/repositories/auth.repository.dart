import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fanup/core/error/failures.dart';

import 'package:fanup/features/auth/domain/entities/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, bool>> register(AuthEntity user);
  Future<Either<Failure, AuthEntity>> loginUser(String email, String password);
  Future<Either<Failure, bool>> logoutUser();
  Future<Either<Failure, AuthEntity>> getCurrentUser();
  Future<Either<Failure, String>> uploadProfilePhoto(File photo);
  Future<Either<Failure, bool>> updateLocalUser({String? fullName, String? phone, String? profilePicture});
}
