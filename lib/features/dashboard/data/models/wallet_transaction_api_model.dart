class WalletTransactionApiModel {
  final String id;
  final String title;
  final int amount;
  final String type;
  final String source;
  final DateTime createdAt;

  const WalletTransactionApiModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.source,
    required this.createdAt,
  });

  factory WalletTransactionApiModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionApiModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      amount: _asInt(json['amount']),
      type: json['type']?.toString() ?? 'credit',
      source: json['source']?.toString() ?? 'system_adjustment',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
