import 'package:fanup/features/dashboard/domain/entities/home_match_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_match_api_model.g.dart';

@JsonSerializable(createToJson: false)
class HomeMatchApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? league;
  final String? startTime;
  final String? status;
  @JsonKey(name: 'teamA')
  final TeamData? teamA;
  @JsonKey(name: 'teamB')
  final TeamData? teamB;

  HomeMatchApiModel({
    this.id,
    this.league,
    this.startTime,
    this.status,
    this.teamA,
    this.teamB,
  });

  factory HomeMatchApiModel.fromJson(Map<String, dynamic> json) =>
      _$HomeMatchApiModelFromJson(json);

  HomeMatchEntity toEntity({bool hasExistingEntry = false}) {
    return HomeMatchEntity(
      id: id ?? '',
      league: league ?? 'League',
      startTime: DateTime.tryParse(startTime ?? '') ?? DateTime.now(),
      status: status ?? 'upcoming',
      teamAShortName: teamA?.shortName ?? 'T1',
      teamBShortName: teamB?.shortName ?? 'T2',
      hasExistingEntry: hasExistingEntry,
    );
  }
}

@JsonSerializable(createToJson: false)
class TeamData {
  @JsonKey(name: '_id')
  final String? id;
  final String? shortName;
  final String? name;

  TeamData({
    this.id,
    this.shortName,
    this.name,
  });

  factory TeamData.fromJson(Map<String, dynamic> json) =>
      _$TeamDataFromJson(json);
}
