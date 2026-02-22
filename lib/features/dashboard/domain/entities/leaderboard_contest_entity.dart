import 'package:equatable/equatable.dart';

class LeaderboardContestEntity extends Equatable {
  final String id;
  final String matchLabel;
  final DateTime startsAt;
  final String status;
  final int entryFee;
  final int participantsCount;
  final int prizePool;

  const LeaderboardContestEntity({
    required this.id,
    required this.matchLabel,
    required this.startsAt,
    required this.status,
    required this.entryFee,
    required this.participantsCount,
    required this.prizePool,
  });

  @override
  List<Object?> get props => [
    id,
    matchLabel,
    startsAt,
    status,
    entryFee,
    participantsCount,
    prizePool,
  ];
}
