import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insured/app_2/core/theme/app_theme.dart' as _SidebarTokens;

class AppColors {
  /// 🔵 BRAND (mapped to your old naming)
  // static const Color favColour = Color(0xFF2A7FAF); // was purple → now blue
  // static const Color favColourDark = Color(0xFF1F5F85); // deeper blue

  static const Color favColour = Color(0xFF2A7FAF); // primary brand blue
  static const Color favColourDark = Color(
    0xFF1F5F85,
  ); // deeper shade of same blue

  static const Color favColour_sec = Color(0xFF6BB7E3); // light blue

  /// 🌑 BACKGROUNDS (unchanged)
  static const Color generalScaffoldBackgroundColor = Color(0xFF0A0F1E);
  static const Color generalScaffoldBackgroundColorlighter = Color(0xFF0C1328);

  /// 🌊 GRADIENTS (same names, new colors)
  static const Color nice_grad_1 = Color(0xFF0A0F1E);
  static const Color nice_grad_2 = Color(0xFF2A7FAF);
  static const Color nice_grad_3 = Color(0xFF6BB7E3);

  /// ✨ ORBS (keep names, fix colors)
  static const Color animatedOrbsGlow = Color(0xFF2A7FAF);
  static const Color animatedOrbsGlow_2 = Color(0xFF6BB7E3);
  static const Color animatedOrbsGlow_3 = Color(0xFF90CAF9);

  /// 📱 ONBOARDING GRADIENTS
  static const List<Color> page1Gradient = [
    Color(0xFF0A0F1E),
    Color(0xFF1A2A3A),
    Color(0xFF2A7FAF),
  ];

  static const List<Color> page2Gradient = [
    Color(0xFF0D1F2B),
    Color(0xFF2A7FAF),
    Color(0xFF6BB7E3),
  ];

  static const List<Color> page3Gradient = [
    Color(0xFF1A1F2F),
    Color(0xFF2A7FAF),
    Color(0xFF6BB7E3),
  ];

  /// 🎯 SIDEBAR
  static const Color sidebarBg = Color(0xFF0E1424);
  static const Color sidebarItem = Color(0xFF121A33);
  static const Color sidebarItemHover = Color(0xFF1A2547);

  static const Color sidebarActive = Color(0xFF2A7FAF);
  static const Color sidebarActiveGlow = Color(0x336BB7E3);

  static const Color sidebarText = Colors.white70;
  static const Color sidebarTextActive = Colors.white;

  /// 🔥 OPTIONAL ACCENTS (NEW but safe to add)
  static const Color accentRed = Color(0xFFC62828);
  static const Color accentOrange = Color(0xFFF4B400);
}

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.favColour,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2A7FAF),
      secondary: Color(0xFF6BB7E3),
      surface: Colors.white,
      background: Color(0xFFF5F5F5),
      onSurface: Colors.black87,
      onBackground: Colors.black87,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.favColour,
    scaffoldBackgroundColor: AppColors.generalScaffoldBackgroundColor,

    colorScheme: ColorScheme.dark(
      primary: AppColors.favColour,
      secondary: AppColors.favColour_sec,
      background: AppColors.generalScaffoldBackgroundColor,
      surface: AppColors.generalScaffoldBackgroundColorlighter,
      onSurface: Colors.white70,
      onBackground: Colors.white70,
    ),
  );
}

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:insured/app_2/core/theme/app_theme.dart' as _SidebarTokens;

// const Color kBrandBlue = Color(0xFF1038B8);
// const Color kBrandPurple = Color(0xFFEF233C); // ← changed to logo red

// const blue = Color(0xFF21409A);
// const purple = Color(0xFFEF233C); // ← changed to logo red

// class AppColors {
//   static Color favColour_sec = Color(0xFF66C6E6);

//   static const Color favColour = _SidebarTokens.purple;
//   static const Color favColourDark = _SidebarTokens.blue;

//   static const Color generalScaffoldBackgroundColor = Color(0xFF0A0F1E);
//   static const Color generalScaffoldBackgroundColorlighter = Color(0xFF0C1328);

