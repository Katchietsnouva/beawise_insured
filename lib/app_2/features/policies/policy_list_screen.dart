import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/core/theme/custom_text_styles.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/card_animation_layout.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_checkbox.dart';
import 'package:insured/app_2/core/widgets/custom_dropdown.dart';
import 'package:insured/app_2/core/widgets/custom_error_refresh_placeholder_adv.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field_animated_search_bar.dart';
import 'package:insured/app_2/core/widgets/ghost_card.dart';
import 'package:insured/app_2/data/models/list_policy_response.dart';
import 'package:insured/app_2/features/policies/widgets/export_policies_dialog.dart';
import 'package:insured/app_2/features/policies/widgets/policy_card.dart';
import 'package:insured/app_2/features/policies/widgets/policy_details_modal_ById.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:insured/app_2/providers/client_view_provider.dart';
import 'package:insured/app_2/providers/policy_provider.dart';
import 'package:intl/intl.dart';

class PolicyListScreen extends ConsumerStatefulWidget {
  final int? initialStatus;
  final String title;
  final Function(PolicyEntry)? onCardTap;
  final StateProvider<ClientViewMode> viewModeProvider;

  /// Shows an "Export Excel" action that downloads the list as a spreadsheet.
  final bool enableExport;

  const PolicyListScreen({
    super.key,
    this.initialStatus,
    required this.title,
    this.onCardTap,
    required this.viewModeProvider,
    this.enableExport = false,
  });

  @override
  ConsumerState<PolicyListScreen> createState() => _PolicyListScreenState();
}

class _PolicyListScreenState extends ConsumerState<PolicyListScreen> {
  final GlobalKey<AnimatedSearchBarState> _searchBarCallerKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  bool _searchExpanded = false;

