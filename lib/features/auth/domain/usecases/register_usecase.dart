import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/app/app_usecase.dart';
import 'package:fanup/features/auth/data/repositories/auth_repository.dart';
import 'package:fanup/features/auth/domain/entities/auth_entity.dart';
import 'package:fanup/features/auth/domain/repositories/auth.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterUsecaseParams extends Equatable {
  final String? authId;
  final String fullName;
  final String email;
  final String password;

  const RegisterUsecaseParams({
    this.authId,
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [authId, fullName, email, password];
}

//provider for register usecase
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase implements UsecaseWithParams<bool, RegisterUsecaseParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
    );
    return _authRepository.register(entity);
  }
}




