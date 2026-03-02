import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/auth/domain/entities/auth_entity.dart';
import 'package:fanup/features/auth/domain/repositories/auth.repository.dart';
import 'package:fanup/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late GoogleLoginUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = GoogleLoginUsecase(authRepository: mockRepository);
  });

  const tIdToken = 'google-id-token-abc123';
  const tUser = AuthEntity(
    id: '1',
    fullName: 'Google User',
    email: 'google@example.com',
    password: '',
    profilePicture: 'https://lh3.googleusercontent.com/photo',
  );

  group('GoogleLoginUsecase', () {
    test('should return AuthEntity when Google login is successful', () async {
      when(() => mockRepository.loginWithGoogle(tIdToken))
          .thenAnswer((_) async => const Right(tUser));

      final result = await usecase(tIdToken);

      expect(result, const Right(tUser));
      verify(() => mockRepository.loginWithGoogle(tIdToken)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ApiFailure when Google login fails', () async {
      const failure = ApiFailure(message: 'Invalid Google token');
      when(() => mockRepository.loginWithGoogle(tIdToken))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(tIdToken);

      expect(result, const Left(failure));
      verify(() => mockRepository.loginWithGoogle(tIdToken)).called(1);
    });

    test('should return NetworkFailure when offline', () async {
      const failure = NetworkFailure();
      when(() => mockRepository.loginWithGoogle(tIdToken))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(tIdToken);

      expect(result, const Left(failure));
    });

    test('should pass the correct idToken to repository', () async {
      when(() => mockRepository.loginWithGoogle(any()))
          .thenAnswer((_) async => const Right(tUser));

      await usecase(tIdToken);

      verify(() => mockRepository.loginWithGoogle(tIdToken)).called(1);
    });
  });
}
