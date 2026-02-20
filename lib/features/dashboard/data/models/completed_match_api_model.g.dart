// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_match_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompletedMatchApiModel _$CompletedMatchApiModelFromJson(
        Map<String, dynamic> json) =>
    CompletedMatchApiModel(
      id: json['_id'] as String? ?? '',
      league: json['league'] as String? ?? 'League',
      startTime: CompletedMatchApiModel._parseStartTime(json['startTime']),
      status: json['status'] as String? ?? 'completed',
      teamA: CompletedMatchApiModel._parseTeam(json['teamA']),
      teamB: CompletedMatchApiModel._parseTeam(json['teamB']),
    );

Map<String, dynamic> _$CompletedMatchApiModelToJson(
        CompletedMatchApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'league': instance.league,
      'startTime': instance.startTime.toIso8601String(),
      'status': instance.status,
      'teamA': instance.teamA.toJson(),
      'teamB': instance.teamB.toJson(),
    };

MatchTeamApiModel _$MatchTeamApiModelFromJson(Map<String, dynamic> json) =>
    MatchTeamApiModel(
      shortName: json['shortName'] as String? ?? 'TBD',
    );

Map<String, dynamic> _$MatchTeamApiModelToJson(MatchTeamApiModel instance) =>
    <String, dynamic>{
      'shortName': instance.shortName,
    };
