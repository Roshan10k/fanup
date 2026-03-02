import 'package:json_annotation/json_annotation.dart';

part 'wallet_transaction_api_model.g.dart';

@JsonSerializable()
class WalletTransactionApiModel {
  @JsonKey(name: '_id', fromJson: _toRequiredString, defaultValue: '')
  final String id;

  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String title;

  @JsonKey(fromJson: _asInt, defaultValue: 0)
  final int amount;

  @JsonKey(fromJson: _toRequiredString, defaultValue: 'credit')
  final String type;

  @JsonKey(fromJson: _toRequiredString, defaultValue: 'system_adjustment')
  final String source;

  @JsonKey(fromJson: _parseDateTime)
  final DateTime createdAt;

  const WalletTransactionApiModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.source,
    required this.createdAt,
  });

  factory WalletTransactionApiModel.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletTransactionApiModelToJson(this);

  static String _toRequiredString(dynamic value) => value?.toString() ?? '';

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime _parseDateTime(dynamic value) =>
      DateTime.tryParse(value?.toString() ?? '') ??
      DateTime.fromMillisecondsSinceEpoch(0);
}
