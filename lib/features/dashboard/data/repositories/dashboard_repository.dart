import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/core/services/connectivity/network_info.dart';
import 'package:fanup/features/dashboard/data/datasources/dashboard_datasource.dart';
import 'package:fanup/features/dashboard/data/datasources/local/dashboard_local_datasource.dart';
import 'package:fanup/features/dashboard/data/models/contest_entry_api_model.dart';
import 'package:fanup/features/dashboard/data/models/home_match_api_model.dart';
import 'package:fanup/features/dashboard/data/models/leaderboard_contest_api_model.dart';
import 'package:fanup/features/dashboard/data/models/leaderboard_payload_api_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_daily_bonus_result_api_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_summary_api_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_transaction_api_model.dart';
import 'package:fanup/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:fanup/features/dashboard/domain/entities/contest_entry_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/home_feed_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/leaderboard_contest_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/leaderboard_payload_entity.dart';
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
  final IDashboardRemoteDataSource _dashboardRemoteDataSource;
  final NetworkInfo _networkInfo;

  DashboardRepository({
    required IDashboardRemoteDataSource dashboardRemoteDataSource,
    required IDashboardLocalDataSource dashboardLocalDataSource,
    required NetworkInfo networkInfo,
  }) : _dashboardRemoteDataSource = dashboardRemoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, HomeFeedEntity>> getHomeFeed() async {
    final isConnected = await _networkInfo.isConnected;

    if (!isConnected) {
      return const Left(
        NetworkFailure(message: 'No internet connection'),
      );
    }

    try {
      final results = await Future.wait([
        _dashboardRemoteDataSource.getUpcomingMatches(page: 1, size: 12),
        _dashboardRemoteDataSource.getMyContestEntries(),
      ]);

      final matches = results[0] as List<HomeMatchApiModel>;
      final entries = results[1] as List<ContestEntryApiModel>;
      // TODO: Implement cache for HomeMatchApiModel
      return Right(_buildHomeFeed(matches, entries));
    } on DioException catch (e) {
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
      return Left(ApiFailure(message: e.toString()));
    }
  }

  HomeFeedEntity _buildHomeFeed(
    List<HomeMatchApiModel> matches,
    List<ContestEntryApiModel> entries,
  ) {
    final entryMatchIds = entries.map((entry) => entry.matchId).toSet();

    final homeMatches = matches
        .map(
          (match) => match.toEntity(
            hasExistingEntry: entryMatchIds.contains(match.id),
          ),
        )
        .toList(growable: false);

    final mappedEntries = entries
        .map(_mapContestEntry)
        .toList(growable: false);

    return HomeFeedEntity(matches: homeMatches, entries: mappedEntries);
  }

  ContestEntryEntity _mapContestEntry(ContestEntryApiModel model) {
    return ContestEntryEntity(
      matchId: model.matchId,
      entryId: model.entryId,
      teamId: model.teamId,
      teamName: model.teamName,
      captainId: model.captainId,
      viceCaptainId: model.viceCaptainId,
      playerIds: model.playerIds,
      points: model.points,
      updatedAt: model.updatedAt,
      match: model.match != null
          ? ContestEntryMatchEntity(
              id: model.match!.id,
              league: model.match!.league,
              startTime: model.match!.startTime,
              status: model.match!.status,
              teamAShortName: model.match!.teamA?.shortName ?? '',
              teamBShortName: model.match!.teamB?.shortName ?? '',
            )
          : null,
    );
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

  @override
  Future<Either<Failure, List<LeaderboardContestEntity>>>
  getLeaderboardContests({required String status}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final contests = await _dashboardRemoteDataSource.getLeaderboardContests(
        status: status,
      );
      return Right(
        contests.map(_mapLeaderboardContest).toList(growable: false),
      );
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message']?.toString() ??
              e.message ??
              'Failed to load leaderboard contests',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LeaderboardPayloadEntity>> getMatchLeaderboard({
    required String matchId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final payload = await _dashboardRemoteDataSource.getMatchLeaderboard(
        matchId: matchId,
      );
      return Right(_mapLeaderboardPayload(payload));
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message']?.toString() ??
              e.message ??
              'Failed to load leaderboard',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  LeaderboardContestEntity _mapLeaderboardContest(
    LeaderboardContestApiModel model,
  ) {
    return LeaderboardContestEntity(
      id: model.id,
      matchLabel: model.matchLabel,
      startsAt: model.startsAt,
      status: model.status,
      entryFee: model.entryFee,
      participantsCount: model.participantsCount,
      prizePool: model.prizePool,
    );
  }

  LeaderboardPayloadEntity _mapLeaderboardPayload(
    LeaderboardPayloadApiModel model,
  ) {
    LeaderboardLeaderEntity mapLeader(LeaderboardLeaderApiModel leader) {
      return LeaderboardLeaderEntity(
        userId: leader.userId,
        rank: leader.rank,
        name: leader.name,
        teams: leader.teams,
        pts: leader.pts,
        winRate: leader.winRate,
        prize: leader.prize,
      );
    }

    return LeaderboardPayloadEntity(
      match: LeaderboardMatchMetaEntity(
        id: model.match.id,
        matchLabel: model.match.matchLabel,
        startsAt: model.match.startsAt,
        status: model.match.status,
      ),
      leaders: model.leaders.map(mapLeader).toList(growable: false),
      myEntry: model.myEntry == null ? null : mapLeader(model.myEntry!),
    );
  }
}
