// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contest_entry_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContestEntryApiModel _$ContestEntryApiModelFromJson(
        Map<String, dynamic> json) =>
    ContestEntryApiModel(
      matchId: json['matchId'] == null
          ? ''
          : ContestEntryApiModel._toRequiredString(json['matchId']),
      teamId: json['teamId'] == null
          ? ''
          : ContestEntryApiModel._toRequiredString(json['teamId']),
      teamName: json['teamName'] == null
          ? ''
          : ContestEntryApiModel._toRequiredString(json['teamName']),
      captainId: json['captainId'] == null
          ? ''
          : ContestEntryApiModel._toRequiredString(json['captainId']),
      viceCaptainId: json['viceCaptainId'] == null
          ? ''
          : ContestEntryApiModel._toRequiredString(json['viceCaptainId']),
      playerIds: json['playerIds'] == null
          ? []
          : ContestEntryApiModel._playerIdsFromJson(json['playerIds']),
    );

Map<String, dynamic> _$ContestEntryApiModelToJson(
        ContestEntryApiModel instance) =>
    <String, dynamic>{
      'matchId': instance.matchId,
      'teamId': instance.teamId,
      'teamName': instance.teamName,
      'captainId': instance.captainId,
      'viceCaptainId': instance.viceCaptainId,
      'playerIds': instance.playerIds,
    };