//   static const Color nice_grad_1 = Color(0xFF0E1424);
//   static const Color nice_grad_2 = Color(0xFF21409A); // blue kept
//   static const Color nice_grad_3 = Color(0xFFEF233C); // ← changed to logo red

//   static const Color animatedOrbsGlow = Color(
//     0xFF3B6BFF,
//   ); // soft electric blue (kept)
//   static const Color animatedOrbsGlow_2 = Color(0xFFEF233C); // ← now logo red
//   static const Color animatedOrbsGlow_3 = Color(
//     0xFFFF7A7A,
//   ); // ← soft red glow (replaces purple glow)

//   // Gradients for onboarding pages
//   static const List<Color> page1Gradient = [
//     Color.fromARGB(255, 13, 18, 31),
//     Color(0xFF162A3A),
//     Color(0xFF21409A), // blue kept
//   ];

//   static const List<Color> page2Gradient = [
//     Color(0xFF0D1F2B),
//     Color(0xFF1B3C7A),
//     Color(0xFF4A5BD4),
//   ];

//   static const List<Color> page3Gradient = [
//     Color(0xFF1A1F2F),
//     Color(0xFF3A3F8F),
//     Color(0xFFEF233C), // ← changed to logo red
//   ];

//   // Dashboard colors
//   static const Color blue = Color(0xFF3B82F6);
//   static const Color orange = Color(0xFFF97316);
//   static const Color green = Color(0xFF22C55E);
//   static const Color purple = Color(0xFFEF233C); // ← changed to logo red

//   ////side bar
//   static const Color sidebarBg = Color(0xFF0E1424);

//   static const Color sidebarItem = Color(0xFF121A33);
//   static const Color sidebarItemHover = Color(0xFF1A2547);

//   static const Color sidebarActive = Color(0xFF21409A);
//   static const Color sidebarActiveGlow = Color(
//     0x33EF233C,
//   ); // ← changed to logo red (with alpha)

//   static const Color sidebarText = Colors.white70;
//   static const Color sidebarTextActive = Colors.white;

//   ////side bar extra
//   static const Color primaryBlue = Color(0xFF21409A);
//   static const Color accentPurple = Color(
//     0xFFEF233C,
//   ); // ← changed to logo red (variable name kept)
// }

// class AppTheme {
//   static final lightTheme_ = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: kBrandBlue,
//     scaffoldBackgroundColor: const Color(0xFFF5F5F5),

//     textTheme: GoogleFonts.interTextTheme().apply(
//       bodyColor: Colors.black87,
//       displayColor: Colors.black87,
//     ),

//     textSelectionTheme: TextSelectionThemeData(
//       selectionColor: kBrandBlue.withOpacity(0.3),
//       cursorColor: kBrandBlue,
//       selectionHandleColor: kBrandPurple, // now red
//     ),

//     colorScheme: ColorScheme.light(
//       primary: kBrandBlue,
//       secondary: kBrandPurple, // now red
//       surface: Colors.white,
//       background: const Color(0xFFF5F5F5),
//       onSurface: Colors.black87,
//       onBackground: Colors.black87,
//     ),
//   );

//   static final lightTheme = ThemeData(
//     brightness: Brightness.light,
//     primaryColor: const Color(0xFF21409A),
//     scaffoldBackgroundColor: const Color(0xFFF5F5F5),

//     textTheme: GoogleFonts.interTextTheme().apply(
//       bodyColor: Colors.black87,
//       displayColor: Colors.black87,
//     ),

//     textSelectionTheme: TextSelectionThemeData(
//       selectionColor: const Color(
//         0xFFEF233C,
//       ).withOpacity(0.3), // ← now logo red
//       cursorColor: const Color(0xFF21409A),
//       selectionHandleColor: const Color(0xFF21409A),
//     ),

