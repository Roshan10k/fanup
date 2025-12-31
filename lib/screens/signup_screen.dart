import 'package:fanup/themes/theme.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;

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

              Image.asset("assets/images/logo.png", height: 120),

              const SizedBox(height: 16),

              Text(
                "Let’s Get Started!",
                style: AppTextStyles.poppinsBold28,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                "Create an account on FanUp",
                style: AppTextStyles.poppinsRegular16.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              _inputField("Full Name", Icons.person_outline),
              const SizedBox(height: 16),

              _inputField(
                "Email",
                Icons.email_outlined,
                inputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              _passwordField(
                label: "Password",
                isVisible: _isPasswordVisible,
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 16),

              _passwordField(
                label: "Confirm Password",
                isVisible: _isConfirmPasswordVisible,
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible =
                        !_isConfirmPasswordVisible;
                  });
                },
              ),

              const SizedBox(height: 20),

              // Terms
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    activeColor: AppColors.primary,
                    onChanged: (value) {
                      setState(() {
                        _agreeToTerms = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.poppinsRegular16.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          const TextSpan(text: "I agree to the "),
                          TextSpan(
                            text: "Terms of Service",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _agreeToTerms ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    "Sign Up",
                    style: AppTextStyles.buttonText,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: AppTextStyles.poppinsRegular15.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Login",
                      style: AppTextStyles.poppinsBold24.copyWith(
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

  Widget _inputField(
    String label,
    IconData icon, {
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
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

  Widget _passwordField({
    required String label,
    required bool isVisible,
    required VoidCallback onPressed,
  }) {
    return TextFormField(
      obscureText: !isVisible,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: onPressed,
        ),
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
}
