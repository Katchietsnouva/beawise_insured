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
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

final currentRouteProvider = StateProvider<String>((ref) => '/dashboard');

// Routes we must never persist as `last_route`: restoring onto them either
// bounces the user (auth screens) or re-triggers the installation/browser loop.
const _nonResumableRoutePrefixes = <String>[
  '/onboarding',
  '/login',
  '/register',
  '/otp',
  '/forgot-password',
  '/reset-password',
  '/installation',
];

class RouteLogger extends NavigatorObserver {
  final Ref ref;
  RouteLogger(this.ref);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateRoute(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _updateRoute(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _updateRoute(newRoute);
  }

  void _updateRoute(Route<dynamic>? route) {
    final context = route?.navigator?.context;
    if (context == null) return;

    // Capture the router synchronously; read the *settled* location in a
    // microtask. We persist the real matched path (e.g. "/motor/quote"), NOT
    // "/$name" — the route name ("motor-quote") is not a valid path, which is
    // what used to get saved and then 404 on the next launch.
    final GoRouter router;
    try {
      router = GoRouter.of(context);
    } catch (_) {
      return;
    }

    Future.microtask(() {
      final location = router.routerDelegate.currentConfiguration.uri.toString();
      if (location.isEmpty) return;
      if (_nonResumableRoutePrefixes.any(location.startsWith)) return;

      ref.read(currentRouteProvider.notifier).state = location;

      // PERSISTENCE: AuthNotifier writes this to SharedPreferences as the
      // `last_route`, which main.dart restores into GoRouter's initialLocation.
      ref.read(authProvider.notifier).updateLastRoute(location);
    });
  }
}
