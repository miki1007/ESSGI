// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pro/component/my_loading_circle.dart';
import 'package:pro/services/Auth/auth_services.dart';
import 'package:pro/services/database/database_service.dart';

import '../component/my_button.dart';
import '../component/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  // Access the auth & db service
  final _auth = AuthService();
  final _db = DatabaseService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwlController = TextEditingController();
  final TextEditingController confirmPwController = TextEditingController();

  String? selectedRole; // For the dropdown
  bool isPasswordVisible = false; // For password visibility
  bool isConfirmPasswordVisible = false; // For confirm password visibility

  // Register button Tap
  void register() async {
    final adminCount = await _db.countAdmins();

    if (pwlController.text == confirmPwController.text) {
      if (selectedRole == 'Admin' && adminCount >= 3) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Registration Denied"),
            content: const Text(
                "The number of admins has reached the limit: . You can only register as a Technician."),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedRole = 'Technician';
                  });
                  Navigator.of(context).pop();
                },
                child: const Text("Register as Technician"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
            ],
          ),
        );
      } else {
        try {
          showLoadingCircle(context);

          await _auth.registerEmailPassword(
              emailController.text, pwlController.text);

          // Finished loading...
          if (mounted) hideLoadingCircle(context);

          // Once registered, create and save user profile in the database
          await _db.saveUserInfoInFirebase(
            name: nameController.text,
            role: selectedRole ?? 'Technician', // Default to Technician if null
            email: emailController.text,
          );

          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/authGet');
          }
        } catch (e) {
          if (mounted) {
            hideLoadingCircle(context);
          }

          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(e.toString()),
              ),
            );
          }
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match"),
        ),
      );
    }
  }

  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
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
                  const SizedBox(height: 50),
                  Icon(
                    Icons.lock_open,
                    size: 75,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 50),
                  Text(
                    "Create an account",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  MyTextField(
                    controller: nameController,
                    hintText: "Enter name",
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),

                  // Role Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    hint: const Text("Select your role"),
                    items: const [
                      DropdownMenuItem(
                        value: 'Admin',
                        child: Text('Admin'),
                      ),
                      DropdownMenuItem(
                        value: 'Technician',
                        child: Text('Technician'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value;
                      });
                    },
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      fillColor: Theme.of(context).colorScheme.secondary,
                      filled: true,
                      hintText: 'select your role',
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 10),

                  MyTextField(
                    controller: emailController,
                    hintText: "Enter Email",
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),

                  // Password TextField with visibility toggle
                  MyTextField(
                    controller: pwlController,
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
                  const SizedBox(height: 10),

                  // Confirm Password TextField with visibility toggle
                  MyTextField(
                    controller: confirmPwController,
                    hintText: "Confirm your password",
                    obscureText: !isConfirmPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Sign in button
                  MyButton(text: "Register", onTap: register),
                  const SizedBox(height: 50),

                  // Already a member ? Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already a member",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            " Login Now",
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
