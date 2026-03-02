import 'package:dartz/dartz.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/app/app_usecase.dart';
import 'package:fanup/features/auth/data/repositories/auth_repository.dart';
import 'package:fanup/features/auth/domain/entities/auth_entity.dart';
import 'package:fanup/features/auth/domain/repositories/auth.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for Google login usecase
final googleLoginUsecaseProvider = Provider<GoogleLoginUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GoogleLoginUsecase(authRepository: authRepository);
});

class GoogleLoginUsecase
    implements UsecaseWithParams<AuthEntity, String> {
  final IAuthRepository _authRepository;

  GoogleLoginUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call(String idToken) async {
    return _authRepository.loginWithGoogle(idToken);
  }
}
