import 'package:flutter/material.dart';

class ResponsiveUtil {
  static double width(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }

  static double height(BuildContext context, double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  static double scaledFont(BuildContext context, double baseFontSize) {
    // Simple scaling based on screen width
    double scaleFactor =
        MediaQuery.of(context).size.width / 375; // iPhone 12/13 base width
    return baseFontSize * scaleFactor.clamp(0.8, 1.2);
  }
}