//     colorScheme: const ColorScheme.light(
//       primary: Color(0xFF21409A),
//       secondary: Color(0xFFEF233C), // ← now logo red
//       surface: Colors.white,
//       background: Color(0xFFF5F5F5),
//       onSurface: Colors.black87,
//       onBackground: Colors.black87,
//     ),
//   );

//   static final darkTheme_ = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: kBrandBlue,
//     scaffoldBackgroundColor: AppColors.generalScaffoldBackgroundColor,

//     textTheme: GoogleFonts.interTextTheme(
//       ThemeData.dark().textTheme,
//     ).apply(bodyColor: Colors.white, displayColor: Colors.white),

//     textSelectionTheme: TextSelectionThemeData(
//       selectionColor: kBrandBlue.withOpacity(0.4),
//       cursorColor: kBrandPurple, // now red
//       selectionHandleColor: kBrandPurple, // now red
//     ),

//     colorScheme: ColorScheme.dark(
//       primary: kBrandBlue,
//       secondary: kBrandPurple, // now red
//       background: AppColors.generalScaffoldBackgroundColor,
//       surface: AppColors.generalScaffoldBackgroundColorlighter,
//       onSurface: Colors.white70,
//       onBackground: Colors.white70,
//     ),
//   );

//   static final darkTheme = ThemeData(
//     brightness: Brightness.dark,
//     primaryColor: kBrandBlue,
//     scaffoldBackgroundColor: AppColors.generalScaffoldBackgroundColor,

//     textTheme: GoogleFonts.interTextTheme(
//       ThemeData.dark().textTheme,
//     ).apply(bodyColor: Colors.white, displayColor: Colors.white),

//     textSelectionTheme: TextSelectionThemeData(
//       selectionColor: kBrandBlue.withOpacity(0.4),
//       cursorColor: kBrandPurple, // now red
//       selectionHandleColor: kBrandPurple, // now red
//     ),

//     colorScheme: ColorScheme.dark(
//       primary: kBrandBlue,
//       secondary: kBrandPurple, // now red
//       background: AppColors.generalScaffoldBackgroundColor,
//       surface: AppColors.generalScaffoldBackgroundColorlighter,
//       onSurface: Colors.white70,
//       onBackground: Colors.white70,
//     ),
//   );
// }

// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:insured/app_2/core/theme/app_theme.dart' as _SidebarTokens;

// // const Color kBrandBlue = Color(0xFF2C8CBF); // 🔵 logo blue
// // const Color kBrandPurple = Color(0xFFC0392B); // 🔴 logo red

// // const blue = Color(0xFF2C8CBF);
// // const purple = Color(0xFFC0392B);

// // class AppColors {
// //   static Color favColour_sec = Color(0xFF66C6E6);

// //   static const Color favColour = Color(0xFFC0392B); // 🔴 accent
// //   static const Color favColourDark = Color(0xFF2C8CBF); // 🔵 primary

// //   static const Color generalScaffoldBackgroundColor = Color(0xFF0A0F1E);
// //   static const Color generalScaffoldBackgroundColorlighter = Color(0xFF0C1328);

// //   static const Color nice_grad_1 = Color(0xFF0E1424);
// //   static const Color nice_grad_2 = Color(0xFF2C8CBF); // 🔵
// //   static const Color nice_grad_3 = Color(0xFFC0392B); // 🔴

// //   static const Color animatedOrbsGlow = Color(0xFF4DA3D9); // blue glow
// //   static const Color animatedOrbsGlow_2 = Color(0xFFE74C3C); // red glow
// //   static const Color animatedOrbsGlow_3 = Color(0xFFFF6B5A); // soft red

// //   // Gradients for onboarding pages
// //   static const List<Color> page1Gradient = [
// //     Color.fromARGB(255, 13, 18, 31),
// //     Color(0xFF1C5D7A),
// //     Color(0xFF2C8CBF),
// //   ];

// //   static const List<Color> page2Gradient = [
// //     Color(0xFF0D1F2B),
// //     Color(0xFF2C8CBF),
// //     Color(0xFFE74C3C),
// //   ];

