import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/glass_input_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/social_button.dart';
import '../../../core/utils/validators.dart';
import 'feature_intro_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      HapticFeedback.lightImpact();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FeatureIntroScreen()),
      );
    }
  }

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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress indicator (step 2 of 3)
                  Center(
                    child: OnboardingProgress(currentStep: 2, totalSteps: 3),
                  ),
                  const SizedBox(height: AppDimens.spacingL),
                  Text(AppStrings.joinTitle, style: TextStyles.headline2),
                  const SizedBox(height: AppDimens.spacingS),
                  Text(AppStrings.joinSubtitle, style: TextStyles.body2),
                  const SizedBox(height: AppDimens.spacingXl),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          GlassInputField(
                            label: AppStrings.nameHint,
                            controller: _nameController,
                            validator: Validators.validateName,
                          ),
                          const SizedBox(height: AppDimens.spacingM),
                          GlassInputField(
                            label: AppStrings.emailHint,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.validateEmail,
                          ),
                          const SizedBox(height: AppDimens.spacingM),
                          GlassInputField(
                            label: AppStrings.passwordHint,
                            controller: _passwordController,
                            obscureText: true,
                            validator: Validators.validatePassword,
                          ),
                          const SizedBox(height: AppDimens.spacingXl),
                          PrimaryButton(
                            text: AppStrings.continueText,
                            onPressed: _handleContinue,
                          ),
                          const SizedBox(height: AppDimens.spacingL),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: AppColors.glassBorder,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimens.spacingM,
                                ),
                                child: Text(
                                  AppStrings.orLoginWith,
                                  style: TextStyles.body2,
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: AppColors.glassBorder,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimens.spacingL),
                          SocialButton(
                            provider: SocialProvider.google,
                            onPressed: () {
                              // Handle Google sign-in
                            },
                          ),
                          const SizedBox(height: AppDimens.spacingM),
                          SocialButton(
                            provider: SocialProvider.apple,
                            onPressed: () {
                              // Handle Apple sign-in
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Local widget for progress indicator (used here for simplicity, but you can import from the separate file)
class OnboardingProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < currentStep
                ? AppColors.accentGreen
                : AppColors.glassBorder,
          ),
        );
      }),
    );
  }
}
