// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_contest_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardContestApiModel _$LeaderboardContestApiModelFromJson(
        Map<String, dynamic> json) =>
    LeaderboardContestApiModel(
      id: json['id'] == null
          ? ''
          : LeaderboardContestApiModel._toRequiredString(json['id']),
      matchLabel: json['matchLabel'] == null
          ? ''
          : LeaderboardContestApiModel._toRequiredString(json['matchLabel']),
      startsAt: LeaderboardContestApiModel._parseDateTime(json['startsAt']),
      status: json['status'] == null
          ? 'completed'
          : LeaderboardContestApiModel._toRequiredString(json['status']),
      entryFee: json['entryFee'] == null
          ? 0
          : LeaderboardContestApiModel._asInt(json['entryFee']),
      participantsCount: json['participantsCount'] == null
          ? 0
          : LeaderboardContestApiModel._asInt(json['participantsCount']),
      prizePool: json['prizePool'] == null
          ? 0
          : LeaderboardContestApiModel._asInt(json['prizePool']),
    );
