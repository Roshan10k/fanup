import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/core/services/connectivity/network_info.dart';
import 'package:fanup/features/dashboard/data/datasources/dashboard_datasource.dart';
import 'package:fanup/features/dashboard/data/datasources/local/dashboard_local_datasource.dart';
import 'package:fanup/features/dashboard/data/models/completed_match_api_model.dart';
import 'package:fanup/features/dashboard/data/models/contest_entry_api_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_daily_bonus_result_api_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_summary_api_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_transaction_api_model.dart';
import 'package:fanup/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:fanup/features/dashboard/domain/entities/home_feed_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/home_match_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/wallet_daily_bonus_result_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/wallet_summary_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/wallet_transaction_entity.dart';
import 'package:fanup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardRepositoryProvider = Provider<IDashboardRepository>((ref) {
  return DashboardRepository(
    dashboardRemoteDataSource: ref.read(dashboardRemoteDataSourceProvider),
    dashboardLocalDataSource: ref.read(dashboardLocalDataSourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class DashboardRepository implements IDashboardRepository {
  static const _homeFeedCacheTtl = Duration(minutes: 5);
  final IDashboardRemoteDataSource _dashboardRemoteDataSource;
  final IDashboardLocalDataSource _dashboardLocalDataSource;
  final NetworkInfo _networkInfo;

  DashboardRepository({
    required IDashboardRemoteDataSource dashboardRemoteDataSource,
    required IDashboardLocalDataSource dashboardLocalDataSource,
    required NetworkInfo networkInfo,
  }) : _dashboardRemoteDataSource = dashboardRemoteDataSource,
       _dashboardLocalDataSource = dashboardLocalDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, HomeFeedEntity>> getHomeFeed() async {
    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      final cached = await _dashboardLocalDataSource.getCachedHomeData();
      if (_isFreshCache(cached)) {
        return Right(_buildHomeFeed(cached!.matches, cached.entries));
      }
      return const Left(
        NetworkFailure(message: 'No internet connection and no fresh cache'),
      );
    }

    try {
      final results = await Future.wait([
        _dashboardRemoteDataSource.getCompletedMatches(page: 1, size: 12),
        _dashboardRemoteDataSource.getMyContestEntries(),
      ]);

      final matches = results[0] as List<CompletedMatchApiModel>;
      final entries = results[1] as List<ContestEntryApiModel>;
      await _dashboardLocalDataSource.cacheHomeData(
        matches: matches,
        entries: entries,
      );
      return Right(_buildHomeFeed(matches, entries));
    } on DioException catch (e) {
      final cached = await _dashboardLocalDataSource.getCachedHomeData();
      if (_isFreshCache(cached)) {
        return Right(_buildHomeFeed(cached!.matches, cached.entries));
      }
      return Left(
        ApiFailure(
          message:
              e.response?.data['message']?.toString() ??
              e.message ??
              'Failed to load home data',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      final cached = await _dashboardLocalDataSource.getCachedHomeData();
      if (_isFreshCache(cached)) {
        return Right(_buildHomeFeed(cached!.matches, cached.entries));
      }
      return Left(ApiFailure(message: e.toString()));
    }
  }

  bool _isFreshCache(DashboardCachedHomeData? cached) {
    if (cached == null) {
      return false;
    }
    final age = DateTime.now().difference(cached.cachedAt);
    return age <= _homeFeedCacheTtl;
  }

  HomeFeedEntity _buildHomeFeed(
    List<CompletedMatchApiModel> matches,
    List<ContestEntryApiModel> entries,
  ) {
    final entryMatchIds = entries.map((entry) => entry.matchId).toSet();

    final homeMatches = matches
        .map(
          (match) => HomeMatchEntity(
            id: match.id,
            league: match.league,
            startTime: match.startTime,
            status: match.status,
            teamAShortName: match.teamAShortName,
            teamBShortName: match.teamBShortName,
            hasExistingEntry: entryMatchIds.contains(match.id),
          ),
        )
        .toList(growable: false);

    return HomeFeedEntity(matches: homeMatches);
  }

  @override
  Future<Either<Failure, WalletSummaryEntity>> getWalletSummary() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final summary = await _dashboardRemoteDataSource.getWalletSummary();
      return Right(_mapWalletSummary(summary));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message']?.toString() ??
              e.message ??
              'Failed to load wallet summary',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WalletTransactionEntity>>> getWalletTransactions({
    int page = 1,
    int size = 20,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final transactions = await _dashboardRemoteDataSource
          .getWalletTransactions(page: page, size: size);
      return Right(
        transactions.map(_mapWalletTransaction).toList(growable: false),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message']?.toString() ??
              e.message ??
              'Failed to load wallet transactions',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WalletDailyBonusResultEntity>>
  claimDailyBonus() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _dashboardRemoteDataSource.claimDailyBonus();
      return Right(_mapWalletDailyBonusResult(result));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message']?.toString() ??
              e.message ??
              'Failed to claim daily bonus',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  WalletSummaryEntity _mapWalletSummary(WalletSummaryApiModel model) {
    return WalletSummaryEntity(
      balance: model.balance,
      totalCredit: model.totalCredit,
      totalDebit: model.totalDebit,
      transactionCount: model.transactionCount,
      lastTransactionAt: model.lastTransactionAt,
    );
  }

  WalletTransactionEntity _mapWalletTransaction(
    WalletTransactionApiModel model,
  ) {
    return WalletTransactionEntity(
      id: model.id,
      title: model.title,
      amount: model.amount,
      type: model.type == 'debit'
          ? WalletTransactionType.debit
          : WalletTransactionType.credit,
      source: model.source,
      createdAt: model.createdAt,
    );
  }

  WalletDailyBonusResultEntity _mapWalletDailyBonusResult(
    WalletDailyBonusResultApiModel model,
  ) {
    return WalletDailyBonusResultEntity(
      created: model.created,
      amount: model.amount,
      message: model.message,
      summary: _mapWalletSummary(model.summary),
    );
  }
}
