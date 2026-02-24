import 'package:fanup/app/routes/app_routes.dart';
import 'package:fanup/app/themes/theme.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildProfileCard(),
              const SizedBox(height: 16),
              _buildContactCard(),
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
          Text("Profile", style: AppTextStyles.headerTitle),
          const SizedBox(height: 4),
          Text("Manage your account", style: AppTextStyles.headerSubtitle),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    final authState = ref.watch(authViewModelProvider);

    // Full profile image URL from backend (filename stored in profilePicture)
    final profilePictureFileName = authState.authEntity?.profilePicture;

    final profilePictureUrl = profilePictureFileName != null
        ? "http://10.0.2.2:3001/uploads/profile-pictures/$profilePictureFileName"
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: profilePictureUrl != null
                ? Image.network(
                    profilePictureUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: 120,
                        height: 120,
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
                      return _buildPlaceholderAvatar();
                    },
                  )
                : _buildPlaceholderAvatar(),
          ),
          const SizedBox(height: 16),
          Text(
            authState.authEntity?.fullName ?? "User",
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: 4),
          Text(
            authState.authEntity?.email ?? "user@example.com",
            style: AppTextStyles.labelText,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderAvatar() {
    final fullName =
        ref.read(authViewModelProvider).authEntity?.fullName ?? "User";

    final initials = fullName
        .split(' ')
        .where((e) => e.isNotEmpty)
        .map((e) => e[0])
        .join()
        .toUpperCase();

    return CircleAvatar(
      radius: 60,
      backgroundColor: const Color(0xFFFFA726),
      child: Text(
        initials.length > 2 ? initials.substring(0, 2) : initials,
        style: AppTextStyles.amountLarge.copyWith(
          fontSize: 36,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    final authState = ref.watch(authViewModelProvider);
    final phone = authState.authEntity?.phone;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Contact Information", style: AppTextStyles.cardTitle),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.email_outlined,
            authState.authEntity?.email ?? "user@example.com",
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.phone_outlined,
            phone != null && phone.isNotEmpty ? phone : "Not added",
            isPlaceholder: phone == null || phone.isEmpty,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isPlaceholder = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: isPlaceholder
                ? AppTextStyles.cardSubtitle.copyWith(
                    color: AppColors.textLight,
                    fontStyle: FontStyle.italic,
                  )
                : AppTextStyles.cardSubtitle,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 24, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: AppTextStyles.menuItemTitle)),
            Icon(Icons.chevron_right, color: AppColors.textLight, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 70),
      child: Divider(height: 1, thickness: 1, color: AppColors.dividerGrey),
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
                    if (context.mounted) {
                      AppRoutes.pushAndRemoveUntil(context, const LoginPage());
                    }
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
