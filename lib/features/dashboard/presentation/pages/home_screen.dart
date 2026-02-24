import 'package:fanup/app/routes/app_routes.dart';
import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/features/create_team/presentation/pages/create_team_page.dart';
import 'package:fanup/features/dashboard/domain/entities/contest_entry_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/home_match_entity.dart';
import 'package:fanup/features/dashboard/presentation/state/home_state.dart';
import 'package:fanup/features/dashboard/presentation/view_model/home_view_model.dart';
import 'package:fanup/features/dashboard/presentation/view_model/wallet_view_model.dart';
import 'package:fanup/features/dashboard/presentation/widgets/balance_card_widget.dart';
import 'package:fanup/features/dashboard/presentation/widgets/match_card_widget.dart';
import 'package:fanup/features/dashboard/presentation/widgets/team_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _activeTab = 'upcoming';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load home data (matches)
      ref.read(homeViewModelProvider.notifier).loadHomeData();
      // Load wallet data (includes balance)
      ref.read(walletViewModelProvider.notifier).loadWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final walletState = ref.watch(walletViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;
            final logoSize = isTablet ? 120.0 : 90.0;
            final spacingBetweenLogoAndText = isTablet ? 20.0 : 14.0;
            final verticalSpacing = isTablet ? 16.0 : 10.0;
            final titleFontSize = isTablet ? 28.0 : 24.0;
            final subtitleFontSize = isTablet ? 18.0 : 16.0;
            final sectionTitleFontSize = isTablet ? 22.0 : 18.0;

            // Get user balance from wallet state
            final userBalance = (walletState.summary?.balance ?? 0).toDouble();

            return RefreshIndicator(
              onRefresh: () async {
                await ref.read(homeViewModelProvider.notifier).loadHomeData();
                await ref.read(walletViewModelProvider.notifier).loadWallet();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: logoSize,
                          width: logoSize,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: spacingBetweenLogoAndText),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Fan',
                                    style: AppTextStyles.poppinsBold24.copyWith(
                                      fontSize: titleFontSize,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Up',
                                    style: AppTextStyles.poppinsBold24.copyWith(
                                      fontSize: titleFontSize,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: verticalSpacing / 2),
                            Text(
                              'Build your dream team',
                              style: AppTextStyles.poppinsRegular16.copyWith(
                                fontSize: subtitleFontSize,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: verticalSpacing),
                    BalanceCardWidget(credit: userBalance),
                    SizedBox(height: verticalSpacing),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 12 : 8,
                      ),
                      child: Text(
                        'Matches',
                        style: AppTextStyles.poppinsSemiBold18.copyWith(
                          fontSize: sectionTitleFontSize,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildTabs(),
                    const SizedBox(height: 8),
                    _buildBody(homeState),
                    SizedBox(height: verticalSpacing * 2),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(HomeState state) {
    if (state.status == HomeStatus.loading && state.matches.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.status == HomeStatus.error && state.matches.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            Text(
              state.errorMessage ?? 'Failed to load matches',
              textAlign: TextAlign.center,
              style: AppTextStyles.poppinsRegular16.copyWith(
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () =>
                  ref.read(homeViewModelProvider.notifier).loadHomeData(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.matches.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        child: Text(
          'No matches found.',
          style: AppTextStyles.poppinsRegular16.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    // For "My Teams" tab, show entries with points
    if (_activeTab == 'my_teams') {
      final entries = state.entries;

      if (entries.isEmpty) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          child: Text(
            'No teams created yet.',
            style: AppTextStyles.poppinsRegular16.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        );
      }

      return Column(
        children: entries
            .map(
              (entry) => TeamCardWidget(
                league: entry.match?.league ?? 'League',
                dateTime: entry.match?.startTime != null
                    ? _formatMatchDate(entry.match!.startTime!)
                    : '',
                teamA: entry.match?.teamAShortName ?? 'T1',
                teamB: entry.match?.teamBShortName ?? 'T2',
                teamName: entry.teamName,
                points: entry.points,
                onViewTeam: () => _openViewTeam(entry),
              ),
            )
            .toList(),
      );
    }

    // For "Upcoming" tab, show match cards
    final matches = state.matches;

    if (matches.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        child: Text(
          'No upcoming matches found.',
          style: AppTextStyles.poppinsRegular16.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      children: matches
          .map(
            (match) => MatchCard(
              league: match.league,
              dateTime: _formatMatchDate(match.startTime),
              teamA: match.teamAShortName,
              teamB: match.teamBShortName,
              buttonLabel: match.createLabel,
              onCreateTeam: () => _openCreateTeam(match),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              key: const Key('upcoming_tab'),
              label: 'Upcoming',
              isActive: _activeTab == 'upcoming',
              onTap: () => setState(() => _activeTab = 'upcoming'),
            ),
          ),
          Expanded(
            child: _buildTabButton(
              key: const Key('my_teams_tab'),
              label: 'My Teams',
              isActive: _activeTab == 'my_teams',
              onTap: () => setState(() => _activeTab = 'my_teams'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required Key key,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.poppinsSemiBold13.copyWith(
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  String _formatMatchDate(DateTime dateTime) {
    return DateFormat('d MMM, yy, h:mm a').format(dateTime);
  }

  Future<void> _openCreateTeam(HomeMatchEntity match) async {
    final isSubmitted = await AppRoutes.push<bool>(
      context,
      CreateTeamPage(
        args: CreateTeamPageArgs(
          matchId: match.id,
          league: match.league,
          teamA: match.teamAShortName,
          teamB: match.teamBShortName,
          startTime: match.startTime,
        ),
      ),
    );

    if (isSubmitted == true && mounted) {
      ref.read(homeViewModelProvider.notifier).loadHomeData();
    }
  }

  Future<void> _openViewTeam(ContestEntryEntity entry) async {
    final isUpdated = await AppRoutes.push<bool>(
      context,
      CreateTeamPage(
        args: CreateTeamPageArgs(
          matchId: entry.matchId,
          league: entry.match?.league ?? 'League',
          teamA: entry.match?.teamAShortName ?? 'T1',
          teamB: entry.match?.teamBShortName ?? 'T2',
          startTime: entry.match?.startTime ?? DateTime.now(),
          existingTeamId: entry.teamId,
          existingTeamName: entry.teamName,
          existingPlayerIds: entry.playerIds,
          existingCaptainId: entry.captainId,
          existingViceCaptainId: entry.viceCaptainId,
        ),
      ),
    );

    if (isUpdated == true && mounted) {
      ref.read(homeViewModelProvider.notifier).loadHomeData();
    }
  }
}
