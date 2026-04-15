// // lib/app_2/core/utils/route_observer.dart

// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_riverpod/legacy.dart';
// // import 'package:go_router/go_router.dart';

// // final currentRouteProvider = StateProvider<String>((ref) => '/dashboard');

// // // class RouteLogger extends GoRouterObserver {
// // class RouteLogger extends GoRouterObserver {
// //   final Ref ref;
// //   RouteLogger(this.ref);

// //   @override
// //   void didChange(String? previousRoute, String currentRoute, bool isRestoring) {
// //     ref.read(currentRouteProvider.notifier).state = currentRoute;
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';

// final currentRouteProvider = StateProvider<String>((ref) => '/dashboard');

// class RouteLogger extends NavigatorObserver {
//   final Ref ref;
//   RouteLogger(this.ref);

//   @override
//   void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     _updateRoute(route.settings.name);
//   }

//   @override
//   void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
//     _updateRoute(previousRoute?.settings.name);
//   }

//   @override
//   void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
//     _updateRoute(newRoute?.settings.name);
//   }

//   void _updateRoute(String? routeName) {
//     if (routeName != null &&
//         routeName != '/onboarding' &&
//         routeName != '/login') {
//       ref.read(currentRouteProvider.notifier).state = routeName;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

final currentRouteProvider = StateProvider<String>((ref) => '/dashboard');

class RouteLogger extends NavigatorObserver {
  final Ref ref;
  RouteLogger(this.ref);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateRoute(route.settings.name);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateRoute(previousRoute?.settings.name);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _updateRoute(newRoute?.settings.name);
  }

  void _updateRoute(String? routeName) {
    if (routeName == null ||
        routeName == 'onboarding' ||
        routeName == 'login' ||
        routeName == 'register')
      return;

    Future.microtask(() {
      ref.read(currentRouteProvider.notifier).state = routeName;

      // 3. PERSISTENCE: Tell AuthNotifier to save this to SharedPreferences
      // Note: GoRouter names usually don't have the '/' prefix,
      // but paths do. Use a leading slash if your initialLocation expects it.
      final path = '/$routeName';
      ref.read(authProvider.notifier).updateLastRoute(path);
    });
  }
}
