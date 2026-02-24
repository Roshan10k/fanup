import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/app/routes/app_routes.dart';
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
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFFCE043), Color(0xFFFF5E62)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Credit info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Available credit",
                style: AppTextStyles.poppinsSemiBold15.copyWith(
                  color: AppColors.textDark,
                ),
              ),
              Text(
                credit.toStringAsFixed(1),
                style: AppTextStyles.poppinsSemiBold18.copyWith(
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),

          // Open Wallet Button
          TextButton.icon(
            onPressed: () {
              AppRoutes.push(context, const WalletScreen());
            },
            icon: const Icon(Icons.wallet, color: Color(0xFFFF5E62)),
            label: Text(
              "Open Wallet",
              style: AppTextStyles.poppinsRegular15.copyWith(
                color: AppColors.textDark,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
