import 'package:fanup/app/themes/theme.dart';
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
      backgroundColor: AppColors.background,
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Leaderboard", style: AppTextStyles.headerTitle),
          const SizedBox(height: 4),
          Text("Match contest rankings", style: AppTextStyles.headerSubtitle),
        ],
      ),
    );
  }

  Widget _buildControls(LeaderboardState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Text(
                  'COMPLETED CONTESTS',
                  style: AppTextStyles.labelText.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: state.selectedMatchId.isEmpty
                          ? null
                          : state.selectedMatchId,
                      hint: const Text('Select match'),
                      isExpanded: true,
                      items: state.contests
                          .map(
                            (item) => DropdownMenuItem<String>(
                              value: item.id,
                              child: Text(
                                item.matchLabel,
                                overflow: TextOverflow.ellipsis,
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
                ),
              ),
            ],
          ),
        ],
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
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contest.matchLabel, style: AppTextStyles.sectionTitle),
          const SizedBox(height: 4),
          Text(
            DateFormat('yyyy-MM-dd HH:mm').format(contest.startsAt.toLocal()),
            style: AppTextStyles.labelText,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryValue('Fee', _credits.format(contest.entryFee)),
              _summaryValue('Players', '${contest.participantsCount}'),
              _summaryValue('Prize', _credits.format(contest.prizePool)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryValue(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.labelText),
        const SizedBox(height: 2),
        Text(value, style: AppTextStyles.cardTitle),
      ],
    );
  }

  Widget _buildTopThree(LeaderboardState state) {
    final leaders = state.payload?.leaders ?? const <LeaderboardLeaderEntity>[];
    if (state.status == LeaderboardStatus.loading && leaders.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: CircularProgressIndicator(),
      );
    }

    if (leaders.isEmpty) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text('No leaderboard data yet.', style: AppTextStyles.labelText),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
            style: AppTextStyles.labelText.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 4),
          Text(
            leader.name,
            style: AppTextStyles.cardTitle.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            '${leader.pts.toStringAsFixed(1)} points',
            style: AppTextStyles.labelText,
          ),
          const SizedBox(height: 4),
          Text(
            'Prize: ${_credits.format(leader.prize)} credits',
            style: AppTextStyles.cardSubtitle.copyWith(
              color: Colors.green.shade700,
              fontWeight: FontWeight.w600,
            ),
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
          style: AppTextStyles.labelText,
        ),
      );
    }

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
          Text('Your Standing', style: AppTextStyles.cardTitle),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${myEntry.rank}',
                    style: AppTextStyles.amountLarge.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${myEntry.pts.toStringAsFixed(1)} pts · ${myEntry.winRate.toStringAsFixed(0)}% win rate',
                    style: AppTextStyles.labelText,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Prize', style: AppTextStyles.labelText),
                  const SizedBox(height: 4),
                  Text(
                    '${_credits.format(myEntry.prize)} credits',
                    style: AppTextStyles.cardTitle.copyWith(
                      color: Colors.green.shade700,
                    ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text('${leader.rank}.', style: AppTextStyles.cardTitle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(leader.name, style: AppTextStyles.cardTitle),
                const SizedBox(height: 2),
                Text(
                  '${leader.teams} team${leader.teams != 1 ? 's' : ''} · ${leader.pts.toStringAsFixed(1)} pts',
                  style: AppTextStyles.labelText,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${leader.winRate.toStringAsFixed(0)}%',
                style: AppTextStyles.cardSubtitle.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _credits.format(leader.prize),
                style: AppTextStyles.labelText.copyWith(
                  color: Colors.green.shade700,
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
