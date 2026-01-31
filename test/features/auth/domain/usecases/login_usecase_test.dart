import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/auth/domain/entities/auth_entity.dart';
import 'package:fanup/features/auth/domain/repositories/auth.repository.dart';
import 'package:fanup/features/auth/domain/usecases/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUsecase(authRepository: mockRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';

  const tUser = AuthEntity(
    id: '1',
    fullName: 'Test User',
    email: tEmail,
    password: tPassword,
    profilePicture: 'https://example.com/profile.jpg',
  );

  group('LoginUsecase', () {
    test('should return AuthEntity when login is successful', () async {
      // Arrange
      when(
        () => mockRepository.loginUser(tEmail, tPassword),
      ).thenAnswer((_) async => const Right(tUser));

      // Act
      final result = await usecase(
        const LoginUsecaseParams(email: tEmail, password: tPassword),
      );

      // Assert
      expect(result, const Right(tUser));
      verify(() => mockRepository.loginUser(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when login fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Invalid credentials');
      when(
        () => mockRepository.loginUser(tEmail, tPassword),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const LoginUsecaseParams(email: tEmail, password: tPassword),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.loginUser(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(
        () => mockRepository.loginUser(tEmail, tPassword),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const LoginUsecaseParams(email: tEmail, password: tPassword),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.loginUser(tEmail, tPassword)).called(1);
    });

    test('should pass correct email and password to repository', () async {
      // Arrange
      when(
        () => mockRepository.loginUser(any(), any()),
      ).thenAnswer((_) async => const Right(tUser));

      // Act
      await usecase(
        const LoginUsecaseParams(email: tEmail, password: tPassword),
      );

      // Assert
      verify(() => mockRepository.loginUser(tEmail, tPassword)).called(1);
    });

    test(
      'should succeed with correct credentials and fail with wrong credentials',
      () async {
        // Arrange
        const wrongEmail = 'wrong@example.com';
        const wrongPassword = 'wrongpassword';
        const failure = ApiFailure(message: 'Invalid credentials');

        // Mock: check credentials using if condition
        when(() => mockRepository.loginUser(any(), any())).thenAnswer((
          invocation,
        ) async {
          final email = invocation.positionalArguments[0] as String;
          final password = invocation.positionalArguments[1] as String;

          // If email and password are correct, return success
          if (email == tEmail && password == tPassword) {
            return const Right(tUser);
          }
          // Otherwise return failure
          return const Left(failure);
        });

        // Act & Assert - Correct credentials should succeed
        final successResult = await usecase(
          const LoginUsecaseParams(email: tEmail, password: tPassword),
        );
        expect(successResult, const Right(tUser));

        // Act & Assert - Wrong email should fail
        final wrongEmailResult = await usecase(
          const LoginUsecaseParams(email: wrongEmail, password: tPassword),
        );
        expect(wrongEmailResult, const Left(failure));

        // Act & Assert - Wrong password should fail
        final wrongPasswordResult = await usecase(
          const LoginUsecaseParams(email: tEmail, password: wrongPassword),
        );
        expect(wrongPasswordResult, const Left(failure));
      },
    );
  });

  group('LoginUsecaseParams', () {
    test('should create params with correct values', () {
      // Arrange & Act
      const params = LoginUsecaseParams(email: tEmail, password: tPassword);

      // Assert
      expect(params.email, tEmail);
      expect(params.password, tPassword);
    });

    test('two params with same values should be equal', () {
      // Arrange
      const params1 = LoginUsecaseParams(email: tEmail, password: tPassword);
      const params2 = LoginUsecaseParams(email: tEmail, password: tPassword);

      // Assert
      expect(params1, params2);
    });

    test('two params with different values should not be equal', () {
      // Arrange
      const params1 = LoginUsecaseParams(email: tEmail, password: tPassword);
      const params2 = LoginUsecaseParams(
        email: 'other@email.com',
        password: tPassword,
      );

      // Assert
      expect(params1, isNot(params2));
    });
  });
}