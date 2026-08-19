import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/core/utils/route_observer.dart';

import 'package:insured/app_2/core/widgets/dashboard_shell.dart';
import 'package:insured/app_2/data/models/certificate_response.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/data/models/list_policy_response.dart';
import 'package:insured/app_2/features/auth/forgot_password_screen.dart';

import 'package:insured/app_2/features/auth/login_screen.dart';
import 'package:insured/app_2/features/auth/otp_screen.dart';
import 'package:insured/app_2/features/auth/reset_password_screen.dart';
import 'package:insured/app_2/features/certificates/certificate_detail/certificate_detail_screen.dart';
import 'package:insured/app_2/features/certificates/certificates_screen.dart';
import 'package:insured/app_2/features/clients/client_detail_screen.dart';
import 'package:insured/app_2/features/clients/clients_screen.dart';
import 'package:insured/app_2/features/dashboard/dashboard_screen.dart';
import 'package:insured/app_2/features/dmvic_double_insurance/dmvic_double_insurance_screen.dart';
import 'package:insured/app_2/features/dmvic_stock/dmvic_stock_screen.dart';
import 'package:insured/app_2/features/error/not_found_screen.dart';
import 'package:insured/app_2/features/installation/installation_screen.dart';
// import 'package:insured/app_2/features/motor/section/motor_quote_result_screen.dart';
import 'package:insured/app_2/features/motor/motor_quote_screen.dart';
import 'package:insured/app_2/features/notifications/notifications_screen.dart';
import 'package:insured/app_2/features/offline/offline_queue_screen.dart';
import 'package:insured/app_2/features/onboarding/onboarding_screen.dart';
import 'package:insured/app_2/features/policies/policies_screen.dart';
import 'package:insured/app_2/features/policies/production_detail_screen/production_detail_screen.dart';
import 'package:insured/app_2/features/profile/profile_screen.dart';
import 'package:insured/app_2/features/quotes/quote_detail_screen.dart';
import 'package:insured/app_2/features/quotes/quotes_screen.dart';
import 'package:insured/app_2/features/quotes_old/quote_detail_screen_old.dart';
import 'package:insured/app_2/features/quotes_old/quotes_screen.dart';
import 'package:insured/app_2/features/renewals/renewal_detail_screen/renewal_detail_screen.dart';
import 'package:insured/app_2/features/renewals/renewals_screen.dart';
import 'package:insured/app_2/features/settings/settings_screen.dart';
import 'package:insured/app_2/features/statement/statement_screen.dart';

import 'package:flutter/widgets.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:insured/app_2/providers/client_view_provider.dart';

import 'data/models/quote_old_model.dart';
import 'features/auth/sign_up_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final initialLocationProvider = Provider<String>((ref) => '/onboarding');

