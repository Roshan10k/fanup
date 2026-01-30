import 'package:dartz/dartz.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/auth/data/repositories/auth_repository.dart';
import 'package:fanup/features/auth/domain/repositories/auth.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadProfilePhotoUsecaseProvider = Provider<UploadProfilePhotoUsecase>(
  (ref) => UploadProfilePhotoUsecase(
    ref.read(authRepositoryProvider),
  ),
);

class UploadProfilePhotoUsecase {
  final IAuthRepository _authRepository;

  UploadProfilePhotoUsecase(this._authRepository);

  Future<Either<Failure, String>> call(String filePath) async {
    return await _authRepository.uploadProfilePhoto(filePath);
  }
}
