import 'package:fanup/features/create_team/domain/entities/contest_entry_entity.dart';
import 'package:fanup/features/create_team/domain/entities/player_entity.dart';
import 'package:fanup/features/create_team/domain/usecases/get_match_players_usecase.dart';
import 'package:fanup/features/create_team/domain/usecases/get_my_entry_for_match_usecase.dart';
import 'package:fanup/features/create_team/domain/usecases/submit_contest_entry_usecase.dart';
import 'package:fanup/features/create_team/domain/utils/team_validator.dart';
import 'package:fanup/features/create_team/presentation/state/create_team_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final createTeamViewModelProvider =
    NotifierProvider<CreateTeamViewModel, CreateTeamState>(
      CreateTeamViewModel.new,
    );

class CreateTeamViewModel extends Notifier<CreateTeamState> {
  late final GetMatchPlayersUsecase _getMatchPlayersUsecase;
  late final GetMyEntryForMatchUsecase _getMyEntryForMatchUsecase;
  late final SubmitContestEntryUsecase _submitContestEntryUsecase;
  String? _activeMatchId;

  @override
  CreateTeamState build() {
    _getMatchPlayersUsecase = ref.read(getMatchPlayersUsecaseProvider);
    _getMyEntryForMatchUsecase = ref.read(getMyEntryForMatchUsecaseProvider);
    _submitContestEntryUsecase = ref.read(submitContestEntryUsecaseProvider);
    return const CreateTeamState();
  }

  Future<void> initialize({
    required String matchId,
    required String teamA,
    required String teamB,
  }) async {
    if (_activeMatchId == matchId && state.players.isNotEmpty) {
      return;
    }

    _activeMatchId = matchId;
    state = state.copyWith(
      status: CreateTeamStatus.loading,
      clearInfoMessage: true,
      clearErrorMessage: true,
      selectedPlayerIds: const [],
      teamName: '',
      captainId: '',
      viceCaptainId: '',
      isCaptainStep: false,
      clearTeamId: true,
    );

    final playersResult = await _getMatchPlayersUsecase(
      GetMatchPlayersParams(teamA: teamA, teamB: teamB),
    );

    await playersResult.fold(
      (failure) async {
        state = state.copyWith(
          status: CreateTeamStatus.error,
          errorMessage: failure.message,
        );
      },
      (players) async {
        state = state.copyWith(
          status: CreateTeamStatus.loaded,
          players: players,
          clearErrorMessage: true,
        );

        final entryResult = await _getMyEntryForMatchUsecase(
          GetMyEntryForMatchParams(matchId: matchId),
        );

        entryResult.fold(
          (failure) {
            state = state.copyWith(infoMessage: failure.message);
          },
          (entry) {
            if (entry == null) {
              return;
            }

            state = state.copyWith(
              teamId: entry.teamId,
              teamName: entry.teamName,
              selectedPlayerIds: entry.playerIds,
              captainId: entry.captainId,
              viceCaptainId: entry.viceCaptainId,
              infoMessage: 'Existing team loaded for editing',
            );
          },
        );
      },
    );
  }

  void setActiveRole(TeamRole? role) {
    state = state.copyWith(activeRole: role, clearInfoMessage: true);
  }

  void setTeamName(String value) {
    state = state.copyWith(teamName: value, clearErrorMessage: true);
  }

  void togglePlayer(PlayerEntity player) {
    final selectedPlayers = state.selectedPlayers;
    final alreadySelected = state.selectedPlayerIds.contains(player.id);

    if (alreadySelected) {
      final nextIds = state.selectedPlayerIds
          .where((id) => id != player.id)
          .toList();
      state = state.copyWith(
        selectedPlayerIds: nextIds,
        captainId: state.captainId == player.id ? '' : state.captainId,
        viceCaptainId: state.viceCaptainId == player.id
            ? ''
            : state.viceCaptainId,
        clearInfoMessage: true,
        clearErrorMessage: true,
      );
      return;
    }

    final addValidation = TeamValidator.validateAddPlayer(
      currentPlayers: selectedPlayers,
      player: player,
    );

    if (addValidation != null) {
      state = state.copyWith(infoMessage: addValidation);
      return;
    }

    state = state.copyWith(
      selectedPlayerIds: [...state.selectedPlayerIds, player.id],
      clearInfoMessage: true,
      clearErrorMessage: true,
    );
  }

  bool canContinueToCaptainStep() {
    final validation = TeamValidator.validateSubmission(
      selectedPlayers: state.selectedPlayers,
      teamName: state.teamName,
      captainId: 'temp-captain',
      viceCaptainId: 'temp-vice',
    );

    if (!validation.isValid) {
      state = state.copyWith(infoMessage: validation.message);
      return false;
    }

    state = state.copyWith(isCaptainStep: true, clearInfoMessage: true);
    return true;
  }

  void backToPlayerSelection() {
    state = state.copyWith(isCaptainStep: false, clearInfoMessage: true);
  }

  void setCaptain(String playerId) {
    state = state.copyWith(captainId: playerId, clearErrorMessage: true);
  }

  void setViceCaptain(String playerId) {
    state = state.copyWith(viceCaptainId: playerId, clearErrorMessage: true);
  }

  Future<bool> submitEntry({required String matchId}) async {
    final validation = TeamValidator.validateSubmission(
      selectedPlayers: state.selectedPlayers,
      teamName: state.teamName,
      captainId: state.captainId,
      viceCaptainId: state.viceCaptainId,
    );

    if (!validation.isValid) {
      state = state.copyWith(errorMessage: validation.message);
      return false;
    }

    state = state.copyWith(
      status: CreateTeamStatus.submitting,
      clearErrorMessage: true,
    );

    final payload = ContestEntryEntity(
      matchId: matchId,
      teamId: state.teamId ?? const Uuid().v4(),
      teamName: state.teamName.trim(),
      captainId: state.captainId,
      viceCaptainId: state.viceCaptainId,
      playerIds: state.selectedPlayerIds,
    );

    final result = await _submitContestEntryUsecase(payload);

    return result.fold(
      (failure) {
        state = state.copyWith(
          status: CreateTeamStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(
          status: CreateTeamStatus.success,
          infoMessage: 'Contest entry submitted successfully',
        );
        return true;
      },
    );
  }
}
