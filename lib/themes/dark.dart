import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DarkTheme {
  static ThemeData get get {
    return ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
        ),
      ),
      textTheme: GoogleFonts.droidSansTextTheme(
        const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 15,
            color: Colors.white,
          ),
          displayLarge: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
          labelLarge: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          headlineLarge: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
