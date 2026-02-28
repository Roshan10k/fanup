class WalletSummaryApiModel {
  final int balance;
  final int totalCredit;
  final int totalDebit;
  final int transactionCount;
  final DateTime? lastTransactionAt;

  const WalletSummaryApiModel({
    required this.balance,
    required this.totalCredit,
    required this.totalDebit,
    required this.transactionCount,
    required this.lastTransactionAt,
  });

  factory WalletSummaryApiModel.fromJson(Map<String, dynamic> json) {
    return WalletSummaryApiModel(
      balance: _asInt(json['balance']),
      totalCredit: _asInt(json['totalCredit']),
      totalDebit: _asInt(json['totalDebit']),
      transactionCount: _asInt(json['transactionCount']),
      lastTransactionAt: _asDateTime(json['lastTransactionAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'totalCredit': totalCredit,
      'totalDebit': totalDebit,
      'transactionCount': transactionCount,
      'lastTransactionAt': lastTransactionAt?.toIso8601String(),
    };
  }

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