// //   static const List<Color> page3Gradient = [
// //     Color(0xFF1A1F2F),
// //     Color(0xFF7A2C2C),
// //     Color(0xFFC0392B),
// //   ];

// //   // Dashboard colors
// //   static const Color blue = Color(0xFF2C8CBF);
// //   static const Color orange = Color(0xFFE67E22);
// //   static const Color green = Color(0xFF27AE60);
// //   static const Color purple = Color(0xFFC0392B);

// //   /////side bar
// //   static const Color sidebarBg = Color(0xFF0E1424);

// //   static const Color sidebarItem = Color(0xFF121A33);
// //   static const Color sidebarItemHover = Color(0xFF1A2547);

// //   static const Color sidebarActive = Color(0xFF2C8CBF);
// //   static const Color sidebarActiveGlow = Color(0x33C0392B);

// //   static const Color sidebarText = Colors.white70;
// //   static const Color sidebarTextActive = Colors.white;

// //   ////side bar extra
// //   static const Color primaryBlue = Color(0xFF2C8CBF);
// //   static const Color accentPurple = Color(0xFFC0392B);
// // }

// // class AppTheme {
// //   static final lightTheme_ = ThemeData(
// //     brightness: Brightness.light,
// //     primaryColor: kBrandBlue,
// //     scaffoldBackgroundColor: const Color(0xFFF5F5F5),

// //     textTheme: GoogleFonts.interTextTheme().apply(
// //       bodyColor: Colors.black87,
// //       displayColor: Colors.black87,
// //     ),

// //     textSelectionTheme: TextSelectionThemeData(
// //       selectionColor: kBrandBlue.withOpacity(0.3),
// //       cursorColor: kBrandBlue,
// //       selectionHandleColor: kBrandPurple,
// //     ),

// //     colorScheme: ColorScheme.light(
// //       primary: kBrandBlue,
// //       secondary: kBrandPurple,
// //       surface: Colors.white,
// //       background: const Color(0xFFF5F5F5),
// //       onSurface: Colors.black87,
// //       onBackground: Colors.black87,
// //     ),
// //   );

// //   static final lightTheme = ThemeData(
// //     brightness: Brightness.light,
// //     primaryColor: kBrandBlue,
// //     scaffoldBackgroundColor: const Color(0xFFF5F5F5),

// //     textTheme: GoogleFonts.interTextTheme().apply(
// //       bodyColor: Colors.black87,
// //       displayColor: Colors.black87,
// //     ),

// //     textSelectionTheme: TextSelectionThemeData(
// //       selectionColor: kBrandPurple.withOpacity(0.3),
// //       cursorColor: kBrandBlue,
// //       selectionHandleColor: kBrandBlue,
// //     ),

// //     colorScheme: ColorScheme.light(
// //       primary: kBrandBlue,
// //       secondary: kBrandPurple,
// //       surface: Colors.white,
// //       background: const Color(0xFFF5F5F5),
// //       onSurface: Colors.black87,
// //       onBackground: Colors.black87,
// //     ),
// //   );

// //   static final darkTheme_ = ThemeData(
// //     brightness: Brightness.dark,
// //     primaryColor: kBrandBlue,
// //     scaffoldBackgroundColor: AppColors.generalScaffoldBackgroundColor,

// //     textTheme: GoogleFonts.interTextTheme(
// //       ThemeData.dark().textTheme,
// //     ).apply(bodyColor: Colors.white, displayColor: Colors.white),

// //     textSelectionTheme: TextSelectionThemeData(
// //       selectionColor: kBrandBlue.withOpacity(0.4),
// //       cursorColor: kBrandPurple,
// //       selectionHandleColor: kBrandPurple,
// //     ),

// //     colorScheme: ColorScheme.dark(
// //       primary: kBrandBlue,
// //       secondary: kBrandPurple,
// //       background: AppColors.generalScaffoldBackgroundColor,
// //       surface: AppColors.generalScaffoldBackgroundColorlighter,
// //       onSurface: Colors.white70,
// //       onBackground: Colors.white70,
// //     ),
// //   );

