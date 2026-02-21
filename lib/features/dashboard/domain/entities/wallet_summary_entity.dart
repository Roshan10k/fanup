import 'package:equatable/equatable.dart';

class WalletSummaryEntity extends Equatable {
  final int balance;
  final int totalCredit;
  final int totalDebit;
  final int transactionCount;
  final DateTime? lastTransactionAt;

  const WalletSummaryEntity({
    required this.balance,
    required this.totalCredit,
    required this.totalDebit,
    required this.transactionCount,
    required this.lastTransactionAt,
  });

  @override
  List<Object?> get props => [
    balance,
    totalCredit,
    totalDebit,
    transactionCount,
    lastTransactionAt,
  ];
}
