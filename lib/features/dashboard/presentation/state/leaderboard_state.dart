import 'package:equatable/equatable.dart';
import 'package:fanup/features/dashboard/domain/entities/leaderboard_contest_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/leaderboard_payload_entity.dart';

enum LeaderboardStatus { initial, loading, loaded, error }

class LeaderboardState extends Equatable {
  final LeaderboardStatus status;
  final String selectedStatus;
  final List<LeaderboardContestEntity> contests;
  final String selectedMatchId;
  final LeaderboardPayloadEntity? payload;
  final String? errorMessage;

  const LeaderboardState({
    this.status = LeaderboardStatus.initial,
    this.selectedStatus = 'upcoming',
    this.contests = const [],
    this.selectedMatchId = '',
    this.payload,
    this.errorMessage,
  });

  LeaderboardState copyWith({
    LeaderboardStatus? status,
    String? selectedStatus,
    List<LeaderboardContestEntity>? contests,
    String? selectedMatchId,
    LeaderboardPayloadEntity? payload,
    bool clearPayload = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return LeaderboardState(
      status: status ?? this.status,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      contests: contests ?? this.contests,
      selectedMatchId: selectedMatchId ?? this.selectedMatchId,
      payload: clearPayload ? null : (payload ?? this.payload),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedStatus,
    contests,
    selectedMatchId,
    payload,
    errorMessage,
  ];
}
