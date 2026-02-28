import 'package:fanup/core/constants/hive_table_constant.dart';
import 'package:fanup/features/dashboard/data/models/contest_entry_api_model.dart';
import 'package:fanup/features/dashboard/data/models/home_match_api_model.dart';
import 'package:hive/hive.dart';

part 'dashboard_home_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.dashboardHomeHiveTypeId)
class DashboardHomeHiveModel extends HiveObject {
  @HiveField(0)
  final DateTime storedAt;

  @HiveField(1)
  final List<Map<String, dynamic>> matchesJson;

  @HiveField(2)
  final List<Map<String, dynamic>> entriesJson;

  DashboardHomeHiveModel({
    required this.storedAt,
    required this.matchesJson,
    required this.entriesJson,
  });

  factory DashboardHomeHiveModel.fromApiModels({
    required List<HomeMatchApiModel> matches,
    required List<ContestEntryApiModel> entries,
  }) {
    return DashboardHomeHiveModel(
      storedAt: DateTime.now(),
      matchesJson: matches.map((item) => item.toJson()).toList(growable: false),
      entriesJson: entries.map((item) => item.toJson()).toList(growable: false),
    );
  }

  List<HomeMatchApiModel> toHomeMatches() {
    return matchesJson
        .map(
          (item) => HomeMatchApiModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList(growable: false);
  }

  List<ContestEntryApiModel> toContestEntries() {
    return entriesJson
        .map(
          (item) =>
              ContestEntryApiModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList(growable: false);
  }
}
