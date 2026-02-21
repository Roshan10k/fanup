import 'package:equatable/equatable.dart';

class ContestEntryEntity extends Equatable {
  final String matchId;
  final String teamId;
  final String teamName;
  final String captainId;
  final String viceCaptainId;
  final List<String> playerIds;

  const ContestEntryEntity({
    required this.matchId,
    required this.teamId,
    required this.teamName,
    required this.captainId,
    required this.viceCaptainId,
    required this.playerIds,
  });

  @override
  List<Object?> get props => [
    matchId,
    teamId,
    teamName,
    captainId,
    viceCaptainId,
    playerIds,
  ];
}

class ExistingContestEntryEntity extends Equatable {
  final String teamId;
  final String teamName;
  final String captainId;
  final String viceCaptainId;
  final List<String> playerIds;

  const ExistingContestEntryEntity({
    required this.teamId,
    required this.teamName,
    required this.captainId,
    required this.viceCaptainId,
    required this.playerIds,
  });

  @override
  List<Object?> get props => [
    teamId,
    teamName,
    captainId,
    viceCaptainId,
    playerIds,
  ];
}
