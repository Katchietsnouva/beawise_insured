import 'package:flutter/material.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';

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
    glowColor: AppColors.animatedOrbsGlow,
    bgGradient: AppColors.page1Gradient,
  ),
  OnboardingPageModel(
    title: 'Instant Quotes',
    subtitle: 'AI-powered risk assessment\nin seconds.',
    glowColor: AppColors.animatedOrbsGlow_2,
    bgGradient: AppColors.page2Gradient,
  ),
  OnboardingPageModel(
    title: 'Join Insured',
    subtitle: 'Your vault of trust,\nalways with you.',
    glowColor: AppColors.animatedOrbsGlow_3,
    bgGradient: AppColors.page3Gradient,
  ),
];
