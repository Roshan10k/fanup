import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/core/utils/responsive_utils.dart';
import 'package:fanup/core/widgets/shimmer_loading.dart';
import 'package:fanup/features/dashboard/domain/entities/leaderboard_contest_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/leaderboard_payload_entity.dart';
import 'package:fanup/features/dashboard/presentation/state/leaderboard_state.dart';
import 'package:fanup/features/dashboard/presentation/view_model/leaderboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  final NumberFormat _credits = NumberFormat.decimalPattern('en_US');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(leaderboardViewModelProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(leaderboardViewModelProvider);
    final selectedContest = state.contests
        .where((c) => c.id == state.selectedMatchId)
        .cast<LeaderboardContestEntity?>()
        .firstOrNull;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref
              .read(leaderboardViewModelProvider.notifier)
              .loadContests(status: 'upcoming'),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildControls(state),
                const SizedBox(height: 16),
                if (state.errorMessage != null)
                  _buildError(state.errorMessage!),
                if (selectedContest != null)
                  _buildContestSummary(selectedContest),
                const SizedBox(height: 16),
                _buildTopThree(state),
                const SizedBox(height: 16),
                _buildMyEntryCard(state),
                const SizedBox(height: 12),
                _buildLeaderList(state),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Leaderboard",
            style: AppTextStyles.headerTitle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Match contest rankings",
            style: AppTextStyles.headerSubtitle.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(LeaderboardState state) {
    final fontScale = context.fontScale;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxWidth < 360;

              if (isSmall) {
                // Stack vertically on very small screens
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStatusBadge(fontScale),
                    const SizedBox(height: 10),
                    _buildMatchDropdown(state, fontScale),
                  ],
                );
              }

              return Row(
                children: [
                  _buildStatusBadge(fontScale),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMatchDropdown(state, fontScale)),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(double fontScale) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10 * fontScale,
        vertical: 6 * fontScale,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Text(
        'COMPLETED',
        style: AppTextStyles.labelText.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
          fontSize: 10 * fontScale,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildMatchDropdown(LeaderboardState state, double fontScale) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10 * fontScale, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: state.selectedMatchId.isEmpty ? null : state.selectedMatchId,
          hint: Text(
            'Select match',
            style: TextStyle(fontSize: 13 * fontScale),
          ),
          isExpanded: true,
          items: state.contests
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item.id,
                  child: Text(
                    item.matchLabel,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13 * fontScale),
                  ),
                ),
              )
              .toList(growable: false),
          onChanged: state.contests.isEmpty
              ? null
              : (value) {
                  if (value == null) return;
                  ref
                      .read(leaderboardViewModelProvider.notifier)
                      .loadMatchLeaderboard(matchId: value);
                },
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: AppTextStyles.labelText.copyWith(color: Colors.red.shade700),
      ),
    );
  }

  Widget _buildContestSummary(LeaderboardContestEntity contest) {
    final fontScale = context.fontScale;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            contest.matchLabel,
            style: AppTextStyles.sectionTitle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16 * fontScale,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('yyyy-MM-dd HH:mm').format(contest.startsAt.toLocal()),
            style: AppTextStyles.labelText.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              fontSize: 11 * fontScale,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 16,
            runSpacing: 10,
            children: [
              _summaryValue(context, 'Fee', _credits.format(contest.entryFee)),
              _summaryValue(context, 'Players', '${contest.participantsCount}'),
              _summaryValue(
                context,
                'Prize',
                _credits.format(contest.prizePool),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryValue(BuildContext context, String title, String value) {
    final theme = Theme.of(context);
    final labelColor = theme.colorScheme.onSurface.withAlpha(170);
    final valueColor = theme.colorScheme.onSurface;
    final fontScale = context.fontScale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppTextStyles.labelText.copyWith(
            color: labelColor,
            fontSize: 10 * fontScale,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.cardTitle.copyWith(
            color: valueColor,
            fontSize: 13 * fontScale,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildTopThree(LeaderboardState state) {
    final leaders = state.payload?.leaders ?? const <LeaderboardLeaderEntity>[];
    if (state.status == LeaderboardStatus.loading && leaders.isEmpty) {
      return const LeaderboardShimmer();
    }

    if (leaders.isEmpty) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'No leaderboard data yet.',
          style: AppTextStyles.labelText.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
          ),
        ),
      );
    }

    final topThree = leaders.take(3).toList(growable: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: topThree
            .map((leader) => _podiumCard(leader))
            .toList(growable: false),
      ),
    );
  }

  Widget _podiumCard(LeaderboardLeaderEntity leader) {
    final fontScale = context.fontScale;
    Color bgColor;
    Color borderColor;

    switch (leader.rank) {
      case 1:
        bgColor = const Color(0xFFFEF9C3); // yellow-50
        borderColor = const Color(0xFFFDE047); // yellow-300
        break;
      case 2:
        bgColor = const Color(0xFFF9FAFB); // gray-50
        borderColor = const Color(0xFFE5E7EB); // gray-200
        break;
      case 3:
        bgColor = const Color(0xFFFFF7ED); // orange-50
        borderColor = const Color(0xFFFED7AA); // orange-200
        break;
      default:
        bgColor = Colors.white;
        borderColor = const Color(0xFFE5E7EB);
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(14 * fontScale),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rank #${leader.rank}',
            style: AppTextStyles.labelText.copyWith(
              color: Colors.grey.shade600,
              fontSize: 11 * fontScale,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            leader.name,
            style: AppTextStyles.cardTitle.copyWith(fontSize: 16 * fontScale),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            '${leader.pts.toStringAsFixed(1)} points',
            style: AppTextStyles.labelText.copyWith(fontSize: 11 * fontScale),
          ),
          const SizedBox(height: 4),
          Text(
            'Prize: ${_credits.format(leader.prize)} credits',
            style: AppTextStyles.cardSubtitle.copyWith(
              color: Colors.green.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 12 * fontScale,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMyEntryCard(LeaderboardState state) {
    final myEntry = state.payload?.myEntry;
    if (myEntry == null) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          'You do not have a standing yet for this contest.',
          style: AppTextStyles.labelText.copyWith(
            fontSize: 12 * context.fontScale,
          ),
        ),
      );
    }

    final fontScale = context.fontScale;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Standing',
            style: AppTextStyles.cardTitle.copyWith(fontSize: 14 * fontScale),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '#${myEntry.rank}',
                        style: AppTextStyles.amountLarge.copyWith(
                          color: AppColors.textDark,
                          fontSize: 28 * fontScale,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${myEntry.pts.toStringAsFixed(1)} pts · ${myEntry.winRate.toStringAsFixed(0)}% win',
                      style: AppTextStyles.labelText.copyWith(
                        fontSize: 11 * fontScale,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Prize',
                    style: AppTextStyles.labelText.copyWith(
                      fontSize: 11 * fontScale,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _credits.format(myEntry.prize),
                    style: AppTextStyles.cardTitle.copyWith(
                      color: Colors.green.shade700,
                      fontSize: 13 * fontScale,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderList(LeaderboardState state) {
    final leaders = state.payload?.leaders ?? const <LeaderboardLeaderEntity>[];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: leaders
            .skip(3)
            .map((leader) => _leaderRow(leader))
            .toList(growable: false),
      ),
    );
  }

  Widget _leaderRow(LeaderboardLeaderEntity leader) {
    final fontScale = context.fontScale;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12 * fontScale),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28 * fontScale,
            child: Text(
              '${leader.rank}.',
              style: AppTextStyles.cardTitle.copyWith(fontSize: 13 * fontScale),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leader.name,
                  style: AppTextStyles.cardTitle.copyWith(
                    fontSize: 13 * fontScale,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 2),
                Text(
                  '${leader.teams} team${leader.teams != 1 ? 's' : ''} · ${leader.pts.toStringAsFixed(1)} pts',
                  style: AppTextStyles.labelText.copyWith(
                    fontSize: 10 * fontScale,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${leader.winRate.toStringAsFixed(0)}%',
                style: AppTextStyles.cardSubtitle.copyWith(
                  color: AppColors.primary,
                  fontSize: 11 * fontScale,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _credits.format(leader.prize),
                style: AppTextStyles.labelText.copyWith(
                  color: Colors.green.shade700,
                  fontSize: 10 * fontScale,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
