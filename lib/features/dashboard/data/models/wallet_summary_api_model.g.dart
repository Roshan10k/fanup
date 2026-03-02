// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_summary_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletSummaryApiModel _$WalletSummaryApiModelFromJson(
        Map<String, dynamic> json) =>
    WalletSummaryApiModel(
      balance: json['balance'] == null
          ? 0
          : WalletSummaryApiModel._asInt(json['balance']),
      totalCredit: json['totalCredit'] == null
          ? 0
          : WalletSummaryApiModel._asInt(json['totalCredit']),
      totalDebit: json['totalDebit'] == null
          ? 0
          : WalletSummaryApiModel._asInt(json['totalDebit']),
      transactionCount: json['transactionCount'] == null
          ? 0
          : WalletSummaryApiModel._asInt(json['transactionCount']),
      lastTransactionAt:
          WalletSummaryApiModel._asDateTime(json['lastTransactionAt']),
    );

Map<String, dynamic> _$WalletSummaryApiModelToJson(
        WalletSummaryApiModel instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'totalCredit': instance.totalCredit,
      'totalDebit': instance.totalDebit,
      'transactionCount': instance.transactionCount,
      'lastTransactionAt': instance.lastTransactionAt?.toIso8601String(),
    };
