// lib/app_2/core/widgets/dashboard_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/core/services/connectivity_service.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/utils/route_observer.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/exit_confirmation_dialog.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastS.dart';
import 'package:insured/app_2/core/widgets/notification_icon.dart';
import 'package:insured/app_2/core/widgets/profile_avatar.dart';
import 'package:insured/app_2/core/widgets/support_whatsapp_button.dart';
import 'package:insured/app_2/core/widgets/two_factor_guard.dart';
import 'package:insured/app_2/features/dashboard/widgets/sidebar.dart';
import 'package:insured/app_2/l10n/app_localizations.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:insured/app_2/providers/connectivity_provider.dart';
import 'package:insured/app_2/providers/offline_prompt_provider.dart';
import 'package:insured/app_2/providers/offline_queue_provider.dart';
import 'package:insured/app_2/providers/settings_provider.dart';

class DashboardShell extends ConsumerWidget {
  final Widget child;
  // final GlobalKey<ScaffoldState> scaffoldKey;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  // DashboardShell({super.key, required this.child}) : scaffoldKey = GlobalKey();
  DashboardShell({super.key, required this.child});

  static OverlayEntry? _currentOfflinePrompt;

  void _showOfflinePrompt(BuildContext context, WidgetRef ref) {
    // Prevent multiple prompts
    if (_currentOfflinePrompt != null) return;

    final entry = OverlayEntry(
      builder: (ctx) => _OfflinePromptOverlay(
        onEnable: () {
          ref
              .read(settingsProvider.notifier)
              .setOfflineMode(true); // ← fixed name
          _dismissOfflinePrompt();
        },
        onDismiss: _dismissOfflinePrompt,
      ),
    );

    _currentOfflinePrompt = entry;
    Overlay.of(context).insert(entry);
  }

  static void _dismissOfflinePrompt() {
    _currentOfflinePrompt?.remove();
    _currentOfflinePrompt = null;
  }

  String _getTitleFromLocation(BuildContext context, String location) {
    final l10n = AppLocalizations.of(context)!;
    if (location.startsWith('/dashboard')) return l10n.sidebar_dashboard;
    if (location.startsWith('/clients')) return l10n.sidebar_clients;
    if (location.startsWith('/motor/quote')) return l10n.sidebar_motorQuote;
    if (location.startsWith('/policies')) return l10n.sidebar_production;
    if (location.startsWith('/dmvic-double-insurance'))
      return l10n.sidebar_dmvicDoubleInsurance;
    if (location.startsWith('/dmvic-stock')) return l10n.sidebar_dmvicStock;
    if (location.startsWith('/statement')) return l10n.sidebar_statement;
    if (location.startsWith('/renewals')) return l10n.sidebar_renewals;
    if (location.startsWith('/certificates')) return l10n.sidebar_certificates;
    // if (location.startsWith('/production')) return l10n.sidebar_production;
    if (location.startsWith('/quotes')) return l10n.sidebar_quotes;
    if (location.startsWith('/settings')) return l10n.sidebar_settings;
    if (location.startsWith('/profile')) return l10n.sidebar_profile;
    if (location.startsWith('/add-client')) return l10n.sidebar_add_client;
    if (location.startsWith('/notifications'))
      return l10n.sidebar_notifications;
    if (location.startsWith('/offline-queue'))
      return l10n.sidebar_offlineQueueScreen;
    return 'Insured';
  }

  // String _getSubtitle(String title) {
  String _getSubtitle(BuildContext context, String title) {
    final l10n = AppLocalizations.of(context)!;
    switch (title) {
      case 'Dashboard':
        // return 'Manage your clients and quotes';
        return l10n.subtitle_dashboard;
      case 'Clients':
        return l10n.subtitle_clients;
      case 'Quotes':
        return l10n.subtitle_quotes;
      case 'Settings':
        return l10n.subtitle_settings;
      case 'My Profile':
        return l10n.subtitle_profile;
      case 'Notifications':
        return l10n.subtitle_notifications;
      default:
        return l10n.subtitle_default;
    }
  }

