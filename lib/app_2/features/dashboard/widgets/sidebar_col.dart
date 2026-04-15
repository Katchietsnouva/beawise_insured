import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/utils/icon_scale_helper.dart';
import 'package:insured/app_2/core/widgets/custom_circular_avatar.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/l10n/app_localizations.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:insured/app_2/providers/sidebar_provider.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final isExpanded = ref.watch(sidebarExpandedProvider);

    final authState = ref.watch(authProvider);
    final user = authState.user;
    final userName = user != null ? user.company : l10n.sidebar_loading;
    final userEmail = user != null ? user.email : '';
    final String pathPrefix = kIsWeb && !kDebugMode ? 'assets/' : '';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isExpanded ? 260 : 80,
      color: Theme.of(context).colorScheme.primary,
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Toggle Button
            Align(
              alignment: isExpanded ? Alignment.centerRight : Alignment.center,
              child: IconButton(
                icon: Icon(
                  isExpanded ? Icons.chevron_left : Icons.chevron_right,
                  color: Colors.white,
                ),
                onPressed: () =>
                    ref.read(sidebarExpandedProvider.notifier).state =
                        !isExpanded,
              ),
            ),

            // Logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image(
                image: AssetImage(
                  '${pathPrefix}images/${Theme.of(context).brightness == Brightness.dark ? 'Insured' : 'Insured_black'}.png',
                ),
                height: isExpanded ? 60 : 30,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      Icons.dashboard,
                      l10n.sidebar_dashboard,
                      '/dashboard',
                      isExpanded,
                    ),
                    _buildMenuItem(
                      context,
                      Icons.people,
                      l10n.sidebar_clients,
                      '/clients',
                      isExpanded,
                    ),
                    _buildMenuItem(
                      context,
                      Icons.motorcycle,
                      l10n.sidebar_motorQuote,
                      '/motor/quote',
                      isExpanded,
                    ),
                    _buildMenuItem(
                      context,
                      Icons.policy,
                      l10n.sidebar_policies,
                      '/policies',
                      isExpanded,
                    ),

                    // --- DMVIC Logic Section ---
                    if (isExpanded)
                      _buildCollapsibleMenuItem(
                        context,
                        Icons.business,
                        l10n.sidebar_dmvic,
                        [
                          _buildMenuItem(
                            context,
                            Icons.assignment,
                            l10n.sidebar_dmvicDoubleInsurance,
                            '/dmvic-double-insurance',
                            isExpanded,
                          ),
                        ],
                        false, // isActive check can be added here
                      )
                    else
                      _buildMenuItem(
                        context,
                        Icons.business,
                        "DMVIC",
                        '/dmvic-stock', // Or whatever default route you prefer for collapsed
                        isExpanded,
                      ),

                    // ---------------------------
                    _buildMenuItem(
                      context,
                      Icons.settings,
                      l10n.sidebar_settings,
                      '/settings',
                      isExpanded,
                    ),
                  ],
                ),
              ),
            ),

            // User Profile Section
            _buildFooter(context, user, userName, userEmail, isExpanded, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsibleMenuItem(
    BuildContext context,
    IconData icon,
    String label,
    List<Widget> subItems,
    bool isActive,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.greenAccent.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        // Fix: Removes default expansion dividers
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Material(
          color: Colors.transparent,
          child: ExpansionTile(
            leading: Icon(
              icon,
              size: 22,
              color: isActive
                  ? Colors.greenAccent
                  : Theme.of(context).colorScheme.onSurface,
            ),
            title: Text(
              label,
              style: TextStyle(
                color: isActive
                    ? Colors.greenAccent
                    : Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            iconColor: Colors.greenAccent,
            collapsedIconColor: Theme.of(context).colorScheme.onSurface,
            children: subItems,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
    bool isExpanded,
  ) {
    final String location = GoRouterState.of(context).uri.path;
    final bool isActive = location.startsWith(route);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? (Theme.of(context).brightness == Brightness.dark
                  ? Colors.greenAccent.withOpacity(0.2)
                  : Colors.green[900])
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Tooltip(
        message: isExpanded ? "" : label,
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(12),
          child: ListTile(
            visualDensity: isExpanded
                ? VisualDensity.standard
                : VisualDensity.compact,
            leading: Icon(
              icon,
              size: 22,
              color: isActive
                  ? (Theme.of(context).brightness == Brightness.dark
                        ? Colors.greenAccent
                        : Colors.white)
                  : Theme.of(context).colorScheme.onSurface,
            ),
            title: isExpanded
                ? Text(
                    label,
                    style: TextStyle(
                      color: isActive
                          ? (Theme.of(context).brightness == Brightness.dark
                                ? Colors.greenAccent
                                : Colors.white)
                          : Theme.of(context).colorScheme.onSurface,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            onTap: () => context.go(route),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    dynamic user,
    String name,
    String email,
    bool isExpanded,
    WidgetRef ref,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 20,
        horizontal: isExpanded ? 16 : 0,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (user != null) CustomCircularAvatar(user: user),
          if (isExpanded) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(name, type: CustomTextType.subHeader, maxLines: 1),
                  CustomText(email, type: CustomTextType.caption, maxLines: 1),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout, size: 20, color: Colors.white70),
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                context.go('/onboarding');
              },
            ),
          ],
        ],
      ),
    );
  }
}

// class Sidebar extends ConsumerWidget {
//   const Sidebar({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // const Sidebar({super.key});
//     final l10n = AppLocalizations.of(context)!;

//     final authState = ref.watch(authProvider);
//     final user = authState.user;

//     final isAuthenticated = authState.isAuthenticated;

//     print('📱 Sidebar build – isAuthenticated: $isAuthenticated, user: $user');
//     print("So am printing the enntire  authState from the side bae $authState");

//     final userName = user != null ? user.company : l10n.sidebar_loading;
//     final userEmail = user != null ? user.email : '';

//     final String pathPrefix = kIsWeb && !kDebugMode ? 'assets/' : '';
//     final String name = user?.email ?? 'User';

//     return Container(
//       width: 260,
//       // color: const Color(0xFF0A1A17),
//       // color: AppTheme.extraColor,
//       color: Theme.of(context).colorScheme.primary,
//       child: Column(
//         children: [
//           const SizedBox(height: 40),
//           // const Text(
//           //   'INSURED',
//           // style: TextStyle( fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2, color: Color(0xFF00FFB2), ),
//           // ),
//           // Image( image: AssetImage('${pathPrefix}assets/images/Insured.png'), height: 80, fit: BoxFit.contain, ),
//           Image(
//             // image: AssetImage('${pathPrefix}/images/Insured.png'),
//             image: AssetImage(
//               '${pathPrefix}/images/${Theme.of(context).brightness == Brightness.dark ? 'Insured' : 'Insured_black'}.png',
//             ),
//             height: 80,
//             fit: BoxFit.contain,
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: Column(
//                 children: [
//                   // Image.asset('/images/Insured.png'),
//                   // const Image(
//                   //   image: NetworkImage('/images/Insured.png'),
//                   //   height: 80,
//                   //   fit: BoxFit.contain,
//                   // ),
//                   // const SizedBox(height: 40),
//                   // Menu items
//                   // _buildMenuItem(Icons.dashboard, 'Dashboard', isActive: true),
//                   _buildMenuItem(
//                     context,
//                     Icons.dashboard,
//                     l10n.sidebar_dashboard,
//                     '/dashboard',
//                   ),
//                   _buildMenuItem(
//                     context,
//                     Icons.people,
//                     l10n.sidebar_clients,
//                     '/clients',
//                   ),

//                   // _buildMenuItem(
//                   //   context,
//                   //   Icons.save,
//                   //   'Motor Save',
//                   //   '/motor/save',
//                   // ),

//                   // _buildMenuItem(
//                   //   context,
//                   //   Icons.done_all,
//                   //   'Motor Result',
//                   //   '/motor/quote-result',
//                   // ),
//                   _buildMenuItem(
//                     context,
//                     Icons.motorcycle,
//                     l10n.sidebar_motorQuote,
//                     '/motor/quote',
//                   ),
//                   _buildMenuItem(
//                     context,
//                     Icons.policy,
//                     l10n.sidebar_policies,
//                     '/policies',
//                   ),
//                   _buildCollapsibleMenuItem(
//                     context,
//                     Icons.business,
//                     l10n.sidebar_dmvic,
//                     [
//                       _buildMenuItem(
//                         context,
//                         Icons.assignment,
//                         l10n.sidebar_dmvicDoubleInsurance,
//                         '/dmvic-double-insurance',
//                       ),
//                       _buildMenuItem(
//                         context,
//                         Icons.storage,
//                         l10n.sidebar_dmvicStock,
//                         '/dmvic-stock',
//                       ),
//                     ],
//                     false,
//                   ),

//                   _buildMenuItem(
//                     context,
//                     Icons.assignment,
//                     l10n.sidebar_statement,
//                     '/statement',
//                   ),
//                   _buildMenuItem(
//                     context,
//                     Icons.autorenew,
//                     l10n.sidebar_renewals,
//                     '/renewals',
//                   ),

//                   _buildMenuItem(
//                     context,
//                     Icons.factory,
//                     l10n.sidebar_production,
//                     '/production',
//                   ),
//                   _buildMenuItem(
//                     context,
//                     Icons.description,
//                     l10n.sidebar_quotes,
//                     '/quotes',
//                   ),

//                   _buildMenuItem(
//                     context,
//                     Icons.settings,
//                     l10n.sidebar_settings,
//                     '/settings',
//                   ),
//                   // Guard this route
//                   //                 IconButton(
//                   //   icon: const Icon(Icons.person),
//                   //   onPressed: () async {
//                   //     final allowed = await showDialog(...); // or use TwoFactorGuard as a modal
//                   //     if (allowed) context.push('/profile');
//                   //   },
//                   // )
//                   _buildMenuItem(
//                     context,
//                     Icons.person,
//                     l10n.sidebar_profile,
//                     '/profile',
//                   ),

//                   _buildMenuItem(
//                     context,
//                     Icons.offline_pin,
//                     l10n.sidebar_offlineQueueScreen,
//                     '/offline-queue',
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           Container(
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               border: Border(
//                 top: BorderSide(color: Colors.white.withOpacity(0.1)),
//               ),
//             ),
//             child: Row(
//               children: [
//                 CustomCircularAvatar(user: user!),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       CustomText(
//                         userName,
//                         type: CustomTextType.subHeader,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       CustomText(
//                         userEmail,
//                         type: CustomTextType.caption,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ],
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.logout,
//                     color: Theme.of(context).colorScheme.onSurface,
//                   ),
//                   // onPressed: () {},
//                   onPressed: () async {
//                     ref.read(authProvider.notifier).logout();

//                     context.go('/onboarding');
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuItem(
//     BuildContext context,
//     IconData icon,
//     String label,
//     String route,
//     // { bool isActive = false,}
//   ) {
//     // final String location = GoRouterState.of(context).uri.toString();
//     // final String location = GoRouter.of(context).location;
//     final String location = GoRouterState.of(context).uri.path;

//     // final bool isActive = location == route;
//     final bool isActive = location.startsWith(route);

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       decoration: BoxDecoration(
//         // color: isActive
//         //     ? Colors.greenAccent.withOpacity(0.2)
//         //     : Colors.transparent,
//         color: isActive
//             // ? Colors.greenAccent
//             ? Theme.of(context).brightness == Brightness.dark
//                   ? Colors.greenAccent.withOpacity(0.2)
//                   : Colors.green[900]
//             : Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: ListTile(
//           leading: Icon(
//             icon,
//             size: responsiveIconSize(context),
//             color: isActive
//                 // ? Colors.greenAccent
//                 ? Theme.of(context).brightness == Brightness.dark
//                       ? Colors.greenAccent
//                       : Colors.white
//                 : Theme.of(context).colorScheme.onSurface,
//           ),
//           title: Text(
//             label,
//             style: TextStyle(
//               // color: isActive
//               //     ? Colors.greenAccent
//               //     : Theme.of(context).colorScheme.onSurface,
//               color: isActive
//                   // ? Colors.greenAccent
//                   ? Theme.of(context).brightness == Brightness.dark
//                         ? Colors.greenAccent
//                         : Colors.white
//                   : Theme.of(context).colorScheme.onSurface,
//               fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
//             ),
//             maxLines: 1,
//           ),
//           onTap: () {
//             context.go(route);
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildCollapsibleMenuItem(
//     BuildContext context,
//     IconData icon,
//     String label,
//     List<Widget> subItems,
//     bool isActive,
//   ) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       decoration: BoxDecoration(
//         color: isActive
//             ? Colors.greenAccent.withOpacity(0.2)
//             : Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: ExpansionTile(
//           leading: Icon(
//             icon,
//             color: isActive
//                 ? Colors.greenAccent
//                 : Theme.of(context).colorScheme.onSurface,
//           ),
//           title: Text(
//             label,
//             style: TextStyle(
//               color: isActive
//                   ? Colors.greenAccent
//                   : Theme.of(context).colorScheme.onSurface,

//               fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
//             ),
//           ),

//           children: subItems,
//         ),
//       ),
//     );
//   }

//   // Widget _buildCollapsibleMenuItem(
//   //   BuildContext context,
//   //   IconData icon,
//   //   String label,
//   //   List<Widget> subItems,
//   //   bool isActive,
//   // ) {
//   //   return Container(
//   //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//   //     decoration: BoxDecoration(
//   //       color: isActive
//   //           ? Colors.greenAccent.withOpacity(0.2)
//   //           : Colors.transparent,
//   //       borderRadius: BorderRadius.circular(12),
//   //     ),
//   //     child: Material(
//   //       color: Colors.transparent,
//   //       child: ExpansionTile(
//   //         leading: Icon(
//   //           icon,
//   //           color: isActive
//   //               ? Colors.greenAccent
//   //               : Theme.of(context).colorScheme.onSurface,
//   //         ),
//   //         title: Text(
//   //           label,
//   //           style: TextStyle(
//   //             color: isActive
//   //                 ? Colors.greenAccent
//   //                 : Theme.of(context).colorScheme.onSurface,
//   //             fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
//   //           ),
//   //         ),
//   //         // Here, we use a static icon for the trailing property, so no rotation
//   //         trailing: Icon(
//   //           Icons.chevron_right, // Or any static icon
//   //           color: isActive
//   //               ? Colors.greenAccent
//   //               : Theme.of(context).colorScheme.onSurface,
//   //         ),
//   //         children: subItems,
//   //       ),
//   //     ),
//   //   );
//   // }
// }
