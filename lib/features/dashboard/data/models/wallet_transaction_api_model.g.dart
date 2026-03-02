// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_transaction_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletTransactionApiModel _$WalletTransactionApiModelFromJson(
        Map<String, dynamic> json) =>
    WalletTransactionApiModel(
      id: json['_id'] == null
          ? ''
          : WalletTransactionApiModel._toRequiredString(json['_id']),
      title: json['title'] == null
          ? ''
          : WalletTransactionApiModel._toRequiredString(json['title']),
      amount: json['amount'] == null
          ? 0
          : WalletTransactionApiModel._asInt(json['amount']),
      type: json['type'] == null
          ? 'credit'
          : WalletTransactionApiModel._toRequiredString(json['type']),
      source: json['source'] == null
          ? 'system_adjustment'
          : WalletTransactionApiModel._toRequiredString(json['source']),
      createdAt: WalletTransactionApiModel._parseDateTime(json['createdAt']),
    );

Map<String, dynamic> _$WalletTransactionApiModelToJson(
        WalletTransactionApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'amount': instance.amount,
      'type': instance.type,
      'source': instance.source,
      'createdAt': instance.createdAt.toIso8601String(),
    };
