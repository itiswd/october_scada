import 'package:flutter/material.dart';

class AppTheme {
  static const Color backgroundColor = Color.fromARGB(255, 251, 250, 251);
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkerBackground = Color(0xFF1C1C1C);
  static const Color cardBackground = Color.fromARGB(255, 25, 25, 25);

  static ThemeData get theme {
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: backgroundColor,
    );
  }
}
