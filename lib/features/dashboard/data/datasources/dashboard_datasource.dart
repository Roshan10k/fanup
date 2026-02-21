import 'package:fanup/features/dashboard/data/models/completed_match_api_model.dart';
import 'package:fanup/features/dashboard/data/models/contest_entry_api_model.dart';

abstract interface class IDashboardRemoteDataSource {
  Future<List<CompletedMatchApiModel>> getCompletedMatches({
    int page = 1,
    int size = 12,
  });

  Future<List<ContestEntryApiModel>> getMyContestEntries();
}

class DashboardCachedHomeData {
  final List<CompletedMatchApiModel> matches;
  final List<ContestEntryApiModel> entries;
  final DateTime cachedAt;

  const DashboardCachedHomeData({
    required this.matches,
    required this.entries,
    required this.cachedAt,
  });
}

abstract interface class IDashboardLocalDataSource {
  Future<void> cacheHomeData({
    required List<CompletedMatchApiModel> matches,
    required List<ContestEntryApiModel> entries,
  });

  Future<DashboardCachedHomeData?> getCachedHomeData();
}