// //   static final darkTheme = ThemeData(
// //     brightness: Brightness.dark,
// //     primaryColor: kBrandBlue,
// //     scaffoldBackgroundColor: AppColors.generalScaffoldBackgroundColor,

// //     textTheme: GoogleFonts.interTextTheme(
// //       ThemeData.dark().textTheme,
// //     ).apply(bodyColor: Colors.white, displayColor: Colors.white),

// //     textSelectionTheme: TextSelectionThemeData(
// //       selectionColor: kBrandBlue.withOpacity(0.4),
// //       cursorColor: kBrandPurple,
// //       selectionHandleColor: kBrandPurple,
// //     ),

// //     colorScheme: ColorScheme.dark(
// //       primary: kBrandBlue,
// //       secondary: kBrandPurple,
// //       background: AppColors.generalScaffoldBackgroundColor,
// //       surface: AppColors.generalScaffoldBackgroundColorlighter,
// //       onSurface: Colors.white70,
// //       onBackground: Colors.white70,
// //     ),
// //   );
// // }

// // // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // // import 'package:insured/app_2/core/theme/app_theme.dart' as _SidebarTokens;

// // // const Color kBrandBlue = Color(0xFF1038B8);
// // // const Color kBrandPurple = Color(0xFFA058E0);

// // // const blue = Color(0xFF21409A);
// // // const purple = Color(0xFF8E5CCB);

// // // // class AppColors {
// // // //   // 🔵 Brand colors (from logo)
// // // //   static const Color primaryBlue = Color(0xFF21409A);
// // // //   static const Color accentPurple = Color(0xFF8E5CCB);

// // // //   // 🌑 Dark UI base (for depth)
// // // //   static const Color darkBackground = Color(0xFF0D1F1C);
// // // //   static const Color darkSurface = Color(0xFF132A26);

// // // //   // ✨ Gradient (BEST LOOK for your app)
// // // //   static const List<Color> mainGradient = [
// // // //     Color(0xFF0D1F1C), // deep base
// // // //     Color(0xFF21409A), // blue
// // // //     Color(0xFF8E5CCB), // purple
// // // //   ];

// // // //   // Optional variations
// // // //   static const List<Color> softGradient = [
// // // //     Color(0xFF21409A),
// // // //     Color(0xFF8E5CCB),
// // // //   ];

// // // //   // Text colors
// // // //   static const Color textLight = Colors.white;
// // // //   static const Color textDim = Colors.white70;
// // // // }

// // // class AppColors {
// // //   // static const Color generalScaffoldBackgroundColor = Color(0xFF0D1F1C);
// // //   // static const Color generalScaffoldBackgroundColor = Color.fromARGB(
// // //   //   255,
// // //   //   31,
// // //   //   25,
// // //   //   13,
// // //   // );

// // //   // static const Color favColour = Colors.greenAccent;
// // //   // static Color favColourDark = Colors.green[900]!;
// // //   static Color favColour_sec = Color(0xFF66C6E6); //0xFF00FFB2

// // //   static const Color favColour = _SidebarTokens.purple;
// // //   static const Color favColourDark = _SidebarTokens.blue;
// // //   // 0xFF66E6C9

// // //   // static const Color generalScaffoldBackgroundColor = Color(
// // //   //     0xFF132A26,
// // //   //   );

// // //   static const Color generalScaffoldBackgroundColor = Color(0xFF0A0F1E);
// // //   static const Color generalScaffoldBackgroundColorlighter = Color(0xFF0C1328);

// // //   // static const Color nice_grad_1 = Color(0xFF0D1F1C);
// // //   // static const Color nice_grad_2 = Color(0xFF145A32); // emerald
// // //   // static const Color nice_grad_3 = Color(0xFF0F3D3E); // teal

// // //   static const Color nice_grad_1 = Color(0xFF0E1424); // deep base
// // //   static const Color nice_grad_2 = Color(0xFF21409A); // blue
// // //   static const Color nice_grad_3 = Color(0xFF8E5CCB); // purple

