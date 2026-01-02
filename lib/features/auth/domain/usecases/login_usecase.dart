import 'package:dartz/dartz.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/core/usecases/app_usecase.dart';
import 'package:fanup/features/auth/data/repositories/auth_repository.dart';
import 'package:fanup/features/auth/domain/entities/auth_entity.dart';
import 'package:fanup/features/auth/domain/repositories/auth.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginUsecaseParams {
  final String email;
  final String password;

  const LoginUsecaseParams({
    required this.email,
    required this.password,
  });
}

//provider for login usecase
final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginUsecase(authRepository: authRepository);
});


class LoginUsecase implements UsecaseWithParams<bool, LoginUsecaseParams> {
  final IAuthRepository _authRepository;

  LoginUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(LoginUsecaseParams params) {
    return _authRepository.loginUser(params.email, params.password);
  }
}
