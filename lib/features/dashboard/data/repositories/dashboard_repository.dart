import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/core/services/connectivity/network_info.dart';
import 'package:fanup/features/dashboard/data/datasources/dashboard_datasource.dart';
import 'package:fanup/features/dashboard/data/datasources/local/dashboard_local_datasource.dart';
import 'package:fanup/features/dashboard/data/models/completed_match_api_model.dart';
import 'package:fanup/features/dashboard/data/models/contest_entry_api_model.dart';
import 'package:fanup/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:fanup/features/dashboard/domain/entities/home_feed_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/home_match_entity.dart';
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
}
