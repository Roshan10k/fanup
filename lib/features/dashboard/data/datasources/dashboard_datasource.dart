import 'package:fanup/features/dashboard/data/models/completed_match_api_model.dart';
import 'package:fanup/features/dashboard/data/models/contest_entry_api_model.dart';
import 'package:fanup/features/dashboard/data/models/home_match_api_model.dart';
import 'package:fanup/features/dashboard/data/models/leaderboard_contest_api_model.dart';
import 'package:fanup/features/dashboard/data/models/leaderboard_payload_api_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_daily_bonus_result_api_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_summary_api_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_transaction_api_model.dart';

abstract interface class IDashboardRemoteDataSource {
  Future<List<HomeMatchApiModel>> getUpcomingMatches({
    int page = 1,
    int size = 12,
  });

  Future<List<CompletedMatchApiModel>> getCompletedMatches({
    int page = 1,
    int size = 12,
  });

  Future<List<ContestEntryApiModel>> getMyContestEntries();

  Future<void> deleteMyContestEntry({required String matchId});

  Future<WalletSummaryApiModel> getWalletSummary();

  Future<List<WalletTransactionApiModel>> getWalletTransactions({
    int page = 1,
    int size = 20,
  });

  Future<WalletDailyBonusResultApiModel> claimDailyBonus();

  Future<List<LeaderboardContestApiModel>> getLeaderboardContests({
    required String status,
  });

  Future<LeaderboardPayloadApiModel> getMatchLeaderboard({
    required String matchId,
  });
}

class DashboardLocalHomeData {
  final List<HomeMatchApiModel> matches;
  final List<ContestEntryApiModel> entries;
  final DateTime storedAt;

  const DashboardLocalHomeData({
    required this.matches,
    required this.entries,
    required this.storedAt,
  });
}

abstract interface class IDashboardLocalDataSource {
  Future<void> saveHomeData({
    required List<HomeMatchApiModel> matches,
    required List<ContestEntryApiModel> entries,
  });

  Future<DashboardLocalHomeData?> getHomeData();

  Future<void> saveWalletSummary(WalletSummaryApiModel summary);

  Future<void> saveWalletTransactions(List<WalletTransactionApiModel> items);

  Future<WalletSummaryApiModel?> getWalletSummary();

  Future<List<WalletTransactionApiModel>?> getWalletTransactions();
}
