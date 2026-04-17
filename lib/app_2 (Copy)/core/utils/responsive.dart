import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200 &&
      MediaQuery.of(context).size.width < 1800;

  static bool isExtraWide(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1800;

  static bool isDesktopOrWider(BuildContext context) =>
      isDesktop(context) || isExtraWide(context);
}
