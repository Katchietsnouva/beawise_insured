// lib/app_2/core/widgets/error_placeholder.dart
import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';

class CustomErrorRefreshPlaceholder extends StatelessWidget {
  final String message;
  final String? details;
  final VoidCallback? onRetry;
  final IconData? icon;
  final String? retryLabel;
  final bool showIcon;
  final bool showDetails;

  const CustomErrorRefreshPlaceholder({
    super.key,
    this.message = 'Failed to fetch data',
    this.details,
    this.onRetry,
    this.icon = Icons.cloud_off,
    this.retryLabel,
    this.showIcon = true,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    print(
      "This is the error message content in CustomErrorRefreshPlaceholder : $details",
    );
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showIcon) ...[
                  Icon(
                    icon ?? Icons.error_outline,
                    size: 30,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                ],
                SizedBox(width: 10),
                Flexible(
                  child: CustomText(
                    message,
                    type: CustomTextType.paragraph,
                    textAlign: TextAlign.center,
                    color: Theme.of(context).colorScheme.error,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (showDetails && details != null && details!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                details!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.8),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),

              CustomAdvancedButton(
                label: '',
                icon: const Icon(Icons.refresh),
                onPressed: onRetry!,
                variant: ButtonVariant.circularPay,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
