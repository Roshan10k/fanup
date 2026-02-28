import 'package:fanup/app/routes/app_routes.dart';
import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/core/api/api_endpoints.dart';
import 'package:fanup/core/providers/sensor_provider.dart';
import 'package:fanup/core/providers/theme_provider.dart';
import 'package:fanup/core/utils/responsive_utils.dart';
import 'package:fanup/features/auth/presentation/pages/login_page.dart';
import 'package:fanup/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:fanup/features/dashboard/presentation/pages/edit_profile_screen.dart';
import 'package:fanup/features/dashboard/presentation/pages/change_password_screen.dart';
import 'package:fanup/features/dashboard/presentation/pages/help_support_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider.notifier).getCurrentUser();
      ref.read(shakeEnabledProvider.notifier).setEnabled(true);
    });
  }

  @override
  void dispose() {
    ref.read(shakeEnabledProvider.notifier).setEnabled(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sensorState = ref.watch(sensorProvider);
    final privacyShieldOn = sensorState.isNear ?? false;

    // Listen for shake events to navigate to help screen
    ref.listen<int>(
      shakeEventProvider,
      (prev, next) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HelpSupportScreen(),
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(privacyShieldOn),
              const SizedBox(height: 24),
              _buildProfileCard(privacyShieldOn),
              const SizedBox(height: 16),
              _buildContactCard(privacyShieldOn),
              const SizedBox(height: 24),
              _buildMenuItems(),
              const SizedBox(height: 24),
              _buildLogoutButton(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool privacyShieldOn) {
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
          Text("Profile", style: AppTextStyles.headerTitle.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          )),
          const SizedBox(height: 4),
          Text("Manage your account", style: AppTextStyles.headerSubtitle),
          if (privacyShieldOn) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Privacy shield active',
                    style: AppTextStyles.poppinsSemiBold13.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileCard(bool privacyShieldOn) {
    final authState = ref.watch(authViewModelProvider);
    final fontScale = context.fontScale;

    // Full profile image URL from backend (filename stored in profilePicture)
    final profilePictureFileName = authState.authEntity?.profilePicture;

    final profilePictureUrl = profilePictureFileName != null
        ? "${ApiEndpoints.mediaServerUrl}/uploads/profile-pictures/$profilePictureFileName"
        : null;

    final avatarSize = 100.0 * fontScale;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20 * fontScale),
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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(avatarSize),
            child: profilePictureUrl != null
                ? Image.network(
                    profilePictureUrl,
                    width: avatarSize,
                    height: avatarSize,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: avatarSize,
                        height: avatarSize,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) {
                      return _buildPlaceholderAvatar(avatarSize);
                    },
                  )
                : _buildPlaceholderAvatar(avatarSize),
          ),
          SizedBox(height: 14 * fontScale),
          Text(
            authState.authEntity?.fullName ?? "User",
            style: AppTextStyles.sectionTitle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16 * fontScale,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            privacyShieldOn
                ? _maskEmail(authState.authEntity?.email ?? "user@example.com")
                : (authState.authEntity?.email ?? "user@example.com"),
            style: AppTextStyles.labelText.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
              fontSize: 12 * fontScale,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderAvatar([double? customSize]) {
    final size = customSize ?? 100.0;
    final fullName =
        ref.read(authViewModelProvider).authEntity?.fullName ?? "User";

    final initials = fullName
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0])
        .join()
        .toUpperCase();

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: const Color(0xFFFFA726),
      child: Text(
        initials.length > 2 ? initials.substring(0, 2) : initials,
        style: AppTextStyles.amountLarge.copyWith(
          fontSize: size * 0.3,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildContactCard(bool privacyShieldOn) {
    final authState = ref.watch(authViewModelProvider);
    final phone = authState.authEntity?.phone;
    final fontScale = context.fontScale;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16 * fontScale),
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
          Text(
            "Contact Information",
            style: AppTextStyles.cardTitle.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14 * fontScale,
            ),
          ),
          SizedBox(height: 14 * fontScale),
          _buildInfoRow(
            Icons.email_outlined,
            privacyShieldOn
                ? _maskEmail(authState.authEntity?.email ?? "user@example.com")
                : (authState.authEntity?.email ?? "user@example.com"),
          ),
          SizedBox(height: 10 * fontScale),
          _buildInfoRow(
            Icons.phone_outlined,
            phone != null && phone.isNotEmpty
                ? (privacyShieldOn ? _maskPhone(phone) : phone)
                : "Not added",
            isPlaceholder: phone == null || phone.isEmpty,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isPlaceholder = false}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tileBackground = isDark
        ? theme.colorScheme.surfaceContainerHighest
        : theme.scaffoldBackgroundColor;
    final iconColor = isDark
      ? theme.colorScheme.onSurface
      : theme.colorScheme.onSurface.withAlpha(153);
    final textColor = isDark
        ? theme.colorScheme.onSurface
        : theme.colorScheme.onSurface.withAlpha(179);
    final fontScale = context.fontScale;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(7 * fontScale),
          decoration: BoxDecoration(
            color: tileBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18 * fontScale, color: iconColor),
        ),
        SizedBox(width: 10 * fontScale),
        Expanded(
          child: Text(
            text,
            style: isPlaceholder
                ? AppTextStyles.cardSubtitle.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(128),
                    fontStyle: FontStyle.italic,
                    fontSize: 12 * fontScale,
                  )
                : AppTextStyles.cardSubtitle.copyWith(
                    color: textColor,
                    fontSize: 12 * fontScale,
                  ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return '***';
    final local = parts[0];
    final domain = parts[1];
    if (local.length <= 2) return '**@$domain';
    return '${local.substring(0, 2)}***@$domain';
  }

  String _maskPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return '***';
    if (digits.length <= 2) return '**';
    return '*** *** ${digits.substring(digits.length - 2)}';
  }

  Widget _buildMenuItems() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
        children: [
          _buildMenuItem(
            icon: Icons.person_outline,
            title: "Edit Profile",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const EditProfileScreen(),
              ),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.lock_outline,
            title: "Change Password",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ChangePasswordScreen(),
              ),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: "Help and Support",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HelpSupportScreen(),
              ),
            ),
          ),
          _buildDivider(),
          _buildThemeToggleItem(),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tileBackground = isDark
        ? theme.colorScheme.surfaceContainerHighest
        : theme.scaffoldBackgroundColor;
    final iconColor = isDark
      ? theme.colorScheme.onSurface
      : theme.colorScheme.onSurface.withAlpha(153);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: tileBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: AppTextStyles.menuItemTitle.copyWith(
              color: theme.colorScheme.onSurface,
            ))),
            Icon(Icons.chevron_right, color: theme.colorScheme.onSurface.withAlpha(160), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 70),
      child: Divider(height: 1, thickness: 1, color: Theme.of(context).dividerColor),
    );
  }

  Widget _buildThemeToggleItem() {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final themeNotifier = ref.read(themeModeProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              size: 24,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Dark Mode",
              style: AppTextStyles.menuItemTitle.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Switch(
            value: isDarkMode,
            onChanged: (_) => themeNotifier.toggleTheme(),
            activeThumbColor: LightColors.primary,
            activeTrackColor: LightColors.primary.withAlpha(128),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Logout"),
              content: const Text("Are you sure you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await ref.read(authViewModelProvider.notifier).logoutUser();
                    if (!mounted) return;
                    AppRoutes.pushAndRemoveUntil(context, const LoginPage());
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.red, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text(
              "Logout",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
