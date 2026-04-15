import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../widgets/feature_card.dart';
import '../animations/stagger_animation.dart';

class FeatureIntroScreen extends StatelessWidget {
  const FeatureIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimens.spacingM),
                Text(AppStrings.featureTitle, style: TextStyles.headline2),
                const SizedBox(height: AppDimens.spacingS),
                Text(AppStrings.featureSubtitle, style: TextStyles.body2),
                const SizedBox(height: AppDimens.spacingXl),
                Expanded(
                  child: SingleChildScrollView(
                    child: StaggerAnimation(
                      children: [
                        // Three feature cards
                        FeatureCard(
                          icon: Icons.speed,
                          title: AppStrings.instantDiagnosis,
                          description: AppStrings.instantDiagnosisDesc,
                        ),
                        const SizedBox(height: AppDimens.spacingM),
                        FeatureCard(
                          icon: Icons.notifications_active,
                          title: AppStrings.smartReminders,
                          description: AppStrings.smartRemindersDesc,
                        ),
                        const SizedBox(height: AppDimens.spacingM),
                        FeatureCard(
                          icon: Icons.assignment_turned_in,
                          title: AppStrings.actionablePlans,
                          description: AppStrings.actionablePlansDesc,
                        ),
                        const SizedBox(height: AppDimens.spacingXl),
                        // Info sections
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.instantSolutions,
                                style: TextStyles.body1,
                              ),
                              const SizedBox(height: AppDimens.spacingS),
                              Text(
                                AppStrings.instantSolutionsDesc,
                                style: TextStyles.body2,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimens.spacingM),
                        GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.trackGrowth,
                                style: TextStyles.body1,
                              ),
                              const SizedBox(height: AppDimens.spacingS),
                              Text(
                                AppStrings.trackGrowthDesc,
                                style: TextStyles.body2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.spacingL),
                PrimaryButton(
                  text: AppStrings.continueText,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    // Proceed to main app
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
