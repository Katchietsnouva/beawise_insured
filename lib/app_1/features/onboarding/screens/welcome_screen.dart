import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/utils/responsive_util.dart';
import 'sign_up_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
              children: [
                const Spacer(flex: 2),
                // Plant illustration placeholder
                Container(
                  height: ResponsiveUtil.height(context, 0.3),
                  width: ResponsiveUtil.width(context, 0.6),
                  decoration: BoxDecoration(
                    color: AppColors.glassWhite,
                    borderRadius: BorderRadius.circular(AppDimens.radiusXl),
                  ),
                  child: const Center(
                    child: Icon(Icons.eco, size: 80, color: Colors.white),
                  ),
                ),
                const Spacer(),
                Text(AppStrings.welcome, style: TextStyles.headline1),
                const SizedBox(height: AppDimens.spacingS),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtil.width(context, 0.1),
                  ),
                  child: Text(
                    AppStrings.welcomeSubtitle,
                    style: TextStyles.body2,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(flex: 2),
                PrimaryButton(
                  text: AppStrings.continueWithPhone,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    );
                  },
                ),
                const SizedBox(height: AppDimens.spacingM),
                PrimaryButton(
                  text: AppStrings.continueWithApple,
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    // Handle Apple sign-in
                  },
                  isOutlined: true,
                ),
                const SizedBox(height: AppDimens.spacingL),
                Text(
                  AppStrings.terms,
                  style: TextStyles.caption,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimens.spacingM),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
