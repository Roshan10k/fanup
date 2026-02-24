// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_entry_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContestEntryApiModel _$ContestEntryApiModelFromJson(
        Map<String, dynamic> json) =>
    ContestEntryApiModel(
      matchId: json['matchId'] as String? ?? '',
      entryId: json['entryId'] as String? ?? '',
      teamId: json['teamId'] as String? ?? '',
      teamName: json['teamName'] as String? ?? '',
      captainId: json['captainId'] as String? ?? '',
      viceCaptainId: json['viceCaptainId'] as String? ?? '',
      playerIds: (json['playerIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      points: (json['points'] as num?)?.toInt() ?? 0,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      match: json['match'] == null
          ? null
          : ContestEntryMatchApiModel.fromJson(
              json['match'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContestEntryApiModelToJson(
        ContestEntryApiModel instance) =>
    <String, dynamic>{
      'matchId': instance.matchId,
      'entryId': instance.entryId,
      'teamId': instance.teamId,
      'teamName': instance.teamName,
      'captainId': instance.captainId,
      'viceCaptainId': instance.viceCaptainId,
      'playerIds': instance.playerIds,
      'points': instance.points,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'match': instance.match,
    };

ContestEntryMatchApiModel _$ContestEntryMatchApiModelFromJson(
        Map<String, dynamic> json) =>
    ContestEntryMatchApiModel(
      id: json['id'] as String? ?? '',
      league: json['league'] as String? ?? '',
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      status: json['status'] as String? ?? '',
      teamA: json['teamA'] == null
          ? null
          : ContestEntryTeamApiModel.fromJson(
              json['teamA'] as Map<String, dynamic>),
      teamB: json['teamB'] == null
          ? null
          : ContestEntryTeamApiModel.fromJson(
              json['teamB'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContestEntryMatchApiModelToJson(
        ContestEntryMatchApiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'league': instance.league,
      'startTime': instance.startTime?.toIso8601String(),
      'status': instance.status,
      'teamA': instance.teamA,
      'teamB': instance.teamB,
    };

ContestEntryTeamApiModel _$ContestEntryTeamApiModelFromJson(
        Map<String, dynamic> json) =>
    ContestEntryTeamApiModel(
      shortName: json['shortName'] as String? ?? '',
    );

Map<String, dynamic> _$ContestEntryTeamApiModelToJson(
        ContestEntryTeamApiModel instance) =>
    <String, dynamic>{
      'shortName': instance.shortName,
    };
