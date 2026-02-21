import 'package:fanup/features/dashboard/data/models/wallet_summary_api_model.dart';

class WalletDailyBonusResultApiModel {
  final bool created;
  final int amount;
  final String message;
  final WalletSummaryApiModel summary;

  const WalletDailyBonusResultApiModel({
    required this.created,
    required this.amount,
    required this.message,
    required this.summary,
  });
}
