import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/app/routes/app_routes.dart';
import 'package:fanup/core/utils/responsive_utils.dart';
import 'package:fanup/features/dashboard/presentation/pages/wallet_screen.dart';
import 'package:flutter/material.dart';

class BalanceCardWidget extends StatelessWidget {
  final double credit;
  final VoidCallback? onAddCredit;

  const BalanceCardWidget({
    super.key,
    required this.credit,
    this.onAddCredit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradientColors = isDark
        ? const [Color(0xFF1B2433), Color(0xFF2A3347)]
        : const [Color(0xFFFCE043), Color(0xFFFF5E62)];
    final onGradient = isDark ? theme.colorScheme.onSurface : AppColors.textDark;
    final iconColor = isDark ? theme.colorScheme.primary : const Color(0xFFFF5E62);
    final buttonBackground = isDark ? theme.colorScheme.surface : Colors.white;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= 500;
        final fontScale = context.fontScale;
        final padding = isTablet ? 22.0 : 16.0;

        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              // Credit info
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Available credit",
                      style: AppTextStyles.poppinsSemiBold15.copyWith(
                        color: onGradient.withAlpha(220),
                        fontSize: 13 * fontScale,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      credit.toStringAsFixed(1),
                      style: AppTextStyles.poppinsSemiBold18.copyWith(
                        color: onGradient,
                        fontSize: 18 * fontScale,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Open Wallet Button
              Flexible(
                flex: 2,
                child: TextButton.icon(
                  onPressed: () {
                    AppRoutes.push(context, const WalletScreen());
                  },
                  icon: Icon(Icons.wallet, color: iconColor, size: 18 * fontScale),
                  label: Text(
                    "Wallet",
                    style: AppTextStyles.poppinsRegular15.copyWith(
                      color: onGradient,
                      fontSize: 13 * fontScale,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: buttonBackground,
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 14 : 10,
                      vertical: isTablet ? 10 : 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
