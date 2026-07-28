import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color deepBlue = Color(0xFF0A2342);
  static const Color deepBlueLight = Color(0xFF143A66);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldMuted = Color(0xFFF0E6C0);
  static const Color offWhite = Color(0xFFF8F9FA);
  static const Color white = Colors.white;
  static const Color slateText = Color(0xFF2D3142);
  static const Color slateMuted = Color(0xFF8E92A4);
  static const Color softError = Color(0xFFC45B5B);
  static const Color success = Color(0xFF4A7C59);
  static const Color divider = Color(0xFFEBE8E1);
}

class AppShadows {
  static BoxShadow level1 = BoxShadow(
    color: AppColors.deepBlue.withOpacity(0.04), blurRadius: 2, offset: const Offset(0, 1));
  static BoxShadow level2 = BoxShadow(
    color: AppColors.deepBlue.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4));
  static BoxShadow level3 = BoxShadow(
    color: AppColors.deepBlue.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 8));
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.offWhite,
      colorScheme: const ColorScheme.light(
        primary: AppColors.deepBlue, secondary: AppColors.gold,
        surface: AppColors.white, background: AppColors.offWhite,
        error: AppColors.softError, onPrimary: AppColors.white,
        onSecondary: AppColors.deepBlue, onSurface: AppColors.slateText,
        onBackground: AppColors.slateText,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0, centerTitle: true, backgroundColor: AppColors.offWhite,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.deepBlue),
        iconTheme: const IconThemeData(color: AppColors.deepBlue),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.deepBlue, letterSpacing: -0.5),
        displayMedium: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.deepBlue, letterSpacing: -0.5),
        titleLarge: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.deepBlue),
        titleMedium: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.slateText),
        bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.slateText, height: 1.5),
        bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.slateMuted, height: 1.4),
        labelLarge: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.white, letterSpacing: 0.5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.deepBlue, foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.deepBlue, side: const BorderSide(color: AppColors.gold, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.gold, textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: AppColors.offWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.divider)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.divider)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.deepBlue, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.softError)),
        hintStyle: GoogleFonts.inter(fontSize: 15, color: AppColors.slateMuted),
      ),
      cardTheme: CardTheme(
        elevation: 0, color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white, selectedItemColor: AppColors.deepBlue, unselectedItemColor: AppColors.slateMuted,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
        type: BottomNavigationBarType.fixed, elevation: 8,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1, space: 1),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating, backgroundColor: AppColors.deepBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentTextStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.white),
      ),
    );
  }
}
