import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/data/models/list_statement_entry.dart';

class StatementCard extends StatefulWidget {
  final StatementEntry entry;
  final NumberFormat currency;

  const StatementCard({super.key, required this.entry, required this.currency});

  @override
  State<StatementCard> createState() => _StatementCardState();
}

class _StatementCardState extends State<StatementCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = widget.entry;

    return GlassCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    formatHumanDate(entry.date),
                    type: CustomTextType.caption,
                    color: theme.colorScheme.primary.withOpacity(0.8),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      size: 20,
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          entry.description,
                          type: CustomTextType.paragraph,
                          fontWeight: FontWeight.bold,
                        ),
                        if (entry.client.isNotEmpty)
                          CustomText(
                            entry.client,
                            type: CustomTextType.caption,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildFinancials(entry, widget.currency),
                ],
              ),

              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox(width: double.infinity),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (entry.ref.isNotEmpty)
                            _infoChip('Ref: ${entry.ref}', Icons.tag),
                          if (entry.type.isNotEmpty)
                            _infoChip(entry.type, Icons.category),
                          if (entry.policyNo.isNotEmpty)
                            _infoChip(
                              'Policy: ${entry.policyNo}',
                              Icons.description,
                            ),
                          _infoChip(
                            'Trans ID: ${entry.transId}',
                            Icons.numbers,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinancials(StatementEntry entry, NumberFormat currency) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (entry.cr > 0)
          Text(
            '+${ceilCurrency(entry.cr)}',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        if (entry.dr > 0)
          Text(
            '-${ceilCurrency(entry.dr)}',
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Bal: ${ceilCurrency(entry.balance)}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12),
          const SizedBox(width: 4),
          CustomText(label, type: CustomTextType.caption),
        ],
      ),
    );
  }
}
