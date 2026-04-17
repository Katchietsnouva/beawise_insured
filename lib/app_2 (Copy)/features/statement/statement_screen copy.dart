import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/providers/statement_provider.dart';
import 'package:intl/intl.dart';

class StatementScreen extends ConsumerStatefulWidget {
  const StatementScreen({super.key});

  @override
  ConsumerState<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends ConsumerState<StatementScreen> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statementProvider.notifier).fetchPage(1);
    });
  }

  Future<void> _selectDateRange() async {
    final DateTime? start = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (start != null) {
      final DateTime? end = await showDatePicker(
        context: context,
        initialDate: _endDate ?? start,
        firstDate: start,
        lastDate: DateTime.now(),
      );
      if (end != null) {
        setState(() {
          _startDate = start;
          _endDate = end;
        });
        final notifier = ref.read(statementProvider.notifier);
        await notifier.setDateRange(
          start: _dateFormat.format(start),
          end: _dateFormat.format(end),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(statementProvider);
    final notifier = ref.read(statementProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // title: const Text('Statement', style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 24.0),
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => notifier.refreshCurrentPage(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date range selector
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _selectDateRange,
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomText(
                              _startDate == null || _endDate == null
                                  ? 'Select Date Range'
                                  : '${_dateFormat.format(_startDate!)} – ${_dateFormat.format(_endDate!)}',
                              type: CustomTextType.paragraph,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildPaginationControls(state, notifier),
          // Table
          Expanded(
            child: state.isLoading && state.response == null
                ? const Center(child: CircularProgressIndicator())
                : state.error != null && state.response == null
                ? Center(
                    child: Text(
                      'Error: ${state.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : _buildStatementTable(state),
          ),
        ],
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
          Row(
            children: [
              const CustomText(
                // 'Items per page: ',
                ' ',
                type: CustomTextType.subHeader,
              ),
              DropdownButton<int>(
                value: state.perPage,
                dropdownColor: const Color(0xFF1E293B),
                style: const TextStyle(color: Colors.white),
                items: [5, 10, 20, 50, 100].map((v) {
                  return DropdownMenuItem(value: v, child: Text('$v'));
                }).toList(),
                onChanged: (val) {
                  if (val != null) notifier.setPerPage(val);
                },
              ),
            ],
          ),
          // Page info + navigation
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

  Widget _buildStatementTable(StatementState state) {
    final response = state.response;
    if (response == null || response.sections.isEmpty) {
      return const Center(
        child: CustomText(
          'No statement entries',
          type: CustomTextType.paragraph,
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(
            Colors.orange.withOpacity(0.2),
          ),
          dataRowColor: MaterialStateProperty.all(Colors.transparent),
          headingTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
          dataTextStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          columns: const [
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Ref')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Policy No')),
            DataColumn(label: Text('Policy ID')),
            DataColumn(label: Text('Trans ID')),
            DataColumn(label: Text('Client')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('DR'), numeric: true),
            DataColumn(label: Text('CR'), numeric: true),
            DataColumn(label: Text('Balance'), numeric: true),
          ],
          rows: response.sections.map((entry) {
            return DataRow(
              cells: [
                DataCell(Text(entry.date)),
                DataCell(Text(entry.ref)),
                DataCell(Text(entry.type)),
                DataCell(Text(entry.policyNo)),
                DataCell(Text(entry.policyId)),
                DataCell(Text(entry.transId)),
                DataCell(Text(entry.client)),
                DataCell(Text(entry.description)),
                DataCell(Text(entry.dr.toStringAsFixed(2))),
                DataCell(Text(entry.cr.toStringAsFixed(2))),
                DataCell(Text(entry.balance.toStringAsFixed(2))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
