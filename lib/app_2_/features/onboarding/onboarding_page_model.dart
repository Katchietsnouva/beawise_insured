import 'package:flutter/material.dart';
import 'package:insured/app_2/core/constants/app_colors.dart';

class OnboardingPageModel {
  final String title;
  final String subtitle;
  final Color glowColor;
  final List<Color> bgGradient;

  const OnboardingPageModel({
    required this.title,
    required this.subtitle,
    required this.glowColor,
    required this.bgGradient,
  });
}

const onboardingPages = [
  OnboardingPageModel(
    title: 'Welcome',
    subtitle: 'Scan documents, verify instantly,\nand get secure coverage.',
    glowColor: Color(0xFF00FFB2),
    bgGradient: AppColors.page1Gradient,
  ),
  OnboardingPageModel(
    title: 'Instant Quotes',
    subtitle: 'AI-powered risk assessment\nin seconds.',
    glowColor: Color(0xFF00F0FF),
    bgGradient: AppColors.page2Gradient,
  ),
  OnboardingPageModel(
    title: 'Join Insured',
    subtitle: 'Your vault of trust,\nalways with you.',
    glowColor: Color(0xFFB2FF00),
    bgGradient: AppColors.page3Gradient,
  ),
];
