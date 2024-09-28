import 'package:daily_planner/firebase/firebase_account.dart';
import 'package:daily_planner/const/colors.dart';
import 'package:daily_planner/home_screen/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAccount firebaseAccount = FirebaseAccount();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Apply a gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [pastelBlue.withOpacity(0.9), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Image.asset('assets/img_logo/logo.png', height: 150),
                ),

                // Email TextField
                _buildTextField(
                  controller: emailController,
                  label: 'Email', // admin@gmail.com
                  obscureText: false,
                ),

                SizedBox(height: 16),

                // Password TextField
                _buildTextField(
                  controller: passwordController,
                  label: 'Mật khẩu', //123456
                  obscureText: true,
                ),

                SizedBox(height: 20),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    child: Text(
                      'Đăng nhập',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Register Option
                TextButton(
                  onPressed: () {
                    // Add navigation to Register screen
                  },
                  child: Text(
                    'Chưa có tài khoản? Đăng ký',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: pastelBlue),
          ),
        ),
        obscureText: obscureText,
        keyboardType: obscureText
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
      ),
    );
  }

  void _login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Call login method from FirebaseAccount
    UserCredential? userCredential =
        await firebaseAccount.login(email, password);

    if (userCredential != null) {
      // Successful login
      print('Đăng nhập thành công: ${userCredential.user?.email}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      // Failed login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email hoặc mật khẩu không đúng')),
      );
    }
  }

  void _register() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Call register method from FirebaseAccount
    UserCredential? userCredential =
        await firebaseAccount.register(email, password);

    if (userCredential != null) {
      // Successful registration
      print('Đăng ký thành công: ${userCredential.user?.email}');
    } else {
      // Failed registration
      print('Đăng ký không thành công');
    }
  }
}
