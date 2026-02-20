import 'package:dio/dio.dart';
import 'package:fanup/core/api/api_client.dart';
import 'package:fanup/core/api/api_endpoints.dart';
import 'package:fanup/features/dashboard/data/datasources/dashboard_datasource.dart';
import 'package:fanup/features/dashboard/data/models/completed_match_api_model.dart';
import 'package:fanup/features/dashboard/data/models/contest_entry_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardRemoteDataSourceProvider = Provider<IDashboardRemoteDataSource>((
  ref,
) {
  return DashboardRemoteDataSource(apiClient: ref.read(apiClientProvider));
});

class DashboardRemoteDataSource implements IDashboardRemoteDataSource {
  final ApiClient _apiClient;

  DashboardRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<CompletedMatchApiModel>> getCompletedMatches({
    int page = 1,
    int size = 12,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.completedMatches,
      queryParameters: {'page': page, 'size': size},
    );

    if (response.data['success'] != true) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message:
            response.data['message']?.toString() ??
            'Failed to load completed matches',
      );
    }

    final rows = (response.data['data'] as List?) ?? <dynamic>[];
    return rows
        .map(
          (item) => CompletedMatchApiModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  @override
  Future<List<ContestEntryApiModel>> getMyContestEntries() async {
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
    return rows
        .map(
          (item) => ContestEntryApiModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
}
