import 'package:equatable/equatable.dart';

class LeaderboardMatchMetaEntity extends Equatable {
  final String id;
  final String matchLabel;
  final DateTime startsAt;
  final String status;

  const LeaderboardMatchMetaEntity({
    required this.id,
    required this.matchLabel,
    required this.startsAt,
    required this.status,
  });

  @override
  List<Object?> get props => [id, matchLabel, startsAt, status];
}

class LeaderboardLeaderEntity extends Equatable {
  final String userId;
  final int rank;
  final String name;
  final int teams;
  final double pts;
  final double winRate;
  final int prize;

  const LeaderboardLeaderEntity({
    required this.userId,
    required this.rank,
    required this.name,
    required this.teams,
    required this.pts,
    required this.winRate,
    required this.prize,
  });

  @override
  List<Object?> get props => [userId, rank, name, teams, pts, winRate, prize];
}

class LeaderboardPayloadEntity extends Equatable {
  final LeaderboardMatchMetaEntity match;
  final List<LeaderboardLeaderEntity> leaders;
  final LeaderboardLeaderEntity? myEntry;

  const LeaderboardPayloadEntity({
    required this.match,
    required this.leaders,
    required this.myEntry,
  });

  @override
  List<Object?> get props => [match, leaders, myEntry];
}
