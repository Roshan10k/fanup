import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/auth/domain/entities/auth_entity.dart';
import 'package:fanup/features/auth/domain/repositories/auth.repository.dart';
import 'package:fanup/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late GetCurrentUserUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = GetCurrentUserUsecase(authRepository: mockRepository);
  });

  const tUser = AuthEntity(
    id: '1',
    fullName: 'Test User',
    email: 'test@example.com',
    password: '',
    profilePicture: 'https://example.com/photo.jpg',
    balance: 100.0,
  );

  group('GetCurrentUserUsecase', () {
    test('should return AuthEntity when user is logged in', () async {
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Right(tUser));

      final result = await usecase();

      expect(result, const Right(tUser));
      verify(() => mockRepository.getCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when no user is logged in', () async {
      const failure = LocalDatabaseFailure(message: 'No user found');
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
      verify(() => mockRepository.getCurrentUser()).called(1);
    });

    test('should return failure when fetching user fails', () async {
      const failure = LocalDatabaseFailure();
      when(() => mockRepository.getCurrentUser())
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase();

      expect(result, const Left(failure));
    });
  });
}
