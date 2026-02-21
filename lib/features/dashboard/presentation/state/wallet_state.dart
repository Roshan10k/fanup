import 'package:equatable/equatable.dart';
import 'package:fanup/features/dashboard/domain/entities/wallet_summary_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/wallet_transaction_entity.dart';

enum WalletStatus { initial, loading, loaded, error }

class WalletState extends Equatable {
  final WalletStatus status;
  final WalletSummaryEntity? summary;
  final List<WalletTransactionEntity> transactions;
  final bool isClaimingBonus;
  final String? infoMessage;
  final String? errorMessage;

  const WalletState({
    this.status = WalletStatus.initial,
    this.summary,
    this.transactions = const [],
    this.isClaimingBonus = false,
    this.infoMessage,
    this.errorMessage,
  });

  WalletState copyWith({
    WalletStatus? status,
    WalletSummaryEntity? summary,
    bool clearSummary = false,
    List<WalletTransactionEntity>? transactions,
    bool? isClaimingBonus,
    String? infoMessage,
    bool clearInfoMessage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return WalletState(
      status: status ?? this.status,
      summary: clearSummary ? null : (summary ?? this.summary),
      transactions: transactions ?? this.transactions,
      isClaimingBonus: isClaimingBonus ?? this.isClaimingBonus,
      infoMessage: clearInfoMessage ? null : (infoMessage ?? this.infoMessage),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    summary,
    transactions,
    isClaimingBonus,
    infoMessage,
    errorMessage,
  ];
}
