import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class AppTheme {
//   static ThemeData darkTheme = ThemeData.dark().copyWith(
//     scaffoldBackgroundColor: const Color(0xFF0D1F1C),
//     textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
//     appBarTheme: const AppBarTheme(
//       backgroundColor: Color.fromARGB(255, 1, 46, 43),
//     ),
//     colorScheme: const ColorScheme.dark(
//       primary: Color(0xFF00FFB2),
//       secondary: Color(0xFF00F0FF),
//     ),
//   );

//   static ThemeData lightTheme = ThemeData.light().copyWith(
//     scaffoldBackgroundColor: const Color(0xFFF5F5F5),
//     textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
//     appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFE6F4F2)),
//     colorScheme: const ColorScheme.dark(
//       primary: Color(0xFF00FFB2),
//       secondary: Color(0xFF00F0FF),
//     ),
//   );
// }

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.greenAccent,
    // iconTheme: Colors.black,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),

    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: Colors.black87,
      displayColor: Colors.black87,
    ),

    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Colors.blue.withOpacity(0.4),
      cursorColor: Colors.blue,
      selectionHandleColor: Colors.blue,
    ),

    colorScheme: ColorScheme.light(
      surface: Colors.white,
      background: const Color(0xFFF5F5F5),
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      primary: const Color(0xFFF5F5F5),
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    // primaryColor: const Color(0xFF00FFB2),
    primaryColor: const Color(0xFF00FFB2),
    // secondaryColor: Colors.black,
    scaffoldBackgroundColor: const Color(0xFF0D1F1C),

    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: Colors.white, displayColor: Colors.white),

    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Colors.blue.withOpacity(0.4),
      cursorColor: Colors.blue,
      selectionHandleColor: Colors.blue,
    ),
    colorScheme: ColorScheme.dark(
      // surface: const Color(0xFF1A1F2B),
      // background: const Color(0xFF0B1220),
      // onSurface: Colors.white70,
      // onBackground: Colors.white70,
      background: Color(0xFF0D1F1C),
      surface: Color(0xFF132A26),

      onSurface: Colors.white70,
      onBackground: Colors.white70,

      secondary: Color(0xFF00E6A0),
      primary: const Color(0xFF0A1A17),
    ),
  );
}
