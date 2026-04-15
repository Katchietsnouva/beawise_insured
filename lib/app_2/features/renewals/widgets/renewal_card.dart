import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/card_animation_layout.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_circular_avatar.dart';
import 'package:insured/app_2/core/widgets/custom_super_card.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/data/models/list_policy_response.dart';
import 'package:insured/app_2/features/policies/widgets/policy_details_modal.dart';
import 'package:insured/app_2/providers/client_view_provider.dart';
import 'package:intl/intl.dart';

class RenewalCard extends StatefulWidget {
  final PolicyEntry entry;
  final int index;
  final NumberFormat currency;
  final VoidCallback? onTap;
  final ClientViewMode viewMode;

  const RenewalCard({
    super.key,
    required this.entry,
    required this.index,
    required this.currency,
    this.onTap,
    required this.viewMode,
  });

  @override
  State<RenewalCard> createState() => _RenewalCardState();
}

class _RenewalCardState extends State<RenewalCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final policy = widget.entry.policy;
    final client = widget.entry.client;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: CustomSuperCard<PolicyEntry>(
        item: widget.entry,
        name: client.name,
        avatar: CustomCircularAvatar(user: client.name),
        title: client.name,
        titleSubRowsPairList: [
          ['Registration', policy.reg ?? '-'],
          // ['Policy Id', policy.id.toString()],
          ['Insurer', policy.insurer],
        ],
        subtitleRowsPairList: [],
        expandedPairs: [
          ['Product', policy.product],
          [
            'Period',
            '${formatHumanDate(policy.starting)} → ${formatHumanDate(policy.ending)}',
          ],
          [
            // 'Policy Amount',
            'Premium',
            'Kshs. ${policy.amount.toString()}',
          ],
          ['Sum Insured', ceilCurrency(policy.sumInsured)],
          ['Premium', ceilCurrency(policy.amount)],
          ['Balance', ceilCurrency(policy.balance)],
          ['Risk Note', policy.risknote.toString()],
          if (policy.reg != null && policy.reg!.isNotEmpty)
            ['Registration', policy.reg!],
        ],
        titleTrailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: policy.balance == 0
                ? Colors.green.withOpacity(0.2)
                : Colors.orange.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            policy.balance == 0
                ? 'Paid'
                // : 'Balance: ${widget.ceilCurrency(policy.balance)}',
                : Responsive.isMobile(context)
                ? ceilCurrency(policy.balance)
                : 'Balance: ${ceilCurrency(policy.balance)}',

            style: TextStyle(
              fontSize: 10,
              color: policy.balance == 0 ? Colors.green : Colors.orange,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // subtitleRowsTrailing: Text(
        //   widget.ceilCurrency(policy.amount),
        //   style: const TextStyle(
        //     color: Colors.greenAccent,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        expandable: true,
        isExpanded: _isExpanded,
        onExpandedChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        trailingButton: CustomAdvancedButton(
          height: 42,
          label: 'View Details',
          variant: ButtonVariant.secondary,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) =>
                  PolicyDetailsModal(policyEntry: widget.entry),
            );
          },
        ),
        onTap: widget.onTap,
        isGrid: widget.viewMode == ClientViewMode.grid,
      ),
    );
  }
}

class RenewalCard_ extends StatefulWidget {
  final PolicyEntry entry;
  final int index;
  final bool isExpanded;
  final Function(bool expanded) onExpansionChanged;
  final NumberFormat currency;

  const RenewalCard_({
    super.key,
    required this.entry,
    required this.index,
    required this.isExpanded,
    required this.onExpansionChanged,
    required this.currency,
  });

  @override
  State<RenewalCard_> createState() => _RenewalCardState_();
}

class _RenewalCardState_ extends State<RenewalCard_> {
  bool _isExpanded = false;
  final currency = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');

  @override
  Widget build(BuildContext context) {
    final policy = widget.entry.policy;
    final client = widget.entry.client;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CardAnimationLayout(
      index: widget.index,
      bounce: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: CardAnimationLayout(
          index: widget.index,
          bounce: true,
          animateOnce: true,
          child: Material(
            elevation: Theme.of(context).brightness == Brightness.light ? 4 : 6,
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).colorScheme.surface,
            child: Card(
              color: Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                // onExpansionChanged: (expanded) {
                //   setState(() {
                //     if (expanded) {
                //       _expandedIndices.add(i);
                //     } else {
                //       _expandedIndices.remove(i);
                //     }
                //   });
                // },
                onExpansionChanged: widget.onExpansionChanged,

                leading: CustomCircularAvatar(user: client.name),
                // CircleAvatar(
                //   backgroundColor: Colors.orange.withOpacity(0.2),
                //   child: CustomText(
                //     client.name.isNotEmpty
                //         ? client.name.substring(0, 2).toUpperCase()
                //         : '?',
                //   ),
                // ),
                title: CustomText(
                  client.name,
                  type: CustomTextType.subHeader,
                  maxLines: 1,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            policy.reg ?? '',
                            type: CustomTextType.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomText(
                            ceilCurrency(policy.amount),
                            type: CustomTextType.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          ceilCurrency(policy.amount),
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: policy.balance == 0
                                ? Colors.green.withOpacity(0.2)
                                : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            policy.balance == 0
                                ? 'Paid'
                                : 'Balance: ${ceilCurrency(policy.balance)}',
                            style: TextStyle(
                              fontSize: 10,
                              color: policy.balance == 0
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: widget.isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        size: 40,
                        Icons.keyboard_arrow_down,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Policy Id', policy.id.toString()),
                        _buildDetailRow(
                          'Risk Note',
                          policy.risknote.toString(),
                        ),
                        _buildDetailRow('Insurer', policy.insurer),
                        _buildDetailRow('Product', policy.product),
                        _buildDetailRow(
                          'Period',
                          '${formatHumanDate(policy.starting)} to ${formatHumanDate(policy.ending)}',
                        ),
                        _buildDetailRow(
                          'Sum Insured',
                          ceilCurrency(policy.sumInsured),
                        ),
                        _buildDetailRow('Premium', ceilCurrency(policy.amount)),
                        _buildDetailRow(
                          'Balance',
                          ceilCurrency(policy.balance),
                        ),
                        if (policy.reg != null && policy.reg!.isNotEmpty)
                          _buildDetailRow('Registration', policy.reg!),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: CustomAdvancedButton(
                                height: 42,
                                label: 'View Details',
                                variant: ButtonVariant.secondary,
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => PolicyDetailsModal(
                                      policyEntry: widget.entry,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(label, type: CustomTextType.paragraph),
          CustomText(value, type: CustomTextType.paragraph),
        ],
      ),
    );
  }
}
