import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/features/create_team/domain/entities/player_entity.dart';
import 'package:fanup/features/create_team/domain/utils/team_validator.dart';
import 'package:fanup/features/create_team/presentation/state/create_team_state.dart';
import 'package:fanup/features/create_team/presentation/view_model/create_team_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CreateTeamPageArgs {
  final String matchId;
  final String league;
  final String teamA;
  final String teamB;
  final DateTime startTime;

  const CreateTeamPageArgs({
    required this.matchId,
    required this.league,
    required this.teamA,
    required this.teamB,
    required this.startTime,
  });
}

class CreateTeamPage extends ConsumerStatefulWidget {
  final CreateTeamPageArgs args;

  const CreateTeamPage({super.key, required this.args});

  @override
  ConsumerState<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends ConsumerState<CreateTeamPage> {
  final _teamNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(createTeamViewModelProvider.notifier)
          .initialize(
            matchId: widget.args.matchId,
            teamA: widget.args.teamA,
            teamB: widget.args.teamB,
          );
      if (!mounted) return;
      final current = ref.read(createTeamViewModelProvider);
      _teamNameController.text = current.teamName;
    });
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createTeamViewModelProvider);
    final selectedPlayers = state.selectedPlayers;
    final roleCounts = TeamValidator.getRoleCounts(selectedPlayers);
    final usedCredits = TeamValidator.getUsedCredits(selectedPlayers);

    ref.listen<CreateTeamState>(createTeamViewModelProvider, (prev, next) {
      if (next.infoMessage != null && next.infoMessage != prev?.infoMessage) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.infoMessage!)));
      }

      if (next.status == CreateTeamStatus.success) {
        Navigator.pop(context, true);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          state.isCaptainStep ? 'Captain & Vice-Captain' : 'Create Team',
          style: AppTextStyles.poppinsSemiBold18.copyWith(
            color: AppColors.textDark,
          ),
        ),
      ),
      body: state.status == CreateTeamStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : state.status == CreateTeamStatus.error && state.players.isEmpty
          ? _buildError(state)
          : state.isCaptainStep
          ? _buildCaptainStep(state)
          : _buildPlayerSelectionStep(state, roleCounts, usedCredits),
    );
  }

  Widget _buildError(CreateTeamState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.errorMessage ?? 'Failed to load team builder',
              textAlign: TextAlign.center,
              style: AppTextStyles.poppinsRegular16,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(createTeamViewModelProvider.notifier)
                    .initialize(
                      matchId: widget.args.matchId,
                      teamA: widget.args.teamA,
                      teamB: widget.args.teamB,
                    );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerSelectionStep(
    CreateTeamState state,
    Map<TeamRole, int> roleCounts,
    double usedCredits,
  ) {
    final creditLeft = TeamValidator.maxCredits - usedCredits;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildMatchHeader(),
              const SizedBox(height: 16),
              TextField(
                controller: _teamNameController,
                onChanged: ref
                    .read(createTeamViewModelProvider.notifier)
                    .setTeamName,
                decoration: const InputDecoration(labelText: 'Team Name'),
              ),
              const SizedBox(height: 12),
              _buildSummaryCard(
                state.selectedPlayerIds.length,
                creditLeft,
                roleCounts,
              ),
              const SizedBox(height: 12),
              _buildRoleTabs(state.activeRole),
              const SizedBox(height: 12),
              ...state.visiblePlayers.map(
                (player) => _buildPlayerTile(state, player),
              ),
            ],
          ),
        ),
        _buildBottomAction(
          child: ElevatedButton(
            onPressed: () {
              ref
                  .read(createTeamViewModelProvider.notifier)
                  .canContinueToCaptainStep();
            },
            child: const Text('Continue'),
          ),
        ),
      ],
    );
  }

  Widget _buildCaptainStep(CreateTeamState state) {
    final selectedPlayers = state.selectedPlayers;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Select Captain', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              ...selectedPlayers.map(
                (player) => RadioListTile<String>(
                  value: player.id,
                  groupValue: state.captainId,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(createTeamViewModelProvider.notifier)
                          .setCaptain(value);
                    }
                  },
                  title: Text(player.fullName),
                  subtitle: Text(
                    '${player.teamShortName} • ${player.role.label}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Select Vice-Captain', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              ...selectedPlayers.map(
                (player) => RadioListTile<String>(
                  value: player.id,
                  groupValue: state.viceCaptainId,
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(createTeamViewModelProvider.notifier)
                          .setViceCaptain(value);
                    }
                  },
                  title: Text(player.fullName),
                  subtitle: Text(
                    '${player.teamShortName} • ${player.role.label}',
                  ),
                ),
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  state.errorMessage!,
                  style: AppTextStyles.poppinsRegular15.copyWith(
                    color: Colors.red,
                  ),
                ),
              ],
            ],
          ),
        ),
        _buildBottomAction(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: ref
                      .read(createTeamViewModelProvider.notifier)
                      .backToPlayerSelection,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: state.status == CreateTeamStatus.submitting
                      ? null
                      : () async {
                          await ref
                              .read(createTeamViewModelProvider.notifier)
                              .submitEntry(matchId: widget.args.matchId);
                        },
                  child: state.status == CreateTeamStatus.submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Submit Team'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    int selectedCount,
    double creditLeft,
    Map<TeamRole, int> roleCounts,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$selectedCount/11 selected', style: AppTextStyles.cardTitle),
          Text(
            'Credit left: ${creditLeft.toStringAsFixed(1)}',
            style: AppTextStyles.cardSubtitle,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: TeamRole.values
                .map(
                  (role) => Chip(
                    label: Text('${role.label}: ${roleCounts[role] ?? 0}'),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchHeader() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientYellow, AppColors.gradientOrange],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.args.league, style: AppTextStyles.poppinsSemiBold15),
          const SizedBox(height: 6),
          Text(
            '${widget.args.teamA} vs ${widget.args.teamB}',
            style: AppTextStyles.poppinsBold24.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('d MMM, yy • h:mm a').format(widget.args.startTime),
            style: AppTextStyles.poppinsRegular15,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleTabs(TeamRole? activeRole) {
    return Wrap(
      spacing: 8,
      children: [
        ChoiceChip(
          selected: activeRole == null,
          label: const Text('ALL'),
          onSelected: (_) => ref
              .read(createTeamViewModelProvider.notifier)
              .setActiveRole(null),
        ),
        ...TeamRole.values.map(
          (role) => ChoiceChip(
            selected: activeRole == role,
            label: Text(role.label),
            onSelected: (_) => ref
                .read(createTeamViewModelProvider.notifier)
                .setActiveRole(role),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerTile(CreateTeamState state, PlayerEntity player) {
    final isSelected = state.selectedPlayerIds.contains(player.id);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(player.fullName),
        subtitle: Text('${player.teamShortName} • ${player.role.label}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(player.credit.toStringAsFixed(1)),
            const SizedBox(width: 10),
            Icon(
              isSelected ? Icons.check_circle : Icons.add_circle_outline,
              color: isSelected ? Colors.green : AppColors.primary,
            ),
          ],
        ),
        onTap: () =>
            ref.read(createTeamViewModelProvider.notifier).togglePlayer(player),
      ),
    );
  }

  Widget _buildBottomAction({required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}
