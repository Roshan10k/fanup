import 'package:json_annotation/json_annotation.dart';

part 'leaderboard_payload_api_model.g.dart';

@JsonSerializable(createToJson: false)
class LeaderboardMatchMetaApiModel {
  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String id;

  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String matchLabel;

  @JsonKey(fromJson: _parseDateTime)
  final DateTime startsAt;

  @JsonKey(fromJson: _toRequiredString, defaultValue: 'completed')
  final String status;

  const LeaderboardMatchMetaApiModel({
    required this.id,
    required this.matchLabel,
    required this.startsAt,
    required this.status,
  });

  factory LeaderboardMatchMetaApiModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardMatchMetaApiModelFromJson(json);

  static String _toRequiredString(dynamic value) => value?.toString() ?? '';

  static DateTime _parseDateTime(dynamic value) =>
      DateTime.tryParse(value?.toString() ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

@JsonSerializable(createToJson: false)
class LeaderboardLeaderApiModel {
  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String userId;

  @JsonKey(fromJson: _asInt, defaultValue: 0)
  final int rank;

  @JsonKey(fromJson: _toRequiredString, defaultValue: 'User')
  final String name;

  @JsonKey(fromJson: _asInt, defaultValue: 0)
  final int teams;

  @JsonKey(fromJson: _asDouble, defaultValue: 0.0)
  final double pts;

  @JsonKey(fromJson: _asDouble, defaultValue: 0.0)
  final double winRate;

  @JsonKey(fromJson: _asInt, defaultValue: 0)
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

  factory LeaderboardLeaderApiModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardLeaderApiModelFromJson(json);

  static String _toRequiredString(dynamic value) => value?.toString() ?? '';

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _asDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}

@JsonSerializable(createToJson: false)
class LeaderboardPayloadApiModel {
  @JsonKey(fromJson: _parseMatch)
  final LeaderboardMatchMetaApiModel match;

  @JsonKey(fromJson: _parseLeaders)
  final List<LeaderboardLeaderApiModel> leaders;

  @JsonKey(fromJson: _parseMyEntry)
  final LeaderboardLeaderApiModel? myEntry;

  const LeaderboardPayloadApiModel({
    required this.match,
    required this.leaders,
    required this.myEntry,
  });

  factory LeaderboardPayloadApiModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardPayloadApiModelFromJson(json);

  static LeaderboardMatchMetaApiModel _parseMatch(dynamic value) {
    if (value is Map) {
      return LeaderboardMatchMetaApiModel.fromJson(
        Map<String, dynamic>.from(value),
      );
    }
    return LeaderboardMatchMetaApiModel.fromJson(const <String, dynamic>{});
  }

  static List<LeaderboardLeaderApiModel> _parseLeaders(dynamic value) {
    if (value is List) {
      return value
          .map(
            (item) => LeaderboardLeaderApiModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false);
    }
    return const [];
  }

  static LeaderboardLeaderApiModel? _parseMyEntry(dynamic value) {
    if (value is Map) {
      return LeaderboardLeaderApiModel.fromJson(
        Map<String, dynamic>.from(value),
      );
    }
    return null;
  }
}
