// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_match_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeMatchApiModel _$HomeMatchApiModelFromJson(Map<String, dynamic> json) =>
    HomeMatchApiModel(
      id: json['_id'] as String?,
      league: json['league'] as String?,
      startTime: json['startTime'] as String?,
      status: json['status'] as String?,
      teamA: json['teamA'] == null
          ? null
          : TeamData.fromJson(json['teamA'] as Map<String, dynamic>),
      teamB: json['teamB'] == null
          ? null
          : TeamData.fromJson(json['teamB'] as Map<String, dynamic>),
    );

TeamData _$TeamDataFromJson(Map<String, dynamic> json) => TeamData(
      id: json['_id'] as String?,
      shortName: json['shortName'] as String?,
      name: json['name'] as String?,
    );
