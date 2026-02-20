import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/core/services/connectivity/network_info.dart';
import 'package:fanup/features/dashboard/data/datasources/dashboard_datasource.dart';
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
    networkInfo: ref.read(networkInfoProvider),
  );
});

class DashboardRepository implements IDashboardRepository {
  final IDashboardRemoteDataSource _dashboardRemoteDataSource;
  final NetworkInfo _networkInfo;

  DashboardRepository({
    required IDashboardRemoteDataSource dashboardRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _dashboardRemoteDataSource = dashboardRemoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, HomeFeedEntity>> getHomeFeed() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final results = await Future.wait([
        _dashboardRemoteDataSource.getCompletedMatches(page: 1, size: 12),
        _dashboardRemoteDataSource.getMyContestEntries(),
      ]);

      final matches = results[0] as List<CompletedMatchApiModel>;
      final entries = results[1] as List<ContestEntryApiModel>;

      final entryMatchIds = entries
          .map((entry) => entry.matchId.toString())
          .toSet();

      final homeMatches = matches
          .map(
            (match) => HomeMatchEntity(
              id: match.id.toString(),
              league: match.league.toString(),
              startTime: match.startTime as DateTime,
              status: match.status.toString(),
              teamAShortName: match.teamAShortName.toString(),
              teamBShortName: match.teamBShortName.toString(),
              hasExistingEntry: entryMatchIds.contains(match.id.toString()),
            ),
          )
          .toList(growable: false);

      return Right(HomeFeedEntity(matches: homeMatches));
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
}
