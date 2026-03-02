// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_payload_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardMatchMetaApiModel _$LeaderboardMatchMetaApiModelFromJson(
        Map<String, dynamic> json) =>
    LeaderboardMatchMetaApiModel(
      id: json['id'] == null
          ? ''
          : LeaderboardMatchMetaApiModel._toRequiredString(json['id']),
      matchLabel: json['matchLabel'] == null
          ? ''
          : LeaderboardMatchMetaApiModel._toRequiredString(json['matchLabel']),
      startsAt: LeaderboardMatchMetaApiModel._parseDateTime(json['startsAt']),
      status: json['status'] == null
          ? 'completed'
          : LeaderboardMatchMetaApiModel._toRequiredString(json['status']),
    );

LeaderboardLeaderApiModel _$LeaderboardLeaderApiModelFromJson(
        Map<String, dynamic> json) =>
    LeaderboardLeaderApiModel(
      userId: json['userId'] == null
          ? ''
          : LeaderboardLeaderApiModel._toRequiredString(json['userId']),
      rank: json['rank'] == null
          ? 0
          : LeaderboardLeaderApiModel._asInt(json['rank']),
      name: json['name'] == null
          ? 'User'
          : LeaderboardLeaderApiModel._toRequiredString(json['name']),
      teams: json['teams'] == null
          ? 0
          : LeaderboardLeaderApiModel._asInt(json['teams']),
      pts: json['pts'] == null
          ? 0.0
          : LeaderboardLeaderApiModel._asDouble(json['pts']),
      winRate: json['winRate'] == null
          ? 0.0
          : LeaderboardLeaderApiModel._asDouble(json['winRate']),
      prize: json['prize'] == null
          ? 0
          : LeaderboardLeaderApiModel._asInt(json['prize']),
    );

LeaderboardPayloadApiModel _$LeaderboardPayloadApiModelFromJson(
        Map<String, dynamic> json) =>
    LeaderboardPayloadApiModel(
      match: LeaderboardPayloadApiModel._parseMatch(json['match']),
      leaders: LeaderboardPayloadApiModel._parseLeaders(json['leaders']),
      myEntry: LeaderboardPayloadApiModel._parseMyEntry(json['myEntry']),
    );
