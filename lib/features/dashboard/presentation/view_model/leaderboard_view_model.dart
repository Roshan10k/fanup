import 'package:fanup/features/dashboard/domain/usecases/get_leaderboard_contests_usecase.dart';
import 'package:fanup/features/dashboard/domain/usecases/get_match_leaderboard_usecase.dart';
import 'package:fanup/features/dashboard/presentation/state/leaderboard_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final leaderboardViewModelProvider =
    NotifierProvider<LeaderboardViewModel, LeaderboardState>(
      LeaderboardViewModel.new,
    );

class LeaderboardViewModel extends Notifier<LeaderboardState> {
  late final GetLeaderboardContestsUsecase _getLeaderboardContestsUsecase;
  late final GetMatchLeaderboardUsecase _getMatchLeaderboardUsecase;

  @override
  LeaderboardState build() {
    _getLeaderboardContestsUsecase = ref.read(
      getLeaderboardContestsUsecaseProvider,
    );
    _getMatchLeaderboardUsecase = ref.read(getMatchLeaderboardUsecaseProvider);
    return const LeaderboardState();
  }

  Future<void> initialize() async {
    await loadContests(status: state.selectedStatus);
  }

  Future<void> loadContests({required String status}) async {
    state = state.copyWith(
      status: LeaderboardStatus.loading,
      selectedStatus: status,
      clearErrorMessage: true,
      clearPayload: true,
    );

    final contestsResult = await _getLeaderboardContestsUsecase(
      GetLeaderboardContestsParams(status: status),
    );

    await contestsResult.fold(
      (failure) async {
        state = state.copyWith(
          status: LeaderboardStatus.error,
          contests: const [],
          selectedMatchId: '',
          errorMessage: failure.message,
        );
      },
      (contests) async {
        final selectedMatchId = contests.isEmpty ? '' : contests.first.id;
        state = state.copyWith(
          contests: contests,
          selectedMatchId: selectedMatchId,
          clearErrorMessage: true,
        );

        if (selectedMatchId.isEmpty) {
          state = state.copyWith(
            status: LeaderboardStatus.loaded,
            clearPayload: true,
          );
          return;
        }

        await loadMatchLeaderboard(matchId: selectedMatchId);
      },
    );
  }

  Future<void> loadMatchLeaderboard({required String matchId}) async {
    if (matchId.isEmpty) {
      state = state.copyWith(
        status: LeaderboardStatus.loaded,
        selectedMatchId: '',
        clearPayload: true,
      );
      return;
    }

    state = state.copyWith(
      status: LeaderboardStatus.loading,
      selectedMatchId: matchId,
      clearErrorMessage: true,
    );

    final payloadResult = await _getMatchLeaderboardUsecase(
      GetMatchLeaderboardParams(matchId: matchId),
    );

    payloadResult.fold(
      (failure) {
        state = state.copyWith(
          status: LeaderboardStatus.error,
          errorMessage: failure.message,
        );
      },
      (payload) {
        state = state.copyWith(
          status: LeaderboardStatus.loaded,
          payload: payload,
          clearErrorMessage: true,
        );
      },
    );
  }
}
