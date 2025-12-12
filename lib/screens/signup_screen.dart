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
    final size = MediaQuery.of(context).size; // For responsiveness

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.04),

                // Logo
                Image.asset(
                  "assets/images/logo.png",
                  height: size.height * 0.15,
                ),

                SizedBox(height: size.height * 0.01),

                // Welcome text
                Text(
                  "Let's Get Started!",
                  style: AppTextStyles.poppinsBold28,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: size.height * 0.01),

                Text(
                  "Create an account on FanUp to get all features",
                  style: AppTextStyles.poppinsRegular16.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: size.height * 0.04),

                // First Name
                _buildInputField("First Name", Icons.person_outline),
                SizedBox(height: size.height * 0.02),

                // Last Name
                _buildInputField("Last Name", Icons.person_outline),
                SizedBox(height: size.height * 0.02),

                // Username
                _buildInputField("User Name", Icons.person_outline),
                SizedBox(height: size.height * 0.02),

                // Email
                _buildInputField("Email", Icons.email_outlined,
                    inputType: TextInputType.emailAddress),
                SizedBox(height: size.height * 0.02),

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
                SizedBox(height: size.height * 0.02),

                // Confirm Password
                _passwordField(
                  label: "Confirm Password",
                  isVisible: _isConfirmPasswordVisible,
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),

                SizedBox(height: size.height * 0.05),

                // Sign Up button
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.065,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Sign Up",
                      style: AppTextStyles.buttonText,
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.04),

                // Already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppTextStyles.poppinsRegular15.copyWith(color: AppColors.textSecondary),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
  "Login",
  style: AppTextStyles.poppinsBold28.copyWith(fontSize: 18, color: AppColors.primary),
)
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, IconData icon,
      {TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.iconGrey),
        labelText: label,
        labelStyle: AppTextStyles.poppinsRegular16.copyWith(color: AppColors.textLight),
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
        labelStyle: AppTextStyles.poppinsRegular16.copyWith(color: AppColors.textLight),
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