// // //   // // static const Color animatedOrbsGlow = Color(0xFF00FFB2); // mint
// // //   // // static const Color animatedOrbsGlow_2 = Color(0xFF00F0FF); // cyan
// // //   // // static const Color animatedOrbsGlow_3 = Color(0xFFB2FF00); // Lime/Neon Green.

// // //   // static const Color animatedOrbsGlow = Color(0xFF21409A); // Blue
// // //   // static const Color animatedOrbsGlow_2 = Color(0xFF8E5CCB); // Purple
// // //   // static const Color animatedOrbsGlow_3 = Color(0xFF7F4ECC); // Lighter Purple Accent

// // //   static const Color animatedOrbsGlow = Color(0xFF3B6BFF); // soft electric blue
// // //   static const Color animatedOrbsGlow_2 = Color(0xFF6C63FF); // indigo blend
// // //   static const Color animatedOrbsGlow_3 = Color(0xFFB388FF); // soft purple glow

// // //   // Gradients for onboarding pages
// // //   // static const List<Color> page1Gradient = [
// // //   //   Color(0xFF0D2318),
// // //   //   Color(0xFF0F3D2E),
// // //   //   Color(0xFF145A32),
// // //   // ];
// // //   static const List<Color> page1Gradient = [
// // //     Color.fromARGB(255, 13, 18, 31), // base (unchanged)
// // //     Color(0xFF162A3A), // dark blue-teal bridge
// // //     Color(0xFF21409A), // brand blue
// // //   ];
// // //   // static const List<Color> page2Gradient = [
// // //   //   Color(0xFF0D1F2B),
// // //   //   Color(0xFF0F3D50),
// // //   //   Color(0xFF0F5A6A),
// // //   // ];
// // //   static const List<Color> page2Gradient = [
// // //     Color(0xFF0D1F2B), // deep blue base
// // //     Color(0xFF1B3C7A), // mid blue
// // //     Color(0xFF4A5BD4), // indigo transition
// // //   ];
// // //   // static const List<Color> page3Gradient = [
// // //   //   Color(0xFF1A1F0D),
// // //   //   Color(0xFF3D4A0F),
// // //   //   Color(0xFF5A6814),
// // //   // ];
// // //   static const List<Color> page3Gradient = [
// // //     Color(0xFF1A1F2F), // dark indigo base
// // //     Color(0xFF3A3F8F), // indigo-purple bridge
// // //     Color(0xFF8E5CCB), // brand purple
// // //   ];

// // //   // Dashboard colors
// // //   static const Color blue = Color(0xFF3B82F6);
// // //   static const Color orange = Color(0xFFF97316);
// // //   static const Color green = Color(0xFF22C55E);
// // //   static const Color purple = Color(0xFFA855F7);

// // //   /////side bar
// // //   static const Color sidebarBg = Color(0xFF0E1424);

// // //   static const Color sidebarItem = Color(0xFF121A33);
// // //   static const Color sidebarItemHover = Color(0xFF1A2547);

// // //   static const Color sidebarActive = Color(0xFF21409A); // blue base
// // //   static const Color sidebarActiveGlow = Color(
// // //     0x338E5CCB,
// // //   ); // purple glow (transparent)

// // //   static const Color sidebarText = Colors.white70;
// // //   static const Color sidebarTextActive = Colors.white;

// // //   ////side bar extra
// // //   static const Color primaryBlue = Color(0xFF21409A);
// // //   static const Color accentPurple = Color(0xFF8E5CCB);
// // // }

// // // class AppTheme {
// // //   static final lightTheme_ = ThemeData(
// // //     brightness: Brightness.light,
// // //     primaryColor: kBrandBlue,
// // //     scaffoldBackgroundColor: const Color(0xFFF5F5F5),

// // //     textTheme: GoogleFonts.interTextTheme().apply(
// // //       bodyColor: Colors.black87,
// // //       displayColor: Colors.black87,
// // //     ),

