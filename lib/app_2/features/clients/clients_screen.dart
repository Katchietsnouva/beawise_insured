import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_checkbox.dart';
import 'package:insured/app_2/core/widgets/custom_t_speed_dial_fab.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field_animated_search_bar.dart';
import 'package:insured/app_2/features/clients/add_client_screen.dart';
import 'package:insured/app_2/features/clients/clients_screen_from_api.dart';
import 'package:insured/app_2/features/clients/pagination_controls.dart';
import 'package:insured/app_2/providers/client_pagination_provider.dart';
import 'package:insured/app_2/providers/client_search_provider.dart';
import 'package:insured/app_2/providers/client_view_provider.dart';

class ClientsScreen extends ConsumerStatefulWidget {
  ClientsScreen({super.key});

  // final clients = clients;

  @override
  ConsumerState<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ClientsScreen> {
  final GlobalKey<AnimatedSearchBarState> _searchBarKey = GlobalKey();
  bool _searchExpanded = false;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clientsPaginationProvider.notifier).fetchPage(1);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
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
    // final notifier = ref.read(clientsPaginationProvider.notifier);
    // final state = ref.read(clientsPaginationProvider);
    // final pagination = state.response?.pagination;

    // if (pagination == null) return;
    // if (state.currentPage >= pagination.lastPage) return;
    // if (state.loadingPages.contains(state.currentPage + 1)) return;

