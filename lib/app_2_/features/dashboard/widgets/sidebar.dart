import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/utils/icon_scale_helper.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_circular_avatar.dart';
import 'package:insured/app_2/l10n/app_localizations.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

class Sidebar extends ConsumerStatefulWidget {
  const Sidebar({super.key});

  @override
  ConsumerState<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends ConsumerState<Sidebar>
    with SingleTickerProviderStateMixin {
  bool _isCollapsed = false;

  late final AnimationController _animController;
  late final Animation<double> _widthAnim;

  static const double _expandedWidth = 260;
  static const double _collapsedWidth = 68;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _widthAnim = Tween<double>(begin: _expandedWidth, end: _collapsedWidth)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isCollapsed = !_isCollapsed);
    _isCollapsed ? _animController.forward() : _animController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isAuthenticated = authState.isAuthenticated;

    final userName = user != null
        ? toTitleCase(user.name)
        : l10n.sidebar_loading;
    final userEmail = user != null ? user.email : '';
    final String pathPrefix = (kIsWeb && kDebugMode) ? '' : 'assets';
    print('📱 Sidebar build – isAuthenticated: $isAuthenticated, user: $user');
    print("So am printing the enntire  authState from the side bae $authState");

    return AnimatedBuilder(
      animation: _widthAnim,
      builder: (context, child) {
        return Container(
          width: _widthAnim.value,
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            children: [
              const SizedBox(height: 60),

              _isCollapsed
                  ? Visibility(
                      visible: Responsive.isMobile(context) ? false : true,
                      child: IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 40,
                        ),
                        onPressed: _toggle,
                      ),
                    )
                  : Responsive.isMobile(context)
                  // MOBILE
                  ? Center(
                      child: Image(
                        image: AssetImage(
                          '$pathPrefix/images/${Theme.of(context).brightness == Brightness.dark ? 'Insured' : 'Insured_black'}.png',
                        ),
                        height: 38,
                        fit: BoxFit.contain,
                      ),
                    )
                  // //  DESKTOP
                  : Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 2),
                          child: Image(
                            image: AssetImage(
                              '$pathPrefix/images/${Theme.of(context).brightness == Brightness.dark ? 'Insured' : 'Insured_black'}.png',
                            ),
                            height: 38,
                            // width: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const Spacer(),
                        Visibility(
                          visible: Responsive.isMobile(context) ? false : true,
                          child: IconButton(
                            tooltip: 'Collapse sidebar',
                            icon: Icon(
                              Icons.chevron_left,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 40,
                            ),
                            onPressed: _toggle,
                          ),
                        ),
                      ],
                    ),

              const SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      _buildMenuItem(
                        context,
                        Icons.dashboard,
                        l10n.sidebar_dashboard,
                        '/dashboard',
                      ),
                      _buildMenuItem(
                        context,
                        Icons.people,
                        l10n.sidebar_clients,
                        '/clients',
                      ),
                      _buildMenuItem(
                        context,
                        Icons.car_rental,
                        l10n.sidebar_motorQuote,
                        '/motor/quote',
                      ),
                      _buildMenuItem(
                        context,
                        Icons.receipt_long,
                        l10n.sidebar_quotes,
                        '/quotes',
                      ),
                      _buildMenuItem(
                        context,
                        Icons.policy,
                        l10n.sidebar_production,
                        '/policies',
                      ),
                      _buildMenuItem(
                        context,
                        Icons.autorenew,
                        l10n.sidebar_renewals,
                        '/renewals',
                      ),
                      _buildMenuItem(
                        context,
                        Icons.description,
                        l10n.sidebar_certificates,
                        '/certificates',
                      ),
                      _buildMenuItem(
                        context,
                        Icons.receipt_long,
                        l10n.sidebar_statement,
                        '/statement',
                      ),

