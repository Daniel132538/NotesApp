import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(fontSize: 16),
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    );
  }
}
