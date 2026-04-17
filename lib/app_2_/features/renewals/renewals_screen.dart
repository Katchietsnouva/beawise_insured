import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/card_animation_layout.dart';
import 'package:insured/app_2/core/widgets/cust_date_range_filter.dart';
import 'package:insured/app_2/core/widgets/custom_dropdown.dart';
import 'package:insured/app_2/core/widgets/custom_error_refresh_placeholder_adv.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/ghost_card.dart';
import 'package:insured/app_2/features/renewals/widgets/renewal_card.dart';
import 'package:insured/app_2/providers/client_view_provider.dart';
import 'package:insured/app_2/providers/renewal_provider.dart';
import 'package:intl/intl.dart';

class RenewalsScreen extends ConsumerStatefulWidget {
  final StateProvider<ClientViewMode> viewModeProvider;
  // ignore: deprecated_member_use
  // const RenewalsScreen(Required required, viewModeProvider, {super.key, required this.viewModeProvider});

  const RenewalsScreen({super.key, required this.viewModeProvider});
  @override
  ConsumerState<RenewalsScreen> createState() => _RenewalsScreenState();
}

class _RenewalsScreenState extends ConsumerState<RenewalsScreen> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  DateTime? _startDate;
  DateTime? _endDate;
  final Set<int> _expandedIndices = {};

  @override
  void initState() {
    super.initState();
    _initDatesFromState();
  }

  void _initDatesFromState() {
    final state = ref.read(renewalProvider);
    try {
      _startDate = DateTime.parse(state.startDate);
      _endDate = DateTime.parse(state.endDate);
    } catch (_) {
      // fallback to defaults
      final now = DateTime.now();
      _startDate = DateTime(now.year, now.month, 1);
      _endDate = DateTime(now.year, now.month + 2, 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(renewalProvider);
    final notifier = ref.read(renewalProvider.notifier);
    final currency = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');
    final viewMode = ref.watch(widget.viewModeProvider);

    // ignore: no_leading_underscores_for_local_identifiers
    Widget _buildGhostSliver() {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) => CardAnimationLayout(
            index: i,
            bounce: true,
            // bounceX: true,
            child: const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: GhostCard(),
            ),
          ),
          childCount: 6,
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onRefresh: () async {
          await notifier.refreshCurrentPage();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leadingWidth: 0,
              titleSpacing: 0,
              title: Padding(
                padding: EdgeInsets.only(
                  left: Responsive.isMobile(context) ? 10 : 20,
                ),
                child: DateRangeFilter(
                  initialStart: _startDate ?? DateTime.now(),
                  initialEnd: _endDate ?? DateTime.now(),
                  compact: true,
                  labelPrefix: "Period:",
                  onRangeSelected: (start, end) {
                    setState(() {
                      _startDate = start;
                      _endDate = end;
                    });
                    // ref.read(renewalProvider.notifier)
                    //     .setDateRange(
                    //       start: _dateFormat.format(start),
                    //       end: _dateFormat.format(end),
                    //     );
                    notifier.setDateRange(
                      start: start.toIso8601String().split('T')[0],
                      end: end.toIso8601String().split('T')[0],
                    );
                  },
                ),
              ),
              actions: [
                if (!Responsive.isMobile(context))
                  IconButton(
                    icon: Icon(
                      viewMode == ClientViewMode.list
                          ? Icons.grid_view
                          : Icons.view_list,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    onPressed: () {
                      ref
                          .read(widget.viewModeProvider.notifier)
                          .update(
                            (mode) => mode == ClientViewMode.list
                                ? ClientViewMode.grid
                                : ClientViewMode.list,
                          );
                    },
                  ),
                if (!Responsive.isMobile(context))
                  Padding(
                    padding: EdgeInsets.only(
                      right: Responsive.isMobile(context) ? 10 : 20,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () => notifier.refreshCurrentPage(),
                    ),
                  ),
              ],
            ),
            if (!Responsive.isMobile(context))
              SliverToBoxAdapter(
                child: _buildPaginationControls(state, notifier),
              ),
            state.isLoading
                // && state.response == null
                ? SliverPadding(
                    padding: const EdgeInsets.all(20.0),
                    sliver: _buildGhostSliver(),
                  )
                : state.error != null && state.response == null
                ? SliverToBoxAdapter(
                    child: CustomErrorRefreshPlaceholder(
                      details: state.error,
                      onRetry: () => notifier.refreshCurrentPage(),
                    ),
                  )
                : state.response?.policies.isEmpty ?? true
                ? SliverToBoxAdapter(
                    // child: Center(
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       CustomText(
                    //         'No renewals found',
                    //         type: CustomTextType.subHeader,
                    //       ),
                    //       CustomAdvancedButton(
                    //         variant: ButtonVariant.circular,
                    //         // label: "Refresh",
                    //         label: "",
                    //         icon: Icon(Icons.refresh),
                    //         onPressed: () => notifier.refreshCurrentPage(),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    child: CustomErrorRefreshPlaceholder(
                      message: 'No renewals found',
                      icon: Icons.search_off,
                      color: Theme.of(context).colorScheme.onSurface,
                      details: state.response?.message,
                      onRetry: () => notifier.refreshCurrentPage(),
                    ),
                  )
                : _buildRenewalList(state, currency, notifier, viewMode),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls(
    RenewalState state,
    RenewalNotifier notifier,
  ) {
    final pagination = state.response?.pagination;
    if (pagination == null) return const SizedBox();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 10 : 20,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 140,
                    child: CustomDropdown<int>(
                      // 'Items per page: ',
                      hint: '',
                      icon: Icons.format_list_numbered,
                      value: state.perPage,
                      items: (() {
                        final options = [5, 10, 20, 50, 100];
                        if (!options.contains(state.perPage))
                          options.insert(0, state.perPage);
                        return options
                            .map(
                              (v) => DropdownMenuItem<int>(
                                value: v,
                                child: Text('$v'),
                              ),
                            )
                            .toList();
                      })(),
                      onChanged: (val) {
                        if (val != null) notifier.setPerPage(val);
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

  Widget _buildRenewalList(
    RenewalState state,
    NumberFormat currency,
    RenewalNotifier notifier,
    ClientViewMode viewMode,
  ) {
    final policies = state.response!.policies;

    if (viewMode == ClientViewMode.list) {
      // return ListView.builder(
      return SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 10 : 20,
          vertical: 10,
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((ctx, i) {
            final entry = policies[i];

            return RenewalCard(
              viewMode: viewMode,
              entry: entry,
              onTap: () => context.push('/renewal-detail', extra: entry),
              index: i,
              // isExpanded: isExpanded,
              currency: currency,
            );
          }, childCount: policies.length),
        ),
        // itemCount: policies.length,
        // itemBuilder:
      );
    } else {
      // return MasonryGridView.count(
      return SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 10 : 20,
          vertical: 10,
        ),
        sliver: SliverMasonryGrid.count(
          crossAxisCount: Responsive.isMobile(context)
              ? 2
              : Responsive.isTablet(context)
              ? 2
              : Responsive.isDesktop(context)
              ? 3
              : 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childCount: policies.length,
          itemBuilder: (ctx, i) {
            final entry = policies[i];
            return CardAnimationLayout(
              index: i,
              bounce: true,
              child: RenewalCard(
                viewMode: viewMode,
                entry: entry,
                onTap: () => context.push('/renewal-detail', extra: entry),
                index: i,
                currency: currency,
              ),
            );
          },
        ),
      );
    }
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
