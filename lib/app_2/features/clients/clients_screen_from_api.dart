import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/card_animation_layout.dart';
import 'package:insured/app_2/core/widgets/custom_error_refresh_placeholder_adv.dart';
import 'package:insured/app_2/core/widgets/ghost_card.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/features/dashboard/widgets/client_card.dart';
import 'package:insured/app_2/providers/client_pagination_provider.dart';
import 'package:insured/app_2/providers/client_search_provider.dart';
import 'package:insured/app_2/providers/client_view_provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ClientsScreenApi extends ConsumerWidget {
  const ClientsScreenApi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paginationState = ref.watch(clientsPaginationProvider);
    final searchState = ref.watch(clientSearchProvider);
    final viewMode = ref.watch(clientViewModeProvider);

    // ── Search active: server-side results are the single source of truth ──
    if (searchState.isActive) {
      final filterLabel = activeClientFilterLabel(
        ref.watch(clientSearchFieldsProvider),
      );
      return searchState.results.when(
        data: (clients) {
          if (clients.isEmpty) {
            return CustomErrorRefreshPlaceholder(
              message: filterLabel == null
                  ? 'No clients found for "${searchState.query}"'
                  : 'No clients found for "${searchState.query}" in $filterLabel',
              icon: Icons.search_off,
              color: Theme.of(context).colorScheme.onSurface,
              showIcon: true,
              showDetails: false,
              onRetry: () => ref.read(clientSearchProvider.notifier).refresh(),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (filterLabel != null)
                _FilterBanner(
                  query: searchState.query,
                  filterLabel: filterLabel,
                ),
              _buildClientList(clients, viewMode, context, ref),
            ],
          );
        },
        loading: () => buildGhostList(viewMode, context),
        error: (err, stack) => CustomErrorRefreshPlaceholder(
          message: 'Search failed',
          details: err.toString(),
          onRetry: () => ref.read(clientSearchProvider.notifier).refresh(),
        ),
      );
    }

    // ── No search: show the paginated list ──
    List<Client> _getAllLoadedClients() {
      final sortedPages = paginationState.cachedPages.keys.toList()..sort();
      List<Client> combined = [];
      for (var page in sortedPages) {
        combined.addAll(paginationState.cachedPages[page]!);
      }
      return combined;
    }

    final allLoadedClients = _getAllLoadedClients();

    if (paginationState.isLoading && allLoadedClients.isEmpty) {
      return buildGhostList(viewMode, context);
    }

    if (paginationState.loadingPages.contains(paginationState.currentPage) &&
        allLoadedClients.isEmpty) {
      return buildGhostList(viewMode, context);
    }
    if (paginationState.error != null && allLoadedClients.isEmpty) {
      return CustomErrorRefreshPlaceholder(
        details: paginationState.error,
        onRetry: () =>
            ref.read(clientsPaginationProvider.notifier).refreshAllAndReset(),
      );
    }

    return _buildClientList(allLoadedClients, viewMode, context, ref);
  }

  Widget _buildClientList(
    List<Client> clients,
    ClientViewMode viewMode,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (clients.isEmpty) {
      // return const Center(child: Text('No clients found.'));
      return CustomErrorRefreshPlaceholder(
        message: 'No clients found',
        icon: Icons.search_off,
        color: Theme.of(context).colorScheme.onSurface,
        showIcon: true,
        showDetails: false,
        onRetry: () => {
          ref.read(clientsPaginationProvider.notifier).refreshAllAndReset(),
        },
      );
    }

    return viewMode == ClientViewMode.list
        ? ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            // padding: const EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsetsGeometry.all(
              Responsive.isMobile(context) ? 10 : 20,
            ),
            itemCount: clients.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) => CardAnimationLayout(
              index: i,
              bounce: true,
              // bounceX: true,
              animateOnce: true,
              child: ClientCard(client: clients[i], viewMode: viewMode),
            ),
          )
        // ? SliverPadding(
        //     padding: const EdgeInsets.all(10),
        //     sliver: SliverList(
        //       delegate: SliverChildBuilderDelegate(
        //         (ctx, i) => Padding(
        //           padding: const EdgeInsets.only(bottom: 12),
        //           child: ClientCard(client: clients[i], viewMode: viewMode),
        //         ),
        //         childCount: clients.length,
        //       ),
        //     ),
        //   )
        // : GridView.builder(
        //     padding: EdgeInsetsGeometry.only(right: 20, top: 20, bottom: 20),
        //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //       crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
        //       childAspectRatio: Responsive.isMobile(context) ? 0.9 : 2.6,
        //       crossAxisSpacing: 12,
        //       mainAxisSpacing: 12,
        //     ),
        //     itemCount: clients.length,
        //     itemBuilder: (ctx, i) => CardAnimationLayout(
        //       index: i,
        //       bounce: true,
        //       bounceX: true,
        //       child: ClientCard(client: clients[i], viewMode: viewMode),
        //     ),
        //   );
        ///////
        : MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsetsGeometry.all(
              Responsive.isMobile(context) ? 10 : 20,
            ),
            crossAxisCount: Responsive.isMobile(context)
                ? 2
                : Responsive.isTablet(context)
                ? 2
                : Responsive.isDesktop(context)
                ? 3
                : 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            itemCount: clients.length,
            itemBuilder: (context, i) => CardAnimationLayout(
              index: i,
              bounce: true,
              child: ClientCard(client: clients[i], viewMode: viewMode),
            ),
          );
    // : SliverPadding(
    //     padding: const EdgeInsets.all(10),
    //     sliver: SliverMasonryGrid.count(
    //       // Use Sliver version
    //       crossAxisCount: Responsive.isMobile(context)
    //           ? 2
    //           : Responsive.isTablet(context)
    //           ? 2
    //           : Responsive.isDesktop(context)
    //           ? 3
    //           : 4,
    //       mainAxisSpacing: 12,
    //       crossAxisSpacing: 12,
    //       itemBuilder: (context, i) =>
    //           ClientCard(client: clients[i], viewMode: viewMode),
    //       childCount: clients.length,
    //     ),
    //   );
  }

  Widget buildGhostList(ClientViewMode viewMode, BuildContext context) {
    const int ghostCount = 6;

    if (viewMode == ClientViewMode.list) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemCount: ghostCount,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (ctx, i) =>
            CardAnimationLayout(index: i, child: const GhostCard()),
      );
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
          childAspectRatio: Responsive.isMobile(context) ? 0.9 : 2.6,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: ghostCount,
        itemBuilder: (ctx, i) =>
            CardAnimationLayout(index: i, child: const GhostCard()),
      );
    }
  }
}

