import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/core/services/location_service.dart';
import 'package:insured/app_2/core/theme/custom_text_styles.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/card_animation_layout.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastS.dart';
import 'package:insured/app_2/core/widgets/ghost_card.dart';
import 'package:insured/app_2/features/clients/add_client_screen.dart';
import 'package:insured/app_2/features/dashboard/widgets/summary_stat_header.dart';
import 'package:insured/app_2/features/dashboard/widgets/quick_actions_row.dart';
import 'package:insured/app_2/features/dashboard/widgets/client_card.dart';
import 'package:insured/app_2/providers/client_pagination_provider.dart';
import 'package:insured/app_2/providers/client_view_provider.dart';
import 'package:insured/app_2/providers/dashboard_provider.dart';
import 'package:insured/app_2/providers/settings_provider.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardDesktop extends ConsumerStatefulWidget {
  const DashboardDesktop({super.key});

  @override
  ConsumerState<DashboardDesktop> createState() => _DashboardDesktopState();
}

// class _DashboardDesktopState extends State<DashboardDesktop> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

// class DashboardDesktop extends ConsumerWidget {
class _DashboardDesktopState extends ConsumerState<DashboardDesktop> {
  // DashboardDesktop({super.key});

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String? _pendingLanguage;
  bool _hasPrompted = false;
  String? _currentLanguage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(settingsProvider);
      final currentMode = ref.read(clientViewModeProvider);
      final desiredMode = settings.defaultView == 'Card View'
          ? ClientViewMode.grid
          : ClientViewMode.list;
      if (currentMode != desiredMode) {
        ref.read(clientViewModeProvider.notifier).update((_) => desiredMode);
      }
    });

    // _autoDetectLanguage();
  }

  Future<void> _autoDetectLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    // Get stored info
    final int shownCount = prefs.getInt('language_prompt_count') ?? 0;
    final int? firstShownTimestamp = prefs.getInt('language_prompt_first_time');

    final now = DateTime.now().millisecondsSinceEpoch;

    // Check expiration: 3 days in milliseconds
    const threeDaysMs = 3 * 24 * 60 * 60 * 1000;
    final isExpired =
        firstShownTimestamp == null || now - firstShownTimestamp > threeDaysMs;

    // If prompt has been shown 2 times AND not expired, skip
    if (shownCount >= 2 && !isExpired) {
      print('Language prompt already shown 2 times, skipping.');
      return;
    }

    final settingsNotifier = ref.read(settingsProvider.notifier);
    final currentLanguage = ref.read(settingsProvider).language;

    if (currentLanguage == 'English') {
      // optional, keep this if you only detect for default language
      final locationService = LocationService();
      final detectedLang = await locationService.detectLanguageFromLocation();
      if (detectedLang != null && detectedLang != 'en') {
        String displayName;
        switch (detectedLang) {
          case 'sw':
            displayName = 'Swahili';
            break;
          case 'fr':
            displayName = 'French';
            break;
          case 'de':
            displayName = 'German';
            break;
          case 'it':
            displayName = 'Italian';
            break;
          default:
            displayName = 'English';
        }

        if (displayName != currentLanguage && !_hasPrompted) {
          // Update count and timestamp
          final newCount = isExpired ? 1 : shownCount + 1;
          await prefs.setInt('language_prompt_count', newCount);
          if (firstShownTimestamp == null || isExpired) {
            await prefs.setInt('language_prompt_first_time', now);
          }

          setState(() {
            _pendingLanguage = displayName;
            _currentLanguage = currentLanguage;
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_pendingLanguage != null) {
              _showLanguagePrompt(
                context,
                displayName,
                currentLanguage,
                settingsNotifier,
              );
              setState(() {
                _hasPrompted = true;
                _pendingLanguage = null;
              });
            }
          });
        }
      }
    }
  }

  void _showLanguagePrompt(
    BuildContext context,
    String newLanguage,
    String currentLanguage,
    SettingsNotifier notifier,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: ConstrainedBox(
            // Ensures the dialog doesn't get too wide on desktop
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header Section ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.language,
                              color: Theme.of(context).primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: CustomText(
                                'Language Detected',
                                type: CustomTextType.subHeader,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                        tooltip: 'Cancel',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // --- Message Section ---
                  CustomText(
                    'We noticed your location suggests $newLanguage. '
                    'Would you like to switch from $currentLanguage?',
                    type: CustomTextType.paragraph,
                  ),
                  const SizedBox(height: 24),

                  // --- Action Buttons Section ---
                  if (Responsive.isMobile(context))
                    // Vertical Stack for Mobile to prevent horizontal overflow
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomAdvancedButton(
                          height: 45,
                          variant: ButtonVariant.primary,
                          customFontSize: 13,
                          label: 'Switch to $newLanguage',
                          onPressed: () {
                            notifier.setLanguage(newLanguage);
                            Navigator.pop(ctx);
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomAdvancedButton(
                          height: 45,
                          variant: ButtonVariant.secondary,
                          customFontSize: 13,
                          label: 'Keep $currentLanguage',
                          onPressed: () => Navigator.pop(ctx),
                        ),
                        const SizedBox(height: 12),
                        CustomAdvancedButton(
                          height: 45,
                          variant: ButtonVariant.secondary,
                          customFontSize: 13,
                          label: 'Settings',
                          onPressed: () {
                            Navigator.pop(ctx); // Pop dialog before navigating
                            context.go('/settings');
                          },
                        ),
                      ],
                    )
                  else
                    // Horizontal Row for Desktop/Tablet
                    Row(
                      children: [
                        Expanded(
                          child: CustomAdvancedButton(
                            height: 40,
                            variant: ButtonVariant.secondary,
                            customFontSize: 12,
                            label: 'Settings',
                            onPressed: () {
                              Navigator.pop(ctx);
                              context.go('/settings');
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomAdvancedButton(
                            height: 40,
                            variant: ButtonVariant.secondary,
                            customFontSize: 12,
                            label: 'Keep $currentLanguage',
                            onPressed: () => Navigator.pop(ctx),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomAdvancedButton(
                            height: 40,
                            variant: ButtonVariant.primary,
                            customFontSize: 12,
                            label: 'Switch to $newLanguage',
                            onPressed: () {
                              notifier.setLanguage(newLanguage);
                              Navigator.pop(ctx);
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleNewClient(BuildContext context, WidgetRef ref) async {
    print('New Client tapped');
    // final result = await showModalBottomSheet<bool>(
    final result = await showModalBottomSheet<(bool, Map<String, dynamic>)>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddClientModal(),
    );

    // if (result == true) {
    // if (result != null) {
    if (result != null) {
      final (success, data) = result;
      if (success) {
        ref.read(clientsPaginationProvider.notifier).refreshCurrentPage();

        FuturisticToastS.show(
          context: context,
          message: 'Client list refreshed successfully!',
          icon: Icons.check_circle,
          alignment: Alignment.topCenter,
        );
      }
    }
  }

  void _handleViewQuotes(BuildContext context) {
    context.go('/motor/quote');
  }

  void _navigateToClients([String? query]) {
    // Optionally pass query via provider or route params
    // For simplicity, just navigate to clients page
    context.go('/clients');
  }

  @override
  Widget build(BuildContext context) {
    final recentClientsAsync = ref.watch(dashboardRecentClientsProvider);

    final state = ref.watch(clientsPaginationProvider);
    final notifier = ref.read(clientsPaginationProvider.notifier);

    final settings = ref.watch(settingsProvider);
    final isLight = settings.themeMode == 'Light';
    // final isLight = Theme.of(context).brightness == Brightness.light;
    final viewMode = ref.watch(clientViewModeProvider);

    return Row(
      children: [
        // const Sidebar(),
        Expanded(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate.fixed([
                      const SizedBox(height: 24),
                      SummaryStatCardHeader(),
                      const SizedBox(height: 24),
                      QuickActionsRow(
                        onNewClient: () => _handleNewClient(context, ref),
                        onViewQuotes: () => _handleViewQuotes(context),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: const CustomText(
                              'Recent Renewals',
                              type: CustomTextType.subHeader,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.refresh,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.9),
                                ),
                                onPressed: () => {
                                  notifier.refreshCurrentPage(),
                                  FuturisticToastS.show(
                                    context: context,
                                    message:
                                        'Client list refreshed successfully!',
                                    icon: Icons.check_circle,
                                    alignment: Alignment.topCenter,
                                  ),
                                },
                              ),
                              SizedBox(width: 10),

                              IconButton(
                                icon: Icon(
                                  viewMode == ClientViewMode.list
                                      ? Icons.grid_view
                                      : Icons.view_list,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
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
                              SizedBox(width: 10),
                              SizedBox(
                                width: Responsive.isMobile(context) ? 200 : 300,
                                child: CustomTextField(
                                  hint: 'Search clients...',
                                  icon: Icons.search,
                                  controller: _searchController,
                                  isSearchField: true,
                                  onSearchChanged: (query) {
                                    setState(
                                      () => _searchQuery = query.toLowerCase(),
                                    );
                                  },
                                  onFieldSubmitted: (value) =>
                                      _navigateToClients(value),
                                  debounceDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ]),
                  ),

                  // SliverList(
                  //   delegate: SliverChildBuilderDelegate(
                  //     (ctx, i) => Padding(
                  //       padding: const EdgeInsets.only(bottom: 12),
                  //       child: ClientCard(client: recentClients[i]),
                  //     ),
                  //     childCount: recentClients.length,
                  //   ),
                  // ),

                  // const SizedBox(height: 16),
                  // Expanded(
                  //   child: ListView.separated(
                  //     itemCount: recentClients.length,
                  //     separatorBuilder: (_, __) =>
                  //         const SizedBox(height: 12),
                  //     itemBuilder: (ctx, i) =>
                  //         ClientCard(client: recentClients[i]),
                  //   ),
                  // ),

                  //// ///
                  recentClientsAsync.when(
                    data: (clients) {
                      final filteredClients = _searchQuery.isEmpty
                          ? clients
                          : clients.where((client) {
                              return client.name.toLowerCase().contains(
                                    _searchQuery,
                                  ) ||
                                  (client.email?.toLowerCase().contains(
                                        _searchQuery,
                                      ) ??
                                      false) ||
                                  (client.mobile?.contains(_searchQuery) ??
                                      false);
                            }).toList();
                      if (filteredClients.isEmpty && _searchQuery.isNotEmpty) {
                        // if (filteredClients.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CustomText(
                                  'No matching recent clients',
                                  type: CustomTextType.paragraph,
                                ),
                                const SizedBox(height: 16),
                                CustomAdvancedButton(
                                  variant: ButtonVariant.secondary,
                                  width: 200,
                                  height: 40,
                                  label: 'View All Clients',
                                  onPressed: () =>
                                      _navigateToClients(_searchQuery),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      // return SliverList(
                      //   delegate: SliverChildBuilderDelegate(
                      //     (ctx, i) => Padding(
                      //       padding: const EdgeInsets.only(bottom: 12),
                      //       child: CardAnimationLayout(
                      //         index: i + 4,
                      //         bounce: true,
                      //         child: ClientCard(client: filteredClients[i]),
                      //       ),
                      //     ),
                      //     childCount: filteredClients.length,
                      //   ),
                      // );

                      if (viewMode == ClientViewMode.list) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (ctx, i) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: CardAnimationLayout(
                                index: i + 4,
                                bounce: true,
                                child: ClientCard(
                                  client: filteredClients[i],
                                  viewMode: viewMode,
                                ),
                              ),
                            ),
                            childCount: filteredClients.length,
                          ),
                        );
                      } else {
                        // Grid view
                        return SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: Responsive.isMobile(context)
                                      ? 2
                                      : 3,
                                  childAspectRatio: Responsive.isMobile(context)
                                      ? 0.9
                                      : 2.6,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            delegate: SliverChildBuilderDelegate(
                              (ctx, i) => CardAnimationLayout(
                                index: i + 4,
                                bounce: true,
                                child: ClientCard(
                                  client: filteredClients[i],
                                  viewMode: viewMode,
                                ),
                              ),
                              childCount: filteredClients.length,
                            ),
                          ),
                        );
                      }
                    },
                    loading: () => SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CardAnimationLayout(
                            index: i + 4,
                            bounce: true,
                            child: const GhostCard(),
                          ),
                        ),
                        childCount: 3,
                      ),
                    ),
                    error: (err, stack) => SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Failed to load clients',
                              style: TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 8),
                            CustomText(
                              err.toString(),
                              type: CustomTextType.paragraph,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // if (filteredClients.!isEmpty)
                  SliverList(
                    delegate: SliverChildListDelegate.fixed([
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: CustomAdvancedButton(
                      //     width: 200,
                      //     height: 40,
                      //     variant: ButtonVariant.secondary,
                      //     label: 'View All Clients',
                      //     onPressed: () => _navigateToClients(_searchQuery),
                      //   ),
                      // ),
                      // tooltip: 'Go to full clients search',
                      // ),
                    ]),
                  ),

                  // !!!!!!!!!!!!
                ],
              ),
            ),

            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 24.0, right: 24.0),
              child: FloatingActionButton(
                onPressed: () async {
                  final result =
                      await showModalBottomSheet<(bool, Map<String, dynamic>)>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const AddClientModal(),
                      );

                  // if (result == true) {
                  //   ref
                  //       .read(clientsPaginationProvider.notifier)
                  //       .refreshCurrentPage();
                  // }
                  // if (result == true) {
                  // if (result != null) {

                  if (result != null) {
                    final (success, data) = result;
                    if (success) {
                      // refresh pagination (optional)
                      ref
                          .read(clientsPaginationProvider.notifier)
                          .refreshCurrentPage();

                      // 🔥 THIS is what you are missing
                      ref.invalidate(dashboardRecentClientsProvider);
                    }
                  }
                },

                // backgroundColor: const Color(0xFF00FFB2).withOpacity(0.1),
                elevation: isLight ? 20 : 20,
                backgroundColor: Theme.of(
                  context,
                ).primaryColor.withOpacity(isLight ? 1 : 0.25),

                // child: Icon(
                //   Icons.add,
                //   size: 40,
                //   color: Theme.of(
                //     context,
                //   ).colorScheme.onSurface.withOpacity(1.0),
                // ),
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(1.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

  // recentClientsAsync.when(
  //                 data: (clients) {
  //                   if (clients.isEmpty) {
  //                     return const Center(
  //                       child: CustomText(
  //                         'No recent clients',
  //                         type: CustomTextType.paragraph,
  //                       ),
  //                     );
  //                   }
  //                   return ListView.separated(
  //                     itemCount: clients.length,
  //                     separatorBuilder: (_, __) => const SizedBox(height: 12),
  //                     itemBuilder: (ctx, i) => CardAnimationLayout(
  //                       index: i + 4,
  //                       bounce: true,

  //                       child: ClientCard(client: clients[i]),
  //                     ),
  //                   );
  //                 },
  //                 loading: () => ListView.separated(
  //                   itemCount: 3,
  //                   separatorBuilder: (_, __) => const SizedBox(height: 12),
  //                   itemBuilder: (_, __) => CardAnimationLayout(
  //                     index: __ + 4,
  //                     bounce: true,

  //                     child: GhostCard(),
  //                   ),
  //                 ),
  //                 error: (err, stack) => Center(
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       const Text(
  //                         'Failed to load clients',
  //                         style: TextStyle(color: Colors.red),
  //                       ),
  //                       const SizedBox(height: 8),
  //                       Text(
  //                         err.toString(),
  //                         style: const TextStyle(color: Colors.white70),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
