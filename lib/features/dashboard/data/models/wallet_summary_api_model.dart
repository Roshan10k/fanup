import 'package:json_annotation/json_annotation.dart';

part 'wallet_summary_api_model.g.dart';

@JsonSerializable()
class WalletSummaryApiModel {
  @JsonKey(fromJson: _asInt, defaultValue: 0)
  final int balance;

  @JsonKey(fromJson: _asInt, defaultValue: 0)
  final int totalCredit;

  @JsonKey(fromJson: _asInt, defaultValue: 0)
  final int totalDebit;

  @JsonKey(fromJson: _asInt, defaultValue: 0)
  final int transactionCount;

  @JsonKey(fromJson: _asDateTime)
  final DateTime? lastTransactionAt;

  const WalletSummaryApiModel({
    required this.balance,
    required this.totalCredit,
    required this.totalDebit,
    required this.transactionCount,
    required this.lastTransactionAt,
  });

  factory WalletSummaryApiModel.fromJson(Map<String, dynamic> json) =>
      _$WalletSummaryApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$WalletSummaryApiModelToJson(this);

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _asDateTime(dynamic value) {
    final raw = value?.toString();
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }
}