/// Small banner shown above search results indicating which filter fields are
/// currently narrowing the list.
class _FilterBanner extends StatelessWidget {
  final String query;
  final String filterLabel;
  const _FilterBanner({required this.query, required this.filterLabel});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Responsive.isMobile(context) ? 12 : 22,
        12,
        Responsive.isMobile(context) ? 12 : 22,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: onSurface.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: onSurface.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Icon(Icons.filter_alt_outlined, size: 16, color: onSurface),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Filtered by $filterLabel',
                style: TextStyle(
                  fontSize: 12,
                  color: onSurface.withOpacity(0.85),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:insured/app_2/core/utils/responsive.dart';
// import 'package:insured/app_2/core/widgets/card_animation_layout.dart';
// import 'package:insured/app_2/core/widgets/ghost_card.dart';
// import 'package:insured/app_2/features/dashboard/widgets/client_card.dart';
// import 'package:insured/app_2/providers/client_pagination_provider.dart';
// import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
// import 'package:insured/app_2/providers/client_view_provider.dart';
// import 'package:insured/app_2/providers/settings_provider.dart';

// class ClientsScreenApi extends ConsumerStatefulWidget {
//   const ClientsScreenApi({super.key});

//   @override
//   ConsumerState<ClientsScreenApi> createState() => _ClientsScreenApiState();
// }

// class _ClientsScreenApiState extends ConsumerState<ClientsScreenApi> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final settings = ref.read(settingsProvider);
//       final currentMode = ref.read(clientViewModeProvider);
//       final desiredMode = settings.defaultView == 'Card View'
//           ? ClientViewMode.grid
//           : ClientViewMode.list;
//       if (currentMode != desiredMode) {
//         ref.read(clientViewModeProvider.notifier).update((_) => desiredMode);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(clientsPaginationProvider);
//     final viewMode = ref.watch(clientViewModeProvider);
//     final filteredClients = ref
//         .read(clientsPaginationProvider.notifier)
//         .getFilteredClients();
//     final isLoading = state.loadingPages.contains(state.currentPage);

//     if (state.error != null && filteredClients.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Error: ${state.error}',
//               style: const TextStyle(color: Colors.red),
//             ),
//             const SizedBox(height: 16),
//             CustomAdvancedButton(
//               width: 200,
//               height: 40,
//               label: 'Retry',
//               onPressed: () => ref
//                   .read(clientsPaginationProvider.notifier)
//                   .refreshAllAndReset(),
//               variant: ButtonVariant.primary,
//             ),
//           ],
//         ),
//       );
//     }

//     if (!isLoading && filteredClients.isEmpty) {
//       return const Center(child: Text('No clients found.'));
//     }

//     final itemCount = isLoading
//         ? (filteredClients.isEmpty ? 5 : filteredClients.length + 5)
//         : filteredClients.length;

//     return viewMode == ClientViewMode.list
//         ? ListView.separated(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//             itemCount: itemCount,
//             separatorBuilder: (_, __) => const SizedBox(height: 12),
//             itemBuilder: (ctx, i) {
//               if (i < filteredClients.length) {
//                 return CardAnimationLayout(
//                   index: i,
//                   bounce: true,
//                   child: ClientCard(
//                     client: filteredClients[i],
//                     viewMode: viewMode,
//                   ),
//                 );
//               } else {
//                 return CardAnimationLayout(index: i, child: GhostCard());
//               }
//             },
//           )
//         : GridView.builder(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),

//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
//               childAspectRatio: Responsive.isMobile(context) ? 0.9 : 2.6,
//               crossAxisSpacing: 12,
//               mainAxisSpacing: 12,
//             ),
//             itemCount: itemCount,
//             itemBuilder: (ctx, i) {
//               if (i < filteredClients.length) {
//                 return CardAnimationLayout(
//                   index: i,
//                   bounce: true,
//                   child: ClientCard(
//                     client: filteredClients[i],
//                     viewMode: viewMode,
//                   ),
//                 );
//               } else {
//                 // return _buildGhostCard(viewMode);
//                 return CardAnimationLayout(
//                   index: i,
//                   // child: _buildGhostCard(viewMode),
//                   child: GhostCard(),
//                 );
//               }
//             },
//           );
//   }
// }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:insured/app_2/core/utils/responsive.dart';
// // import 'package:insured/app_2/features/dashboard/widgets/client_card.dart';
// // import 'package:insured/app_2/providers/client_provider.dart';
// // import 'package:insured/app_2/core/widgets/insured_button.dart';
// // import 'package:insured/app_2/providers/client_view_provider.dart';

// // class ClientsScreenApi extends ConsumerWidget {
// //   const ClientsScreenApi({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final clientsAsync = ref.watch(clientsProvider);

// //     return clientsAsync.when(
// //       data: (clients) {
// //         if (clients.isEmpty) {
// //           return const Center(child: Text('No clients found.'));
// //         }
// //         // return ClientCard(client: clients[i]);
// //         final viewMode = ref.watch(clientViewModeProvider);

// //         return viewMode == ClientViewMode.list
// //             ? ListView.separated(
// //                 padding: const EdgeInsets.symmetric(horizontal: 16),
// //                 itemCount: clients.length,
// //                 separatorBuilder: (_, __) => const SizedBox(height: 12),
// //                 itemBuilder: (ctx, i) =>
// //                     ClientCard(client: clients[i], viewMode: viewMode),
// //               )
// //             : GridView.builder(
// //                 padding: const EdgeInsets.all(16),
// //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                   crossAxisCount: Responsive.isMobile(context) ? 2 : 3,
// //                   childAspectRatio: Responsive.isMobile(context) ? 0.5 : 2.6,
// //                   crossAxisSpacing: 12,
// //                   mainAxisSpacing: 12,
// //                 ),
// //                 itemCount: clients.length,
// //                 itemBuilder: (ctx, i) =>
// //                     ClientCard(client: clients[i], viewMode: viewMode),
// //               );
// //         // },

// //         // return ListView.builder(
// //         //   padding: const EdgeInsets.all(16),
// //         //   itemCount: clients.length,
// //         //   itemBuilder: (ctx, i) => Card(
// //         //     margin: const EdgeInsets.only(bottom: 8),
// //         //     child: ListTile(
// //         //       title: Text(clients[i].name),
// //         //       subtitle: Text(clients[i].email),
// //         //       // trailing: Text(clients[i].status),
// //         //     ),
// //         //   ),
// //         // );
// //       },
// //       loading: () => const Center(child: CircularProgressIndicator()),
// //       error: (err, stack) {
// //         return Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Text('Error: $err', style: const TextStyle(color: Colors.red)),
// //               const SizedBox(height: 16),
// //               CustomAdvancedButton(
// //                 label: 'Retry',
// //                 onPressed: () => ref.refresh(clientsProvider),
// //                 variant: ButtonVariant.primary,
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
