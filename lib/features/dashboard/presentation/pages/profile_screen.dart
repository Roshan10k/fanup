import 'dart:io';
import 'package:fanup/app/routes/app_routes.dart';
import 'package:fanup/core/api/api_endpoints.dart';
import 'package:fanup/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  File? _selectedImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // Reload user data from local storage when screen comes into focus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider.notifier).getCurrentUser();
    });
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _getImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _getImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      
      if (mounted) {
        await _uploadImage();
      }
    }
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      
      if (mounted) {
        await _uploadImage();
      }
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() => _isUploading = true);

    await ref.read(authViewModelProvider.notifier).uploadProfilePhoto(
      _selectedImage!.path,
    );

    setState(() => _isUploading = false);

    // Check if upload succeeded
    final authState = ref.read(authViewModelProvider);
    if (authState.errorMessage != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${authState.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (authState.authEntity?.profileImageUrl != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile photo updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      // Clear local image since it's now on server
      setState(() => _selectedImage = null);
    }
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
    final profileImageUrl = authState.authEntity?.profileImageUrl;
    
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
          Stack(
            children: [
              // Profile Image or Avatar
              if (_selectedImage != null || profileImageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          profileImageUrl!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Image load error: $error');
                            print('Attempted URL: $profileImageUrl');
                            return _buildPlaceholderAvatar();
                          },
                        ),
                )
              else
                _buildPlaceholderAvatar(),
              
              // Edit Button
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _isUploading ? null : _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA726),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: _isUploading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(authState.authEntity?.fullName ?? "User", style: AppTextStyles.sectionTitle),
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
    final fullName = ref.read(authViewModelProvider).authEntity?.fullName ?? "User";
    final initials = fullName.split(' ').map((e) => e[0]).join().toUpperCase();
    
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
    final email = authState.authEntity?.email ?? "user@example.com";

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
          Text(
            "Contact Information",
            style: AppTextStyles.cardTitle,
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.email_outlined, email),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.phone_outlined, "+977 1235456789"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.textSecondary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: AppTextStyles.cardSubtitle),
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
            title: "Personal Details",
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.shield_outlined,
            title: "Privacy and Security",
            onTap: () {},
          ),
          _buildDivider(),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: "Help and Support",
            onTap: () {},
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
      borderRadius: BorderRadius.circular(16),
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
            Expanded(
              child: Text(title, style: AppTextStyles.menuItemTitle),
            ),
            Icon(Icons.chevron_right, color: AppColors.textLight, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 70),
      child: Divider(
        height: 1,
        thickness: 1,
        color: AppColors.dividerGrey,
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
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text("Logout", style: AppTextStyles.sectionTitle),
              content: Text(
                "Are you sure you want to logout?",
                style: AppTextStyles.cardSubtitle,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await ref.read(authViewModelProvider.notifier).logoutUser();
                    if (context.mounted) {
                AppRoutes.pushAndRemoveUntil(context, const LoginPage());
              }
                  },
                  child: Text(
                    "Logout",
                    style: AppTextStyles.cardTitle.copyWith(
                      color: Colors.red,
                    ),
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
          children: [
            const Icon(Icons.logout, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              "Logout",
              style: AppTextStyles.menuItemTitle.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}