    // notifier.nextPage();
  }

  void _onSearchChanged_(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(clientsPaginationProvider.notifier).setSearchQuery(query);
    });
  }

  // void _onSearchChanged(String query) {
  //   if (_debounce?.isActive ?? false) _debounce?.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 500), () {
  //     ref.read(clientSearchProvider.notifier).search(query);
  //     ref.read(clientsPaginationProvider.notifier).setSearchQuery(query);
  //   });

  //   // if (query.isEmpty) {
  //   //   ref.read(clientSearchProvider.notifier).clear();
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    final viewMode = ref.watch(clientViewModeProvider);
    final paginationState = ref.watch(clientsPaginationProvider);
    final paginationNotifier = ref.read(clientsPaginationProvider.notifier);

    final isLight = Theme.of(context).brightness == Brightness.light;
    final GlobalKey<SpeedDialFABState> _speedDialKey = GlobalKey();

    Widget oldSearchField = CustomTextField(
      hint: 'Search clients...',
      icon: Icons.search,
      controller: _searchController,
      isSearchField: true,
      onSearchChanged: (query) {
        ref
            //     .read(clientsPaginationProvider.notifier)
            //     .setSearchQuery(query);
            // // _onSearchChanged(query);
            .read(clientsPaginationProvider.notifier)
            .onSearchChanged(query);
        // ref.read(clientSearchProvider.notifier).search(query);
      },
      onChanged: (query) {
        // Optional: immediate feedback (e.g., update UI)
        ref.read(clientsPaginationProvider.notifier).setSearchQuery(query);
        ref.read(clientSearchProvider.notifier).search(query);
      },
      debounceDuration: Duration(milliseconds: 300),
    );

    Widget advancedSearchField = AnimatedSearchBar(
      key: _searchBarKey,
      controller: _searchController,
      hint: 'Search clients...',
      debounceDuration: const Duration(milliseconds: 300),

      onSearchChanged: (query) {
        ref.read(clientsPaginationProvider.notifier).setSearchQuery(query);
        ref.read(clientSearchProvider.notifier).search(query);
      },
      onToggle: () {
        final isNowExpanded = _searchBarKey.currentState?.isExpanded ?? false;
        if (_searchExpanded != isNowExpanded) {
          setState(() => _searchExpanded = isNowExpanded);
        }
      },
      filterDialogTitle: 'Client Filters',
      filterDialogBuilder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              CustomCheckbox(
                label: 'Name',
                value: true,
                onChanged: (val) {
                  // plug your filter logic here
                },
              ),
              CustomCheckbox(label: 'Email', value: true, onChanged: (val) {}),
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
                        // _filterByName = _filterByEmail = _filterByReg = false;
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
                        // _filterByName = _filterByEmail = _filterByReg = true;
                      });
                      setState(() {});
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >=
              scrollInfo.metrics.maxScrollExtent - 200) {
            if (!paginationState.isLoading) {
              if (paginationState.currentPage < paginationState.lastPage) {
                // Prevent spamming the API
                if (!paginationState.loadingPages.contains(
                  paginationState.currentPage + 1,
                )) {
                  paginationNotifier.nextPage();
                }
              }
            }
          }
          return false;
        },
        child: RefreshIndicator(
          color: Theme.of(context).colorScheme.onSurface,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          onRefresh: () async {
            await ref
                .read(clientsPaginationProvider.notifier)
                // .refreshCurrentPage();
                .refreshAllAndReset();
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (!Responsive.isMobile(context) ||
                  (Responsive.isMobile(context) && _searchExpanded))
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leadingWidth: 0,
                  titleSpacing: 0,
                  title: Padding(
                    padding: EdgeInsets.only(
                      left: Responsive.isMobile(context) ? 10 : 20,
                      right: 4,
                    ),
                    child: Row(
                      children: [
                        // Expanded(child: oldSearchField),
                        Flexible(child: advancedSearchField),
                        // if (!Responsive.isMobile(context)) ...[
                        const SizedBox(width: 4),
                        // IconButton(
                        //   icon: Icon(
                        //     Icons.filter_list,
                        //     color: Theme.of(context).colorScheme.onSurface,
                        //   ),
                        //   onPressed: () {
                        //     _showFilterDialog();
                        //   },
                        // ),
                        // // ],
                      ],
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
                              .read(clientViewModeProvider.notifier)
                              .update(
                                (state) => state == ClientViewMode.list
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
                          onPressed: () => {
                            ref
                                .read(clientsPaginationProvider.notifier)
                                // .refreshCurrentPage(),
                                .refreshAllAndReset(),
                          },
                        ),
                      ),
                  ],
                ),
              // SliverToBoxAdapter(
              //   child: Column(
              //     children: [
              //       // Pagination controls
              //       const PaginationControls(),
              //       // Expanded(child: ClientsScreenApi()),
              //       SizedBox(
              //         height:
              //             MediaQuery.of(context).size.height -
              //             150, // Adjust as needed
              //         child: ClientsScreenApi(),
              //       ),
              //       // _buildBottomNav(paginationState, paginationNotifier),
              //     ],
              //   ),
              // ),
              if (!Responsive.isMobile(context))
                SliverToBoxAdapter(child: const PaginationControls()),

              SliverToBoxAdapter(child: ClientsScreenApi()),

              if (paginationState.isLoading &&
                  paginationState.cachedPages.isNotEmpty)
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
              // ClientsScreenApi(),
            ],
          ),
        ),
      ),

      // floatingActionButton: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   crossAxisAlignment: CrossAxisAlignment.end,
      //   children: [
      //     FloatingActionButton(
      //       heroTag: "fab_top",
      //       // mini: true,
      //       onPressed: () {
      //         if (_searchExpanded) {
      //           _searchBarKey.currentState?.collapse();
      //         } else {
      //           setState(() => _searchExpanded = true);
      //           WidgetsBinding.instance.addPostFrameCallback((_) {
      //             _searchBarKey.currentState?.expand();
      //           });
      //         }
      //       },
      //       elevation: isLight ? 16 : 20,
      //       backgroundColor: Theme.of(
      //         context,
      //       ).primaryColor.withOpacity(isLight ? 1 : 0.25),
      //       child: Icon(
      //         _searchExpanded ? Icons.close : Icons.search,
      //         size: 32,
      //         color: Theme.of(context).colorScheme.onSurface.withOpacity(1.0),
      //       ),
      //     ),

      //     const SizedBox(height: 12),

      //     FloatingActionButton(
      //       onPressed: () async {
      //         // final result = await showModalBottomSheet<bool>(
      //         final result =
      //             await showModalBottomSheet<(bool, Map<String, dynamic>)>(
      //               context: context,
      //               isScrollControlled: true,
      //               backgroundColor: Colors.transparent,
      //               builder: (context) => const AddClientModal(),
      //             );

      //         if (result != null) {
      //           final (success, data) = result;
      //           if (success) {
      //             ref
      //                 .read(clientsPaginationProvider.notifier)
      //                 .refreshAllAndReset();
      //           }
      //         }
      //       },
      //       elevation: isLight ? 16 : 20,
      //       backgroundColor: Theme.of(
      //         context,
      //       ).primaryColor.withOpacity(isLight ? 1 : 0.25),
      //       child: Icon(
      //         Icons.add,
      //         size: 40,
      //         color: Theme.of(context).colorScheme.onSurface.withOpacity(1.0),
      //       ),
      //     ),
      //   ],
      // ),
      floatingActionButton: SpeedDialFAB(
        key: _speedDialKey,
        isLight: isLight,
        openIcon: Icons.menu,
        closeIcon: Icons.close,
        actions: [
          // Search — wires into your existing AnimatedSearchBar logic
          SpeedDialAction(
            heroTag: "fab_search",
            icon: _searchExpanded ? Icons.search_off : Icons.search,
            tooltip: 'Search',
            onPressed: () {
              _speedDialKey.currentState?.close();
              if (_searchExpanded) {
                _searchBarKey.currentState?.collapse();
              } else {
                setState(() => _searchExpanded = true);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _searchBarKey.currentState?.expand();
                });
              }
            },
          ),

          // Add client
          SpeedDialAction(
            heroTag: "fab_add",
            icon: Icons.add,
            tooltip: 'Add Client',
            onPressed: () async {
              _speedDialKey.currentState?.close();
              final result =
                  await showModalBottomSheet<(bool, Map<String, dynamic>)>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const AddClientModal(),
                  );
              if (result != null) {
                final (success, _) = result;
                if (success) {
                  ref
                      .read(clientsPaginationProvider.notifier)
                      .refreshAllAndReset();
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(
    ClientsPaginationState state,
    ClientsPaginationNotifier notifier,
  ) {
    // final pagination = state.response?.pagination;
    if (state == null) return const SizedBox();

    return Container(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.6),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navBtn("PREV", state.currentPage > 1 ? notifier.previousPage : null),
          CustomText(
            '${state.currentPage} of ${state.lastPage}',
            // "${pagination.currentPage} / ${pagination.lastPage}",
            type: CustomTextType.caption,
          ),
          _navBtn(
            "NEXT",
            state.currentPage < state.lastPage ? notifier.nextPage : null,
          ),
        ],
      ),
    );
  }

  Widget _navBtn(String label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: onTap == null
              ? Theme.of(context).colorScheme.onSurface.withOpacity(0.4)
              : const Color(0xFF00FFB2),
        ),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: CustomText('Filter Clients'),
        content: CustomText('Filter options coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// Expanded(
//   // child: ListView.separated(
//   //   padding: const EdgeInsets.symmetric(horizontal: 16),
//   //   itemCount: clients.length,
//   //   separatorBuilder: (_, __) => const SizedBox(height: 12),
//   //   itemBuilder: (ctx, i) => ClientCard(client: clients[i]),
//   // ),
//   child: viewMode == ClientViewMode.list
//       ? ListView.separated(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           itemCount: clients.length,
//           separatorBuilder: (_, __) =>
//               const SizedBox(height: 12),
//           itemBuilder: (ctx, i) => ClientCard(
//             client: clients[i],
//             viewMode: viewMode,
//           ),
//         )
//       : GridView.builder(
//           // final bool isMobile = Responsive.isMobile(context);
//           padding: const EdgeInsets.all(16),
//           gridDelegate:
//               SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: Responsive.isMobile(context)
//                     ? 2
//                     // : Responsive.isTablet(context)
//                     // ? 3
//                     : 3,
//                 childAspectRatio: Responsive.isMobile(context)
//                     ? 0.5
//                     : Responsive.isTablet(context)
//                     ? 1.0
//                     : 2.6,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//               ),
//           itemCount: clients.length,
//           itemBuilder: (ctx, i) => ClientCard(
//             client: clients[i],
//             viewMode: viewMode,
//           ),
//         ),
// ),
