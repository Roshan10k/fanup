import 'package:dartz/dartz.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/features/dashboard/domain/entities/home_feed_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/leaderboard_contest_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/leaderboard_payload_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/wallet_daily_bonus_result_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/wallet_summary_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/wallet_transaction_entity.dart';

abstract interface class IDashboardRepository {
  Future<Either<Failure, HomeFeedEntity>> getHomeFeed();

  Future<Either<Failure, WalletSummaryEntity>> getWalletSummary();

  Future<Either<Failure, List<WalletTransactionEntity>>> getWalletTransactions({
    int page = 1,
    int size = 20,
  });

  Future<Either<Failure, WalletDailyBonusResultEntity>> claimDailyBonus();

  Future<Either<Failure, List<LeaderboardContestEntity>>>
  getLeaderboardContests({required String status});

  Future<Either<Failure, LeaderboardPayloadEntity>> getMatchLeaderboard({
    required String matchId,
  });
}
