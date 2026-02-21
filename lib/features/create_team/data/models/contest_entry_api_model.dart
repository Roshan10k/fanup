import 'package:fanup/features/create_team/domain/entities/contest_entry_entity.dart';

class ContestEntryApiModel {
  final String matchId;
  final String teamId;
  final String teamName;
  final String captainId;
  final String viceCaptainId;
  final List<String> playerIds;

  const ContestEntryApiModel({
    required this.matchId,
    required this.teamId,
    required this.teamName,
    required this.captainId,
    required this.viceCaptainId,
    required this.playerIds,
  });

  factory ContestEntryApiModel.fromJson(Map<String, dynamic> json) {
    final ids = (json['playerIds'] as List?) ?? const [];
    return ContestEntryApiModel(
      matchId: (json['matchId'] ?? '').toString(),
      teamId: (json['teamId'] ?? '').toString(),
      teamName: (json['teamName'] ?? '').toString(),
      captainId: (json['captainId'] ?? '').toString(),
      viceCaptainId: (json['viceCaptainId'] ?? '').toString(),
      playerIds: ids.map((e) => e.toString()).toList(),
    );
  }

  ExistingContestEntryEntity toExistingEntryEntity() {
    return ExistingContestEntryEntity(
      teamId: teamId,
      teamName: teamName,
      captainId: captainId,
      viceCaptainId: viceCaptainId,
      playerIds: playerIds,
    );
  }
}
