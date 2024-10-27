// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscuretext;
  final String? Function(String?)? validator;
  final int? maxLine;
  final Widget? suffixIcon; // Add this line

  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscuretext,
    this.validator,
    this.maxLine,
    this.suffixIcon, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscuretext,
      maxLines: maxLine ?? 1, // Set maxLines to 1 by default
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
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        suffixIcon: suffixIcon, // Add this line
      ),
    );
  }
}
