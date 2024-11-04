import 'package:flutter/material.dart';
import 'package:pro/component/my_text_field.dart';
import 'package:pro/pages/login_page.dart';
import 'package:pro/services/Auth/auth_services.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _sendPasswordResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _auth.sendPasswordResetEmail(_emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Password reset link sent to ${_emailController.text}")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(onTap: () {})),
      );
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to send reset email. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter your email to receive a password reset link.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: _emailController,
                hintText: 'Enter your email',
                obscureText: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email address';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _errorMessage != null
                  ? Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    )
                  : Container(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _sendPasswordResetEmail,
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : const Text('Send Password Reset Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
