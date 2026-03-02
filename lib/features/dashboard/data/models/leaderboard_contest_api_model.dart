import 'package:json_annotation/json_annotation.dart';

part 'leaderboard_contest_api_model.g.dart';

@JsonSerializable(createToJson: false)
class LeaderboardContestApiModel {
  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String id;

  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String matchLabel;

  @JsonKey(fromJson: _parseDateTime)
  final DateTime startsAt;

  @JsonKey(fromJson: _toRequiredString, defaultValue: 'completed')
  final String status;

  @JsonKey(fromJson: _asInt, defaultValue: 0)
  final int entryFee;

  @JsonKey(fromJson: _asInt, defaultValue: 0)
  final int participantsCount;

  @JsonKey(fromJson: _asInt, defaultValue: 0)
  final int prizePool;

  const LeaderboardContestApiModel({
    required this.id,
    required this.matchLabel,
    required this.startsAt,
    required this.status,
    required this.entryFee,
    required this.participantsCount,
    required this.prizePool,
  });

  factory LeaderboardContestApiModel.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardContestApiModelFromJson(json);

  static String _toRequiredString(dynamic value) => value?.toString() ?? '';

  static DateTime _parseDateTime(dynamic value) =>
      DateTime.tryParse(value?.toString() ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
