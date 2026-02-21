import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fanup/core/error/failures.dart';
import 'package:fanup/core/services/connectivity/network_info.dart';
import 'package:fanup/features/create_team/data/datasources/create_team_datasource.dart';
import 'package:fanup/features/create_team/data/datasources/create_team_remote_datasource.dart';
import 'package:fanup/features/create_team/domain/entities/contest_entry_entity.dart';
import 'package:fanup/features/create_team/domain/entities/player_entity.dart';
import 'package:fanup/features/create_team/domain/repositories/create_team_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createTeamRepositoryProvider = Provider<ICreateTeamRepository>((ref) {
  return CreateTeamRepository(
    remoteDatasource: ref.read(createTeamRemoteDatasourceProvider),
    networkInfo: ref.read(networkInfoProvider),
  );
});

class CreateTeamRepository implements ICreateTeamRepository {
  final ICreateTeamRemoteDatasource _remoteDatasource;
  final NetworkInfo _networkInfo;

  CreateTeamRepository({
    required ICreateTeamRemoteDatasource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDatasource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<PlayerEntity>>> getPlayers({
    required String teamA,
    required String teamB,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final models = await _remoteDatasource.getPlayers(
        teamA: teamA,
        teamB: teamB,
      );
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message']?.toString() ??
              e.message ??
              'Failed to load players',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ExistingContestEntryEntity?>> getMyEntryForMatch(
    String matchId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final model = await _remoteDatasource.getMyEntryForMatch(matchId);
      return Right(model?.toExistingEntryEntity());
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message']?.toString() ??
              e.message ??
              'Failed to load existing entry',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> submitContestEntry(
    ContestEntryEntity entry,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final success = await _remoteDatasource.submitContestEntry(entry);
      return Right(success);
    } on DioException catch (e) {
      return Left(
        ApiFailure(
          message:
              e.response?.data['message']?.toString() ??
              e.message ??
              'Failed to submit contest entry',
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