// // //     textSelectionTheme: TextSelectionThemeData(
// // //       selectionColor: kBrandBlue.withOpacity(0.3),
// // //       cursorColor: kBrandBlue,
// // //       selectionHandleColor: kBrandPurple,
// // //     ),

// // //     colorScheme: ColorScheme.light(
// // //       primary: kBrandBlue,
// // //       secondary: kBrandPurple,
// // //       surface: Colors.white,
// // //       background: const Color(0xFFF5F5F5),
// // //       onSurface: Colors.black87,
// // //       onBackground: Colors.black87,
// // //     ),
// // //   );

// // //   static final lightTheme = ThemeData(
// // //     brightness: Brightness.light,
// // //     primaryColor: const Color(0xFF21409A), // 🔵 Blue
// // //     scaffoldBackgroundColor: const Color(0xFFF5F5F5),

// // //     textTheme: GoogleFonts.interTextTheme().apply(
// // //       bodyColor: Colors.black87,
// // //       displayColor: Colors.black87,
// // //     ),

// // //     textSelectionTheme: TextSelectionThemeData(
// // //       selectionColor: const Color(0xFF8E5CCB).withOpacity(0.3), // 🟣 Purple
// // //       cursorColor: const Color(0xFF21409A),
// // //       selectionHandleColor: const Color(0xFF21409A),
// // //     ),

// // //     colorScheme: const ColorScheme.light(
// // //       primary: Color(0xFF21409A), // 🔵 main brand
// // //       secondary: Color(0xFF8E5CCB), // 🟣 accent
// // //       surface: Colors.white,
// // //       background: Color(0xFFF5F5F5),
// // //       onSurface: Colors.black87,
// // //       onBackground: Colors.black87,
// // //     ),
// // //   );

// // //   static final darkTheme_ = ThemeData(
// // //     brightness: Brightness.dark,
// // //     primaryColor: kBrandBlue,
// // //     scaffoldBackgroundColor: AppColors.generalScaffoldBackgroundColor,

// // //     textTheme: GoogleFonts.interTextTheme(
// // //       ThemeData.dark().textTheme,
// // //     ).apply(bodyColor: Colors.white, displayColor: Colors.white),

// // //     textSelectionTheme: TextSelectionThemeData(
// // //       selectionColor: kBrandBlue.withOpacity(0.4),
// // //       cursorColor: kBrandPurple,
// // //       selectionHandleColor: kBrandPurple,
// // //     ),

// // //     colorScheme: ColorScheme.dark(
// // //       primary: kBrandBlue,
// // //       secondary: kBrandPurple,
// // //       background: AppColors.generalScaffoldBackgroundColor,
// // //       surface: AppColors.generalScaffoldBackgroundColorlighter,
// // //       onSurface: Colors.white70,
// // //       onBackground: Colors.white70,
// // //     ),
// // //   );

// // //   static final darkTheme = ThemeData(
// // //     brightness: Brightness.dark,
// // //     primaryColor: kBrandBlue,
// // //     scaffoldBackgroundColor: AppColors.generalScaffoldBackgroundColor,

// // //     textTheme: GoogleFonts.interTextTheme(
// // //       ThemeData.dark().textTheme,
// // //     ).apply(bodyColor: Colors.white, displayColor: Colors.white),

// // //     textSelectionTheme: TextSelectionThemeData(
// // //       selectionColor: kBrandBlue.withOpacity(0.4),
// // //       cursorColor: kBrandPurple,
// // //       selectionHandleColor: kBrandPurple,
// // //     ),

// // //     colorScheme: ColorScheme.dark(
// // //       primary: kBrandBlue,
// // //       secondary: kBrandPurple,
// // //       background: AppColors.generalScaffoldBackgroundColor,
// // //       surface: AppColors.generalScaffoldBackgroundColorlighter,
// // //       onSurface: Colors.white70,
// // //       onBackground: Colors.white70,
// // //     ),
// // //   );
// // // }
