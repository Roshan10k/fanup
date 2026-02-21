import 'package:equatable/equatable.dart';

enum WalletTransactionType { credit, debit }

class WalletTransactionEntity extends Equatable {
  final String id;
  final String title;
  final int amount;
  final WalletTransactionType type;
  final String source;
  final DateTime createdAt;

  const WalletTransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.source,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, title, amount, type, source, createdAt];
}
