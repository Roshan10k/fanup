import 'dart:io';

import 'package:fanup/app/routes/app_routes.dart';
import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/core/utils/snackbar_utils.dart';
import 'package:fanup/features/auth/presentation/pages/login_page.dart';
import 'package:fanup/features/auth/presentation/state/auth_state.dart';
import 'package:fanup/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:fanup/features/dashboard/presentation/widgets/media_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final List<File> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();

  bool _isUploading = false;
  String? _selectedMediaType;

  File? get _selectedImage =>
      _selectedMedia.isNotEmpty ? _selectedMedia.first : null;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authViewModelProvider.notifier).getCurrentUser();
    });
  }

  /* -------------------- Permission Handling -------------------- */

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }

    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Required"),
        content: const Text(
          "This feature requires permission to access your camera or gallery. "
          "Please enable it in your device settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  /* -------------------- Media Pickers -------------------- */

  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);
    if (!hasPermission) return;

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      await _uploadPhoto(File(photo.path));
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        await _uploadPhoto(File(image.path));
      }
    } catch (e) {
      debugPrint('Gallery Error: $e');
      if (mounted) {
        SnackbarUtils.showError(
          context,
          'Unable to access gallery. Please try using the camera instead.',
        );
      }
    }
  }

  Future<void> _uploadPhoto(File photo) async {
    setState(() {
      _isUploading = true;
      _selectedMedia
        ..clear()
        ..add(photo);
      _selectedMediaType = 'photo';
    });

    try {
      await ref.read(authViewModelProvider.notifier).uploadProfilePhoto(photo);
    } catch (e) {
      debugPrint('Upload error in UI: $e');
      if (mounted) {
        setState(() {
          _isUploading = false;
          _selectedMedia.clear();
        });
        SnackbarUtils.showError(context, 'Failed to upload photo');
      }
    }
  }

  void _showMediaPicker() {
    MediaPickerBottomSheet.show(
      context,
      onCameraTap: _pickFromCamera,
      onGalleryTap: _pickFromGallery,
    );
  }

  /* -------------------- UI -------------------- */

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      // Upload success
      if (previous?.status == AuthStatus.loading &&
          next.status == AuthStatus.authenticated) {
        if (_isUploading && mounted) {
          setState(() {
            _isUploading = false;
            _selectedMedia.clear();
          });
          SnackbarUtils.showSuccess(
            context,
            'Profile photo updated successfully!',
          );
        }
      }

      // Upload error
      if (previous?.status == AuthStatus.loading &&
          next.status == AuthStatus.error) {
        if (_isUploading && mounted) {
          setState(() {
            _isUploading = false;
            _selectedMedia.clear();
          });
          SnackbarUtils.showError(
            context,
            next.errorMessage ?? 'Failed to upload profile photo',
          );
        }
      }
    });
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      )
                    : (profilePictureUrl != null
                          ? Image.network(
                              profilePictureUrl,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                              errorBuilder: (_, __, ___) {
                                debugPrint(
                                  'Failed to load image from: $profilePictureUrl',
                                );
                                return _buildPlaceholderAvatar();
                              },
                            )
                          : _buildPlaceholderAvatar()),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _isUploading ? null : _showMediaPicker,
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
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
          _buildInfoRow(Icons.phone_outlined, "+977 1234567890"),
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
          child: Icon(icon, size: 20, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTextStyles.cardSubtitle)),
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
