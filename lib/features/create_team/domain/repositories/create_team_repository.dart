import 'package:dartz/dartz.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/create_team/domain/entities/contest_entry_entity.dart';
import 'package:fanup/features/create_team/domain/entities/player_entity.dart';

abstract interface class ICreateTeamRepository {
  Future<Either<Failure, List<PlayerEntity>>> getPlayers({
    required String teamA,
    required String teamB,
  });

  Future<Either<Failure, ExistingContestEntryEntity?>> getMyEntryForMatch(
    String matchId,
  );

  Future<Either<Failure, bool>> submitContestEntry(ContestEntryEntity entry);
}
