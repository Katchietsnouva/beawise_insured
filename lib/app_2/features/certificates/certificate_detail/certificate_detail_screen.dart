import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/widgets/custom_circular_avatar.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/data/models/certificate_response.dart';
import 'package:intl/intl.dart';

class CertificateDetailScreen extends StatelessWidget {
  final Certificate cert;
  const CertificateDetailScreen({super.key, required this.cert});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');
    final firstHalf = [
      _detailRow('Certificate Number', cert.certificate.number),
      _detailRow('Registration', cert.certificate.regno),
      _detailRow('Type', cert.certificate.type),
      _detailRow('Start Date', formatHumanDate(cert.certificate.startDate)),
      _detailRow('End Date', formatHumanDate(cert.certificate.endDate)),
      _detailRow('Days to Expiry', cert.certificate.daysToExpiry.toString()),
    ];

    final secondHalf = [
      // _detailRow('Policy ID', cert.policy.id.toString()),
      _detailRow('Risk Note', cert.policy.riskNote.toString()),
      _detailRow('Policy No', cert.policy.policyNo ?? '-'),
      _detailRow('Insurer', cert.policy.insurer),
      _detailRow('Premium', ceilCurrency(cert.policy.premium)),
      _detailRow('Paid', ceilCurrency(cert.policy.paid)),
      _detailRow('Balance', ceilCurrency(cert.policy.balance)),
      _detailRow('Client Name', cert.client.name),
      _detailRow('Client Mobile', cert.client.mobile),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText('Certificate Details', type: CustomTextType.header),
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
                  user: cert.client.name,
                  radius: 50,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: const CustomText(
                  'Certificate Information',
                  type: CustomTextType.header,
                ),
              ),
              const Divider(color: Colors.white30),
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
                  label: 'Renew Certificate',
                  variant: ButtonVariant.primary,
                  onPressed: () {
                    // Navigate to renewal flow
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
