import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';

class PolicyFinancialModal extends StatelessWidget {
  final int policyCount;
  final double grossPremium;
  final double receipted;
  final double balance;
  final double commission;
  final VoidCallback onViewAll;

  const PolicyFinancialModal({
    super.key,
    required this.policyCount,
    required this.grossPremium,
    required this.receipted,
    required this.balance,
    required this.commission,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 800),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(
                'Production Summary',
                type: CustomTextType.header,
                // fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 20),
              _buildDetailRow(
                'Total Productions',
                policyCount.toString(),
                Icons.policy,
              ),
              const Divider(),
              _buildDetailRow(
                'Gross Premium',
                currency.format(grossPremium),
                Icons.attach_money,
              ),
              _buildDetailRow(
                'Receipted',
                currency.format(receipted),
                Icons.check_circle,
              ),
              _buildDetailRow(
                'Balance',
                currency.format(balance),
                Icons.account_balance,
              ),
              _buildDetailRow(
                'Commission',
                currency.format(commission),
                Icons.trending_up,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CustomAdvancedButton(
                      label: 'Close',
                      onPressed: () => Navigator.pop(context),
                      variant: ButtonVariant.secondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomAdvancedButton(
                      label: 'View All Productions',
                      onPressed: () {
                        Navigator.pop(context);
                        onViewAll();
                      },
                      variant: ButtonVariant.primary,
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

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Opacity(
            opacity: 0.8,
            child: Icon(icon, size: 20, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Opacity(
              opacity: 0.8,
              child: CustomText(label, type: CustomTextType.paragraph),
            ),
          ),
          CustomText(
            value,
            type: CustomTextType.paragraph,
            // fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
