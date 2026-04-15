import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:go_router/go_router.dart';

class NotFoundScreen extends StatelessWidget {
  final String path;

  const NotFoundScreen({super.key, required this.path});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: GlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 24),
                  const CustomText(
                    'Page Not Found',
                    type: CustomTextType.header,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 12),
                  const CustomText(
                    'The page you are looking for does not exist.',
                    type: CustomTextType.paragraph,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  CustomText(
                    'Path: $path',
                    type: CustomTextType.caption,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  CustomAdvancedButton(
                    label: 'Return to Home page',
                    onPressed: () => context.go('/dashboard'),
                    variant: ButtonVariant.primary,
                  ),
                  const SizedBox(height: 16),
                  CustomAdvancedButton(
                    label: 'Go Back',
                    onPressed: () => context.pop(),
                    variant: ButtonVariant.secondary,
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
