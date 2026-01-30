import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/app/app_usecase.dart';
import 'package:fanup/features/auth/data/repositories/auth_repository.dart';
import 'package:fanup/features/auth/domain/entities/auth_entity.dart';

import 'package:fanup/features/auth/domain/repositories/auth.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginUsecaseParams extends Equatable {
  final String email;
  final String password;

  const LoginUsecaseParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

//provider for login usecase
final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LoginUsecase(authRepository: authRepository);
});

class LoginUsecase
    implements UsecaseWithParams<AuthEntity, LoginUsecaseParams> {
  final IAuthRepository _authRepository;

  LoginUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call(LoginUsecaseParams params) async {
    return _authRepository.loginUser(params.email, params.password);
  }
}
