import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/auth/domain/entities/auth_entity.dart';
import 'package:fanup/features/auth/domain/repositories/auth.repository.dart';
import 'package:fanup/features/auth/domain/usecases/register_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepository);
  });

  const tEntity = AuthEntity(
    fullName: 'Test User',
    email: 'test@example.com',
    password: 'password123',
  );

  const tParams = RegisterUsecaseParams(
    fullName: 'Test User',
    email: 'test@example.com',
    password: 'password123',
  );

  group('RegisterUsecase', () {
    test('should return true when registration is successful', () async {
      when(() => mockRepository.register(tEntity))
          .thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockRepository.register(tEntity)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ApiFailure when registration fails', () async {
      const failure = ApiFailure(message: 'Email already exists');
      when(() => mockRepository.register(tEntity))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(tParams);

      expect(result, const Left(failure));
      verify(() => mockRepository.register(tEntity)).called(1);
    });

    test('should return NetworkFailure when offline', () async {
      const failure = NetworkFailure();
      when(() => mockRepository.register(tEntity))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(tParams);

      expect(result, const Left(failure));
    });
  });

  group('RegisterUsecaseParams', () {
    test('two params with same values should be equal', () {
      const params1 = RegisterUsecaseParams(
        fullName: 'Test',
        email: 'a@b.com',
        password: 'pass',
      );
      const params2 = RegisterUsecaseParams(
        fullName: 'Test',
        email: 'a@b.com',
        password: 'pass',
      );
      expect(params1, params2);
    });

    test('two params with different values should not be equal', () {
      const params1 = RegisterUsecaseParams(
        fullName: 'Test',
        email: 'a@b.com',
        password: 'pass',
      );
      const params2 = RegisterUsecaseParams(
        fullName: 'Other',
        email: 'a@b.com',
        password: 'pass',
      );
      expect(params1, isNot(params2));
    });
  });
}
