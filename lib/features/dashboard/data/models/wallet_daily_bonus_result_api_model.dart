import 'package:fanup/features/dashboard/data/models/wallet_summary_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_daily_bonus_result_api_model.g.dart';

@JsonSerializable(createToJson: false)
class WalletDailyBonusResultApiModel {
  @JsonKey(defaultValue: false)
  final bool created;

  @JsonKey(fromJson: _asInt, defaultValue: 0)
  final int amount;

  @JsonKey(fromJson: _toRequiredString, defaultValue: '')
  final String message;

  @JsonKey(fromJson: _parseSummary)
  final WalletSummaryApiModel summary;

  const WalletDailyBonusResultApiModel({
    required this.created,
    required this.amount,
    required this.message,
    required this.summary,
  });

  factory WalletDailyBonusResultApiModel.fromJson(
    Map<String, dynamic> json,
  ) => _$WalletDailyBonusResultApiModelFromJson(json);

  static String _toRequiredString(dynamic value) => value?.toString() ?? '';

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static WalletSummaryApiModel _parseSummary(dynamic value) {
    if (value is Map) {
      return WalletSummaryApiModel.fromJson(
        Map<String, dynamic>.from(value),
      );
    }
    return WalletSummaryApiModel.fromJson(const <String, dynamic>{});
  }
}
