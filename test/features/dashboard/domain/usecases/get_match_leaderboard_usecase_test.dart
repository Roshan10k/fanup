import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:fanup/features/dashboard/domain/usecases/get_match_leaderboard_usecase.dart';
import 'package:fanup/features/dashboard/domain/entities/leaderboard_payload_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late GetMatchLeaderboardUsecase usecase;
  late MockDashboardRepository mockRepository;

  setUp(() {
    mockRepository = MockDashboardRepository();
    usecase = GetMatchLeaderboardUsecase(dashboardRepository: mockRepository);
  });

  const tMatchId = 'match-123';

  group('GetMatchLeaderboardUsecase', () {
    test('should return LeaderboardPayloadEntity on success', () async {
      final tPayload = LeaderboardPayloadEntity(
        match: LeaderboardMatchMetaEntity(
          id: tMatchId,
          matchLabel: 'Team A vs Team B',
          startsAt: DateTime(2024, 6, 1),
          status: 'live',
        ),
        leaders: const [],
        myEntry: null,
      );

      when(() => mockRepository.getMatchLeaderboard(matchId: tMatchId))
          .thenAnswer((_) async => Right(tPayload));

      final result = await usecase(
          const GetMatchLeaderboardParams(matchId: tMatchId));

      expect(result, Right(tPayload));
      verify(() => mockRepository.getMatchLeaderboard(matchId: tMatchId))
          .called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure on error', () async {
      const failure = ApiFailure(message: 'Match not found', statusCode: 404);
      when(() => mockRepository.getMatchLeaderboard(matchId: tMatchId))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(
          const GetMatchLeaderboardParams(matchId: tMatchId));

      expect(result, const Left(failure));
    });
  });

  group('GetMatchLeaderboardParams', () {
    test('two params with same matchId should be equal', () {
      const p1 = GetMatchLeaderboardParams(matchId: 'abc');
      const p2 = GetMatchLeaderboardParams(matchId: 'abc');
      expect(p1, p2);
    });

    test('two params with different matchId should not be equal', () {
      const p1 = GetMatchLeaderboardParams(matchId: 'abc');
      const p2 = GetMatchLeaderboardParams(matchId: 'xyz');
      expect(p1, isNot(p2));
    });
  });
}
