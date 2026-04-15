import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_super_card.dart';
import 'package:insured/app_2/data/models/list_policy_response.dart';
import 'package:insured/app_2/data/models/list_policy_single_response.dart';
import 'package:insured/app_2/features/policies/widgets/pesapal_payment_modal_stk.dart';
import 'package:insured/app_2/features/policies/widgets/policy_card_cert_modal.dart';
import 'package:insured/app_2/features/policies/widgets/policy_details_modal_ById.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:insured/app_2/providers/client_view_provider.dart';
import 'package:insured/app_2/providers/policy_provider.dart';
import 'package:intl/intl.dart';

class PolicyCard extends StatefulWidget {
  final PolicyEntry entry;
  // final Set<int> expandedIndices;
  // final int index;
  final NumberFormat currencyFormat;
  final AuthState authState;
  final PolicyNotifier notifier;
  final VoidCallback? onTap;
  final ClientViewMode viewMode;

  const PolicyCard({
    super.key,

    required this.entry,
    // required this.expandedIndices,
    // required this.index,
    required this.currencyFormat,
    required this.authState,
    required this.notifier,
    this.onTap,
    required this.viewMode,
  });

  @override
  State<PolicyCard> createState() => _PolicyCardState();
}

class _PolicyCardState extends State<PolicyCard> {
  bool _isExpanded = false;
  static Widget fullDetailsModal(SinglePolicyResponse? response) {
    return PolicyDetailsModalFull(response: response);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final policy = widget.entry.policy;
    final client = widget.entry.client;
    // final isExpanded = widget.expandedIndices.contains(widget.index);

    Widget certBtn = Container(
      child: CustomAdvancedButton(
        label: 'Issue certificate',
        variant: ButtonVariant.payBtn,
        // height: 50,
        icon: Icon(Icons.verified),
        // onPressed: () => {},
        // onPressed: () {
        //   ref
        //       .read(issueCertificateControllerProvider.notifier)
        //       .issueCertificate(policy.id.toString());
        // },
        onPressed: () {
          IssueCertificateModal.show(context, policy.id.toString());
        },
        // // width: Responsive.isMobile(context)
        // //     ? double.infinity
        // //     : null, // ← safe here
        // onPressed: () => showModalBottomSheet(
        //   context: context,
        //   isScrollControlled: true,
        //   backgroundColor: Colors.transparent,
        //   builder: (_) => ClientDetailsModal(client: client),
        // ),
      ),
    );
    final isNotIssued =
        (policy.policyNo == null || policy.policyNo.toString() == 'null');
    final canIssueCert = policy.issueCert!;
    final installmentBalance = (policy.issueCertData?.shortfall) ?? 0;
    final mainBalance = policy.balance ?? 0;
    return CustomSuperCard<PolicyEntry>(
      name: client.name,
      title: client.name,
      titleSubRowsPairList: [
        ['Reg', policy.reg ?? ''],
        [
          // 'Policy Amount',
          'Premium',
          '${ceilCurrency(policy.amount)}',
        ],
      ],
      subtitleRowsPairList: [
        // ['Policy Id', (policy.id.toString() ?? '')],
        // ['Policy Number', (policy.policyNo.toString() ?? 'Not issued')],
        [
          'Policy Number',
          // (policy.policyNo == null || policy.policyNo.toString() == 'null')
          isNotIssued ? 'Not issued' : policy.policyNo.toString(),
        ],

        ['Risknote', (policy.risknote.toString() ?? '')],
      ],

      // subtitleRows: [
      //   CustomText(policy.id.toString() ?? '', type: CustomTextType.caption),
      //   CustomText(
      //     widget.currencyFormat.format(policy.risknote),
      //     type: CustomTextType.caption,
      //   ),
      // ],
      titleTrailingEnd: true,
      // trailingButton: ...,
      // titleTrailing: IdBadge(id: "100000"),
      titleTrailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: policy.balance == 0
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
                policy.balance == 0
                    ? 'Paid'
                    : 'Balance: ${ceilCurrency(policy.balance)}',
                style: TextStyle(
                  fontSize: 12,
                  color: policy.balance == 0
                      ? isDark
                            ? Colors.green
                            : Colors.green[900]!.withOpacity(0.9)
                      : Colors.orange,
                ),
                overflow: TextOverflow.ellipsis,
              ),
      ),
      subtitleRowsTrailing:
          (Responsive.isMobile(context) ||
              widget.viewMode == ClientViewMode.grid)
          ? null
          : Text(
              'Policy amount: ${ceilCurrency(policy.amount)}',
              style: TextStyle(
                color: isDark ? Colors.green : Colors.green[700]!,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),

      // subtitleRowsTrailingList:
      //     (Responsive.isMobile(context) &&
      //         widget.viewMode == ClientViewMode.grid)
      //     ? null
      //     : [
      //         Text(
      //           'Policy amount: ${ceilCurrency(policy.amount)}',
      //           style: TextStyle(
      //             color: isDark ? Colors.green : Colors.green[700]!,
      //             fontWeight: FontWeight.bold,
      //             fontSize: 12,
      //           ),
      //         ),
      //         SizedBox(height: 2),
      //         Text(
      //           'Installment Balance: ${ceilCurrency(policy.issueCertData?.shortfall ?? 0)}',
      //           style: TextStyle(
      //             color: isDark ? Colors.green : Colors.green[700]!,
      //             fontWeight: FontWeight.bold,
      //             fontSize: 12,
      //           ),
      //         ),
      //       ],
      subtitleRowsTrailingListPairs:
          (Responsive.isMobile(context) &&
              widget.viewMode == ClientViewMode.grid)
          ? null
          : [
              ['Policy amount', ceilCurrency(policy.amount)],
              if (normalizeMoney(installmentBalance) !=
                  normalizeMoney(mainBalance))
                [
                  'Installment Balance',
                  //  ceilCurrency(installmentBalance)
                  ceilCurrency(policy.issueCertData?.shortfall ?? 0),
                ],
              // [
              //   'Installment Balance',
              //   ceilCurrency(policy.issueCertData?.shortfall ?? 0),
              // ],
            ],
      expandable: true,
      isExpanded: _isExpanded,
      onExpandedChanged: (expanded) {
        setState(() => _isExpanded = expanded);
      },
      expandedPairs: [
        // ['Policy Id', policy.id.toString()],
        // ['Risk Note', policy.risknote.toString()],
        ['Insurer', policy.insurer],
        ['Product', policy.product],
        [
          'Period',
          '${formatHumanDate(policy.starting)} to ${formatHumanDate(policy.ending)}',
        ],
        ['Sum Insured', ceilCurrency(policy.sumInsured)],
        ['Premium', ceilCurrency(policy.amount)],
        // ['Paid', ceilCurrency(policy.amount - policy.balance)],
        ['Premium Instalments', policy.premiumInstalments.toString()],
        ['Paid', ceilCurrency(policy.receipted)],
        if (Responsive.isMobile(context)) ...[
          [
            'Installment Balance',
            '${ceilCurrency(policy.issueCertData?.shortfall ?? 0)}',
          ],
        ],
        // ['Commission', ceilCurrency(policy.commission)],
        if (policy.commission != 0)
          ['Commission', ceilCurrency(policy.commission)],
        // ['Transaction', policy.transaction],
      ],

      trailingButton:
          (((Responsive.isMobile(context)) && !isNotIssued) ||
              ((!Responsive.isMobile(context) &&
                      (widget.viewMode == ClientViewMode.grid)) &&
                  // !isNotIssued
                  canIssueCert!))
          ? certBtn
          : null,
      expandedContent: [
        // _buildDetailRow('Policy Id', policy.id.toString()),
        // _buildDetailRow('Risk Note', policy.risknote.toString()),
      ],
      expandedButtons: [
        CustomAdvancedButton(
          variant: ButtonVariant.secondary,
          label: 'Full Details',
          onPressed: () async {
            final policyId = policy.id;
            print(
              "Preparign to spawn dedicated PolicyDetailsModalFull usign id: policyId: ${policyId}",
            );
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => FutureBuilder<SinglePolicyResponse?>(
                future: widget.notifier.fetchPolicyById(policyId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(80),
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError || snapshot.data?.isSuccess != true) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text(
                          'Failed to load full details',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    );
                  }
                  return PolicyDetailsModalFull(response: snapshot.data);
                },
              ),
            );
          },
        ),

        // if (!Responsive.isMobile!(context)) SizedBox(width: 8),
        if ((policy?.balance ?? 0) > 0)
          CustomAdvancedButton(
            label: 'Click To Pay',
            variant: ButtonVariant.payBtn,
            onPressed: () {
              if (policy != null && (policy.balance ?? 0) > 0) {
                final paymentData = {
                  // "account": "RKTQDM7W",
                  "account": policy?.risknote,
                  "amount": '',
                  "phone": "07",
                };
                PesapalPaymentModalStk.show(
                  context,
                  paymentData,
                  token: widget.authState.bearerToken!,
                  user: widget.authState.user,
                  balance: policy!.balance,

                  // '${ceilCurrency(policy.issueCertData?.shortfall ?? 0)}',
                  installationBalance: policy.issueCertData?.shortfall ?? 0,
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
      // isGrid: false,
      isGrid: widget.viewMode == ClientViewMode.grid,
      onTap: widget.onTap,
    );
  }
}
