import 'package:equatable/equatable.dart';

class ContestEntryEntity extends Equatable {
  final String matchId;
  final String entryId;
  final String teamId;
  final String teamName;
  final String captainId;
  final String viceCaptainId;
  final List<String> playerIds;
  final int points;
  final DateTime? updatedAt;
  final ContestEntryMatchEntity? match;

  const ContestEntryEntity({
    required this.matchId,
    required this.entryId,
    required this.teamId,
    required this.teamName,
    this.captainId = '',
    this.viceCaptainId = '',
    this.playerIds = const [],
    this.points = 0,
    this.updatedAt,
    this.match,
  });

  @override
  List<Object?> get props => [
    matchId,
    entryId,
    teamId,
    teamName,
    captainId,
    viceCaptainId,
    playerIds,
    points,
    updatedAt,
    match,
  ];
}

class ContestEntryMatchEntity extends Equatable {
  final String id;
  final String league;
  final DateTime? startTime;
  final String status;
  final String teamAShortName;
  final String teamBShortName;

  const ContestEntryMatchEntity({
    required this.id,
    required this.league,
    this.startTime,
    this.status = '',
    this.teamAShortName = '',
    this.teamBShortName = '',
  });

  @override
  List<Object?> get props => [
    id,
    league,
    startTime,
    status,
    teamAShortName,
    teamBShortName,
  ];
}
