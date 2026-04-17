import 'package:flutter/material.dart';

double responsiveIconSize(BuildContext context, {double baseSize = 24}) {
  final scale = MediaQuery.of(context).textScaler.scale(1);
  return baseSize * scale;
}
