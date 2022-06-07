import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DarkTheme {
  static ThemeData get get {
    return ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: Colors.black,
        ),
      ),
      textTheme: GoogleFonts.droidSansTextTheme(
        const TextTheme(
            bodyText1: TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
            bodyText2: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
            headline6: TextStyle(
              fontSize: 20,
              color: Colors.white,
            )),
      ),
    );
  }
}
