import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fanup/features/dashboard/domain/usecases/delete_my_contest_entry_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late DeleteMyContestEntryUsecase usecase;
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
    usecase =
        DeleteMyContestEntryUsecase(dashboardRepository: mockRepository);
  });

  const tMatchId = 'match-456';

  group('DeleteMyContestEntryUsecase', () {
    test('should return void on success', () async {
      when(() => mockRepository.deleteMyContestEntry(matchId: tMatchId))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase(
          const DeleteMyContestEntryParams(matchId: tMatchId));

      expect(result.isRight(), true);
      verify(() => mockRepository.deleteMyContestEntry(matchId: tMatchId))
          .called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when entry does not exist', () async {
      const failure = ApiFailure(message: 'Entry not found', statusCode: 404);
      when(() => mockRepository.deleteMyContestEntry(matchId: tMatchId))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(
          const DeleteMyContestEntryParams(matchId: tMatchId));

      expect(result, const Left(failure));
    });

    test('should return NetworkFailure when offline', () async {
      const failure = NetworkFailure();
      when(() => mockRepository.deleteMyContestEntry(matchId: tMatchId))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(
          const DeleteMyContestEntryParams(matchId: tMatchId));

      expect(result, const Left(failure));
    });
  });

  group('DeleteMyContestEntryParams', () {
    test('two params with same matchId should be equal', () {
      const p1 = DeleteMyContestEntryParams(matchId: 'abc');
      const p2 = DeleteMyContestEntryParams(matchId: 'abc');
      expect(p1, p2);
    });
  });
}
