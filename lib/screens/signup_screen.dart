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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isTablet = constraints.maxWidth >= 600;

            // Responsive sizing
            final double horizontalPadding = isTablet
                ? constraints.maxWidth * 0.2
                : constraints.maxWidth * 0.06;
            final double logoHeight = isTablet
                ? constraints.maxHeight * 0.25
                : constraints.maxHeight * 0.12;
            final double spacingExtraSmall = isTablet
                ? constraints.maxHeight * 0.01
                : constraints.maxHeight * 0.01;
            final double spacingSmall = isTablet
                ? constraints.maxHeight * 0.02
                : constraints.maxHeight * 0.02;
            final double spacingMedium = isTablet
                ? constraints.maxHeight * 0.03
                : constraints.maxHeight * 0.04;
            final double spacingLarge = isTablet
                ? constraints.maxHeight * 0.05
                : constraints.maxHeight * 0.05;
            final double buttonHeight = isTablet
                ? constraints.maxHeight * 0.07
                : constraints.maxHeight * 0.065;
            final double fontSizeTitle = isTablet ? 32 : 28;
            final double fontSizeSubtitle = isTablet ? 18 : 16;
            final double fontSizeSignUpLink = isTablet ? 20 : 18;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: spacingMedium),

                    // Logo
                    Image.asset(
                      "assets/images/logo.png",
                      height: logoHeight,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: spacingExtraSmall),

                    // Welcome text
                    Text(
                      "Let's Get Started!",
                      style: AppTextStyles.poppinsBold28.copyWith(
                        fontSize: fontSizeTitle,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: spacingExtraSmall),

                    Text(
                      "Create an account on FanUp to get all features",
                      style: AppTextStyles.poppinsRegular16.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: fontSizeSubtitle,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: spacingMedium),

                    // First Name
                    _buildInputField("First Name", Icons.person_outline),
                    SizedBox(height: spacingSmall),

                    // Last Name
                    _buildInputField("Last Name", Icons.person_outline),
                    SizedBox(height: spacingSmall),

                    // Username
                    _buildInputField("User Name", Icons.person_outline),
                    SizedBox(height: spacingSmall),

                    // Email
                    _buildInputField(
                      "Email",
                      Icons.email_outlined,
                      inputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: spacingSmall),

                    // Password
                    _passwordField(
                      label: "Password",
                      isVisible: _isPasswordVisible,
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    SizedBox(height: spacingSmall),

                    // Confirm Password
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

                    SizedBox(height: spacingLarge),

                    // Sign Up button
                    SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text("Sign Up", style: AppTextStyles.buttonText),
                      ),
                    ),

                    SizedBox(height: spacingMedium),

                    // Already have an account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: AppTextStyles.poppinsRegular15.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: fontSizeSubtitle,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            "Login",
                            style: AppTextStyles.poppinsBold28.copyWith(
                              fontSize: fontSizeSignUpLink,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: spacingMedium),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    IconData icon, {
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.iconGrey),
        labelText: label,
        labelStyle: AppTextStyles.poppinsRegular16.copyWith(
          color: AppColors.textLight,
        ),
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
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.iconGrey,
          ),
          onPressed: onPressed,
        ),
        labelText: label,
        labelStyle: AppTextStyles.poppinsRegular16.copyWith(
          color: AppColors.textLight,
        ),
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
