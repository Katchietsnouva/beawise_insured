// helpers/responsive_helper.dart
import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/screen_width_layout_provider.dart';
// import 'package:provider/provider.dart';

// This helper function provides a way to make font sizes adapt to screen width.
double responsiveFontSize(BuildContext context, {double baseSize = 14.0}) {
  final screenWidth = MediaQuery.of(context).size.width;
  // if (screenWidth < 800) {
  //   return baseSize * 0.9; // Reduce font size on very small screens
  // } else if (screenWidth < 600) {
  //   return baseSize * 0.8; // Reduce font size on very small screens
  // } else if (screenWidth < 420) {
  //   return baseSize * 0.7; // Reduce font size on very small screens
  // } else if (screenWidth < 400) {
  //   return baseSize * 0.6; // Reduce font size on very small screens
  // } else
  //   return baseSize;

  if (screenWidth < 400) {
    return baseSize * 0.6;
  } else if (screenWidth < 420) {
    return baseSize * 0.7;
  } else if (screenWidth < 600) {
    return baseSize * 0.8;
  } else if (screenWidth < 800) {
    return baseSize * 0.9;
  } else {
    return baseSize;
  }

  // if (screenWidth < 420) {
  //   return baseSize * 0.6; // Reduce font size on very small screens
  // }
  // return baseSize;
}

extension Responsive on BuildContext {
  // bool get isMobileLayout => MediaQuery.of(this).size.width < watch<ScreenWidthLayoutProvider>().pixelValue;
  // bool get isDesktopLayout => !isMobileLayout;

  bool isMobileLayout(double breakpoint) {
    return MediaQuery.of(this).size.width < breakpoint;
  }

  bool isDesktopLayout(double breakpoint) {
    return !isMobileLayout(breakpoint);
  }
}
