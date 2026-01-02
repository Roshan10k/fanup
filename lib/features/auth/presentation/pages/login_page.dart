import 'package:fanup/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:fanup/features/dashboard/bottom_navigation_screen.dart';
import 'package:fanup/app/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/signup_page.dart';
import '../state/auth_state.dart';


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
      _showSnackbar("Please fill all fields");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Call  Riverpod login function
    await ref.read(authViewModelProvider.notifier).loginUser(email, password);

    final state = ref.read(authViewModelProvider);

    if (state.status == AuthStatus.authenticated) {
      // Navigate to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavigationScreen()),
      );
    } else if (state.status == AuthStatus.error) {
      _showSnackbar(state.errorMessage ?? "Login failed");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignUpScreen()),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset("assets/images/logo.png", height: 220),
              const SizedBox(height: 24),
              Text(
                "Welcome back!",
                style: AppTextStyles.poppinsBold28,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Log in to your FanUp account",
                style: AppTextStyles.poppinsRegular16.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _inputField(
                "Email",
                Icons.email_outlined,
                controller: _emailController,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _passwordField(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
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
                          "Login",
                          style: AppTextStyles.buttonText,
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account? ",
                    style: AppTextStyles.poppinsRegular15.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: _navigateToSignup,
                    child: Text(
                      "Sign Up",
                      style: AppTextStyles.poppinsSemiBold18.copyWith(
                        color: AppColors.primary,
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

  Widget _inputField(String label, IconData icon,
      {TextInputType inputType = TextInputType.text,
      required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.iconGrey),
        labelText: label,
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon:
              Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        labelText: "Password",
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
