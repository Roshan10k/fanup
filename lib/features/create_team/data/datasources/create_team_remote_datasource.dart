import 'package:dio/dio.dart';
import 'package:fanup/core/api/api_client.dart';
import 'package:fanup/core/api/api_endpoints.dart';
import 'package:fanup/features/create_team/data/datasources/create_team_datasource.dart';
import 'package:fanup/features/create_team/data/models/contest_entry_api_model.dart';
import 'package:fanup/features/create_team/data/models/player_api_model.dart';
import 'package:fanup/features/create_team/domain/entities/contest_entry_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createTeamRemoteDatasourceProvider =
    Provider<ICreateTeamRemoteDatasource>((ref) {
      return CreateTeamRemoteDatasource(apiClient: ref.read(apiClientProvider));
    });

class CreateTeamRemoteDatasource implements ICreateTeamRemoteDatasource {
  final ApiClient _apiClient;

  CreateTeamRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<PlayerApiModel>> getPlayers({
    required String teamA,
    required String teamB,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.players,
      queryParameters: {'teamShortNames': '$teamA,$teamB'},
    );

    if (response.data['success'] != true) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message:
            response.data['message']?.toString() ?? 'Failed to load players',
      );
    }

    final rows = (response.data['data'] as List?) ?? <dynamic>[];
    return rows
        .map(
          (item) =>
              PlayerApiModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  @override
  Future<ContestEntryApiModel?> getMyEntryForMatch(String matchId) async {
    final response = await _apiClient.get(ApiEndpoints.myContestEntries);

    if (response.data['success'] != true) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message:
            response.data['message']?.toString() ??
            'Failed to load contest entries',
      );
    }

    final rows = (response.data['data'] as List?) ?? <dynamic>[];
    for (final item in rows) {
      final row = ContestEntryApiModel.fromJson(
        Map<String, dynamic>.from(item as Map),
      );
      if (row.matchId == matchId) {
        return row;
      }
    }

    return null;
  }

  @override
  Future<bool> submitContestEntry(ContestEntryEntity entry) async {
    final response = await _apiClient.post(
      ApiEndpoints.submitContestEntry(entry.matchId),
      data: {
        'teamId': entry.teamId,
        'teamName': entry.teamName,
        'captainId': entry.captainId,
        'viceCaptainId': entry.viceCaptainId,
        'playerIds': entry.playerIds,
      },
    );

    if (response.data['success'] != true) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message:
            response.data['message']?.toString() ??
            'Failed to submit contest entry',
      );
    }

    return true;
  }
}