  int? _selectedStatus;
  final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'en_US',
    symbol: '',
  );
  String _searchQuery = '';
  bool _filterByName = true;
  bool _filterByEmail = true;
  bool _filterByReg = true;

  final Set<int> _expandedIndices = {};
  bool _modalOpened = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is int && !_modalOpened) {
      // Remove the extra so it doesn't open again on rebuild
      _modalOpened = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openPolicyModal(extra);
      });
    }
  }

  Future<void> _openPolicyModal(int policyId) async {
    final notifier = ref.read(policyProvider.notifier);
    final response = await notifier.fetchPolicyById(policyId);
    if (response != null && mounted) {
      print("debuggin if this runs after payment confirmation... 1");
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        // builder: (_) => PolicyDetailsModalFull(response: response),
        builder: (_) => PolicyDetailsModalFull(
          response: response,
          onPaymentConfirmed: () async {
            print("debuggin if this runs after payment confirmation... 2");
            // 1. Close all modals
            // Navigator.pop(context); // closes policy modal
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              print('Yoooooow! no pages are left in the stack');
            }
            // // 2. Navigate to Production (if not already there)
            // //    Assuming the production screen is at '/production'
            // //    You might need to pop until that route or use GoRouter.
            // // if (GoRouter.of(context).location != '/production') {
            // //   context.go('/production');
            // // }
            // final currentLocation = GoRouterState.of(context).uri.toString();
            // if (currentLocation != '/production') {
            //   context.go('/production');
            // }
            context.goNamed('production', extra: policyId);

            // if (!mounted) return;
            await ref.read(policyProvider.notifier).refreshAllAndReset();
            // 4. Re-open the policy modal with the same ID
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _openPolicyModal(policyId);
            });
          },
        ),
      );
    }
  }

  void _handlePaymentSuccess(int policyId) async {
    // 1. Close the policy modal if it's open
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    // 2. Navigate to Production, passing the policy ID
    context.goNamed('production', extra: policyId);
    // 3. Refresh the policy list
    await ref.read(policyProvider.notifier).refreshAllAndReset();
    // 4. Reopen the policy modal (optional)
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openPolicyModal(policyId);
      });
    }
  }

  final TextEditingController _searchController = TextEditingController();

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (_) => ExportPoliciesDialog(
        fixedStatus: widget.initialStatus,
        title: widget.title,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(policyProvider.notifier);
      if (widget.initialStatus != null) {
        setState(() => _selectedStatus = widget.initialStatus);
        notifier.setStatus(widget.initialStatus);
      } else {
        notifier.fetchPage(1);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = position.pixels;
    final threshold = 200.0;

    if (currentScroll >= maxScroll - threshold) {
      _loadMore();
    }
  }

  void _loadMore() {
    final notifier = ref.read(policyProvider.notifier);
    final state = ref.read(policyProvider);
    final pagination = state.response?.pagination;

    // Don't load if already at last page or currently loading a page
    if (pagination == null) return;
    if (state.currentPage >= pagination.lastPage) return;
    if (state.loadingPages.contains(state.currentPage + 1)) return;

    notifier.nextPage();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(policyProvider);
    final notifier = ref.read(policyProvider.notifier);
    final viewMode = ref.watch(widget.viewModeProvider);

    // Combine all loaded pages from the cache for the current status
    List<PolicyEntry> _getAllLoadedPolicies(PolicyState state) {
      final statusCache = state.cachedPages[state.currentStatus] ?? {};
      // Sort by page number to ensure they stack correctly (Page 1, then Page 2...)
      final sortedPages = statusCache.keys.toList()..sort();

      List<PolicyEntry> combined = [];
      for (var page in sortedPages) {
        combined.addAll(statusCache[page]!.policies);
      }
      return combined;
    }

    final allLoadedPolicies = _getAllLoadedPolicies(state);

    List<PolicyEntry> _filterPolicies(List<PolicyEntry> policies) {
      if (_searchQuery.isEmpty) return policies;
      final query = _searchQuery.toLowerCase();
      return policies.where((entry) {
        final client = entry.client;
        final policy = entry.policy;
        return client.name.toLowerCase().contains(query) ||
            client.email.toLowerCase().contains(query) ||
            (policy.reg?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

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

    Widget SearchWithFilter_ = CustomTextField(
      hint: 'name/email/reg...',
      icon: Icons.search,
      controller: _searchController,
      isSearchField: true,
      onSearchChanged: (query) {
        // ref
        //     .read(policyProvider.notifier)
        //     .setSearchQuery(query);
        setState(() {
          _searchQuery = query;
        });
      },
      onChanged: (query) {
        // Optional: immediate feedback (e.g., update UI)
      },
      debounceDuration: Duration(milliseconds: 300),
    );

    Widget expContrSearchWithFilter = AnimatedSearchBar(
      key: _searchBarCallerKey,
      controller: _searchController,
      hint: 'Search by name /email /reg...',
      debounceDuration: const Duration(milliseconds: 300),
      onSearchChanged: (query) => setState(() => _searchQuery = query),
      filterDialogTitle: 'Search Filters',

      // // onToggle: () => setState(() {}),
      // onToggle: () => setState(() => _searchExpanded = !_searchExpanded),
      onToggle: () {
        // Use the actual state from the key to keep the parent in sync
        final isNowExpanded =
            _searchBarCallerKey.currentState?.isExpanded ?? false;
        if (_searchExpanded != isNowExpanded) {
          setState(() => _searchExpanded = isNowExpanded);
        }
      },
      // ← drop your whole _showFilterDialog body right here
      filterDialogBuilder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomCheckbox(
              label: 'Name',
              value: _filterByName,
              onChanged: (val) {
                setDialogState(() => _filterByName = val ?? true);
                setState(() {});
              },
            ),
            CustomCheckbox(
              label: 'Email',
              value: _filterByEmail,
              onChanged: (val) {
                setDialogState(() => _filterByEmail = val ?? true);
                setState(() {});
              },
            ),
            CustomCheckbox(
              label: 'Registration No',
              value: _filterByReg,
              onChanged: (val) {
                setDialogState(() => _filterByReg = val ?? true);
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomAdvancedButton(
                  height: 34,
                  width: 100,
                  customFontSize: 12,
                  label: 'Clear All',
                  variant: ButtonVariant.secondary,
                  onPressed: () {
                    setDialogState(() {
                      _filterByName = _filterByEmail = _filterByReg = false;
                    });
                    setState(() {});
                  },
                ),
                CustomAdvancedButton(
                  height: 34,
                  width: 100,
                  customFontSize: 12,
                  label: 'Select All',
                  variant: ButtonVariant.primary,
                  onPressed: () {
                    setDialogState(() {
                      _filterByName = _filterByEmail = _filterByReg = true;
                    });
                    setState(() {});
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          // Trigger when user is within 200 pixels of the bottom
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - 200) {
            final pagination = state.response?.pagination;
            if (pagination != null && !state.isLoading) {
              if (state.currentPage < pagination.lastPage) {
                // Prevent spamming the API if the next page is already loading
                if (!state.loadingPages.contains(state.currentPage + 1)) {
                  notifier.nextPage();
                }
              }
            }
          }
          return false; // Let the scroll events bubble up
        },
        child: RefreshIndicator(
          color: Theme.of(context).colorScheme.onSurface,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          onRefresh: () async {
            // await notifier.refreshCurrentPage();
            await notifier.refreshAllAndReset();
          },
          child: CustomScrollView(
            // controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (!Responsive.isMobile(context) ||
                  (Responsive.isMobile(context) &&
                      // (_searchBarCallerKey.currentState?.isExpanded ?? true)))
                      // (_searchBarCallerKey.currentState?.isExpanded ?? true)))
                      _searchExpanded))
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leadingWidth: 0,
                  titleSpacing: 0,
                  // title: _buildPaginationControls(state, notifier),
                  title: Padding(
                    padding: EdgeInsets.only(
                      left: Responsive.isMobile(context) ? 10 : 20,
                      right: 4,
                    ),
                    child: Row(
                      children: [
                        Flexible(child: expContrSearchWithFilter),
                        // if (Responsive.isMobile(context)) ...[
                        // const SizedBox(width: 4),
                        // IconButton( icon: Icon(Icons.filter_list, color: Theme.of(context).colorScheme.onSurface), onPressed: () { _showFilterDialog();},),
                      ],
                    ),
                  ),
                  actions: [
                    if (widget.enableExport)
                      IconButton(
                        icon: Icon(
                          Icons.file_download_outlined,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        tooltip: 'Export to Excel',
                        onPressed: _showExportDialog,
                      ),
                    // Expanded(child: SearchWithFilter),
                    if (!Responsive.isMobile(context))
                      // SearchWithFilter,
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
                                  (prev) => prev == ClientViewMode.list
                                      ? ClientViewMode.grid
                                      : ClientViewMode.list,
                                );
                          },
                          tooltip: viewMode == ClientViewMode.list
                              ? 'Switch to Grid'
                              : 'Switch to List',
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
                          // onPressed: () => {notifier.refreshCurrentPage()},
                          onPressed: () => {notifier.refreshAllAndReset()},
                        ),
                      ),
                  ],

                  // ),
                ),
              if (!Responsive.isMobile(context))
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Responsive.isMobile(context) ? 10 : 20,
                      vertical: 4,
                    ),
                    child: _buildPaginationControls(state, notifier),
                  ),
                ),
              // state.isLoading
              // isInitialLoad
              // We only want to show the full-screen ghost skeletons if it's the very first load
              (state.isLoading && allLoadedPolicies.isEmpty)
                  //  && state.response == null
                  ? SliverPadding(
                      padding: const EdgeInsets.all(20.0),
                      sliver: _buildGhostSliver(),
                    )
                  // : state.error != null && state.response == null
                  // : state.error != null && allLoadedPolicies.isEmpty
                  : state.error != null &&
                        (state.response == null || !state.response!.isSuccess)
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: CustomErrorRefreshPlaceholder(
                        // message: safgsfdfda',
                        details: state.error,
                        // onRetry: () => notifier.refreshCurrentPage(),
                        onRetry: () => notifier.refreshAllAndReset(),
                      ),
                    )
                  // // : state.response!.policies.isEmpty
                  // : state.response?.policies.isEmpty ?? true
                  : allLoadedPolicies.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: CustomErrorRefreshPlaceholder(
                        message: 'No ${widget.title.toLowerCase()} found',
                        icon: Icons.search_off,
                        color: Theme.of(context).colorScheme.onSurface,
                        details: state.response?.message,
                        // onRetry: () => notifier.refreshCurrentPage(),
                        onRetry: () => notifier.refreshAllAndReset(),
                      ),
                    )
                  : _buildPolicyList(
                      state,
                      notifier,
                      viewMode,
                      allLoadedPolicies,
                    ),

              if (state.isLoading && allLoadedPolicies.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // TODO: your action
      //   },
      //   child: const Icon(Icons.add),
      // ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.enableExport && Responsive.isMobile(context)) ...[
            FloatingActionButton(
              heroTag: 'fab_export',
              mini: true,
              onPressed: _showExportDialog,
              elevation: 12,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(
                Theme.of(context).brightness == Brightness.light ? 1 : 0.25,
              ),
              tooltip: 'Export to Excel',
              child: Icon(
                Icons.file_download_outlined,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
          ],
          FloatingActionButton(
            heroTag: 'fab_search',
            // // // onPressed: () => _handleNewClient(context, ref),
            // // onPressed: () {
            // //   _searchBarCallerKey.currentState?.expand();
            // // },
            // onPressed: () {
            //   final searchState = _searchBarCallerKey.currentState;
            //   if (searchState == null) return;

            //   if (searchState.isExpanded) {
            //     searchState.collapse();
            //   } else {
            //     searchState.expand();
            //   }
            //   // We don't strictly need setState here if onToggle is working,
            //   // but it doesn't hurt for immediate UI feedback
            // },
            onPressed: () {
              if (_searchExpanded) {
                _searchBarCallerKey.currentState?.collapse();
                // onToggle handles setState
              } else {
                setState(() => _searchExpanded = true);
                // // give the SliverAppBar one frame to mount, then expand
                // WidgetsBinding.instance.addPostFrameCallback((_) {
                //   _searchBarCallerKey.currentState?.expand();
                // });
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_searchBarCallerKey.currentState != null) {
                    _searchBarCallerKey.currentState!.expand();
                  }
                });
              }
            },
            elevation: 20,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(
              Theme.of(context).brightness == Brightness.light ? 1 : 0.25,
            ),
            child: Icon(
              // _searchBarCallerKey.currentState?.isExpanded == true
              _searchExpanded ? Icons.close : Icons.search,
              size: 32,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls(PolicyState state, PolicyNotifier notifier) {
    final pagination = state.response?.pagination;
    if (pagination == null) return const SizedBox();

    return Container(
      // padding: const EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 16),
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
                      items: [5, 10, 20, 50, 100].map((v) {
                        return DropdownMenuItem<int>(
                          value: v,
                          // child: CustomText('$v'),
                          child: Text(v.toString()),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) notifier.setPerPage(val);
                      },
                    ),
                  ),
                  // Only show status filter if no initialStatus was provided
                  if (widget.initialStatus == null) ...[
                    const SizedBox(width: 4),
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

  Widget _buildPolicyList(
    PolicyState state,
    PolicyNotifier notifier,
    ClientViewMode viewMode,
    List<PolicyEntry> allPolicies,
  ) {
    // // final policies = state.response!.policies;
    // final allPolicies = state.response?.policies ?? [];

    List<PolicyEntry> _filterPolicies(List<PolicyEntry> policies) {
      if (_searchQuery.isEmpty) return policies;
      final query = _searchQuery.toLowerCase();
      return policies.where((entry) {
        final client = entry.client;
        final policy = entry.policy;
        return (_filterByName && client.name.toLowerCase().contains(query)) ||
            (_filterByEmail && client.email.toLowerCase().contains(query)) ||
            (_filterByReg &&
                (policy.reg?.toLowerCase().contains(query) ?? false));
      }).toList();
    }

    final filteredPolicies = _filterPolicies(allPolicies);

    final filteredPolicies__ = allPolicies.where((entry) {
      final query = state.searchQuery.toLowerCase();
      if (query.isEmpty) return true;

      final name = entry.client.name.toLowerCase();
      final email = entry.client.email.toLowerCase();
      final reg = (entry.policy.reg ?? '').toLowerCase();

      return name.contains(query) ||
          email.contains(query) ||
          reg.contains(query);
    }).toList();

    if (filteredPolicies.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: CustomText('No matching policies found.')),
      );
    }

    if (viewMode == ClientViewMode.list) {
      return SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 10 : 20,
          vertical: 20,
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((ctx, i) {
            final entry = filteredPolicies[i];

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CardAnimationLayout(
                index: i,
                bounce: true,
                animateOnce: true,
                child: PolicyCard(
                  viewMode: viewMode,
                  entry: entry,
                  currencyFormat: _currencyFormat,
                  authState: ref.read(authProvider),
                  notifier: notifier,
                  onTap: widget.onCardTap != null
                      ? () => widget.onCardTap!(entry)
                      : null,
                  onPaymentConfirmed: _handlePaymentSuccess,
                ),
              ),
            );
          }, childCount: filteredPolicies.length),
        ),
      );
    } else {
      return SliverPadding(
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? 10 : 20,
          vertical: 20,
        ),
        sliver: SliverMasonryGrid.count(
          crossAxisCount: Responsive.isMobile(context)
              ? 2
              : Responsive.isTablet(context)
              ? 3
              : Responsive.isDesktop(context)
              ? 3
              : 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childCount: filteredPolicies.length,
          itemBuilder: (context, i) {
            final entry = filteredPolicies[i];

            return CardAnimationLayout(
              index: i,
              bounce: true,
              animateOnce: true,
              child: PolicyCard(
                viewMode: viewMode,
                entry: entry,
                currencyFormat: _currencyFormat,
                authState: ref.read(authProvider),
                notifier: notifier,
                onTap: widget.onCardTap != null
                    ? () => widget.onCardTap!(entry)
                    : null,
                onPaymentConfirmed: _handlePaymentSuccess,
              ),
            );
          },
        ),
      );
    }
  }
}
