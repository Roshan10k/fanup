import 'package:dio/dio.dart';
import 'package:fanup/core/api/api_client.dart';
import 'package:fanup/core/api/api_endpoints.dart';
import 'package:fanup/features/dashboard/data/datasources/dashboard_datasource.dart';
import 'package:fanup/features/dashboard/data/models/completed_match_api_model.dart';
import 'package:fanup/features/dashboard/data/models/contest_entry_api_model.dart';
import 'package:fanup/features/dashboard/data/models/home_match_api_model.dart';
import 'package:fanup/features/dashboard/data/models/leaderboard_contest_api_model.dart';
import 'package:fanup/features/dashboard/data/models/leaderboard_payload_api_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_daily_bonus_result_api_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_summary_api_model.dart';
import 'package:fanup/features/dashboard/data/models/wallet_transaction_api_model.dart';
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
  Future<List<HomeMatchApiModel>> getUpcomingMatches({
    int page = 1,
    int size = 12,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.matches,
      queryParameters: {'page': page, 'size': size, 'status': 'upcoming'},
    );

    if (response.data['success'] != true) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message:
            response.data['message']?.toString() ??
            'Failed to load upcoming matches',
      );
    }

    final rows = (response.data['data'] as List?) ?? <dynamic>[];
    return rows
        .map(
          (item) => HomeMatchApiModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

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

  @override
  Future<WalletSummaryApiModel> getWalletSummary() async {
    final response = await _apiClient.get(ApiEndpoints.walletSummary);

    if (response.data['success'] != true) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message:
            response.data['message']?.toString() ??
            'Failed to load wallet summary',
      );
    }

    final data = Map<String, dynamic>.from(
      (response.data['data'] as Map?) ?? const <String, dynamic>{},
    );

    return WalletSummaryApiModel.fromJson(data);
  }

  @override
  Future<List<WalletTransactionApiModel>> getWalletTransactions({
    int page = 1,
    int size = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.walletTransactions,
      queryParameters: {'page': page, 'size': size},
    );

    if (response.data['success'] != true) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message:
            response.data['message']?.toString() ??
            'Failed to load wallet transactions',
      );
    }

    final rows = (response.data['data'] as List?) ?? <dynamic>[];
    return rows
        .map(
          (item) => WalletTransactionApiModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<WalletDailyBonusResultApiModel> claimDailyBonus() async {
    final response = await _apiClient.post(
      ApiEndpoints.walletDailyBonus,
      data: const <String, dynamic>{},
    );

    if (response.data['success'] != true) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message:
            response.data['message']?.toString() ??
            'Failed to claim daily bonus',
      );
    }

    final data = Map<String, dynamic>.from(
      (response.data['data'] as Map?) ?? const <String, dynamic>{},
    );
    final summaryMap = Map<String, dynamic>.from(
      (data['summary'] as Map?) ?? const <String, dynamic>{},
    );

    return WalletDailyBonusResultApiModel(
      created: data['created'] == true,
      amount: _asInt(data['amount']),
      message: response.data['message']?.toString() ?? 'Daily bonus processed',
      summary: WalletSummaryApiModel.fromJson(summaryMap),
    );
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  @override
  Future<List<LeaderboardContestApiModel>> getLeaderboardContests({
    required String status,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.leaderboardContests,
      queryParameters: {'status': status},
    );

    if (response.data['success'] != true) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message:
            response.data['message']?.toString() ??
            'Failed to load leaderboard contests',
      );
    }

    final rows = (response.data['data'] as List?) ?? const <dynamic>[];
    return rows
        .map(
          (item) => LeaderboardContestApiModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<LeaderboardPayloadApiModel> getMatchLeaderboard({
    required String matchId,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.leaderboardContestByMatch(matchId),
    );

    if (response.data['success'] != true) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message:
            response.data['message']?.toString() ??
            'Failed to load match leaderboard',
      );
    }

    final data = Map<String, dynamic>.from(
      (response.data['data'] as Map?) ?? const <String, dynamic>{},
    );
    return LeaderboardPayloadApiModel.fromJson(data);
  }
}
