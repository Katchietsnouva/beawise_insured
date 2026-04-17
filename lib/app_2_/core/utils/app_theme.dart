// lib/utils/app_theme.dart
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColorLight =
      // Color(0xFF007BFF);
      // Color.fromARGB(255, 88, 167, 185);
      Color(0xFF37008C);

  static const Color secondaryColor =
      // Color(0xFF00C6AE);
      Color(0xFF37008C);

  static const Color backgroundColor = Color(0xFFF8F9FA);
  // static const Color surfaceColor = Color.fromARGB(255, 224, 245, 249);
  static const Color surfaceColor = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF343A40);
  static const Color subtleTextColor = Color(0xFF6C757D);
  static const Color surfaceColor_2 = Color.fromARGB(255, 237, 228, 249);
  // static const Color surfaceColor_3 = Color.fromARGB(255, 214, 230, 238);
  static const Color surfaceColor_3 = Color.fromARGB(255, 154, 110, 181);
  // static Color surfaceColor_3 = primaryColorLight.withOpacity(0.9);

  static Color primaryColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? primaryColorLight
      : primaryColorLight.withOpacity(0.8);

  static Color reversedTextColor(BuildContext context) {
    final theme = Theme.of(context);
    return theme.brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  // static ThemeData get theme {
  //   return ThemeData(
  //     primaryColor: primaryColor,
  //     scaffoldBackgroundColor: backgroundColor,
  //     fontFamily: GoogleFonts.poppins().fontFamily,
  //   );
  // }

  static const _light = _ThemeColors(
    primary: Color(0xFF37008C),
    surface: Color(0xFFF5F5F5),
    background: Color(0xFFF8F9FA),
    text: Color(0xFF343A40),
    inputFill: Color(0xFFF1F3F4),
    inputBorder: Color(0xFFBDBDBD),
  );

  static const _dark = _ThemeColors(
    primary: Color(0xFF9E77ED),
    // primary: Color(0xFF37008C),
    surface: Color(0xFF25282D),
    background: Color(0xFF1A1D21),
    text: Color(0xFFE0E0E0),
    inputFill: Color(0xFF303030),
    inputBorder: Color(0xFF616161),
  );

  // --- THEME DATA ---
  static ThemeData get lightTheme => _buildTheme(_light, Brightness.light);
  static ThemeData get darkTheme => _buildTheme(_dark, Brightness.dark);

  // --- CORE BUILDER ---
  static ThemeData _buildTheme(_ThemeColors c, Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      primaryColor: c.primary,
      scaffoldBackgroundColor: c.background,
      fontFamily: 'Roboto',
      cardTheme: CardThemeData(
        color: brightness == Brightness.light ? Colors.white : c.surface,
        elevation: brightness == Brightness.light ? 1 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.primary, width: 2),
        ),
      ),
      textTheme: _textTheme(c.text),
      elevatedButtonTheme: _elevatedButtonTheme(c.primary),
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: c.primary,
        secondary: c.primary,
        surface: c.surface,
        background: c.background,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: c.text,
        onBackground: c.text,
        onError: Colors.white,
      ),
    );
  }

  // --- TEXT THEME ---
  static TextTheme _textTheme(Color textColor) => TextTheme(
    headlineMedium: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w600,
      color: textColor,
      fontSize: 24,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      color: textColor,
      fontSize: 18,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Roboto',
      color: textColor.withOpacity(0.7),
      fontSize: 14,
      height: 1.5,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w600,
      color: Colors.white,
      fontSize: 16,
    ),
  );

  // --- BUTTON THEME ---
  static ElevatedButtonThemeData _elevatedButtonTheme(Color primary) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      );
}

// --- HELPER COLOR HOLDER ---
class _ThemeColors {
  final Color primary, surface, background, text, inputFill, inputBorder;
  const _ThemeColors({
    required this.primary,
    required this.surface,
    required this.background,
    required this.text,
    required this.inputFill,
    required this.inputBorder,
  });
}
