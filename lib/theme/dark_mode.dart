// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
      surface: Colors.black,
      primary: Colors.grey.shade600,
      secondary: Colors.grey.shade900,
      tertiary: Color.fromARGB(255, 50, 50, 50),
      onPrimary: Colors.green.shade600,
      inversePrimary: Colors.grey.shade200),
);