                      _buildMenuItem(
                        context,
                        Icons.fact_check,
                        l10n.sidebar_dmvicDoubleInsurance,
                        '/dmvic-double-insurance',
                      ),
                      // _buildCollapsibleMenuItem(
                      //   context,
                      //   Icons.business,
                      //   l10n.sidebar_dmvic,
                      //   [
                      //     _buildMenuItem(
                      //       context,
                      //       Icons.assignment,
                      //       l10n.sidebar_dmvicDoubleInsurance,
                      //       '/dmvic-double-insurance',
                      //     ),
                      //     _buildMenuItem(
                      //       context,
                      //       Icons.storage,
                      //       l10n.sidebar_dmvicStock,
                      //       '/dmvic-stock',
                      //     ),
                      //   ],
                      //   false,
                      // ),
                      // _buildMenuItem(
                      //   context,
                      //   Icons.offline_pin,
                      //   l10n.sidebar_offlineQueueScreen,
                      //   '/offline-queue',
                      // ),
                      // _buildMenuItem(
                      //   context,
                      //   Icons.download_rounded,
                      //   'Installation',
                      //   '/installation',
                      // ),
                      _buildMenuItem(
                        context,
                        Icons.person,
                        l10n.sidebar_profile,
                        '/profile',
                      ),
                      _buildMenuItem(
                        context,
                        Icons.settings,
                        l10n.sidebar_settings,
                        '/settings',
                      ),
                    ],
                  ),
                ),
              ),

              // ── Footer ──
              Material(
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 8,
                    right: 8,
                    top: 4,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.1)),
                    ),
                  ),
                  child: _isCollapsed
                      // Collapsed footer — just avatar + logout stacked
                      ? Column(
                          children: [
                            if (user != null)
                              CustomCircularAvatar(user: user.name),
                            const SizedBox(height: 8),
                            IconButton(
                              icon: Icon(
                                Icons.logout,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () async {
                                // ref.read(authProvider.notifier).logout();
                                Future.microtask(() {
                                  ref.read(authProvider.notifier).logout();
                                });
                                context.go('/login');
                              },
                            ),
                          ],
                        )
                      // Expanded footer — full row
                      : Row(
                          children: [
                            if (user != null)
                              // CustomCircularAvatar(user: user.name),
                              const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Image(
                                      image: AssetImage(
                                        '$pathPrefix/images/inscloud.png',
                                      ),
                                      width: 100,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  // CustomText(
                                  //   userEmail,
                                  //   type: CustomTextType.caption,
                                  //   maxLines: 1,
                                  //   overflow: TextOverflow.ellipsis,
                                  // ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.logout,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () async {
                                context.go('/login');
                                // ref.read(authProvider.notifier).logout();
                                Future.microtask(() {
                                  ref.read(authProvider.notifier).logout();
                                });
                              },
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    final String location = GoRouterState.of(context).uri.path;
    final bool isActive = location.startsWith(route);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color activeColor = isDark ? Colors.greenAccent : Colors.white;
    final Color iconColor = isActive
        ? activeColor
        : Theme.of(context).colorScheme.onSurface;

    // ── Collapsed: icon-only with tooltip ──
    if (_isCollapsed) {
      return Tooltip(
        message: label,
        preferBelow: false,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark
                      ? Colors.greenAccent.withOpacity(0.2)
                      : Colors.green[900])
                : (isDark
                      ? Theme.of(context).colorScheme.background
                      : Colors.white10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => context.go(route),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  icon,
                  size: responsiveIconSize(context),
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // ── Expanded: full list tile ──
    final isMobile = Responsive.isMobile(context);
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 6 : 10,
        vertical: isMobile ? 1 : 4,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? (isDark ? Colors.greenAccent.withOpacity(0.2) : Colors.green[900])
            : (isDark
                  ? Theme.of(context).colorScheme.background
                  : Colors.white10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          leading: Icon(
            icon,
            size: responsiveIconSize(context),
            color: iconColor,
          ),
          title: Text(
            label,
            style: TextStyle(
              color: iconColor,
              fontWeight: isActive ? FontWeight.w400 : FontWeight.w300,
            ),
            maxLines: 1,
          ),
          onTap: () => context.go(route),
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
    // ── Collapsed: just the icon with tooltip ──
    if (_isCollapsed) {
      return Tooltip(
        message: label,
        preferBelow: false,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.greenAccent.withOpacity(0.2)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              color: isActive
                  ? Colors.greenAccent
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      );
    }

    // ── Expanded: full expansion tile ──
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.greenAccent.withOpacity(0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: ExpansionTile(
          leading: Icon(
            icon,
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
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          children: subItems,
        ),
      ),
    );
  }
}

// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter/foundation.dart';
// import 'package:insured/app_2/core/theme/app_theme.dart';
// import 'package:insured/app_2/core/utils/formatHumanDate.dart';
// import 'package:insured/app_2/core/utils/icon_scale_helper.dart';
// import 'package:insured/app_2/core/widgets/custom_circular_avatar.dart';
// import 'package:insured/app_2/core/widgets/custom_text.dart';
// import 'package:insured/app_2/l10n/app_localizations.dart';
// import 'package:insured/app_2/providers/auth_provider.dart';

// // context.go('/route');

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

//     final userName = user != null
//         ? toTitleCase(user.name)
//         : l10n.sidebar_loading;
//     final userEmail = user != null ? user.email : '';

//     // final String pathPrefix = kIsWeb && !kDebugMode ? 'assets' : '';
//     final String pathPrefix = (kIsWeb && kDebugMode) ? '' : 'assets';
//     // final String name = user?.name ?? 'User';

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
//                     Icons.description,
//                     l10n.sidebar_quotes,
//                     '/quotes',
//                   ),

//                   // _buildMenuItem(
//                   //   context,
//                   //   Icons.description,
//                   //   l10n.sidebar_quotes,
//                   //   '/quotes_old',
//                   // ),
//                   _buildMenuItem(
//                     context,
//                     Icons.policy,
//                     // l10n.sidebar_policies,
//                     l10n.sidebar_production,
//                     '/policies',
//                   ),

//                   _buildMenuItem(
//                     context,
//                     Icons.autorenew,
//                     l10n.sidebar_renewals,
//                     '/renewals',
//                   ),

//                   // _buildMenuItem(
//                   //   context,
//                   //   Icons.factory,
//                   //   l10n.sidebar_production,
//                   //   '/production',
//                   // ),
//                   _buildMenuItem(
//                     context,
//                     Icons.description,
//                     'Certificates',
//                     '/certificates',
//                   ),

//                   _buildMenuItem(
//                     context,
//                     Icons.assignment,
//                     l10n.sidebar_statement,
//                     '/statement',
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
//                     Icons.offline_pin,
//                     l10n.sidebar_offlineQueueScreen,
//                     '/offline-queue',
//                   ),
//                   _buildMenuItem(
//                     context,
//                     Icons.download_rounded,
//                     'Installation',
//                     '/installation',
//                   ),
//                   _buildMenuItem(
//                     context,
//                     Icons.person,
//                     l10n.sidebar_profile,
//                     '/profile',
//                   ),

//                   _buildMenuItem(
//                     context,
//                     Icons.settings,
//                     l10n.sidebar_settings,
//                     '/settings',
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           Material(
//             child: Container(
//               padding: const EdgeInsets.only(
//                 left: 16,
//                 right: 16,
//                 top: 4,
//                 bottom: 10,
//               ),
//               decoration: BoxDecoration(
//                 border: Border(
//                   top: BorderSide(color: Colors.white.withOpacity(0.1)),
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   if (user != null) CustomCircularAvatar(user: user!.name),
//                   // else
//                   //   const SizedBox(width: 32, height: 32),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // CustomText(
//                         //   userName,
//                         //   type: CustomTextType.subHeader,
//                         //   maxLines: 1,
//                         //   overflow: TextOverflow.ellipsis,
//                         // ),
//                         Padding(
//                           padding: const EdgeInsets.all(4.0),
//                           child: Image(
//                             // image: AssetImage('${pathPrefix}/images/Insured.png'),
//                             image: AssetImage(
//                               '${pathPrefix}/images/${Theme.of(context).brightness == Brightness.dark ? 'inscloud' : 'inscloud'}.png',
//                             ),
//                             // height: 80,
//                             width: 60,
//                             fit: BoxFit.contain,
//                           ),
//                         ),
//                         CustomText(
//                           userEmail,
//                           type: CustomTextType.caption,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       Icons.logout,
//                       color: Theme.of(context).colorScheme.onSurface,
//                     ),
//                     // onPressed: () {},
//                     onPressed: () async {
//                       ref.read(authProvider.notifier).logout();

//                       context.go('/login');
//                     },
//                   ),
//                 ],
//               ),
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
// }

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
// // }
