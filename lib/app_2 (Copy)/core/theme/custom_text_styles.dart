// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AppTextStyles {
//   static TextTheme get _inter => GoogleFonts.interTextTheme();

//   static TextStyle get headline1 => _inter.displayLarge!.copyWith(
//     fontSize: 34,
//     fontWeight: FontWeight.bold,
//     color: Colors.white,
//   );

//   static TextStyle get headline2 => _inter.displayMedium!.copyWith(
//     fontSize: 28,
//     fontWeight: FontWeight.w600,
//     color: Colors.white,
//   );

//   static TextStyle get headline3 => _inter.displaySmall!.copyWith(
//     fontSize: 22,
//     fontWeight: FontWeight.w600,
//     color: Colors.white,
//   );

//   static TextStyle get bodyLarge =>
//       _inter.bodyLarge!.copyWith(fontSize: 16, color: Colors.white70);

//   static TextStyle get bodyMedium =>
//       _inter.bodyMedium!.copyWith(fontSize: 14, color: Colors.white70);

//   static TextStyle get bodySmall =>
//       _inter.bodySmall!.copyWith(fontSize: 12, color: Colors.white60);

//   static TextStyle get button => _inter.labelLarge!.copyWith(
//     fontSize: 16,
//     fontWeight: FontWeight.w600,
//     color: Colors.white,
//   );

//   static TextStyle get caption =>
//       _inter.labelSmall!.copyWith(fontSize: 11, color: Colors.white54);
// }

import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/providers/settings_provider.dart';

// enum CustomTextType { header, subHeader, paragraph, caption }

class CustomTextStyles {
  static TextStyle style(
    BuildContext context, {
    CustomTextType type = CustomTextType.paragraph,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    final baseColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;

    double defaultFontSize;
    FontWeight defaultFontWeight;
    double opacity;

    // final themeSetting = Theme.of(context).brightness;
    // final isLightMode = themeSetting == 'Light';
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    switch (type) {
      case CustomTextType.header:
        defaultFontSize = 20;
        defaultFontWeight = FontWeight.w900;
        opacity = 1;
        break;

      case CustomTextType.subHeader:
        defaultFontSize = 18;
        defaultFontWeight = FontWeight.w700;
        // opacity = 0.9;
        opacity = isLightMode ? 0.95 : 0.9;
        break;

      case CustomTextType.paragraph:
        // defaultFontSize = 16;
        defaultFontSize = 14;
        defaultFontWeight = FontWeight.w400;
        // defaultFontWeight = FontWeight.normal;
        // opacity = 0.85;
        opacity = isLightMode ? 0.9 : 0.85;

        break;

      case CustomTextType.caption:
        defaultFontSize = 13;
        defaultFontWeight = FontWeight.w200;
        opacity = isLightMode ? 0.85 : 0.6;
        // opacity = 1.0;
        break;
    }

    return TextStyle(
      fontSize: fontSize ?? defaultFontSize,
      fontWeight: fontWeight ?? defaultFontWeight,
      color: color ?? baseColor.withOpacity(opacity),
    );
  }
}
