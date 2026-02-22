class LeaderboardContestApiModel {
  final String id;
  final String matchLabel;
  final DateTime startsAt;
  final String status;
  final int entryFee;
  final int participantsCount;
  final int prizePool;

  const LeaderboardContestApiModel({
    required this.id,
    required this.matchLabel,
    required this.startsAt,
    required this.status,
    required this.entryFee,
    required this.participantsCount,
    required this.prizePool,
  });

  factory LeaderboardContestApiModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardContestApiModel(
      id: json['id']?.toString() ?? '',
      matchLabel: json['matchLabel']?.toString() ?? '',
      startsAt:
          DateTime.tryParse(json['startsAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      status: json['status']?.toString() ?? 'completed',
      entryFee: _asInt(json['entryFee']),
      participantsCount: _asInt(json['participantsCount']),
      prizePool: _asInt(json['prizePool']),
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
