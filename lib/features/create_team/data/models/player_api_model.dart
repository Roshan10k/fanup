import 'package:fanup/features/create_team/domain/entities/player_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player_api_model.g.dart';

@JsonSerializable()
class PlayerApiModel {
  @JsonKey(name: '_id', fromJson: _toRequiredString, defaultValue: '')
  final String id;

  @JsonKey(fromJson: _fullNameFromJson, defaultValue: 'Player')
  final String fullName;

  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String teamShortName;

  @JsonKey(fromJson: _roleFromJson, defaultValue: 'bowler')
  final String role;

  @JsonKey(fromJson: _toDouble, defaultValue: 0.0)
  final double credit;

  @JsonKey(fromJson: _toBool, defaultValue: false)
  final bool isPlaying;

  const PlayerApiModel({
    required this.id,
    required this.fullName,
    required this.teamShortName,
    required this.role,
    required this.credit,
    required this.isPlaying,
  });

  factory PlayerApiModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerApiModelToJson(this);

  PlayerEntity toEntity() {
    return PlayerEntity(
      id: id,
      fullName: fullName,
      teamShortName: teamShortName,
      role: TeamRoleX.fromBackend(role),
      credit: credit,
      isPlaying: isPlaying,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse((value ?? '0').toString()) ?? 0;
  }

  static bool _toBool(dynamic value) => value == true;

  static String _toRequiredString(dynamic value) {
    return value?.toString() ?? '';
  }

  static String _fullNameFromJson(dynamic value) {
    return value?.toString() ?? 'Player';
  }

  static String _roleFromJson(dynamic value) {
    return value?.toString() ?? 'bowler';
  }
}
