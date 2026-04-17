import 'package:flutter/material.dart';
import 'package:insured/app_2/core/theme/custom_text_styles.dart';

enum CustomTextType { header, subHeader, paragraph, caption }

class CustomText extends StatelessWidget {
  final String text;
  final CustomTextType type;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const CustomText(
    this.text, {
    super.key,
    this.type = CustomTextType.paragraph,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    // // Theme-based default colors
    // final defaultColor =
    //     color ?? Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white;

    double defaultFontSize;
    FontWeight defaultFontWeight;

    switch (type) {
      case CustomTextType.header:
        defaultFontSize = 28;
        defaultFontWeight = FontWeight.bold;
        break;
      case CustomTextType.subHeader:
        defaultFontSize = 20;
        defaultFontWeight = FontWeight.w600;
        break;
      case CustomTextType.paragraph:
        defaultFontSize = 16;
        defaultFontWeight = FontWeight.normal;
        break;
      case CustomTextType.caption:
        defaultFontSize = 14;
        defaultFontWeight = FontWeight.w100;
        break;
    }

    final baseColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.red;

    Color defaultColor;

    // switch (type) {
    //   case CustomTextType.header:
    //     defaultColor = color ?? baseColor;
    //     break;

    //   case CustomTextType.subHeader:
    //     defaultColor = color ?? baseColor.withOpacity(0.9);
    //     break;

    //   case CustomTextType.paragraph:
    //     defaultColor = color ?? baseColor.withOpacity(0.85);
    //     break;

    //   case CustomTextType.caption:
    //     defaultColor = color ?? baseColor.withOpacity(0.4);
    //     break;
    // }
    return Text(
      text,
      // maxLines: maxLines ?? 1,
      // overflow: overflow ?? TextOverflow.ellipsis,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      // style: TextStyle(
      //   fontSize: fontSize ?? defaultFontSize,
      //   fontWeight: fontWeight ?? defaultFontWeight,
      //   color: defaultColor,
      // ),
      style: CustomTextStyles.style(
        context,
        type: type,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}








// // Large page header
// CustomText(
//   'Recent Clients',
//   type: CustomTextType.header,
// ),

// // Section / small header
// CustomText(
//   'Manage your clients',
//   type: CustomTextType.subHeader,
// ),

// // Normal paragraph
// CustomText(
//   'Here you can view all client details and manage their policies.',
//   type: CustomTextType.paragraph,
// ),

// // Caption / footnote
// CustomText(
//   'Updated 2 hours ago',
//   type: CustomTextType.caption,
//   color: Colors.grey,
// ),


// CustomText(
//   'Special Header',
//   type: CustomTextType.header,
//   color: Colors.orange,
//   fontSize: 32,
//   fontWeight: FontWeight.w900,
// )