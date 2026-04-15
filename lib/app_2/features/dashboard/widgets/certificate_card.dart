import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_circular_avatar.dart';
import 'package:insured/app_2/core/widgets/custom_super_card.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/data/models/certificate_response.dart';
import 'package:insured/app_2/features/policies/widgets/pesapal_payment_modal_stk.dart';
import 'package:insured/app_2/features/policies/widgets/policy_card_cert_modal.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:insured/app_2/providers/client_view_provider.dart';
import 'package:intl/intl.dart';

class CertificateCard extends StatefulWidget {
  // const CertificateCard({super.key});
  final Certificate cert;
  final bool compact;
  final AuthState authState;

  final VoidCallback? onTap;
  final ClientViewMode viewMode;

  const CertificateCard({
    super.key,
    required this.cert,
    this.compact = false,
    this.onTap,
    required this.viewMode,
    required this.authState,
  });

  @override
  State<CertificateCard> createState() => _CertificateCardState();
}

class _CertificateCardState extends State<CertificateCard> {
  bool isExpanded = false;

  void _toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '',
  );
  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');
    final showExtraDetails =
        !widget.compact; // show extra fields if not compact
    final cert = widget.cert;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canIssueCert = cert.policy.issueCert!;

    Widget certBtn = Container(
      child: CustomAdvancedButton(
        label: 'Issue certificate',
        variant: ButtonVariant.payBtn,
        // height: 50,
        icon: Icon(Icons.verified),
        onPressed: () {
          IssueCertificateModal.show(context, cert.policy.id.toString());
        },
      ),
    );

    return CustomSuperCard<Certificate>(
      name: cert.client.name,
      title: cert.client.name,
      titleSubRowsPairList: [
        ['Certificate No', '${cert.certificate.number}'],
        ['Reg No', '${cert.certificate.regno}'],
      ],
      titleTrailingEnd: true,
      titleTrailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: cert.policy.balance == 0
              ? isDark
                    ? Colors.green.withOpacity(0.2)
                    : Colors.green[900]!.withOpacity(0.2)
              : Colors.orange.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child:
            (Responsive.isMobile(context) &&
                widget.viewMode == ClientViewMode.grid)
            ? null
            : Text(
                cert.policy.balance == 0
                    ? 'Paid'
                    : 'Balance: ${ceilCurrency(cert.policy.balance)}',
                style: TextStyle(
                  fontSize: 12,
                  color: cert.policy.balance == 0
                      ? isDark
                            ? Colors.green
                            : Colors.green[900]!.withOpacity(0.9)
                      : Colors.orange,
                ),
                overflow: TextOverflow.ellipsis,
              ),
      ),

      trailingButton:
          (((Responsive.isMobile(context))
              // && !isNotIssued
              ) ||
              ((!Responsive.isMobile(context) &&
                      (widget.viewMode == ClientViewMode.grid)) &&
                  // !isNotIssued
                  canIssueCert!))
          ? certBtn
          : null,
      subtitleRowsPairList: [
        ['Insurer', '${cert.policy.insurer}'],
        [
          'Period',
          '${formatHumanDate(cert.certificate.startDate)} → ${formatHumanDate(cert.certificate.endDate)}',
        ],
      ],
      // subtitleRows: [
      //   // CustomText(
      //   //   'Certificate No: ${cert.certificate.number}',
      //   //   type: CustomTextType.caption,
      //   // ),
      //   // CustomText(
      //   //   'Reg No: ${cert.certificate.regno}',
      //   //   type: CustomTextType.paragraph,
      //   // ),
      //   if (!compact)
      //     CustomText(
      //       'Insurer: ${cert.policy.insurer}',
      //       type: CustomTextType.paragraph,
      //     ),
      //   CustomText(
      //     'Period: ${cert.certificate.startDate} → ${cert.certificate.endDate}',
      //     type: CustomTextType.paragraph,
      //   ),
      // ],
      expandedPairs: [
        ['Premium', '${ceilCurrency(cert.policy.premium)}'],
        ['Balance', '${ceilCurrency(cert.policy.balance)}'],
        ['Certificate Type', cert.certificate.type],
        ['Certificate No', cert.certificate.number],
        ['Reg No', cert.certificate.regno],
        ['Policy No', cert.policy.policyNo ?? '-'],
        ['Risk Note', cert.policy.riskNote.toString()],
        ['Premium', '${ceilCurrency(cert.policy.premium)}'],
        ['Paid', '${ceilCurrency(cert.policy.paid)}'],
        ['Balance', '${ceilCurrency(cert.policy.balance)}'],
        ['Days to Expiry', cert.certificate.daysToExpiry.toString()],
      ],

      // // extraRows: [
      // //   Row(
      // //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // //     children: [
      // //       CustomText(
      // //         'Premium: ${ceilCurrency(cert.policy.premium)}',
      // //         type: CustomTextType.caption,
      // //       ),
      // //       CustomText(
      // //         'Balance: ${ceilCurrency(cert.policy.balance)}',
      // //         type: CustomTextType.caption,
      // //         color: Colors.deepOrangeAccent,
      // //       ),
      // //     ],
      // //   ),
      // // ],
      subtitleRowsTrailing:
          (Responsive.isMobile(context) ||
              widget.viewMode == ClientViewMode.grid)
          ? null
          : Text(
              'Policy amount: ${ceilCurrency(cert.policy.balance)}',
              style: TextStyle(
                color: isDark ? Colors.green : Colors.green[700]!,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
      expandable: true,
      isExpanded: isExpanded,
      expandedButtons: [
        // if (!Responsive.isMobile!(context)) SizedBox(width: 8),
        if ((cert.policy?.balance ?? 0) > 0)
          CustomAdvancedButton(
            label: 'Click To Pay',
            variant: ButtonVariant.payBtn,
            onPressed: () {
              if (cert.policy != null && (cert.policy.balance ?? 0) > 0) {
                final paymentData = {
                  // "account": "RKTQDM7W",
                  "account": cert.policy?.riskNote,
                  "amount": '',
                  "phone": "07",
                };
                PesapalPaymentModalStk.show(
                  context,
                  paymentData,
                  token: widget.authState.bearerToken!,
                  user: widget.authState.user,
                  balance: cert.policy!.balance,
                  // '${ceilCurrency(cert.policy.issueCertData?.shortfall ?? 0)}',
                  installationBalance:
                      cert.policy.issueCertData?.shortfall ?? 0,
                );
              }
            },
          ),

        if ((!Responsive.isMobile(context) &&
                (widget.viewMode != ClientViewMode.grid))
            // && !isNotIssued
            &&
            canIssueCert!)
          certBtn,
      ],
      onExpandedChanged: (val) => setState(() => isExpanded = val),

      isGrid: widget.viewMode == ClientViewMode.grid,
      onTap: widget.onTap,
    );
  }
}

class CertificateCard_ extends StatelessWidget {
  final Certificate cert;
  final bool
  compact; // optional: for dashboard you might want a more compact version

  const CertificateCard_({super.key, required this.cert, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');
    final showExtraDetails = !compact; // show extra fields if not compact

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomCircularAvatar(user: cert.client.name),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      cert.client.name,
                      type: CustomTextType.subHeader,
                    ),
                    CustomText(
                      'Certificate No: ${cert.certificate.number}',
                      type: CustomTextType.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomText(
            'Reg No: ${cert.certificate.regno}',
            type: CustomTextType.paragraph,
          ),
          if (showExtraDetails) ...[
            CustomText(
              'Insurer: ${cert.policy.insurer}',
              type: CustomTextType.paragraph,
            ),
          ],
          CustomText(
            'Period: ${formatHumanDate(cert.certificate.startDate)} → ${formatHumanDate(cert.certificate.endDate)}',
            // 'yo',
            type: CustomTextType.paragraph,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                'Premium: ${ceilCurrency(cert.policy.premium)}',
                type: CustomTextType.caption,
              ),
              CustomText(
                'Balance: ${ceilCurrency(cert.policy.balance)}',
                type: CustomTextType.caption,
                color: Colors.deepOrangeAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
