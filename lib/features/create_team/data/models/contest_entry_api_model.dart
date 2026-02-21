import 'package:fanup/features/create_team/domain/entities/contest_entry_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contest_entry_api_model.g.dart';

@JsonSerializable()
class ContestEntryApiModel {
  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String matchId;

  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String teamId;

  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String teamName;

  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String captainId;

  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String viceCaptainId;

  @JsonKey(fromJson: _playerIdsFromJson, defaultValue: <String>[])
  final List<String> playerIds;

  const ContestEntryApiModel({
    required this.matchId,
    required this.teamId,
    required this.teamName,
    required this.captainId,
    required this.viceCaptainId,
    required this.playerIds,
  });

  factory ContestEntryApiModel.fromJson(Map<String, dynamic> json) =>
      _$ContestEntryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContestEntryApiModelToJson(this);

  ExistingContestEntryEntity toExistingEntryEntity() {
    return ExistingContestEntryEntity(
      teamId: teamId,
      teamName: teamName,
      captainId: captainId,
      viceCaptainId: viceCaptainId,
      playerIds: playerIds,
    );
  }

  static List<String> _playerIdsFromJson(dynamic value) {
    final ids = (value as List?) ?? const [];
    return ids.map((e) => e.toString()).toList();
  }

  static String _toRequiredString(dynamic value) {
    return value?.toString() ?? '';
  }
}