  String _getSubtitleFromLocation(BuildContext context, String location) {
    final l10n = AppLocalizations.of(context)!;
    if (location.startsWith('/dashboard')) return l10n.subtitle_dashboard;
    if (location.startsWith('/clients')) return l10n.subtitle_clients;
    if (location.startsWith('/motor/quote')) return l10n.subtitle_motorQuote;
    if (location.startsWith('/policies')) return l10n.subtitle_production;
    if (location.startsWith('/dmvic-double-insurance'))
      return l10n.subtitle_dmvicDoubleInsurance;
    if (location.startsWith('/dmvic-stock')) return l10n.subtitle_dmvicStock;
    if (location.startsWith('/statement')) return l10n.subtitle_statement;
    if (location.startsWith('/renewals')) return l10n.subtitle_renewals;
    if (location.startsWith('/certificates')) return l10n.subtitle_certificates;
    // if (location.startsWith('/production')) return l10n.subtitle_production;
    if (location.startsWith('/quotes')) return l10n.subtitle_quotes;
    if (location.startsWith('/settings')) return l10n.subtitle_settings;
    if (location.startsWith('/profile')) return l10n.subtitle_profile;
    if (location.startsWith('/add-client')) return l10n.subtitle_add_client;
    if (location.startsWith('/notifications'))
      return l10n.subtitle_notifications;
    if (location.startsWith('/offline-queue'))
      return l10n.subtitle_offlineQueueScreen;
    return 'Fully Insured';
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    String title,
    String location, {
    bool showBackButton = false,
  }) {
    // final location = GoRouterState.of(context).uri.path;
    final settings = ref.watch(settingsProvider);
    final subtitle = _getSubtitleFromLocation(context, location);

    final authState = ref.watch(authProvider);
    final user = authState.user;

    final themeMode = ref.watch(settingsProvider).themeMode;
    final effectiveIsDark = themeMode == 'System'
        ? MediaQuery.of(context).platformBrightness == Brightness.dark
        : themeMode == 'Dark';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 24),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              if (showBackButton) ...[
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(title, type: CustomTextType.header),
                    // // if (_getSubtitle(context, title).isNotEmpty)
                    // if (subtitle.isNotEmpty)
                    //   CustomText(
                    //     // _getSubtitle(context, title),
                    //     subtitle,
                    //     type: CustomTextType.paragraph,
                    //   ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // IconButton(
              //   icon: Icon(
              //     ref.watch(settingsProvider).themeMode == 'Dark'
              //         ? Icons.dark_mode
              //         : Icons.light_mode,
              //     // color: Theme.of(context).primaryColor,
              //     color: ref.watch(settingsProvider).themeMode == 'Dark'
              //         ? Color(0xFF00FFB2)
              //         : Colors.black,
              //   ),
              //   onPressed: () {
              //     final notifier = ref.read(settingsProvider.notifier);
              //     final current = ref.read(settingsProvider).themeMode;
              //     notifier.setThemeMode(current == 'Dark' ? 'Light' : 'Dark');
              //   },
              // ),
              Visibility(
                visible: false,
                child: Opacity(
                  // opacity: settings.enableNotifications ? 1 : 0.2,
                  opacity: settings.enableNotifications ? 0 : 0,
                  child: IgnorePointer(
                    ignoring: !settings.enableNotifications,
                    child: const NotificationIcon(),
                  ),
                ),
              ),
              const SupportWhatsappButton(compact: true),
              IconButton(
                icon: Icon(
                  effectiveIsDark ? Icons.dark_mode : Icons.light_mode,
                  color: effectiveIsDark
                      // ? const Color(0xFF00FFB2)
                      ? AppColors.animatedOrbsGlow
                      : Colors.black,
                ),
                onPressed: () {
                  final currentMode = ref.read(settingsProvider).themeMode;
                  String nextMode;
                  if (currentMode == 'System') {
                    final isDarkNow =
                        MediaQuery.of(context).platformBrightness ==
                        Brightness.dark;
                    nextMode = isDarkNow ? 'Light' : 'Dark';
                  } else {
                    nextMode = currentMode == 'Dark' ? 'Light' : 'Dark';
                  }
                  ref.read(settingsProvider.notifier).setThemeMode(nextMode);
                },
              ),

              // Container(
              //   constraints: BoxConstraints(maxWidth: 100),
              //   child: ThemeModeSelector(),
              // ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  context.go('/settings');
                },
                color: location.startsWith('/settings')
                    ? Colors.orange
                    : Theme.of(context).colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              // ProfileAvatar(user: user!),
              if (user != null)
                ProfileAvatar(user: user)
              else
                const SizedBox(width: 32, height: 32),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final location = GoRouterState.of(context).uri.path;
    final title = _getTitleFromLocation(context, location);
    final subtitle = _getSubtitleFromLocation(context, location);

