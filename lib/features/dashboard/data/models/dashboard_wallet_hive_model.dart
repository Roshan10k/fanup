import 'package:fanup/core/constants/hive_table_constant.dart';
import 'package:fanup/features/dashboard/data/models/wallet_summary_api_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_transaction_api_model.dart';
import 'package:hive/hive.dart';

part 'dashboard_wallet_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.dashboardWalletHiveTypeId)
class DashboardWalletHiveModel extends HiveObject {
  @HiveField(0)
  final DateTime storedAt;

  @HiveField(1)
  final Map<String, dynamic>? summaryJson;

  @HiveField(2)
  final List<Map<String, dynamic>> transactionsJson;

  DashboardWalletHiveModel({
    required this.storedAt,
    this.summaryJson,
    this.transactionsJson = const [],
  });

  DashboardWalletHiveModel copyWith({
    DateTime? storedAt,
    Map<String, dynamic>? summaryJson,
    List<Map<String, dynamic>>? transactionsJson,
  }) {
    return DashboardWalletHiveModel(
      storedAt: storedAt ?? this.storedAt,
      summaryJson: summaryJson ?? this.summaryJson,
      transactionsJson: transactionsJson ?? this.transactionsJson,
    );
  }

  WalletSummaryApiModel? toSummary() {
    final summary = summaryJson;
    if (summary == null) return null;
    return WalletSummaryApiModel.fromJson(Map<String, dynamic>.from(summary));
  }

  List<WalletTransactionApiModel> toTransactions() {
    return transactionsJson
        .map(
          (item) => WalletTransactionApiModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList(growable: false);
  }
}
