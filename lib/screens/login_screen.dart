import 'package:fanup/screens/bottom_navigation_screen.dart';
import 'package:fanup/screens/signup_screen.dart';
import 'package:fanup/themes/theme.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isTablet = constraints.maxWidth >= 600;

            // Responsive sizing
            final double horizontalPadding =
                isTablet ? constraints.maxWidth * 0.2 : constraints.maxWidth * 0.08;
            final double logoHeight = isTablet ? constraints.maxHeight * 0.3 : constraints.maxHeight * 0.25;
            final double spacingSmall = isTablet ? constraints.maxHeight * 0.02 : constraints.maxHeight * 0.01;
            final double spacingMedium = isTablet ? constraints.maxHeight * 0.04 : constraints.maxHeight * 0.02;
            final double spacingLarge = isTablet ? constraints.maxHeight * 0.06 : constraints.maxHeight * 0.05;
            final double buttonHeight = isTablet ? constraints.maxHeight * 0.07 : constraints.maxHeight * 0.065;
            final double fontSizeWelcome = isTablet ? 32 : 28;
            final double fontSizeSubtitle = isTablet ? 18 : 16;
            final double fontSizeSignUp = isTablet ? 20 : 18;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: SizedBox(
                  height: constraints.maxHeight * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Image.asset(
                        "assets/images/logo.png",
                        height: logoHeight,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: spacingMedium),

                      // Welcome text
                      Text(
                        "Welcome back!",
                        style: AppTextStyles.poppinsBold28.copyWith(
                          color: AppColors.textDark,
                          fontSize: fontSizeWelcome,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: spacingSmall),

                      // Subtitle
                      Text(
                        "Log in to existing FanUp account",
                        style: AppTextStyles.poppinsRegular16.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: fontSizeSubtitle,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: spacingLarge),

                      // Username
                      TextFormField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: AppColors.iconGrey,
                          ),
                          labelText: "Username",
                          filled: true,
                          fillColor: AppColors.inputBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      SizedBox(height: spacingMedium),

                      // Password
                      TextFormField(
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
                            color: AppColors.iconGrey,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.iconGrey,
                            ),
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
                      ),

                      SizedBox(height: spacingLarge),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: buttonHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BottomNavigationScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            textStyle: AppTextStyles.buttonText,
                          ),
                          child: const Text("Login"),
                        ),
                      ),

                      SizedBox(height: spacingMedium),

                      // Sign Up Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an Account? ",
                            style: AppTextStyles.poppinsRegular15.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: fontSizeSubtitle,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: AppTextStyles.poppinsBold28.copyWith(
                                color: AppColors.primary,
                                fontSize: fontSizeSignUp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
