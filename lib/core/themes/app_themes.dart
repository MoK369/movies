import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static const Color darkPrimaryColor = Color(0xFF121312);
  static const Color darkOnPrimaryColor = Color(0xFFFFB224);
  static const Color darkSecondaryColor = Color(0xFF1A1A1A);

  static final ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: darkPrimaryColor,
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: darkOnPrimaryColor),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: darkSecondaryColor,
          unselectedItemColor: Color(0xFFC6C6C6),
          selectedItemColor: darkOnPrimaryColor),
      appBarTheme: AppBarTheme(
          backgroundColor: darkSecondaryColor,
          foregroundColor: Colors.white,
          titleTextStyle: GoogleFonts.inter(
              fontSize: 24, fontWeight: FontWeight.w400, color: Colors.white)),
      textTheme: TextTheme(
          labelLarge: GoogleFonts.poppins(
              fontSize: 25, fontWeight: FontWeight.w400, color: Colors.white),
          labelMedium: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white),
          labelSmall: GoogleFonts.inter(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white)),
      sliderTheme: const SliderThemeData(
          activeTrackColor: darkOnPrimaryColor,
          activeTickMarkColor: darkOnPrimaryColor,
          thumbColor: darkOnPrimaryColor,
          valueIndicatorColor: darkOnPrimaryColor),
      inputDecorationTheme: InputDecorationTheme(
          fillColor: const Color(0xFF514F4F),
          filled: true,
          border: InputBorder.none,
          prefixIconColor: Colors.white,
          hintStyle:
              TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 18),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.white, width: 1.2)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.white, width: 1.2))));
}
