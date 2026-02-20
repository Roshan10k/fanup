import 'package:fanup/features/dashboard/data/models/completed_match_api_model.dart';
import 'package:fanup/features/dashboard/data/models/contest_entry_api_model.dart';

abstract interface class IDashboardRemoteDataSource {
  Future<List<CompletedMatchApiModel>> getCompletedMatches({
    int page = 1,
    int size = 12,
  });

  Future<List<ContestEntryApiModel>> getMyContestEntries();
}
