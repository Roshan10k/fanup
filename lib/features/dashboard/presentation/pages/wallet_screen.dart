import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child: Text(
          'Wallet Screen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}