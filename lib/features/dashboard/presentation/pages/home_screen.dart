import 'package:fanup/app/routes/app_routes.dart';
import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/core/widgets/shimmer_loading.dart';
import 'package:fanup/features/create_team/presentation/pages/create_team_page.dart';
import 'package:fanup/features/dashboard/domain/entities/contest_entry_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/home_match_entity.dart';
import 'package:fanup/features/dashboard/domain/usecases/delete_my_contest_entry_usecase.dart';
import 'package:fanup/features/dashboard/presentation/state/home_state.dart';
import 'package:fanup/features/dashboard/presentation/state/dashboard_nav_state.dart';
import 'package:fanup/features/dashboard/presentation/view_model/home_view_model.dart';
import 'package:fanup/features/dashboard/presentation/view_model/wallet_view_model.dart';
import 'package:fanup/features/notifications/domain/usecases/get_unread_notification_count_usecase.dart';
import 'package:fanup/features/notifications/presentation/pages/notification_screen.dart';
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
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).loadHomeData();
      ref.read(walletViewModelProvider.notifier).loadWallet();
      _loadUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final walletState = ref.watch(walletViewModelProvider);
    final userBalance = (walletState.summary?.balance ?? 0).toDouble();

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 600;

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, isTablet),
                    SizedBox(height: isTablet ? 14 : 8),
                    BalanceCardWidget(
                      credit: userBalance,
                      onOpenWallet: () {
                        ref.read(dashboardTabIndexProvider.notifier).setTab(2);
                      },
                    ),
                    SizedBox(height: isTablet ? 14 : 8),
                    _buildSectionTitle(context, isTablet),
                    const SizedBox(height: 10),
                    _buildTabs(),
                    const SizedBox(height: 8),
                    _buildBody(homeState),
                    SizedBox(height: isTablet ? 28 : 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      ref.read(homeViewModelProvider.notifier).loadHomeData(),
      ref.read(walletViewModelProvider.notifier).loadWallet(),
      _loadUnreadCount(),
    ]);
  }

  Future<void> _loadUnreadCount() async {
    final result = await ref.read(getUnreadNotificationCountUsecaseProvider)();
    result.fold((_) {}, (count) {
      if (!mounted) return;
      setState(() {
        _unreadCount = count;
      });
    });
  }

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  Widget _buildHeader(BuildContext context, bool isTablet) {
    final logoSize = isTablet ? 80.0 : 60.0;
    final titleFontSize = isTablet ? 22.0 : 18.0;
    final subtitleFontSize = isTablet ? 14.0 : 12.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: logoSize,
          width: logoSize,
          fit: BoxFit.contain,
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Flexible(
          child: Column(
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
                        color: Theme.of(context).colorScheme.onSurface,
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
              const SizedBox(height: 4),
              Text(
                'Build your dream team',
                style: AppTextStyles.poppinsRegular16.copyWith(
                  fontSize: subtitleFontSize,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                size: isTablet ? 36 : 28,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              onPressed: () async {
                await AppRoutes.push(context, const NotificationScreen());
                _loadUnreadCount();
              },
            ),
            if (_unreadCount > 0)
              Positioned(
                right: 5,
                top: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1.5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                  child: Text(
                    _unreadCount > 99 ? '99+' : _unreadCount.toString(),
                    style: AppTextStyles.poppinsSemiBold13.copyWith(
                      color: Colors.white,
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 12 : 8),
      child: Text(
        'Matches',
        style: AppTextStyles.poppinsSemiBold18.copyWith(
          fontSize: isTablet ? 18.0 : 15.0,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tabs
  // ---------------------------------------------------------------------------

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.poppinsSemiBold13.copyWith(
              color: isActive
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface.withAlpha(153),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Body
  // ---------------------------------------------------------------------------

  Widget _buildBody(HomeState state) {
    if (state.status == HomeStatus.loading && state.matches.isEmpty) {
      return const MatchCardShimmer();
    }

    if (state.status == HomeStatus.error && state.matches.isEmpty) {
      return _buildErrorState(state.errorMessage);
    }

    if (_activeTab == 'my_teams') {
      return _buildMyTeamsTab(state);
    }

    return _buildUpcomingTab(state);
  }

  Widget _buildErrorState(String? message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        children: [
          Text(
            message ?? 'Failed to load matches',
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

  Widget _buildUpcomingTab(HomeState state) {
    if (state.matches.isEmpty) {
      return _buildEmptyState('No upcoming matches found.');
    }

    return Column(
      children: state.matches
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

  Widget _buildMyTeamsTab(HomeState state) {
    if (state.entries.isEmpty) {
      return _buildEmptyState('No teams created yet.');
    }

    return Column(
      children: state.entries
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
              onDeleteTeam: () => _confirmDeleteTeam(entry),
            ),
          )
          .toList(),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Text(
        message,
        style: AppTextStyles.poppinsRegular16.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _formatMatchDate(DateTime dateTime) {
    return DateFormat('d MMM, yy, h:mm a').format(dateTime);
  }

  Future<void> _openCreateTeam(HomeMatchEntity match) async {
    final isSubmitted = await AppRoutes.push(
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
    final isUpdated = await AppRoutes.push(
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
          isViewOnly: true,
        ),
      ),
    );

    if (isUpdated == true && mounted) {
      ref.read(homeViewModelProvider.notifier).loadHomeData();
    }
  }

  Future<void> _confirmDeleteTeam(ContestEntryEntity entry) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Team'),
        content: Text('Delete "${entry.teamName}" from this match?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    final result = await ref.read(deleteMyContestEntryUsecaseProvider)(
      DeleteMyContestEntryParams(matchId: entry.matchId),
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Team deleted successfully')),
        );
        ref.read(homeViewModelProvider.notifier).loadHomeData();
      },
    );
  }
}
