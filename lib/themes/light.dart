import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LightTheme {
  static ThemeData get get {
    return ThemeData.light().copyWith(
      brightness: Brightness.light,
      backgroundColor: const Color(0xFFFFFFFA),
      scaffoldBackgroundColor: const Color(0xFFFFFFFA),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: const Color(0xFFFFFFFA),
        iconTheme: const IconThemeData(
          color: Colors.lightBlueAccent,
        ),
        titleTextStyle: GoogleFonts.openSans(
          color: Colors.black,
          fontSize: 28,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: Colors.blue,
        ),
      ),
      textTheme: GoogleFonts.openSansTextTheme(
        ThemeData.light().textTheme,
      ),
    );
  }
}
