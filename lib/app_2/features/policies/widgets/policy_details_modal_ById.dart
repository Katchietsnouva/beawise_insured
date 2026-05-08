import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/data/models/list_policy_single_response.dart';
import 'package:insured/app_2/features/policies/widgets/pesapal_payment_modal_stk.dart';
import 'package:insured/app_2/features/policies/widgets/policy_card_cert_modal.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyDetailsModalFull extends ConsumerWidget {
  final SinglePolicyResponse? response;
  final VoidCallback onPaymentConfirmed;

  const PolicyDetailsModalFull({
    super.key,
    required this.response,
    required this.onPaymentConfirmed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final currency = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');

    final policy = response?.policy;
    final pdfLink = policy?.riskNoteLink;

    final authState = ref.read(authProvider);
    final user = authState.user;
    final token = authState.bearerToken;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark
              ? Color(0xFF00FFB2).withOpacity(0.1)
              : Theme.of(context).colorScheme.surface.withOpacity(0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          policy?.client ?? 'Unknown Client',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          'Risk Note: ${policy?.riskNote ?? 'N/A'}',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              Divider(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
                height: 32,
              ),
              Row(
                children: [
                  _buildStatCard(
                    'Premium',
                    ceilCurrency(policy?.premium ?? 0),
                    Icons.account_balance_wallet,
                    isDark ? Colors.greenAccent : Colors.green[900]!,
                    context,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    'Balance',
                    ceilCurrency(policy?.balance ?? 0),
                    Icons.account_balance_wallet,
                    Colors.blueAccent,
                    context,
                  ),
                  // _buildStatCard( 'Receipted', ceilCurrency(policy?.receipted ?? 0), Icons.shield, Colors.blueAccent, context),
                ],
              ),

              // const SizedBox(height: 10),
              // Row(
              //   children: [
              //     const SizedBox(width: 12),
              //     _buildStatCard( 'Sum Insured', ceilCurrency(policy?.sumInsured ?? 0), Icons.shield, Colors.blueAccent, context,),
              //   ],
              // ),
              const SizedBox(height: 24),

              const CustomText(
                "Policy Information",
                type: CustomTextType.subHeader,
                fontWeight: FontWeight.normal,
              ),
              const SizedBox(height: 12),

              _buildDetailRow(
                'Risk Note No',
                policy?.riskNote.toString() ?? 'N/A',
              ),
              _buildDetailRow('Policy No', policy?.policyNo ?? 'N/A'),
              _buildDetailRow('Insurer', policy?.insurer ?? 'N/A'),
              // _buildDetailRow('Product', policy?.product ?? 'N/A'),
              _buildDetailRow('Policy Class', policy?.product ?? 'N/A'),
              _buildDetailRow('Sales Type', policy?.salesType ?? 'N/A'),
              // _buildDetailRow('Sub Cover', policy?.subCover ?? 'N/A'),
              // _buildDetailRow( 'Marine DMVIC',policy?.marineDmvic?.toString() ?? 'N/A',),
              // _buildDetailRow('Number of Vehicles',policy?.vehicles.length.toString() ?? '0'),
              // _buildDetailRow('Number of Claims', policy?.claims.length.toString() ?? '0',),
              // _buildDetailRow( 'Policy Documents', policy?.policyDocuments.length.toString() ?? '0'),
              // _buildDetailRow('Client Documents',policy?.clientDocuments.length.toString() ?? '0',),
              // _buildDetailRow('Errors', response?.errors?.toString() ?? 'None'),
              // _buildDetailRow('Transaction', policy?.transaction ?? 'N/A'),

              // _buildDetailRow('Currency', policy?.currency ?? 'N/A'),
              // _buildDetailRow(
              //   'Receipted',
              //   ceilCurrency(policy?.receipted ?? 0),
              // ),
              _buildDetailRow(
                'Sum Insured',
                ceilCurrency(policy?.sumInsured ?? 0),
              ),
              _buildDetailRow(
                'Period',
                '${formatHumanDate(policy?.startDate ?? '')} → ${formatHumanDate(policy?.endDate ?? '')}',
              ),

              // _buildDetailRow('Status', policy?.status.toString() ?? 'N/A'),
              _buildDetailRow('Balance', ceilCurrency(policy?.balance ?? 0)),

              // _buildDetailRow( 'Paid', ceilCurrency( (policy?.premium ?? 0) - (policy?.balance ?? 0) ) ),
              _buildDetailRow('Paid', ceilCurrency((policy?.receipted ?? 0))),
              _buildDetailRow(
                'Installment Balance',
                '${ceilCurrency(policy?.issueCertData?.shortfall ?? 0)}',
              ),
              const SizedBox(height: 16),

              if (policy?.issueCert == true) ...[
                const SizedBox(height: 16),
                CustomAdvancedButton(
                  label: 'Issue Certificate',
                  variant: ButtonVariant.payBtn,
                  icon: const Icon(Icons.verified),
                  onPressed: () {
                    IssueCertificateModal.show(context, policy!.id.toString());
                  },
                ),
                const SizedBox(height: 24),
              ],
              if ((policy?.balance ?? 0) > 0)
                if ((policy?.balance ?? 0) > 0)
                  CustomAdvancedButton(
                    label: 'Click To Pay',
                    variant: ButtonVariant.payBtn,
                    color1: isDark ? Colors.greenAccent : Colors.green[900],
                    color2: Colors.teal,
                    onPressed: () {
                      print(
                        "Pay btn clicked in PolicyDetailsModalFull... x onPaymentConfirmed: $onPaymentConfirmed",
                      );
                      if (policy != null && (policy.balance ?? 0) > 0) {
                        final paymentData = {
                          // "account": "RKTQDM7W",
                          "account": policy?.riskNote,
                          "amount": '',
                          "phone": "07",
                        };
                        PesapalPaymentModalStk.show(
                          context,
                          paymentData,
                          token: authState.bearerToken!,
                          user: authState.user,
                          balance: policy!.balance,
                          installationBalance: policy!.issueCertData!.shortfall,
                          onPaymentConfirmed: onPaymentConfirmed,
                        );
                        print(
                          "debuggin if this runs after  PesapalPaymentModalStk... x onPaymentConfirmed: $onPaymentConfirmed",
                        );
                      }
                    },
                  ),
              if (pdfLink != null && pdfLink.isNotEmpty) ...[
                const SizedBox(height: 24),
                CustomAdvancedButton(
                  label: 'View / Download Risk Note',
                  variant: ButtonVariant.secondary,
                  icon: const Icon(
                    Icons.picture_as_pdf,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => _openPDF(pdfLink),
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    BuildContext context,
  ) {
    return Expanded(
      child: Container(
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
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            CustomText(label, type: CustomTextType.paragraph),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Opacity(
            opacity: 0.8,
            child: CustomText(label, type: CustomTextType.caption),
          ),
          CustomText(value, type: CustomTextType.caption),
        ],
      ),
    );
  }

  Future<void> _openPDF(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
