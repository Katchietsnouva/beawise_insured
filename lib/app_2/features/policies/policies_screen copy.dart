import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/theme/custom_text_styles.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/card_animation_layout.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/data/models/list_policy_response.dart';
import 'package:insured/app_2/data/models/list_policy_single_response.dart';
import 'package:insured/app_2/features/policies/widgets/policy_details_modal.dart';
import 'package:insured/app_2/features/policies/widgets/policy_details_modal_ById.dart';
import 'package:insured/app_2/providers/policy_provider.dart';
import 'package:intl/intl.dart';

class PoliciesScreen extends ConsumerStatefulWidget {
  const PoliciesScreen({super.key});

  @override
  ConsumerState<PoliciesScreen> createState() => _PoliciesScreenState();
}

class _PoliciesScreenState extends ConsumerState<PoliciesScreen> {
  int? _selectedStatus;
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '',
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(policyProvider.notifier).fetchPage(1);
    });
  }

  final Set<int> _expandedIndices = {};

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(policyProvider);
    final notifier = ref.read(policyProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // title: constCustomText(
        //   'Policies. Currently displaying with default status 0',
        //   style: TextStyle(color: Colors.white),
        // ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onPressed: () => notifier.refreshCurrentPage(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildPaginationControls(state, notifier),
          Expanded(
            child: state.isLoading && state.response == null
                ? const Center(child: CircularProgressIndicator())
                : state.error != null && state.response == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${state.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        CustomAdvancedButton(
                          width: 200,
                          height: 40,
                          label: 'Retry',
                          onPressed: () => notifier.refreshCurrentPage(),
                          variant: ButtonVariant.primary,
                        ),
                      ],
                    ),
                  )
                : state.response?.policies.isEmpty ?? true
                ? const Center(
                    child: CustomText(
                      'No policies found',
                      type: CustomTextType.subHeader,
                    ),
                  )
                : _buildPolicyList(state, notifier),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls(PolicyState state, PolicyNotifier notifier) {
    final pagination = state.response?.pagination;
    if (pagination == null) return const SizedBox();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const CustomText(
                    // 'Items per page: ',
                    ' ',
                    type: CustomTextType.paragraph,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  DropdownButton<int>(
                    value: state.perPage,
                    dropdownColor: const Color(0xFF1E293B),
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    items: [5, 10, 20, 50, 100].map((v) {
                      return DropdownMenuItem(
                        value: v,
                        child: CustomText('$v'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) notifier.setPerPage(val);
                    },
                  ),
                  SizedBox(width: 4),
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<int?>(
                      value: _selectedStatus,
                      hint: Text(
                        'Status',
                        style: CustomTextStyles.style(
                          context,
                          type: CustomTextType.paragraph,
                        ),
                      ),
                      dropdownColor: const Color(0xFF1E293B),
                      style: const TextStyle(color: Colors.white),
                      underline: const SizedBox(),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: CustomText('All'),
                        ),
                        ...List.generate(4, (index) => index).map(
                          (i) => DropdownMenuItem(
                            value: i,
                            child: CustomText('Status $i'),
                          ),
                        ),
                      ],
                      onChanged: (value) async {
                        setState(() => _selectedStatus = value);
                        await notifier.setStatus(value);
                      },
                    ),
                  ),
                ],
              ),
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
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.9),
                ),
                onPressed: pagination.currentPage > 1
                    ? () => notifier.previousPage()
                    : null,
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.9),
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

  Widget _buildPolicyList(PolicyState state, PolicyNotifier notifier) {
    final policies = state.response!.policies;
    // final PolicyEntry policies = state.response!.policies;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: policies.length,
      itemBuilder: (ctx, i) {
        final entry = policies[i];
        final client = entry.client;
        final policy = entry.policy;
        final isMobile = Responsive.isMobile(context);
        final isExpanded = _expandedIndices.contains(i);

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CardAnimationLayout(
            index: i,
            bounce: true,
            bounceX: true,
            child: Material(
              elevation: Theme.of(context).brightness == Brightness.light
                  ? 4
                  : 6,
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).colorScheme.surface,
              child: Card(
                // margin: const EdgeInsets.only(bottom: 12),
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  onExpansionChanged: (expanded) {
                    setState(() {
                      if (expanded) {
                        _expandedIndices.add(i);
                      } else {
                        _expandedIndices.remove(i);
                      }
                    });
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange.withOpacity(0.2),
                    child: CustomText(
                      // client.name.isNotEmpty ? client.name[0].toUpperCase() : '?',
                      client.name.isNotEmpty
                          ? client.name.substring(0, 2).toUpperCase()
                          : '?',
                    ),
                  ),
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
                              '${policy.reg}',
                              // '${policy.policyNo ?? policy.risknote.toString()}',
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
                              '${_currencyFormat.format(policy.amount)}',
                              // '${policy.insurer}',
                              type: CustomTextType.caption,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomText(
                              '${_currencyFormat.format(policy.balance)}',
                              // '${policy.insurer}',
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
                            _currencyFormat.format(policy.amount),
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
                                  : 'Balance: ${_currencyFormat.format(policy.balance)}',
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
                        turns: isExpanded ? 0.5 : 0.0,
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
                            '${policy.starting} to ${policy.ending}',
                          ),
                          _buildDetailRow(
                            'Sum Insured',
                            _currencyFormat.format(policy.sumInsured),
                          ),
                          _buildDetailRow(
                            'Premium',
                            _currencyFormat.format(policy.amount),
                          ),
                          _buildDetailRow(
                            'Commission',
                            _currencyFormat.format(policy.commission),
                          ),

                          _buildDetailRow('Transaction', policy.transaction),
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
                                        policyEntry: entry,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: CustomAdvancedButton(
                                  height: 42,
                                  label: 'Full Details',
                                  variant: ButtonVariant.primary,
                                  onPressed: () async {
                                    final policyId = policy.id;

                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          FutureBuilder<SinglePolicyResponse?>(
                                            future: notifier.fetchPolicyById(
                                              policyId,
                                            ),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(80),
                                                    child:
                                                        CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                );
                                              }

                                              if (snapshot.hasError ||
                                                  snapshot.data?.isSuccess !=
                                                      true) {
                                                return const Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(40),
                                                    child: Text(
                                                      'Failed to load full details',
                                                      style: TextStyle(
                                                        color: Colors.redAccent,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }

                                              return PolicyDetailsModalFull(
                                                response: snapshot.data,
                                              );
                                            },
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
        );
      },
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
