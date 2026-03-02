import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/create_team/domain/entities/player_entity.dart';
import 'package:fanup/features/create_team/domain/repositories/create_team_repository.dart';
import 'package:fanup/features/create_team/domain/usecases/get_match_players_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateTeamRepository extends Mock implements ICreateTeamRepository {}

void main() {
  late GetMatchPlayersUsecase usecase;
  late MockCreateTeamRepository mockRepository;

  setUp(() {
    mockRepository = MockCreateTeamRepository();
    usecase = GetMatchPlayersUsecase(createTeamRepository: mockRepository);
  });

  const tTeamA = 'team-a-id';
  const tTeamB = 'team-b-id';

  group('GetMatchPlayersUsecase', () {
    test('should return list of players on success', () async {
      when(() => mockRepository.getPlayers(teamA: tTeamA, teamB: tTeamB))
          .thenAnswer((_) async => const Right(<PlayerEntity>[]));

      final result = await usecase(
          const GetMatchPlayersParams(teamA: tTeamA, teamB: tTeamB));

      expect(result, const Right(<PlayerEntity>[]));
      verify(() => mockRepository.getPlayers(teamA: tTeamA, teamB: tTeamB))
          .called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure on error', () async {
      const failure = ApiFailure(message: 'Players not found');
      when(() => mockRepository.getPlayers(teamA: tTeamA, teamB: tTeamB))
          .thenAnswer((_) async => const Left(failure));

      final result = await usecase(
          const GetMatchPlayersParams(teamA: tTeamA, teamB: tTeamB));

      expect(result, const Left(failure));
    });
  });

  group('GetMatchPlayersParams', () {
    test('two params with same values should be equal', () {
      const p1 = GetMatchPlayersParams(teamA: 'a', teamB: 'b');
      const p2 = GetMatchPlayersParams(teamA: 'a', teamB: 'b');
      expect(p1, p2);
    });

    test('two params with different values should not be equal', () {
      const p1 = GetMatchPlayersParams(teamA: 'a', teamB: 'b');
      const p2 = GetMatchPlayersParams(teamA: 'a', teamB: 'c');
      expect(p1, isNot(p2));
    });
  });
}
