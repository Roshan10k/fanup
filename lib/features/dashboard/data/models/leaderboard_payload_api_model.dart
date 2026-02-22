class LeaderboardMatchMetaApiModel {
  final String id;
  final String matchLabel;
  final DateTime startsAt;
  final String status;

  const LeaderboardMatchMetaApiModel({
    required this.id,
    required this.matchLabel,
    required this.startsAt,
    required this.status,
  });

  factory LeaderboardMatchMetaApiModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardMatchMetaApiModel(
      id: json['id']?.toString() ?? '',
      matchLabel: json['matchLabel']?.toString() ?? '',
      startsAt:
          DateTime.tryParse(json['startsAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      status: json['status']?.toString() ?? 'completed',
    );
  }
}

class LeaderboardLeaderApiModel {
  final String userId;
  final int rank;
  final String name;
  final int teams;
  final double pts;
  final double winRate;
  final int prize;

  const LeaderboardLeaderApiModel({
    required this.userId,
    required this.rank,
    required this.name,
    required this.teams,
    required this.pts,
    required this.winRate,
    required this.prize,
  });

  factory LeaderboardLeaderApiModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardLeaderApiModel(
      userId: json['userId']?.toString() ?? '',
      rank: _asInt(json['rank']),
      name: json['name']?.toString() ?? 'User',
      teams: _asInt(json['teams']),
      pts: _asDouble(json['pts']),
      winRate: _asDouble(json['winRate']),
      prize: _asInt(json['prize']),
    );
  }
}

class LeaderboardPayloadApiModel {
  final LeaderboardMatchMetaApiModel match;
  final List<LeaderboardLeaderApiModel> leaders;
  final LeaderboardLeaderApiModel? myEntry;

  const LeaderboardPayloadApiModel({
    required this.match,
    required this.leaders,
    required this.myEntry,
  });

  factory LeaderboardPayloadApiModel.fromJson(Map<String, dynamic> json) {
    final matchMap = Map<String, dynamic>.from(
      (json['match'] as Map?) ?? const <String, dynamic>{},
    );
    final leadersRows = (json['leaders'] as List?) ?? const <dynamic>[];
    final myEntryMap = json['myEntry'] as Map?;

    return LeaderboardPayloadApiModel(
      match: LeaderboardMatchMetaApiModel.fromJson(matchMap),
      leaders: leadersRows
          .map(
            (item) => LeaderboardLeaderApiModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false),
      myEntry: myEntryMap == null
          ? null
          : LeaderboardLeaderApiModel.fromJson(
              Map<String, dynamic>.from(myEntryMap),
            ),
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
