import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/domain/entities/leaderboard_contest_entity.dart';
import 'package:fanup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fanup/features/dashboard/domain/usecases/get_leaderboard_contests_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late GetLeaderboardContestsUsecase usecase;
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
    usecase =
        GetLeaderboardContestsUsecase(dashboardRepository: mockRepository);
  });

  group('GetLeaderboardContestsUsecase', () {
    test('should return list of contests on success', () async {
      when(() => mockRepository.getLeaderboardContests(status: 'live'))
          .thenAnswer((_) async => const Right(<LeaderboardContestEntity>[]));

      final result = await usecase(
          const GetLeaderboardContestsParams(status: 'live'));

      expect(result, const Right(<LeaderboardContestEntity>[]));
      verify(() => mockRepository.getLeaderboardContests(status: 'live'))
          .called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass correct status parameter', () async {
      when(() =>
              mockRepository.getLeaderboardContests(status: 'completed'))
          .thenAnswer((_) async => const Right(<LeaderboardContestEntity>[]));

      await usecase(
          const GetLeaderboardContestsParams(status: 'completed'));

      verify(() =>
              mockRepository.getLeaderboardContests(status: 'completed'))
          .called(1);
    });

    test('should return failure on error', () async {
      const failure = ApiFailure(message: 'Server error');
      when(() => mockRepository.getLeaderboardContests(status: 'live'))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(
          const GetLeaderboardContestsParams(status: 'live'));

      expect(result, const Left(failure));
    });
  });

  group('GetLeaderboardContestsParams', () {
    test('two params with same status should be equal', () {
      const p1 = GetLeaderboardContestsParams(status: 'live');
      const p2 = GetLeaderboardContestsParams(status: 'live');
      expect(p1, p2);
    });
  });
}
