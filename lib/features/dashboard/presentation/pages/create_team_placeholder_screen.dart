import 'package:fanup/app/themes/theme.dart';
import 'package:flutter/material.dart';

class CreateTeamPlaceholderScreen extends StatelessWidget {
  final String matchLabel;
  final bool isEdit;

  const CreateTeamPlaceholderScreen({
    super.key,
    required this.matchLabel,
    required this.isEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Team Builder', style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        )),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isEdit
                    ? 'Edit Team (Coming Next Sprint)'
                    : 'Create Team (Coming Next Sprint)',
                textAlign: TextAlign.center,
                style: AppTextStyles.poppinsBold24.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Selected match: $matchLabel',
                style: AppTextStyles.poppinsRegular16.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
