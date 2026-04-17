import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/widgets/custom_circular_avatar.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/data/models/list_policy_response.dart';
import 'package:intl/intl.dart';

class QuoteDetailScreen extends StatelessWidget {
  final PolicyEntry entry;
  const QuoteDetailScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final policy = entry.policy;
    final client = entry.client;
    final currency = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');
    final firstHalf = [
      // _detailRow('Policy Id', policy.id.toString()),
      _detailRow('Risk Note', policy.risknote.toString()),
      _detailRow('Insurer', policy.insurer),
      _detailRow('Product', policy.product),
      _detailRow(
        'Period',
        '${formatHumanDate(policy.starting)} → ${formatHumanDate(policy.ending)}',
      ),
      _detailRow('Sum Insured', ceilCurrency(policy.sumInsured)),
      _detailRow('Premium', ceilCurrency(policy.amount)),
      _detailRow('Commission', ceilCurrency(policy.commission)),
      _detailRow('Transaction', policy.transaction),
      if (policy.reg != null && policy.reg!.isNotEmpty)
        _detailRow('Registration', policy.reg!),
    ];

    final secondHalf = [
      _detailRow('Client Name', client.name),
      _detailRow('Client No', client.clientNo),
      _detailRow('Mobile', client.mobile),
      _detailRow('Email', client.email),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          'Quote Details Information',
          type: CustomTextType.header,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CustomCircularAvatar(
                  user: client.name,
                  radius: 50,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: const CustomText(
                  'Quote Information',
                  type: CustomTextType.header,
                ),
              ),
              const Divider(color: Colors.white30),
              // Use two columns on wide screens, one column on mobile
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: GlassCard(child: Column(children: firstHalf)),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: GlassCard(child: Column(children: secondHalf)),
                        ),
                      ],
                    );
                  }
                  return GlassCard(
                    child: Column(children: [...firstHalf, ...secondHalf]),
                  );
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: CustomAdvancedButton(
                  width: 400,
                  height: 50,
                  label: 'Generate Policy',
                  variant: ButtonVariant.primary,
                  onPressed: () {
                    // Navigate to policy creation (maybe MotorSaveScreen)
                    // You can pass the quote data if needed
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Opacity(
            opacity: 0.4,
            child: CustomText(label, type: CustomTextType.subHeader),
          ),
          CustomText(value, type: CustomTextType.paragraph),
        ],
      ),
    );
  }
}
