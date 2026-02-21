import 'package:fanup/core/services/hive/hive_service.dart';
import 'package:fanup/features/dashboard/data/datasources/dashboard_datasource.dart';
import 'package:fanup/features/dashboard/data/models/completed_match_api_model.dart';
import 'package:fanup/features/dashboard/data/models/contest_entry_api_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardLocalDataSourceProvider = Provider<IDashboardLocalDataSource>((
  ref,
) {
  return DashboardLocalDataSource(hiveService: ref.read(hiveServiceProvider));
});

class DashboardLocalDataSource implements IDashboardLocalDataSource {
  static const _homeDataCacheKey = 'dashboard_home_data_cache_v1';
  final HiveService _hiveService;

  DashboardLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<void> cacheHomeData({
    required List<CompletedMatchApiModel> matches,
    required List<ContestEntryApiModel> entries,
  }) async {
    final payload = <String, dynamic>{
      'cachedAt': DateTime.now().toIso8601String(),
      'matches': matches.map((e) => e.toJson()).toList(growable: false),
      'entries': entries.map((e) => e.toJson()).toList(growable: false),
    };

    await _hiveService.putAppData(_homeDataCacheKey, payload);
  }

  @override
  Future<DashboardCachedHomeData?> getCachedHomeData() async {
    try {
      final raw = _hiveService.getAppData<dynamic>(_homeDataCacheKey);
      if (raw is! Map) {
        return null;
      }

      final map = Map<String, dynamic>.from(raw);
      final cachedAtRaw = map['cachedAt']?.toString() ?? '';
      final cachedAt =
          DateTime.tryParse(cachedAtRaw) ??
          DateTime.fromMillisecondsSinceEpoch(0);

      final rawMatches = (map['matches'] as List?) ?? const [];
      final rawEntries = (map['entries'] as List?) ?? const [];

      final matches = rawMatches
          .whereType<Map>()
          .map(
            (item) => CompletedMatchApiModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(growable: false);

      final entries = rawEntries
          .whereType<Map>()
          .map(
            (item) =>
                ContestEntryApiModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false);

      return DashboardCachedHomeData(
        matches: matches,
        entries: entries,
        cachedAt: cachedAt,
      );
    } catch (e) {
      debugPrint('Dashboard cache read error: $e');
      return null;
    }
  }
}
