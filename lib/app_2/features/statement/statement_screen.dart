import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/cust_date_range_filter.dart';
import 'package:insured/app_2/core/widgets/custom_dropdown.dart';
import 'package:insured/app_2/core/widgets/custom_error_refresh_placeholder_adv.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/data/models/list_statement_entry.dart';
import 'package:insured/app_2/providers/statement_provider.dart';
import 'package:intl/intl.dart';

class StatementScreen extends ConsumerStatefulWidget {
  const StatementScreen({super.key});

  @override
  ConsumerState<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends ConsumerState<StatementScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(statementProvider);
      // _startDate = DateTime.tryParse(state.startDate);
      // _endDate = DateTime.tryParse(state.endDate);

      try {
        _startDate = DateTime.parse(state.startDate);
        _endDate = DateTime.parse(state.endDate);
      } catch (_) {
        // fallback to defaults
        final now = DateTime.now();
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = DateTime(now.year, now.month + 2, 0);
      }
      // Trigger initial fetch
      ref.read(statementProvider.notifier).fetchPage(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(statementProvider);
    final notifier = ref.read(statementProvider.notifier);
    final currency = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(0.0),
          child: DateRangeFilter(
            initialStart: _startDate ?? DateTime.now(),
            initialEnd: _endDate ?? DateTime.now(),
            labelPrefix: "Period:",
            compact: true,
            onRangeSelected: (start, end) {
              setState(() {
                _startDate = start;
                _endDate = end;
              });
              notifier.setDateRange(
                start: start.toIso8601String().split('T')[0],
                end: end.toIso8601String().split('T')[0],
              );
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => notifier.refreshCurrentPage(),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onRefresh: () async {
          await notifier.refreshCurrentPage();
        },
        child: Column(
          children: [
            if (!Responsive.isMobile(context))
              _buildPaginationControls(state, notifier),
            Expanded(
              child: state.isLoading && state.response == null
                  ? const Center(child: CircularProgressIndicator())
                  : state.error != null && state.response == null
                  ? CustomErrorRefreshPlaceholder(
                      details: state.error,
                      onRetry: () => notifier.refreshCurrentPage(),
                    )
                  : _buildStatementList(state, currency),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls(
    StatementState state,
    StatementNotifier notifier,
  ) {
    final pagination = state.response?.pagination;
    if (pagination == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 140,
            child: CustomDropdown<int>(
              // 'Items per page: ',
              hint: '',
              icon: Icons.format_list_numbered,
              value: state.perPage,
              items: [5, 10, 20, 50, 100].map((v) {
                return DropdownMenuItem<int>(value: v, child: Text('$v'));
              }).toList(),
              onChanged: (val) {
                if (val != null) notifier.setPerPage(val);
              },
            ),
          ),

          Row(
            children: [
              CustomText(
                '${pagination.currentPage} of ${pagination.lastPage}',
                type: CustomTextType.paragraph,
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: pagination.currentPage > 1
                    ? () => notifier.previousPage()
                    : null,
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: pagination.currentPage < pagination.lastPage
                    ? () => notifier.nextPage()
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatementList(StatementState state, NumberFormat currency) {
    final sections = state.response!.sections;
    final totals = state.response!.totals;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryItem(
                      'Total DR',
                      ceilCurrency(totals.totalDr),
                      Icons.arrow_drop_down_sharp,
                      Colors.red,
                    ),
                  ),
                  Expanded(
                    child: _buildSummaryItem(
                      'Total CR',
                      ceilCurrency(totals.totalCr),
                      Icons.arrow_drop_up_sharp,
                      Colors.green,
                    ),
                  ),
                  Expanded(
                    child: _buildSummaryItem(
                      'Balance',
                      ceilCurrency(totals.totalBalance),
                      Icons.account_balance,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...sections.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildStatementCard(entry, currency),
            // child: StatementCard(entry: entry, currency: currency),
            // child: StatementCard(entry: entry, currency: currency),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 4),
          CustomText(label, type: CustomTextType.paragraph),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: Responsive.isMobile(context) ? 14 : 18,
              // fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatementCard(StatementEntry entry, NumberFormat currency) {
    String policyIdStr = entry.policyId?.toString() ?? '';
    String transIdStr = entry.transId?.toString() ?? '';
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (entry.client.isNotEmpty)
                      CustomText(
                        'Client: ${entry.client}',
                        type: CustomTextType.paragraph,
                      ),
                    Opacity(
                      opacity: 0.5,
                      child: CustomText(
                        formatHumanDate(entry.date),
                        type: CustomTextType.subHeader,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    CustomText(
                      entry.description,
                      type: CustomTextType.paragraph,
                    ),
                    if (Responsive.isMobile(context))
                      SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (entry.dr > 0)
                                Text(
                                  'DR: ${ceilCurrency(entry.dr)}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              const SizedBox(width: 10),
                              if (entry.cr > 0)
                                Text(
                                  'CR: ${ceilCurrency(entry.cr)}',
                                  style: const TextStyle(color: Colors.green),
                                ),
                              const SizedBox(width: 10),
                              CustomText(
                                'Balance: ${ceilCurrency(entry.balance)}',
                                type: CustomTextType.paragraph,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                if (Responsive.isDesktopOrWider(context))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (entry.dr > 0)
                        Text(
                          'DR: ${ceilCurrency(entry.dr)}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      if (entry.cr > 0)
                        Text(
                          'CR: ${ceilCurrency(entry.cr)}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      CustomText(
                        'Balance: ${ceilCurrency(entry.balance)}',
                        type: CustomTextType.paragraph,
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                if (entry.ref.isNotEmpty)
                  _buildInfoChip('Ref: ${entry.ref}', Icons.code),
                if (entry.type.isNotEmpty)
                  _buildInfoChip('Type: ${entry.type}', Icons.category),
                if (entry.policyNo.isNotEmpty)
                  _buildInfoChip(
                    'Policy: ${entry.policyNo}',
                    Icons.description,
                  ),

                // policyIdStr
                // if (transIdStr.isNotEmpty)
                //   _buildInfoChip('Trans ID: ${entry.transId}', Icons.tag),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Theme.of(context).colorScheme.onSurface),
          const SizedBox(width: 4),
          CustomText(label, type: CustomTextType.caption),
        ],
      ),
    );
  }
}
