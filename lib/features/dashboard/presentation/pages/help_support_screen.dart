import 'package:fanup/app/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: $text'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Help & Support', style: AppTextStyles.sectionTitle.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        )),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'Get In Touch',
                style: AppTextStyles.headerTitle.copyWith(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Need support or have questions? Reach out and our team will respond quickly.',
                style: AppTextStyles.labelText.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                ),
              ),
              const SizedBox(height: 24),
              _buildContactCard(
                context: context,
                icon: Icons.email_outlined,
                iconColor: Colors.red.shade500,
                bgColor: Colors.red.shade50,
                title: 'Email Us',
                value: 'support@fanup.com',
                onTap: () => _copyToClipboard(context, 'support@fanup.com'),
              ),
              const SizedBox(height: 16),
              _buildContactCard(
                context: context,
                icon: Icons.phone_outlined,
                iconColor: Colors.blue.shade500,
                bgColor: Colors.blue.shade50,
                title: 'Call Us',
                value: '+01-123-456',
                onTap: () => _copyToClipboard(context, '+01-123-456'),
              ),
              const SizedBox(height: 16),
              _buildContactCard(
                context: context,
                icon: Icons.location_on_outlined,
                iconColor: Colors.amber.shade600,
                bgColor: Colors.amber.shade50,
                title: 'Visit Us',
                value: 'Kathmandu, Nepal',
                onTap: () => _copyToClipboard(context, 'Kathmandu, Nepal'),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withAlpha(13),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Support Hours',
                          style: AppTextStyles.cardTitle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Monday - Friday: 9:00 AM - 6:00 PM (NPT)',
                      style: AppTextStyles.labelText.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Saturday: 10:00 AM - 4:00 PM (NPT)',
                      style: AppTextStyles.labelText.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sunday: Closed',
                      style: AppTextStyles.labelText.copyWith(
                        color: Colors.red.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withAlpha(25),
                      Theme.of(context).colorScheme.primary.withAlpha(13),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withAlpha(51),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      color: Theme.of(context).colorScheme.primary,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'We usually reply within 24 hours',
                      style: AppTextStyles.cardTitle.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.cardTitle.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  )),
                  const SizedBox(height: 4),
                  Text(value, style: AppTextStyles.labelText.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
                  )),
                ],
              ),
            ),
            Icon(
              Icons.copy,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(128),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
