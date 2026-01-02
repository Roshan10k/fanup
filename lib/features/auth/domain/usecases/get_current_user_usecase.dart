import 'package:dartz/dartz.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/core/usecases/app_usecase.dart';
import 'package:fanup/features/auth/domain/entities/auth_entity.dart';
import 'package:fanup/features/auth/domain/repositories/auth.repository.dart';

class GetCurrentUserUsecase implements UsecaseWithoutParams<AuthEntity?> {
  final IAuthRepository _authRepository;

  GetCurrentUserUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity?>> call() {
    return _authRepository.getCurrentUser();
  }
}
