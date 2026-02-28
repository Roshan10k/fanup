import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/core/utils/responsive_utils.dart';
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
  final String? existingTeamId;
  final String? existingTeamName;
  final List<String>? existingPlayerIds;
  final String? existingCaptainId;
  final String? existingViceCaptainId;
  final bool isViewOnly;

  const CreateTeamPageArgs({
    required this.matchId,
    required this.league,
    required this.teamA,
    required this.teamB,
    required this.startTime,
    this.existingTeamId,
    this.existingTeamName,
    this.existingPlayerIds,
    this.existingCaptainId,
    this.existingViceCaptainId,
    this.isViewOnly = false,
  });

  bool get isEditing => existingTeamId != null && existingTeamId!.isNotEmpty;
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.args.isViewOnly
              ? 'Team Preview'
              : state.isPreviewStep
              ? 'Preview Team'
              : state.isCaptainStep
              ? 'Captain & Vice-Captain'
              : 'Create Team',
          style: AppTextStyles.poppinsSemiBold18.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: state.status == CreateTeamStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : state.status == CreateTeamStatus.error && state.players.isEmpty
          ? _buildError(state)
          : widget.args.isViewOnly
          ? _buildPreviewStep(state, readOnly: true)
          : state.isPreviewStep
          ? _buildPreviewStep(state)
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
              RadioGroup<String>(
                groupValue: state.captainId.isEmpty ? null : state.captainId,
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(createTeamViewModelProvider.notifier)
                        .setCaptain(value);
                  }
                },
                child: Column(
                  children: selectedPlayers
                      .map(
                        (player) => RadioListTile<String>(
                          value: player.id,
                          title: Text(player.fullName),
                          subtitle: Text(
                            '${player.teamShortName} • ${player.role.label}',
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
              const SizedBox(height: 16),
              Text('Select Vice-Captain', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 8),
              RadioGroup<String>(
                groupValue: state.viceCaptainId.isEmpty
                    ? null
                    : state.viceCaptainId,
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(createTeamViewModelProvider.notifier)
                        .setViceCaptain(value);
                  }
                },
                child: Column(
                  children: selectedPlayers
                      .map(
                        (player) => RadioListTile<String>(
                          value: player.id,
                          title: Text(player.fullName),
                          subtitle: Text(
                            '${player.teamShortName} • ${player.role.label}',
                          ),
                        ),
                      )
                      .toList(growable: false),
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
                  onPressed: () {
                    ref
                        .read(createTeamViewModelProvider.notifier)
                        .canContinueToPreviewStep();
                  },
                  child: const Text('Preview Team'),
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
    final fontScale = context.fontScale;

    return Container(
      padding: EdgeInsets.all(12 * fontScale),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$selectedCount/11 selected',
            style: AppTextStyles.cardTitle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14 * fontScale,
            ),
          ),
          Text(
            'Credit left: ${creditLeft.toStringAsFixed(1)}',
            style: AppTextStyles.cardSubtitle.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(170),
              fontSize: 12 * fontScale,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: TeamRole.values
                .map(
                  (role) => Chip(
                    label: Text(
                      '${role.label}: ${roleCounts[role] ?? 0}',
                      style: TextStyle(fontSize: 11 * fontScale),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 6 * fontScale),
                    visualDensity: VisualDensity.compact,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchHeader() {
    final fontScale = context.fontScale;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headerGradient = isDark
        ? const [Color(0xFF2A3347), Color(0xFF1C2436)]
        : const [AppColors.gradientYellow, AppColors.gradientOrange];
    final primaryTextColor = Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: EdgeInsets.all(12 * fontScale),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: headerGradient),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.args.league,
            style: AppTextStyles.poppinsSemiBold15.copyWith(
              color: primaryTextColor,
              fontSize: 13 * fontScale,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '${widget.args.teamA} vs ${widget.args.teamB}',
              style: AppTextStyles.poppinsBold24.copyWith(
                fontSize: 18 * fontScale,
                color: primaryTextColor,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('d MMM, yy • h:mm a').format(widget.args.startTime),
            style: AppTextStyles.poppinsRegular15.copyWith(
              color: primaryTextColor.withAlpha(190),
              fontSize: 12 * fontScale,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleTabs(TeamRole? activeRole) {
    final fontScale = context.fontScale;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        ChoiceChip(
          selected: activeRole == null,
          label: Text('ALL', style: TextStyle(fontSize: 12 * fontScale)),
          onSelected: (_) => ref
              .read(createTeamViewModelProvider.notifier)
              .setActiveRole(null),
          visualDensity: VisualDensity.compact,
        ),
        ...TeamRole.values.map(
          (role) => ChoiceChip(
            selected: activeRole == role,
            label: Text(role.label, style: TextStyle(fontSize: 12 * fontScale)),
            onSelected: (_) => ref
                .read(createTeamViewModelProvider.notifier)
                .setActiveRole(role),
            visualDensity: VisualDensity.compact,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerTile(CreateTeamState state, PlayerEntity player) {
    final isSelected = state.selectedPlayerIds.contains(player.id);
    final fontScale = context.fontScale;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12 * fontScale,
          vertical: 4,
        ),
        title: Text(
          player.fullName,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14 * fontScale,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          '${player.teamShortName} • ${player.role.label}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(170),
            fontSize: 12 * fontScale,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              player.credit.toStringAsFixed(1),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 13 * fontScale,
              ),
            ),
            SizedBox(width: 8 * fontScale),
            Icon(
              isSelected ? Icons.check_circle : Icons.add_circle_outline,
              color: isSelected
                  ? Colors.green
                  : Theme.of(context).colorScheme.primary,
              size: 22 * fontScale,
            ),
          ],
        ),
        onTap: () =>
            ref.read(createTeamViewModelProvider.notifier).togglePlayer(player),
      ),
    );
  }

  Widget _buildPreviewStep(CreateTeamState state, {bool readOnly = false}) {
    final selectedPlayers = state.selectedPlayers;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildMatchHeader(),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withAlpha(100),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        state.teamName.isEmpty
                            ? 'Unnamed Team'
                            : state.teamName,
                        style: AppTextStyles.poppinsSemiBold18.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha(35),
                      ),
                      child: Text(
                        '${selectedPlayers.length}/11',
                        style: AppTextStyles.poppinsSemiBold13.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ...selectedPlayers.map((player) {
                final isCaptain = state.captainId == player.id;
                final isViceCaptain = state.viceCaptainId == player.id;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(player.fullName),
                    subtitle: Text(
                      '${player.teamShortName} • ${player.role.label}',
                    ),
                    trailing: Wrap(
                      spacing: 6,
                      children: [
                        if (isCaptain)
                          Chip(
                            label: const Text('C'),
                            visualDensity: VisualDensity.compact,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary.withAlpha(35),
                          ),
                        if (isViceCaptain)
                          Chip(
                            label: const Text('VC'),
                            visualDensity: VisualDensity.compact,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.secondary.withAlpha(60),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        _buildBottomAction(
          child: Row(
            children: [
              if (!readOnly) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: ref
                        .read(createTeamViewModelProvider.notifier)
                        .backToCaptainSelection,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: readOnly
                    ? ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      )
                    : ElevatedButton(
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
                            : Text(
                                widget.args.isEditing
                                    ? 'Update Team'
                                    : 'Save Team',
                              ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction({required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}
