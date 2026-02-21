import 'package:equatable/equatable.dart';
import 'package:fanup/features/dashboard/domain/entities/wallet_summary_entity.dart';

class WalletDailyBonusResultEntity extends Equatable {
  final bool created;
  final int amount;
  final String message;
  final WalletSummaryEntity summary;

  const WalletDailyBonusResultEntity({
    required this.created,
    required this.amount,
    required this.message,
    required this.summary,
  });

  @override
  List<Object?> get props => [created, amount, message, summary];
}
