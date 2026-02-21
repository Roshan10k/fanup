// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerApiModel _$PlayerApiModelFromJson(Map<String, dynamic> json) =>
    PlayerApiModel(
      id: json['_id'] == null
          ? ''
          : PlayerApiModel._toRequiredString(json['_id']),
      fullName: json['fullName'] == null
          ? 'Player'
          : PlayerApiModel._fullNameFromJson(json['fullName']),
      teamShortName: json['teamShortName'] == null
          ? ''
          : PlayerApiModel._toRequiredString(json['teamShortName']),
      role: json['role'] == null
          ? 'bowler'
          : PlayerApiModel._roleFromJson(json['role']),
      credit: json['credit'] == null
          ? 0.0
          : PlayerApiModel._toDouble(json['credit']),
      isPlaying: json['isPlaying'] == null
          ? false
          : PlayerApiModel._toBool(json['isPlaying']),
    );

Map<String, dynamic> _$PlayerApiModelToJson(PlayerApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fullName': instance.fullName,
      'teamShortName': instance.teamShortName,
      'role': instance.role,
      'credit': instance.credit,
      'isPlaying': instance.isPlaying,
    };