final appRouterProvider = Provider<GoRouter>((ref) {
  final initial = ref.watch(initialLocationProvider);

  // Re-run GoRouter's redirect whenever auth state changes (login, logout, or
  // once the async storage load finishes). Without this, opening a protected
  // deep link like /#/motor/quote on an unauthenticated device stays on that
  // route instead of bouncing the user to /login.
  final authRefresh = ValueNotifier<int>(0);
  ref.listen(authProvider, (_, _) => authRefresh.value++);

  final renewalsViewModeProvider = StateProvider<ClientViewMode>(
    (ref) => ClientViewMode.list,
  );
  final certificatesViewModeProvider = StateProvider<ClientViewMode>(
    (ref) => ClientViewMode.list,
  );
  final policiesViewModeProvider = StateProvider<ClientViewMode>(
    (ref) => ClientViewMode.list,
  );
  final quotesViewModeProvider = StateProvider<ClientViewMode>(
    (ref) => ClientViewMode.list,
  );
  final productionViewModeProvider = StateProvider<ClientViewMode>(
    (ref) => ClientViewMode.list,
  );

  // ThemeMode _mode = ThemeMode.dark;
  // void _toggle() => setState(
  //   () => _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
  // );

  return GoRouter(
    // navigatorKey: rootNavigatorKey, // 2. LINK THE KEY HERE
    initialLocation: initial,
    refreshListenable: authRefresh,
    observers: [RouteLogger(ref)],

    redirect: (context, state) {
      // final auth = ref.watch(authProvider);
      final auth = ref.read(authProvider); // ← read, not watch

      //  (if auth.user ){
      // final auth = ref.watch(authProvider);
      //  }
      if (auth.isLoading && auth.lastRoute == null
      //  && state.matchedLocation == '/login'
      )
        return null; // this miraculosly prevents the bug that occred when user tries to log in and is suddnely redirected to /onboarding route coz of teh newly introduced protected routes update i just did, but  is still bugy to keep user logged in ehrn he/she refreshess the page when already logged in. user is taken to login page on refreshign any page is in eg /clinets route but i can still see that the local storage has even the last page visited :flutter.last_route "/dashboard". so lets solve the bug that occurs when uer is logged in and refreshes but is taken to login page
      final isAuthenticated = auth.isAuthenticated;
      // Check if the user is authenticated
      // final isLoginRoute =
      //     state.matchedLocation == '/login' ||
      //     state.matchedLocation == '/onboarding' ||
      //     state.matchedLocation == '/register' ||
      //     state.matchedLocation == '/otp' ||
      //     state.matchedLocation == '/forgot-password' ||
      //     state.matchedLocation == '/reset-password' ||
      //     state.matchedLocation == '/installation';
      final publicRoutes = [
        '/login',
        '/onboarding',
        '/register',
        '/otp',
        '/forgot-password',
        '/reset-password',
        '/installation',
      ];

      // if (!isAuthenticated && !isLoginRoute) {
      //   return '/login';
      // }

      // // If authenticated and trying to access a login/register route, go to /dashboard
      // if (isAuthenticated && isLoginRoute) {
      //   return '/dashboard';
      // }

      final isPublic = publicRoutes.any(
        (r) => state.matchedLocation.startsWith(r),
      );

      // Not authenticated + trying to access protected route → go to login
      if (!isAuthenticated && !isPublic) {
        return '/login';
      }

      // Authenticated + trying to access login/onboarding → go to dashboard
      if (isAuthenticated &&
          (state.matchedLocation == '/login' ||
              state.matchedLocation == '/onboarding' ||
              state.matchedLocation == '/register')) {
        return '/dashboard';
      }

      // No redirect needed
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        // builder: (context, state) => const OnboardingScreen(),
        builder: (context, state) => OnboardingScreen(
          key: UniqueKey(), // forces rebuild
        ),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const SignUpScreen(),
      ),

      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) => const OtpScreen(),
      ),

      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder: (context, state) {
          final email = state.extra as String?;
          return ResetPasswordScreen(email: email);
        },
      ),

      GoRoute(
        path: '/motor/quote',
        name: 'motor-quote',
        builder: (context, state) => const MotorQuoteScreen(),
      ),

      GoRoute(
        path: '/installation',
        name: 'installation',
        builder: (context, state) =>
            // DownloadScreen(onToggleTheme: _toggle, themeMode: _mode),
            const DownloadScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => DashboardShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/clients',
            name: 'clients',
            builder: (context, state) => ClientsScreen(),
          ),

          GoRoute(
            path: '/client/:clientId',
            name: 'client-detail',
            builder: (context, state) {
              // Get the client object from 'extra'
              final client = state.extra as Client;
              return ClientDetailScreen(client: client);
            },
          ),

          // GoRoute(
          //   path: '/add-client',
          //   name: 'add-client',
          //   builder: (context, state) => const AddClientScreen(),
          // ),
          GoRoute(
            path: '/policies',
            // name: 'policies',
            name: 'production',
            builder: (context, state) => const PoliciesScreen(),
          ),
          GoRoute(
            path: '/production-detail',
            name: 'production-detail',
            builder: (context, state) {
              final entry = state.extra as PolicyEntry;
              return ProductionDetailScreen(entry: entry);
            },
          ),
          GoRoute(
            path: '/dmvic-double-insurance',
            name: 'dmvic-double-insurance',
            // builder: (context, state) => const DmvicDoubleInsuranceScreen(),
            builder: (context, state) =>
                const DmvicModalLauncher(), // ← Widget ✓
          ),

          GoRoute(
            path: '/dmvic-stock',
            name: 'dmvic-stock',
            builder: (context, state) => const DmvicStockScreen(),
          ),

          GoRoute(
            path: '/statement',
            name: 'statement',
            builder: (context, state) => const StatementScreen(),
          ),

          GoRoute(
            path: '/renewals',
            name: 'renewals',
            builder: (context, state) =>
                RenewalsScreen(viewModeProvider: renewalsViewModeProvider),
            // builder: (context, state) =>
            // RenewalsScreen(viewModeProvider: null,
            //  RenewalsScreen(required this.viewModeProvider)
            // ),
          ),
          GoRoute(
            path: '/renewal-detail',
            name: 'renewal-detail',
            builder: (context, state) {
              final entry = state.extra as PolicyEntry;
              return RenewalDetailScreen(entry: entry);
            },
          ),
          // GoRoute(
          //   path: '/production',
          //   name: 'production',
          //   builder: (context, state) => const ProductionScreen(),
          // ),
          GoRoute(
            path: '/quotes',
            name: 'quotes',
            builder: (context, state) => QuotesScreen(),
          ),
          // GoRoute(
          //   path: '/quote-detail',
          //   name: 'quote-detail',
          //   builder: (context, state) {
          //     final entry = state.extra as PolicyEntry;
          //     return QuoteDetailScreen(entry: entry);
          //   },
          // ),
          GoRoute(
            path: '/quote-detail',
            name: 'quote-detail',
            builder: (context, state) {
              // 1. Debug: See if the router even receives the call
              print(
                "Router: Navigating to quote-detail with extra: ${state.extra}",
              );

              if (state.extra is! PolicyEntry) {
                print(
                  "Router Error: 'extra' is not a PolicyEntry. It is a ${state.extra.runtimeType}",
                );
                return const NotFoundScreen(path: 'Invalid Data');
              }

              final entry = state.extra as PolicyEntry;
              return QuoteDetailScreen(entry: entry);
            },
          ),
          GoRoute(
            path: '/certificates',
            name: 'certificates',
            builder: (context, state) => CertificatesScreen(
              viewModeProvider: certificatesViewModeProvider,
            ),
          ),
          GoRoute(
            path: '/certificate-detail',
            name: 'certificate-detail',
            builder: (context, state) {
              final cert = state.extra as Certificate;
              return CertificateDetailScreen(cert: cert);
            },
          ),
          GoRoute(
            path: '/quotes_old',
            name: 'quotes_old',
            builder: (context, state) => QuotesScreen_old(),
          ),
          GoRoute(
            path: '/quote-detail-old',
            name: 'quotes-detail-old',
            builder: (context, state) {
              final quote = state.extra as Quote_old;
              return QuoteDetailScreenOld(quote: quote);
            },
          ),

          // GoRoute(
          //   path: '/motor/quote-result',
          //   name: 'motor-quote-result',
          //   builder: (context, state) => const MotorQuoteResultScreen(),
          // ),
          // GoRoute(
          //   path: '/motor/save',
          //   name: 'motor-save',
          //   builder: (context, state) => const MotorSaveScreen(),
          // ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => SettingsScreen(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),

          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),

          GoRoute(
            path: '/offline-queue',
            name: 'offline-queue',
            builder: (context, state) => const OfflineQueueScreen(),
          ),
          // GoRoute(
          //   // path: '/:any',
          //   path: '/:pathMatch(.*)',
          //   name: 'not-found',
          //   builder: (context, state) =>
          //       NotFoundScreen(path: state.uri.toString()),
          // ),
        ],
      ),
      GoRoute(
        path: '/:pathMatch(.*)',
        // path: '/:any',
        builder: (context, state) => NotFoundScreen(path: state.uri.toString()),
      ),
    ],
  );
});
