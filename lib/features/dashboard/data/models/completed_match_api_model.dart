import 'package:json_annotation/json_annotation.dart';

part 'completed_match_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CompletedMatchApiModel {
  @JsonKey(name: '_id', defaultValue: '')
  final String id;

  @JsonKey(defaultValue: 'League')
  final String league;

  @JsonKey(fromJson: _parseStartTime)
  final DateTime startTime;

  @JsonKey(defaultValue: 'completed')
  final String status;

  @JsonKey(name: 'teamA', fromJson: _parseTeam)
  final MatchTeamApiModel teamA;

  @JsonKey(name: 'teamB', fromJson: _parseTeam)
  final MatchTeamApiModel teamB;

  const CompletedMatchApiModel({
    required this.id,
    required this.league,
    required this.startTime,
    required this.status,
    required this.teamA,
    required this.teamB,
  });

  String get teamAShortName => teamA.shortName;
  String get teamBShortName => teamB.shortName;

  factory CompletedMatchApiModel.fromJson(Map<String, dynamic> json) =>
      _$CompletedMatchApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompletedMatchApiModelToJson(this);

  static DateTime _parseStartTime(dynamic value) {
    final raw = value?.toString() ?? '';
    return DateTime.tryParse(raw) ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  static MatchTeamApiModel _parseTeam(dynamic value) {
    final map = value is Map<String, dynamic>
        ? value
        : Map<String, dynamic>.from(value as Map? ?? const {});
    return MatchTeamApiModel.fromJson(map);
  }
}

@JsonSerializable()
class MatchTeamApiModel {
  @JsonKey(defaultValue: 'TBD')
  final String shortName;

  const MatchTeamApiModel({required this.shortName});

  factory MatchTeamApiModel.fromJson(Map<String, dynamic> json) =>
      _$MatchTeamApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$MatchTeamApiModelToJson(this);
}
