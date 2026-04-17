import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';

Future<bool> showExitConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Dialog(
          backgroundColor: Colors.transparent,
          child: GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.exit_to_app, size: 48, color: Colors.orange),
                  const SizedBox(height: 16),
                  const CustomText(
                    'Exit App',
                    type: CustomTextType.header,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  const CustomText(
                    'Are you sure you want to exit?',
                    type: CustomTextType.paragraph,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: CustomAdvancedButton(
                          label: 'Cancel',
                          onPressed: () => Navigator.pop(ctx, false),
                          variant: ButtonVariant.secondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomAdvancedButton(
                          label: 'Exit',
                          onPressed: () => Navigator.pop(ctx, true),
                          variant: ButtonVariant.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ) ??
      false;
}
