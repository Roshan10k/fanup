import 'package:fanup/core/services/hive/hive_service.dart';
import 'package:fanup/features/dashboard/data/datasources/dashboard_datasource.dart';
import 'package:fanup/features/dashboard/data/models/contest_entry_api_model.dart';
import 'package:fanup/features/dashboard/data/models/home_match_api_model.dart';
import 'package:fanup/features/dashboard/data/models/dashboard_home_hive_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_summary_api_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_transaction_api_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardLocalDataSourceProvider = Provider<IDashboardLocalDataSource>((
  ref,
) {
  return DashboardLocalDataSource(hiveService: ref.read(hiveServiceProvider));
});

class DashboardLocalDataSource implements IDashboardLocalDataSource {
  final HiveService _hiveService;

  DashboardLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> saveHomeData({
    required List<HomeMatchApiModel> matches,
    required List<ContestEntryApiModel> entries,
  }) async {
    final home = DashboardHomeHiveModel.fromApiModels(
      matches: matches,
      entries: entries,
    );
    await _hiveService.saveDashboardHome(home);
  }

  @override
  Future<DashboardLocalHomeData?> getHomeData() async {
    try {
      final home = _hiveService.getDashboardHome();
      if (home == null) {
        return null;
      }

      return DashboardLocalHomeData(
        matches: home.toHomeMatches(),
        entries: home.toContestEntries(),
        storedAt: home.storedAt,
      );
    } catch (e) {
      debugPrint('Dashboard home read error: $e');
      return null;
    }
  }

  @override
  Future<void> saveWalletSummary(WalletSummaryApiModel summary) async {
    await _hiveService.saveDashboardWalletSummary(summary);
  }

  @override
  Future<void> saveWalletTransactions(
    List<WalletTransactionApiModel> items,
  ) async {
    await _hiveService.saveDashboardWalletTransactions(items);
  }

  @override
  Future<WalletSummaryApiModel?> getWalletSummary() async {
    try {
      return _hiveService.getDashboardWalletSummary();
    } catch (e) {
      debugPrint('Dashboard wallet summary read error: $e');
      return null;
    }
  }

  @override
  Future<List<WalletTransactionApiModel>?> getWalletTransactions() async {
    try {
      return _hiveService.getDashboardWalletTransactions();
    } catch (e) {
      debugPrint('Dashboard wallet transactions read error: $e');
      return null;
    }
  }
}
