import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/core/utils/responsive_utils.dart';
import 'package:fanup/features/dashboard/domain/entities/wallet_summary_entity.dart';
import 'package:fanup/features/dashboard/domain/entities/wallet_transaction_entity.dart';
import 'package:fanup/features/dashboard/presentation/state/wallet_state.dart';
import 'package:fanup/features/dashboard/presentation/view_model/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class WalletScreen extends ConsumerStatefulWidget {
  const WalletScreen({super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  final NumberFormat _creditFormat = NumberFormat.decimalPattern('en_US');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(walletViewModelProvider.notifier).loadWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletViewModelProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(walletViewModelProvider.notifier).loadWallet(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildBalanceCard(walletState),
                const SizedBox(height: 32),
                _buildRecentTransactions(walletState),
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
          Text("My Wallet", style: AppTextStyles.headerTitle.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          )),
          const SizedBox(height: 4),
          Text("Manage your credits", style: AppTextStyles.headerSubtitle.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
          )),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(WalletState state) {
    final WalletSummaryEntity? summary = state.summary;
    final balance = summary?.balance ?? 0;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradientColors = isDark
        ? const [Color(0xFF1C2637), Color(0xFF2B3550)]
        : const [Color(0xFFFFD54F), Color(0xFFFFA726)];
    final onGradient = isDark ? theme.colorScheme.onSurface : Colors.black87;
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.45)
        : const Color(0xFFFFA726).withOpacity(0.3);
    final fontScale = context.fontScale;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 350;
        final padding = isSmall ? 18.0 : 24.0;
        final balanceFontSize = isSmall ? 28.0 : 36.0;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradientColors),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      "Total Credits",
                      style: AppTextStyles.cardTitle.copyWith(
                        color: onGradient.withAlpha(220),
                        fontSize: 14 * fontScale,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.monetization_on,
                    size: 18 * fontScale,
                    color: onGradient.withAlpha(180),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  _creditFormat.format(balance),
                  style: AppTextStyles.amountLarge.copyWith(
                    fontSize: balanceFontSize * fontScale,
                    color: onGradient,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Use Wrap for better responsiveness on small screens
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  _buildBalanceDetail(
                    "Credits In",
                    _creditFormat.format(summary?.totalCredit ?? 0),
                  ),
                  _buildBalanceDetail(
                    "Credits Out",
                    _creditFormat.format(summary?.totalDebit ?? 0),
                  ),
                  _buildBalanceDetail(
                    "Transactions",
                    '${summary?.transactionCount ?? 0}',
                  ),
                ],
              ),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  state.errorMessage!,
                  style: AppTextStyles.labelText.copyWith(
                    color: Colors.red.shade800,
                    fontSize: 12 * fontScale,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (state.infoMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  state.infoMessage!,
                  style: AppTextStyles.labelText.copyWith(
                    color: Colors.green.shade800,
                    fontSize: 12 * fontScale,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: state.isClaimingBonus
                      ? null
                      : _showEarnCreditsBottomSheet,
                  icon: state.isClaimingBonus
                      ? SizedBox(
                          width: 16 * fontScale,
                          height: 16 * fontScale,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(Icons.stars, size: 18 * fontScale),
                  label: Flexible(
                    child: Text(
                      state.isClaimingBonus ? "Processing..." : "Earn More Credits",
                      style: AppTextStyles.cardTitle.copyWith(
                        color: const Color(0xFFFFA726),
                        fontSize: 14 * fontScale,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFFFA726),
                    padding: EdgeInsets.symmetric(vertical: 12 * fontScale),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBalanceDetail(String label, String amount) {
    final theme = Theme.of(context);
    final labelColor = theme.colorScheme.onSurface.withAlpha(170);
    final valueColor = theme.colorScheme.onSurface;
    final fontScale = context.fontScale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppTextStyles.labelText.copyWith(
            color: labelColor,
            fontSize: 11 * fontScale,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: AppTextStyles.amountSmall.copyWith(
            color: valueColor,
            fontSize: 14 * fontScale,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(WalletState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text("Recent Transactions", style: AppTextStyles.cardTitle.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                ), overflow: TextOverflow.ellipsis),
              ),
              TextButton(
                onPressed: () =>
                    ref.read(walletViewModelProvider.notifier).loadWallet(),
                child: Text(
                  "Refresh",
                  style: AppTextStyles.labelText.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Builder(
            builder: (_) {
              if (state.status == WalletStatus.loading &&
                  state.transactions.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (state.transactions.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'No transactions yet.',
                    style: AppTextStyles.labelText.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                );
              }

              return Column(
                children: state.transactions
                    .map(_buildTransactionItem)
                    .toList(growable: false),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(WalletTransactionEntity transaction) {
    final String formattedDate = DateFormat(
      'yyyy-MM-dd • HH:mm',
    ).format(transaction.createdAt.toLocal());
    final iconAndColor = _iconForTransaction(transaction);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withAlpha(13),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconAndColor.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(iconAndColor.icon, color: iconAndColor.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: AppTextStyles.cardSubtitle.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(formattedDate, style: AppTextStyles.captionText.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                      ), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "${transaction.type == WalletTransactionType.credit ? '+' : '-'}${_creditFormat.format(transaction.amount)}",
            style: AppTextStyles.labelText.copyWith(
              color: transaction.type == WalletTransactionType.credit
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFF44336),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  _WalletIconAndColor _iconForTransaction(WalletTransactionEntity transaction) {
    if (transaction.source.contains('bonus')) {
      return const _WalletIconAndColor(
        icon: Icons.card_giftcard,
        color: Color(0xFF2196F3),
      );
    }

    if (transaction.type == WalletTransactionType.credit) {
      return const _WalletIconAndColor(
        icon: Icons.arrow_downward,
        color: Color(0xFF4CAF50),
      );
    }

    return const _WalletIconAndColor(
      icon: Icons.arrow_upward,
      color: Color(0xFFF44336),
    );
  }

  void _showEarnCreditsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.stars, color: Color(0xFFFFA726), size: 28),
                const SizedBox(width: 12),
                Text("Earn More Credits", style: AppTextStyles.sectionTitle),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Complete tasks to earn free credits",
              style: AppTextStyles.cardSubtitle,
            ),
            const SizedBox(height: 24),
            _buildEarnCreditTile(
              icon: Icons.calendar_today,
              title: "Daily Login Bonus",
              subtitle: "Claim once every day",
              credits: "+100",
              color: const Color(0xFF4CAF50),
              onTap: () {
                Navigator.pop(context);
                _claimDailyBonus();
              },
            ),
            const SizedBox(height: 12),
            _buildEarnCreditTile(
              icon: Icons.person_add,
              title: "Invite Friends",
              subtitle: "Referral rewards coming soon",
              credits: "+500",
              color: const Color(0xFF2196F3),
              onTap: () {
                Navigator.pop(context);
                _showSimpleDialog(
                  "Invite Friends",
                  "Referral rewards are coming soon.",
                );
              },
            ),
            const SizedBox(height: 12),
            _buildEarnCreditTile(
              icon: Icons.workspace_premium,
              title: "Contest Wins",
              subtitle: "Rewards from contests are auto-credited",
              credits: "Variable",
              color: const Color(0xFFF59E0B),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEarnCreditTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String credits,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.labelText),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                credits,
                style: AppTextStyles.cardValue.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _claimDailyBonus() async {
    await ref.read(walletViewModelProvider.notifier).claimDailyBonus();
    if (!mounted) {
      return;
    }

    final state = ref.read(walletViewModelProvider);
    if (state.errorMessage != null) {
      _showSimpleDialog('Daily Bonus', state.errorMessage!);
      return;
    }

    final message = state.infoMessage ?? 'Daily bonus processed';
    _showSimpleDialog('Daily Bonus', message);
  }

  void _showSimpleDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: AppTextStyles.sectionTitle),
        content: Text(message, style: AppTextStyles.cardSubtitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: AppTextStyles.cardTitle.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletIconAndColor {
  final IconData icon;
  final Color color;

  const _WalletIconAndColor({required this.icon, required this.color});
}
