import 'package:fanup/themes/theme.dart';
import 'package:flutter/material.dart';

class BalanceCardWidget extends StatelessWidget {
  final double credit;
  final VoidCallback onAddCredit;

  const BalanceCardWidget({
    super.key,
    required this.credit,
    required this.onAddCredit,
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

          // Add Credit Button
          TextButton(
            onPressed: onAddCredit,
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              "Add Credit",
              style: AppTextStyles.poppinsRegular15.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
