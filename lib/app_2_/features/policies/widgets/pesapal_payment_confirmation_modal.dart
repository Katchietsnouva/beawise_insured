import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';

class PaymentConfirmationModal extends StatelessWidget {
  final VoidCallback onPaidSuccessfully;
  final VoidCallback onResend;

  const PaymentConfirmationModal({
    super.key,
    required this.onPaidSuccessfully,
    required this.onResend,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? const Color(0xFF00FFB2).withOpacity(0.08)
        : Colors.white.withOpacity(0.9);

    return FractionallySizedBox(
      alignment: Alignment.bottomCenter,
      heightFactor: 0.80,

      // child: Container(
      //   padding: const EdgeInsets.all(24),
      //   decoration: BoxDecoration(
      //     color: bgColor,

      //     borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      //   ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ), // Apply the blur effect
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Icon(
                Icons.check_circle_outline,
                size: 64,
                color: isDark ? Colors.greenAccent : Colors.green,
              ),
              const SizedBox(height: 16),
              CustomText('STK Push Sent', type: CustomTextType.subHeader),
              const SizedBox(height: 8),
              Text(
                'Check your phone and enter your M‑Pesa PIN.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CustomAdvancedButton(
                      label: 'Resend Payment',
                      variant: ButtonVariant.secondary,
                      onPressed: () {
                        print(
                          "Resend Payment clicked in PaymentConfirmationModal... x onResend: $onResend",
                        );
                        Navigator.pop(context);
                        onResend();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomAdvancedButton(
                      label: 'Paid Successfully',
                      variant: ButtonVariant.primary,
                      onPressed: () {
                        onPaidSuccessfully();
                        print(
                          "Paid Successfully clicked in PaymentConfirmationModal... x onPaidSuccessfully: $onPaidSuccessfully",
                        );
                        // Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
