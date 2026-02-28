import 'package:equatable/equatable.dart';
import 'package:fanup/features/create_team/domain/entities/player_entity.dart';
import 'package:fanup/features/create_team/domain/utils/team_validator.dart';

enum CreateTeamStatus { initial, loading, loaded, submitting, success, error }

class CreateTeamState extends Equatable {
  final CreateTeamStatus status;
  final List<PlayerEntity> players;
  final List<String> selectedPlayerIds;
  final TeamRole? activeRole;
  final String teamName;
  final String captainId;
  final String viceCaptainId;
  final String? teamId;
  final bool isCaptainStep;
  final bool isPreviewStep;
  final String? infoMessage;
  final String? errorMessage;

  const CreateTeamState({
    this.status = CreateTeamStatus.initial,
    this.players = const [],
    this.selectedPlayerIds = const [],
    this.activeRole,
    this.teamName = '',
    this.captainId = '',
    this.viceCaptainId = '',
    this.teamId,
    this.isCaptainStep = false,
    this.isPreviewStep = false,
    this.infoMessage,
    this.errorMessage,
  });

  List<PlayerEntity> get selectedPlayers =>
      players.where((p) => selectedPlayerIds.contains(p.id)).toList();

  List<PlayerEntity> get visiblePlayers {
    if (activeRole == null) {
      return players;
    }
    return players.where((p) => p.role == activeRole).toList();
  }

  TeamValidatorResult get validationPreview => TeamValidator.validateSubmission(
    selectedPlayers: selectedPlayers,
    teamName: teamName,
    captainId: captainId,
    viceCaptainId: viceCaptainId,
  );

  CreateTeamState copyWith({
    CreateTeamStatus? status,
    List<PlayerEntity>? players,
    List<String>? selectedPlayerIds,
    TeamRole? activeRole,
    bool clearActiveRole = false,
    String? teamName,
    String? captainId,
    String? viceCaptainId,
    String? teamId,
    bool clearTeamId = false,
    bool? isCaptainStep,
    bool? isPreviewStep,
    String? infoMessage,
    bool clearInfoMessage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CreateTeamState(
      status: status ?? this.status,
      players: players ?? this.players,
      selectedPlayerIds: selectedPlayerIds ?? this.selectedPlayerIds,
      activeRole: clearActiveRole ? null : (activeRole ?? this.activeRole),
      teamName: teamName ?? this.teamName,
      captainId: captainId ?? this.captainId,
      viceCaptainId: viceCaptainId ?? this.viceCaptainId,
      teamId: clearTeamId ? null : (teamId ?? this.teamId),
      isCaptainStep: isCaptainStep ?? this.isCaptainStep,
      isPreviewStep: isPreviewStep ?? this.isPreviewStep,
      infoMessage: clearInfoMessage ? null : (infoMessage ?? this.infoMessage),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    players,
    selectedPlayerIds,
    activeRole,
    teamName,
    captainId,
    viceCaptainId,
    teamId,
    isCaptainStep,
    isPreviewStep,
    infoMessage,
    errorMessage,
  ];
}
