// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pro/component/my_button.dart';
import 'package:pro/component/my_loading_circle.dart';
import 'package:pro/component/my_text_field.dart';
import 'package:pro/pages/forgot_pass_page.dart';
import 'package:pro/services/Auth/auth_services.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Access the auth service
  final _auth = AuthService();
  // Text controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  // Password visibility toggle
  bool isPasswordVisible = false; // For password visibility

  // Login method
  void login() async {
    try {
      showLoadingCircle(context);

      await _auth.loginEmailPassword(emailController.text, pwController.text);
      Navigator.of(context).pushReplacementNamed('/authGet');

      if (mounted) {
        hideLoadingCircle(context);
      }
    } catch (e) {
      if (mounted) {
        hideLoadingCircle(context);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    }
  }

  // Build UI
  @override
  Widget build(BuildContext context) {
    // Scaffold
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  // Logo
                  Icon(
                    Icons.lock_open,
                    size: 75,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(height: 50),
                  // Welcome text
                  Text(
                    "Welcome to ESSGI",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Email text field
                  MyTextField(
                      controller: emailController,
                      hintText: "Enter Email",
                      obscureText: false),
                  const SizedBox(height: 20),
                  // Password text field with visibility toggle
                  MyTextField(
                    controller: pwController,
                    hintText: "Enter your password",
                    obscureText: !isPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Forgot password
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassPage()),
                      );
                    },
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Sign in button
                  MyButton(text: "Login", onTap: login),
                  const SizedBox(height: 50),
                  // Not registered? Register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "I don't have an account?",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      // User can tap this to go to the register page
                      GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            " Register Now",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
