import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
      surface: Colors.grey.shade300, // Slightly lighter for better contrast
      primary: Colors.grey.shade500, // Warmer primary color
      secondary: Colors.grey.shade300, // Lighten secondary slightly
      tertiary: Colors.grey.shade50, // Keep white for clean look
      inversePrimary:
          Colors.grey.shade900 // Darker shade for better text contrast
      ),
);
