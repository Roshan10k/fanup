import 'package:json_annotation/json_annotation.dart';

part 'contest_entry_api_model.g.dart';

@JsonSerializable()
class ContestEntryApiModel {
  @JsonKey(defaultValue: '')
  final String matchId;

  @JsonKey(defaultValue: '')
  final String entryId;

  @JsonKey(defaultValue: '')
  final String teamId;

  @JsonKey(defaultValue: '')
  final String teamName;

  @JsonKey(defaultValue: '')
  final String captainId;

  @JsonKey(defaultValue: '')
  final String viceCaptainId;

  @JsonKey(defaultValue: <String>[])
  final List<String> playerIds;

  @JsonKey(defaultValue: 0)
  final int points;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  @JsonKey(name: 'match')
  final ContestEntryMatchApiModel? match;

  const ContestEntryApiModel({
    required this.matchId,
    this.entryId = '',
    this.teamId = '',
    this.teamName = '',
    this.captainId = '',
    this.viceCaptainId = '',
    this.playerIds = const [],
    this.points = 0,
    this.updatedAt,
    this.match,
  });

  factory ContestEntryApiModel.fromJson(Map<String, dynamic> json) =>
      _$ContestEntryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContestEntryApiModelToJson(this);
}

@JsonSerializable()
class ContestEntryMatchApiModel {
  @JsonKey(defaultValue: '')
  final String id;

  @JsonKey(defaultValue: '')
  final String league;

  final DateTime? startTime;

  @JsonKey(defaultValue: '')
  final String status;

  final ContestEntryTeamApiModel? teamA;
  final ContestEntryTeamApiModel? teamB;

  const ContestEntryMatchApiModel({
    this.id = '',
    this.league = '',
    this.startTime,
    this.status = '',
    this.teamA,
    this.teamB,
  });

  factory ContestEntryMatchApiModel.fromJson(Map<String, dynamic> json) =>
      _$ContestEntryMatchApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContestEntryMatchApiModelToJson(this);
}

@JsonSerializable()
class ContestEntryTeamApiModel {
  @JsonKey(defaultValue: '')
  final String shortName;

  const ContestEntryTeamApiModel({this.shortName = ''});

  factory ContestEntryTeamApiModel.fromJson(Map<String, dynamic> json) =>
      _$ContestEntryTeamApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContestEntryTeamApiModelToJson(this);
}