    final showBackButton = ![
      '/dashboard',
      '/clients',
      '/motor/quote',
      '/policies',
      '/dmvic-double-insurance',
      '/dmvic-stock',
      '/statement',
      '/renewals',
      '/certificates',
      '/production',
      '/quotes',
      '/settings',
      '/profile',
      '/notifications',
      '/offline-queue',
    ].contains(location);

    ref.listen<String>(currentRouteProvider, (_, newRoute) {
      ref.read(authProvider.notifier).updateLastRoute(newRoute);
    });

    // void _showOfflinePrompt(BuildContext context, WidgetRef ref) {
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (ctx) {
    //       return Dialog(
    //         shape: RoundedRectangleBorder(
    //           borderRadius: BorderRadius.circular(28),
    //         ),
    //         child: ConstrainedBox(
    //           constraints: const BoxConstraints(maxWidth: 500),
    //           child: Padding(
    //             padding: const EdgeInsets.all(24.0),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Row(
    //                       children: [
    //                         Icon(
    //                           Icons.offline_bolt,
    //                           color: Theme.of(context).primaryColor,
    //                           size: 24,
    //                         ),
    //                         const SizedBox(width: 12),
    //                         Flexible(
    //                           child: CustomText(
    //                             'Offline Mode',
    //                             type: CustomTextType.subHeader,
    //                             fontWeight: FontWeight.bold,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     IconButton(
    //                       icon: const Icon(Icons.close),
    //                       onPressed: () => Navigator.pop(ctx),
    //                       tooltip: 'Cancel',
    //                     ),
    //                   ],
    //                 ),
    //                 const SizedBox(height: 16),
    //                 const CustomText(
    //                   'You are offline. Enable offline mode to save actions locally and upload later.',
    //                   type: CustomTextType.paragraph,
    //                 ),
    //                 const SizedBox(height: 24),
    //                 ConstrainedBox(
    //                   constraints: const BoxConstraints(maxWidth: 500),
    //                   child: Row(
    //                     children: [
    //                       Expanded(
    //                         child: CustomAdvancedButton(
    //                           variant: ButtonVariant.secondary,
    //                           label: 'Not Now',
    //                           onPressed: () => Navigator.pop(ctx),
    //                         ),
    //                       ),
    //                       const SizedBox(width: 8),
    //                       Expanded(
    //                         child: CustomAdvancedButton(
    //                           variant: ButtonVariant.primary,
    //                           label: 'Enable Offline Mode',
    //                           onPressed: () {
    //                             ref
    //                                 .read(settingsProvider.notifier)
    //                                 .setOfflineModeEnabled(true);
    //                             Navigator.pop(ctx);
    //                           },
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // }

    ref.listen<AsyncValue<bool>>(connectivityStreamProvider, (previous, next) {
      final isOnline = next.value ?? true;
      final wasOnline = previous?.value ?? true;

      if (previous != null && isOnline != wasOnline) {
        if (isOnline) {
          print('🌐 [Connectivity]: Device is back ONLINE');
          final settings = ref.read(settingsProvider);
          final promptShown = ref.read(offlinePromptShownProvider);
          // if (!settings.offlineModeEnabled && !promptShown) {
          //   ref.read(offlinePromptShownProvider.notifier).state = true;
          //   _showOfflinePrompt(context, ref);
          // }

          if (!settings.offlineModeEnabled && !promptShown) {
            ref.read(offlinePromptShownProvider.notifier).state = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) _showOfflinePrompt(context, ref);
            });
          }

          FuturisticToastS.show(
            context: context,
            message: "You're back online!",
            icon: Icons.wifi_off,
            alignment: Alignment.topCenter,
            // duration: const Duration(seconds: 400),
            duration: null,
          );
        } else {
          print('🚫 [Connectivity]: Device is now OFFLINE');

          final settings = ref.read(settingsProvider);
          if (settings.offlineModeEnabled) {
            // automatically process pending items
            ref.read(offlineQueueNotifierProvider.notifier).processAll(context);
          }
          FuturisticToastS.show(
            context: context,
            message: "No internet connection.",
            icon: Icons.wifi,
            alignment: Alignment.topCenter,
            // duration: const Duration(seconds: 400),
            duration: null,
          );
        }
      }
    });

    final themeMode = ref.watch(settingsProvider).themeMode;
    final effectiveIsDark = themeMode == 'System'
        ? MediaQuery.of(context).platformBrightness == Brightness.dark
        : themeMode == 'Dark';

    if (Responsive.isMobile(context)) {
      final authState = ref.watch(authProvider);
      final user = authState.user;
      return WillPopScope(
        onWillPop: () async {
          if (location == '/dashboard') {
            return await showExitConfirmationDialog(context);
          }
          return true;
        },
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(title, type: CustomTextType.header),
                // if (subtitle.isNotEmpty)
                //   CustomText(subtitle, type: CustomTextType.caption),
              ],
            ),

            // Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start)),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
            ),
            // iconTheme: const IconThemeData(color: Colors.white),--
            actions: [
              const SizedBox(width: 8),

              // IconButton(
              //   icon: Icon(
              //     ref.watch(settingsProvider).themeMode == 'Dark'
              //         ? Icons.dark_mode
              //         : Icons.light_mode,
              //     // color: Theme.of(context).primaryColor,
              //     color: ref.watch(settingsProvider).themeMode == 'Dark'
              //         ? Color(0xFF00FFB2)
              //         : Colors.black,
              //   ),
              //   onPressed: () {
              //     final notifier = ref.read(settingsProvider.notifier);
              //     final current = ref.read(settingsProvider).themeMode;
              //     notifier.setThemeMode(current == 'Dark' ? 'Light' : 'Dark');
              //   },
              // ),
              Visibility(
                visible: false,
                child: Opacity(
                  // opacity: settings.enableNotifications ? 1 : 0.2,
                  opacity: settings.enableNotifications ? 0 : 0,
                  child: IgnorePointer(
                    ignoring: !settings.enableNotifications,
                    child: const NotificationIcon(),
                  ),
                ),
              ),
              const SupportWhatsappButton(compact: true),
              IconButton(
                icon: Icon(
                  effectiveIsDark ? Icons.dark_mode : Icons.light_mode,
                  color: effectiveIsDark
                      // ? const Color(0xFF00FFB2)
                      ? AppColors.animatedOrbsGlow
                      : Colors.black,
                ),
                onPressed: () {
                  final currentMode = ref.read(settingsProvider).themeMode;
                  String nextMode;
                  if (currentMode == 'System') {
                    final isDarkNow =
                        MediaQuery.of(context).platformBrightness ==
                        Brightness.dark;
                    nextMode = isDarkNow ? 'Light' : 'Dark';
                  } else {
                    nextMode = currentMode == 'Dark' ? 'Light' : 'Dark';
                  }
                  ref.read(settingsProvider.notifier).setThemeMode(nextMode);
                },
              ),

              // IconButton(
              //   icon: const Icon(Icons.settings),
              //   onPressed: () {
              //     context.go('/settings');
              //   },
              //   color: location.startsWith('/settings')
              //       ? Colors.orange
              //       : Theme.of(context).colorScheme.onSurface,
              // ),
              // ProfileAvatar(user: user!),
              // if (user != null)
              //   ProfileAvatar(user: user)
              // else
              // const SizedBox(width: 32, height: 32),
              const SizedBox(width: 8, height: 32),
            ],
          ),
          drawer: const Sidebar(),
          body: child,
          // bottomNavigationBar: BottomNavBar(currentRoute: location),
          // bottomNavigationBar: const DynamicBottomNavBar(),
        ),
      );
    }

    return TwoFactorGuard(
      child: WillPopScope(
        onWillPop: () async {
          if (location == '/dashboard') {
            return await showExitConfirmationDialog(context);
          }
          return true;
        },
        child: Row(
          children: [
            const Sidebar(),
            Expanded(
              child: Scaffold(
                // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                body: Column(
                  children: [
                    _buildHeader(
                      context,
                      ref,
                      title,
                      location,
                      showBackButton: showBackButton,
                    ),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfflinePromptOverlay extends StatelessWidget {
  final VoidCallback onEnable;
  final VoidCallback onDismiss;

  const _OfflinePromptOverlay({
    required this.onEnable,
    required this.onDismiss,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onDismiss,
        child: Container(
          color: Colors.black.withOpacity(0.75),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.offline_bolt,
                                color: Colors.orange,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              const CustomText(
                                'Offline Mode',
                                type: CustomTextType.header,
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: onDismiss,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const CustomText(
                        'You are offline. Enable offline mode to save actions locally and upload later.',
                        type: CustomTextType.paragraph,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomAdvancedButton(
                            label: "Not Now",
                            variant: ButtonVariant.secondary,
                            onPressed: onDismiss,
                            height: 36,
                          ),
                          const SizedBox(width: 12),
                          CustomAdvancedButton(
                            height: 36,
                            label: "Enable Offline Mode",
                            variant: ButtonVariant.primary,
                            onPressed: onEnable,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// // lib/app_2/core/widgets/dashboard_shell.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:insured/app_2/core/services/connectivity_service.dart';
// import 'package:insured/app_2/core/theme/app_theme.dart';
// import 'package:insured/app_2/core/utils/responsive.dart';
// import 'package:insured/app_2/core/utils/route_observer.dart';
// import 'package:insured/app_2/core/utils/settings_ThemeModeSelector.dart';
// import 'package:insured/app_2/core/widgets/custom_text.dart';
// import 'package:insured/app_2/core/widgets/futuristic_toastS.dart';
// import 'package:insured/app_2/core/widgets/notification_icon.dart';
// import 'package:insured/app_2/core/widgets/profile_avatar.dart';
// import 'package:insured/app_2/core/widgets/two_factor_guard.dart';
// import 'package:insured/app_2/features/clients/add_client_screen.dart';
// import 'package:insured/app_2/features/dashboard/widgets/sidebar.dart';
// import 'package:insured/app_2/l10n/app_localizations.dart';
// import 'package:insured/app_2/providers/auth_provider.dart';
// import 'package:insured/app_2/providers/client_pagination_provider.dart';
// import 'package:insured/app_2/providers/client_provider.dart';
// import 'package:insured/app_2/providers/client_view_provider.dart';
// import 'package:insured/app_2/providers/connectivity_provider.dart';
// import 'package:insured/app_2/providers/notification_provider.dart';
// import 'package:insured/app_2/providers/settings_provider.dart';

// class DashboardShell extends ConsumerWidget {
//   final Widget child;
//   final GlobalKey<ScaffoldState> scaffoldKey;

//   DashboardShell({super.key, required this.child}) : scaffoldKey = GlobalKey();

//   String _getTitleFromLocation(BuildContext context, String location) {
//     final l10n = AppLocalizations.of(context)!;
//     if (location.startsWith('/dashboard')) return l10n.sidebar_dashboard;
//     if (location.startsWith('/clients')) return l10n.sidebar_clients;
//     if (location.startsWith('/motor/quote')) return l10n.sidebar_motorQuote;
//     if (location.startsWith('/policies')) return l10n.sidebar_policies;
//     if (location.startsWith('/dmvic-double-insurance'))
//       return l10n.sidebar_dmvicDoubleInsurance;
//     if (location.startsWith('/dmvic-stock')) return l10n.sidebar_dmvicStock;
//     if (location.startsWith('/statement')) return l10n.sidebar_statement;
//     if (location.startsWith('/renewals')) return l10n.sidebar_renewals;
//     if (location.startsWith('/production')) return l10n.sidebar_production;
//     if (location.startsWith('/quotes')) return l10n.sidebar_quotes;
//     if (location.startsWith('/settings')) return l10n.sidebar_settings;
//     if (location.startsWith('/profile')) return l10n.sidebar_profile;
//     if (location.startsWith('/add-client')) return l10n.sidebar_add_client;
//     if (location.startsWith('/notifications'))
//       return l10n.sidebar_notifications;
//     // return l10n.sidebar_default;
//     return 'l10n.sidebar_default';
//   }

//   String _getSubtitleFromLocation(BuildContext context, String location) {
//     final l10n = AppLocalizations.of(context)!;
//     if (location.startsWith('/dashboard')) return l10n.subtitle_dashboard;
//     if (location.startsWith('/clients')) return l10n.subtitle_clients;
//     if (location.startsWith('/motor/quote')) return l10n.subtitle_motorQuote;
//     if (location.startsWith('/policies')) return l10n.subtitle_policies;
//     if (location.startsWith('/dmvic-double-insurance'))
//       return l10n.subtitle_dmvicDoubleInsurance;
//     if (location.startsWith('/dmvic-stock')) return l10n.subtitle_dmvicStock;
//     if (location.startsWith('/statement')) return l10n.subtitle_statement;
//     if (location.startsWith('/renewals')) return l10n.subtitle_renewals;
//     if (location.startsWith('/production')) return l10n.subtitle_production;
//     if (location.startsWith('/quotes')) return l10n.subtitle_quotes;
//     if (location.startsWith('/settings')) return l10n.subtitle_settings;
//     if (location.startsWith('/profile')) return l10n.subtitle_profile;
//     if (location.startsWith('/add-client')) return l10n.sidebar_add_client;
//     if (location.startsWith('/notifications'))
//       return l10n.subtitle_notifications;
//     return '';
//   }

//   Widget _buildHeader(
//     BuildContext context,
//     WidgetRef ref,
//     String title,
//     String location, {
//     bool showBackButton = false,
//   }) {
//     final viewMode = ref.watch(clientViewModeProvider);
//     final state = ref.watch(clientsPaginationProvider);
//     final notifier = ref.read(clientsPaginationProvider.notifier);
//     final settings = ref.watch(settingsProvider);
//     final subtitle = _getSubtitleFromLocation(context, location);

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 24),
//       color: Theme.of(context).scaffoldBackgroundColor,
//       child: Column(
//         children: [
//           Row(
//             children: [
//               if (showBackButton) ...[
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () => context.pop(),
//                 ),
//                 const SizedBox(width: 8),
//               ],
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(title, type: CustomTextType.header),
//                     if (subtitle.isNotEmpty)
//                       CustomText(subtitle, type: CustomTextType.paragraph),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 8),
//               IconButton(
//                 icon: Icon(
//                   ref.watch(settingsProvider).themeMode == 'Dark'
//                       ? Icons.dark_mode
//                       : Icons.light_mode,
//                   color: ref.watch(settingsProvider).themeMode == 'Dark'
//                       ? const Color(0xFF00FFB2)
//                       : Colors.black,
//                 ),
//                 onPressed: () {
//                   final notifier = ref.read(settingsProvider.notifier);
//                   final current = ref.read(settingsProvider).themeMode;
//                   notifier.setThemeMode(current == 'Dark' ? 'Light' : 'Dark');
//                 },
//               ),
//               Opacity(
//                 opacity: settings.enableNotifications ? 1 : 0.2,
//                 child: IgnorePointer(
//                   ignoring: !settings.enableNotifications,
//                   child: const NotificationIcon(),
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.settings),
//                 onPressed: () => context.go('/settings'),
//                 color: location.startsWith('/settings')
//                     ? Colors.orange
//                     : Theme.of(context).colorScheme.onSurface,
//               ),
//               const SizedBox(width: 8),
//               const ProfileAvatar(),
//             ],
//           ),
//           const Divider(),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final settings = ref.watch(settingsProvider);
//     final location = GoRouterState.of(context).uri.path;
//     final title = _getTitleFromLocation(context, location);
//     final showBackButton = ![
//       '/dashboard',
//       '/clients',
//       '/motor/quote',
//       '/policies',
//       '/dmvic-double-insurance',
//       '/dmvic-stock',
//       '/statement',
//       '/renewals',
//       '/production',
//       '/quotes',
//       '/settings',
//       '/profile',
//       '/notifications',
//     ].contains(location);

//     ref.listen<String>(currentRouteProvider, (_, newRoute) {
//       ref.read(authProvider.notifier).updateLastRoute(newRoute);
//     });

//     ref.listen<AsyncValue<bool>>(connectivityStreamProvider, (previous, next) {
//       final isOnline = next.value ?? true;
//       final wasOnline = previous?.value ?? true;
//       if (previous != null && isOnline != wasOnline) {
//         if (isOnline) {
//           print('🌐 [Connectivity]: Device is back ONLINE');
//           FuturisticToastS.show(
//             context: context,
//             message: "You're back online!",
//             icon: Icons.wifi_off,
//             alignment: Alignment.topCenter,
//             duration: null,
//           );
//         } else {
//           print('🚫 [Connectivity]: Device is now OFFLINE');
//           FuturisticToastS.show(
//             context: context,
//             message: "No internet connection.",
//             icon: Icons.wifi,
//             alignment: Alignment.topCenter,
//             duration: null,
//           );
//         }
//       }
//     });

//     if (Responsive.isMobile(context)) {
//       return Scaffold(
//         key: scaffoldKey,
//         appBar: AppBar(
//           elevation: 0,
//           title: Text(title),
//           leading: IconButton(
//             icon: const Icon(Icons.menu),
//             onPressed: () => scaffoldKey.currentState?.openDrawer(),
//           ),
//           actions: [
//             const SizedBox(width: 8),
//             IconButton(
//               icon: Icon(
//                 ref.watch(settingsProvider).themeMode == 'Dark'
//                     ? Icons.dark_mode
//                     : Icons.light_mode,
//                 color: ref.watch(settingsProvider).themeMode == 'Dark'
//                     ? const Color(0xFF00FFB2)
//                     : Colors.black,
//               ),
//               onPressed: () {
//                 final notifier = ref.read(settingsProvider.notifier);
//                 final current = ref.read(settingsProvider).themeMode;
//                 notifier.setThemeMode(current == 'Dark' ? 'Light' : 'Dark');
//               },
//             ),
//             Opacity(
//               opacity: settings.enableNotifications ? 1 : 0.2,
//               child: IgnorePointer(
//                 ignoring: !settings.enableNotifications,
//                 child: const NotificationIcon(),
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.settings),
//               onPressed: () => context.go('/settings'),
//               color: location.startsWith('/settings')
//                   ? Colors.orange
//                   : Theme.of(context).colorScheme.onSurface,
//             ),
//             const ProfileAvatar(),
//             const SizedBox(width: 8),
//           ],
//         ),
//         drawer: const Sidebar(),
//         body: child,
//       );
//     }

//     return TwoFactorGuard(
//       child: Row(
//         children: [
//           const Sidebar(),
//           Expanded(
//             child: Scaffold(
//               body: Column(
//                 children: [
//                   _buildHeader(
//                     context,
//                     ref,
//                     title,
//                     location,
//                     showBackButton: showBackButton,
//                   ),
//                   Expanded(child: child),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
