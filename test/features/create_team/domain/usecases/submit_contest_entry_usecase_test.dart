import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/create_team/domain/repositories/create_team_repository.dart';
import 'package:fanup/features/create_team/domain/usecases/submit_contest_entry_usecase.dart';
import 'package:fanup/features/create_team/domain/entities/contest_entry_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateTeamRepository extends Mock implements ICreateTeamRepository {}

class FakeContestEntryEntity extends Fake implements ContestEntryEntity {}

void main() {
  late SubmitContestEntryUsecase usecase;
  late MockCreateTeamRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeContestEntryEntity());
  });

  setUp(() {
    mockRepository = MockCreateTeamRepository();
    usecase = SubmitContestEntryUsecase(createTeamRepository: mockRepository);
  });

  group('SubmitContestEntryUsecase', () {
    test('should return true on successful submission', () async {
      when(() => mockRepository.submitContestEntry(any()))
          .thenAnswer((_) async => const Right(true));

      final entry = FakeContestEntryEntity();
      final result = await usecase(entry);

      expect(result, const Right(true));
      verify(() => mockRepository.submitContestEntry(entry)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when submission fails', () async {
      const failure =
          ApiFailure(message: 'Insufficient balance', statusCode: 402);
      when(() => mockRepository.submitContestEntry(any()))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(FakeContestEntryEntity());

      expect(result, const Left(failure));
    });

    test('should return NetworkFailure when offline', () async {
      const failure = NetworkFailure();
      when(() => mockRepository.submitContestEntry(any()))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(FakeContestEntryEntity());

      expect(result, const Left(failure));
    });
  });
}
