// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_daily_bonus_result_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletDailyBonusResultApiModel _$WalletDailyBonusResultApiModelFromJson(
        Map<String, dynamic> json) =>
    WalletDailyBonusResultApiModel(
      created: json['created'] as bool? ?? false,
      amount: json['amount'] == null
          ? 0
          : WalletDailyBonusResultApiModel._asInt(json['amount']),
      message: json['message'] == null
          ? ''
          : WalletDailyBonusResultApiModel._toRequiredString(json['message']),
      summary: WalletDailyBonusResultApiModel._parseSummary(json['summary']),
    );
