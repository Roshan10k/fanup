import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fanup/app/routes/app_routes.dart';
import 'package:fanup/app/themes/theme.dart';
import 'package:fanup/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:fanup/features/auth/presentation/state/auth_state.dart';
import 'package:fanup/features/auth/presentation/widgets/google_sign_in_button.dart';
import 'package:fanup/features/dashboard/presentation/pages/dashboard_page.dart';
import '../pages/signup_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar('Please fill all fields');
      return;
    }

    setState(() => _isLoading = true);

    await ref
        .read(authViewModelProvider.notifier)
        .loginUser(email, password);

    final state = ref.read(authViewModelProvider);

    if (!mounted) return;

    if (state.status == AuthStatus.authenticated) {
      AppRoutes.pushReplacement(context, const BottomNavigationScreen());
    } else if (state.status == AuthStatus.error) {
      _showSnackbar(state.errorMessage ?? 'Login failed');
    }

    setState(() => _isLoading = false);
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isGoogleLoading = true);

    await ref.read(authViewModelProvider.notifier).loginWithGoogle();

    final state = ref.read(authViewModelProvider);

    if (!mounted) return;

    if (state.status == AuthStatus.authenticated) {
      AppRoutes.pushReplacement(context, const BottomNavigationScreen());
      return;
    } else if (state.status == AuthStatus.error) {
      _showSnackbar(state.errorMessage ?? 'Google sign-in failed');
    }

    if (mounted) setState(() => _isGoogleLoading = false);
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateToSignup() {
    AppRoutes.push(context, const SignUpScreen());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final secondary = onSurface.withAlpha(179);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              Hero(
                tag: 'fanup-logo',
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 220,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Welcome back!',
                style: AppTextStyles.poppinsBold28.copyWith(color: onSurface),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Log in to your FanUp account',
                style: AppTextStyles.poppinsRegular16.copyWith(color: secondary),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Email
              TextFormField(
                key: const Key('email_field'),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration(
                  label: 'Email',
                  icon: Icons.email_outlined,
                ),
              ),

              const SizedBox(height: 16),

              // Password
              TextFormField(
                key: const Key('password_field'),
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: _inputDecoration(
                  label: 'Password',
                  icon: Icons.lock_outline,
                  suffix: IconButton(
                    key: const Key('toggle_password_visibility'),
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Login Button
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  key: const Key('login_button'),
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          'Login',
                          style: AppTextStyles.buttonText,
                        ),
                ),
              ),

              const SizedBox(height: 24),

              const OrDivider(),

              const SizedBox(height: 24),

              GoogleSignInButton(
                key: const Key('google_login_button'),
                onPressed: _handleGoogleLogin,
                isLoading: _isGoogleLoading,
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      "Don't have an account? ",
                      style: AppTextStyles.poppinsRegular15.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    key: const Key('navigate_signup'),
                    onTap: _navigateToSignup,
                    child: Text(
                      'Sign Up',
                      style: AppTextStyles.poppinsSemiBold18.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    final theme = Theme.of(context);
    final fill = theme.inputDecorationTheme.fillColor ?? theme.colorScheme.surface;
    final iconColor = theme.colorScheme.onSurface.withAlpha(179);

    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: iconColor),
      suffixIcon: suffix,
      filled: true,
      fillColor: fill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
