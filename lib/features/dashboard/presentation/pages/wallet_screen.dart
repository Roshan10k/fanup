import 'package:flutter/material.dart';
import 'package:fanup/app/themes/theme.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final List<Transaction> _transactions = [
    Transaction(
      title: 'Contest Prize - IND vs AUS',
      amount: 2500,
      type: TransactionType.credit,
      date: DateTime(2025, 11, 19, 14, 30),
      icon: Icons.arrow_downward,
      iconColor: const Color(0xFF4CAF50),
    ),
    Transaction(
      title: 'Daily Login Bonus',
      amount: 1000,
      type: TransactionType.credit,
      date: DateTime(2025, 11, 18, 10, 15),
      icon: Icons.card_giftcard,
      iconColor: const Color(0xFF2196F3),
    ),
    Transaction(
      title: 'Joined Mega Contest',
      amount: 49,
      type: TransactionType.debit,
      date: DateTime(2025, 11, 17, 16, 45),
      icon: Icons.arrow_upward,
      iconColor: const Color(0xFFF44336),
    ),
    Transaction(
      title: 'Contest Prize - PAK vs SA',
      amount: 1500,
      type: TransactionType.credit,
      date: DateTime(2025, 11, 16, 18, 20),
      icon: Icons.arrow_downward,
      iconColor: const Color(0xFF4CAF50),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildBalanceCard(),
              const SizedBox(height: 32),
              _buildRecentTransactions(),
              const SizedBox(height: 24),
            ],
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
          Text("My Wallet", style: AppTextStyles.headerTitle),
          const SizedBox(height: 4),
          Text("Manage your credits", style: AppTextStyles.headerSubtitle),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFD54F), Color(0xFFFFA726)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFA726).withOpacity(0.3),
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
              Text(
                "Total Credits",
                style: AppTextStyles.cardTitle.copyWith(
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.monetization_on,
                size: 20,
                color: Colors.black87.withOpacity(0.7),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "10,450",
            style: AppTextStyles.amountLarge.copyWith(
              fontSize: 40,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBalanceDetail("Contest Wins", "2450"),
              _buildBalanceDetail("Daily Bonus", "850"),
              _buildBalanceDetail("Achievements", "600"),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showEarnCreditsBottomSheet,
              icon: const Icon(Icons.stars, size: 20),
              label: Text(
                "Earn More Credits",
                style: AppTextStyles.cardTitle.copyWith(
                  color: const Color(0xFFFFA726),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFFFA726),
                padding: const EdgeInsets.symmetric(vertical: 14),
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
  }

  Widget _buildBalanceDetail(String label, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelText.copyWith(
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: AppTextStyles.amountSmall.copyWith(
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Recent Transactions", style: AppTextStyles.sectionTitle),
              TextButton(
                onPressed: () {},
                child: Text(
                  "View All",
                  style: AppTextStyles.cardTitle.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: _transactions.map((transaction) {
              return _buildTransactionItem(transaction);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final String formattedDate = DateFormat('yyyy-MM-dd • HH:mm').format(transaction.date);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: transaction.iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.icon,
              color: transaction.iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.title, style: AppTextStyles.cardTitle),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(formattedDate, style: AppTextStyles.labelText),
                  ],
                ),
              ],
            ),
          ),
          Text(
            "${transaction.type == TransactionType.credit ? '+' : '-'}${transaction.amount}",
            style: AppTextStyles.amountSmall.copyWith(
              color: transaction.type == TransactionType.credit
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFF44336),
            ),
          ),
        ],
      ),
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
              subtitle: "Login every day to earn credits",
              credits: "+100",
              color: const Color(0xFF4CAF50),
              onTap: () {
                Navigator.pop(context);
                _showSimpleDialog("Daily Bonus", "You've earned 100 credits!");
              },
            ),
            const SizedBox(height: 12),
            _buildEarnCreditTile(
              icon: Icons.person_add,
              title: "Invite Friends",
              subtitle: "Earn credits for each friend who joins",
              credits: "+500",
              color: const Color(0xFF2196F3),
              onTap: () {
                Navigator.pop(context);
                _showSimpleDialog("Referral Code", "Your code: FANUP2025");
              },
            ),
            const SizedBox(height: 12),
            _buildEarnCreditTile(
              icon: Icons.workspace_premium,
              title: "Complete Achievements",
              subtitle: "Unlock achievements to earn credits",
              credits: "+200",
              color: const Color(0xFF9C27B0),
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
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
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

enum TransactionType { credit, debit }

class Transaction {
  final String title;
  final int amount;
  final TransactionType type;
  final DateTime date;
  final IconData icon;
  final Color iconColor;

  Transaction({
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.icon,
    required this.iconColor,
  });
}