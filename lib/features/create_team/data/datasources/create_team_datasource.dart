import 'package:fanup/features/create_team/data/models/contest_entry_api_model.dart';
import 'package:fanup/features/create_team/data/models/player_api_model.dart';
import 'package:fanup/features/create_team/domain/entities/contest_entry_entity.dart';

abstract interface class ICreateTeamRemoteDatasource {
  Future<List<PlayerApiModel>> getPlayers({
    required String teamA,
    required String teamB,
  });

  Future<ContestEntryApiModel?> getMyEntryForMatch(String matchId);

  Future<bool> submitContestEntry(ContestEntryEntity entry);
}
