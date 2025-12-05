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
      backgroundColor: Colors.white,
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
                const Text(
                  "Let's Get Started!",
                  style: TextStyle(
                    fontFamily: "assets/fonts/Poppins-Bold.ttf",
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: size.height * 0.01),

                const Text(
                  "Create an account on FanUp to get all features",
                  style: TextStyle(
                    fontFamily: "assets/fonts/Poppins-Regular.ttf",
                    fontSize: 16,
                    color: Colors.black54,
                  ),
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
                      _isConfirmPasswordVisible =
                          !_isConfirmPasswordVisible;
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
                      backgroundColor: const Color(0xFFFE304C),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontFamily: "assets/fonts/Poppins-SemiBold.ttf",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.04),

                // Already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontFamily: "assets/fonts/Poppins-Regular.ttf",
                        fontSize: 15,
                        color: Colors.black54,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontFamily: "assets/fonts/Poppins-Bold.ttf",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFE304C),
                        ),
                      ),
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
        prefixIcon: Icon(icon, color: Colors.grey),
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: "assets/fonts/Poppins-Regular.ttf",
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
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
            color: Colors.grey,
          ),
          onPressed: onPressed,
        ),
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: "assets/fonts/Poppins-Regular.ttf",
        ),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
