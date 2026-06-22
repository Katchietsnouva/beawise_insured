// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:insured/app_2/features/installation/installation_screen.dart';

// void main() => runApp(const _App());

// class _App extends StatefulWidget {
//   const _App();
//   @override
//   State<_App> createState() => _AppState();
// }

// class _AppState extends State<_App> {
//   ThemeMode _mode = ThemeMode.dark;
//   void _toggle() => setState(
//     () => _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       themeMode: _mode,
//       theme: _buildTheme(Brightness.light),
//       darkTheme: _buildTheme(Brightness.dark),
//       // home: DownloadScreen(onToggleTheme: _toggle, themeMode: _mode),
//       home: DownloadScreen(),
//     );
//   }
// }

// ThemeData _buildTheme(Brightness brightness) {
//   final dark = brightness == Brightness.dark;
//   return ThemeData(
//     brightness: brightness,
//     scaffoldBackgroundColor: dark
//         ? const Color(0xFF0D1F1C)
//         : const Color(0xFFF0FAF7),
//     colorScheme: ColorScheme(
//       brightness: brightness,
//       primary: dark ? const Color(0xFF00FFB2) : const Color(0xFF00A572),
//       onPrimary: const Color(0xFF0D1F1C),
//       secondary: dark ? const Color(0xFF00CC8E) : const Color(0xFF008A5E),
//       onSecondary: Colors.white,
//       error: Colors.redAccent,
//       onError: Colors.white,
//       surface: dark ? const Color(0xFF132620) : const Color(0xFFE4F4EE),
//       onSurface: dark ? const Color(0xFFF0FAF7) : const Color(0xFF0D2520),
//     ),
//     fontFamily: 'SF Pro Display',
//     useMaterial3: true,
//   );
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:insured/app_2/app_router.dart';
// import 'package:insured/app_2/core/theme/app_theme.dart';

// import 'dart:ui'; // Required for PlatformDispatcher
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// // Import your router file to access rootNavigatorKey
// import 'package:insured/app_2/app_router.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   // 1. Catch Flutter Framework errors (Widget build, layout, etc.)
//   FlutterError.onError = (details) {
//     FlutterError.presentError(details);
//     _showGlobalErrorDialog(details.exception.toString());
//   };

//   // 2. Catch Asynchronous errors (Platform Channels, Plugins, Timers)
//   // This is what will catch your MissingPluginException!
//   PlatformDispatcher.instance.onError = (error, stack) {
//     _showGlobalErrorDialog(error.toString());
//     return true;
//   };

//   runApp(const ProviderScope(child: InsuredApp()));
// }

// class InsuredApp extends ConsumerWidget {
//   const InsuredApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final router = ref.watch(appRouterProvider);
//     return MaterialApp.router(
//       title: 'Insured',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.darkTheme,
//       routerConfig:
//           router, // No need for navigatorKey here, GoRouter handles it
//     );
//   }
// }

// void _showGlobalErrorDialog(String error) {
//   // Use the key from your router file
//   final context = rootNavigatorKey.currentContext;
//   if (context == null) return;

//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       backgroundColor: const Color(0xFF1A1A1A),
//       title: const Text(
//         "System Notice",
//         style: TextStyle(color: Colors.redAccent),
//       ),
//       content: SingleChildScrollView(
//         child: Text(
//           error,
//           style: const TextStyle(color: Colors.white70, fontSize: 13),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("DISMISS"),
//         ),
//       ],
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/app_router.dart';
import 'package:insured/app_2/core/constants/url_cosntants.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/utils/text_scale_provider.dart';
import 'package:insured/app_2/core/utils/theme_provider.dart';
import 'package:insured/app_2/l10n/app_localizations.dart';
import 'package:insured/app_2/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final rememberMe = prefs.getBool('remember_me') ?? false;
  final lastRoute = prefs.getString('last_route') ?? '/onboarding';
  final initialLocation = rememberMe ? lastRoute : '/onboarding';

  runApp(
    ProviderScope(
      overrides: [initialLocationProvider.overrideWithValue(initialLocation)],
      child: const InsuredApp(),
    ),
  );
}

// class InsuredApp extends ConsumerWidget {
class InsuredApp extends ConsumerStatefulWidget {
  const InsuredApp({super.key});

  @override
  ConsumerState<InsuredApp> createState() => _InsuredAppState();
}

class _InsuredAppState extends ConsumerState<InsuredApp> {
  String? _pendingLanguage;
  bool _hasPrompted = false;

  @override
  void initState() {
    super.initState();
    // _autoDetectLanguage();
  }

  // Future<void> _autoDetectLanguage_() async {
  //   final settingsNotifier = ref.read(settingsProvider.notifier);
  //   final currentLanguage = ref.read(settingsProvider).language;

  //   final locationService = LocationService();
  //   final detectedLang = await locationService.detectLanguageFromLocation();

  //   if (detectedLang != null) {
  //     String displayName;
  //     switch (detectedLang) {
  //       case 'sw':
  //         displayName = 'Swahili';
  //         break;
  //       case 'fr':
  //         displayName = 'French';
  //         break;
  //       case 'de':
  //         displayName = 'German';
  //         break;
  //       case 'it':
  //         displayName = 'Italian';
  //         break;
  //       default:
  //         displayName = 'English';
  //     }

  //     // Only prompt if the detected language is different and we haven't already asked
  //     if (displayName != currentLanguage && !_hasPrompted) {
  //       setState(() {
  //         _pendingLanguage = displayName;
  //       });

  //       // Wait for the first frame to have a valid context
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         if (_pendingLanguage != null) {
  //           _showLanguagePrompt(context, displayName, settingsNotifier);
  //           setState(() {
  //             _hasPrompted = true;
  //             _pendingLanguage = null;
  //           });
  //         }
  //       });
  //     }
  //   }
  // }

  Locale _getLocale(String languageName) {
    switch (languageName) {
      case 'Swahili':
        return const Locale('sw', 'KE');
      case 'French':
        return const Locale('fr', 'FR');
      case 'German':
        return const Locale('de', 'DE');
      case 'Italian':
        return const Locale('it', 'IT');
      case 'Russian':
        return const Locale('ru', 'RU');
      case 'Chinese':
        return const Locale('zh', 'CN');
      case 'Arabic':
        return const Locale('ar', 'AE');
      case 'English':
      default:
        return const Locale('en', 'US');
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final textScateProviderState = ref.watch(textScaleProvider);
    final themeProviderState = ref.watch(themeProvider);
    final settingsProviderState = ref.watch(settingsProvider);

    ThemeMode mode = ThemeMode.system;
    if (settingsProviderState.themeMode == 'Light') mode = ThemeMode.light;
    if (settingsProviderState.themeMode == 'Dark') mode = ThemeMode.dark;

    return MaterialApp.router(
      title: InscloudUrls.appName,
      debugShowCheckedModeBanner: false,
      // theme: AppTheme.darkTheme,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // themeMode: themeProviderState.themeMode,
      themeMode: mode,

      locale: _getLocale(settingsProviderState.language),
      // -------------------------------
      // !!!!!!!!!!!!!!!
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // !!!!!!!!!!!!!
      routerConfig: router,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScateProviderState.textScaleFactor),
        ),
        child: child!,
      ),
    );
  }
}

// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:model_viewer_plus/model_viewer_plus.dart';

// // // // // void main() => runApp(const MyApp());
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:insured/app_2/app_router.dart';
// import 'package:insured/app_2/core/theme/app_theme.dart';

// import 'dart:ui'; // Required for PlatformDispatcher
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// // Import your router file to access rootNavigatorKey
// import 'package:insured/app_2/app_router.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   // 1. Catch Flutter Framework errors (Widget build, layout, etc.)
//   FlutterError.onError = (details) {
//     FlutterError.presentError(details);
//     _showGlobalErrorDialog(details.exception.toString());
//   };

//   // 2. Catch Asynchronous errors (Platform Channels, Plugins, Timers)
//   // This is what will catch your MissingPluginException!
//   PlatformDispatcher.instance.onError = (error, stack) {
//     _showGlobalErrorDialog(error.toString());
//     return true;
//   };

//   runApp(const ProviderScope(child: InsuredApp()));
// }

// class InsuredApp extends ConsumerWidget {
//   const InsuredApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final router = ref.watch(appRouterProvider);
//     return MaterialApp.router(
//       title: 'Insured',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.darkTheme,
//       routerConfig:
//           router, // No need for navigatorKey here, GoRouter handles it
//     );
//   }
// }

// void _showGlobalErrorDialog(String error) {
//   // Use the key from your router file
//   final context = rootNavigatorKey.currentContext;
//   if (context == null) return;

//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       backgroundColor: const Color(0xFF1A1A1A),
//       title: const Text(
//         "System Notice",
//         style: TextStyle(color: Colors.redAccent),
//       ),
//       content: SingleChildScrollView(
//         child: Text(
//           error,
//           style: const TextStyle(color: Colors.white70, fontSize: 13),
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text("DISMISS"),
//         ),
//       ],
//     ),
//   );
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:insured/app_2/app_router.dart';
// import 'package:insured/app_2/core/services/location_service.dart';
// import 'package:insured/app_2/core/theme/app_theme.dart';
// import 'package:insured/app_2/core/utils/text_scale_provider.dart';
// import 'package:insured/app_2/core/utils/theme_provider.dart';
// import 'package:insured/app_2/core/widgets/custom_text.dart';
// import 'package:insured/app_2/l10n/app_localizations.dart';
// import 'package:insured/app_2/providers/settings_provider.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final prefs = await SharedPreferences.getInstance();
//   final rememberMe = prefs.getBool('remember_me') ?? false;
//   final lastRoute = prefs.getString('last_route') ?? '/onboarding';
//   final initialLocation = rememberMe ? lastRoute : '/onboarding';

//   runApp(
//     ProviderScope(
//       overrides: [initialLocationProvider.overrideWithValue(initialLocation)],
//       child: const InsuredApp(),
//     ),
//   );
// }

// // class InsuredApp extends ConsumerWidget {
// class InsuredApp extends ConsumerStatefulWidget {
//   const InsuredApp({super.key});

//   @override
//   ConsumerState<InsuredApp> createState() => _InsuredAppState();
// }

// class _InsuredAppState extends ConsumerState<InsuredApp> {
//   String? _pendingLanguage;
//   bool _hasPrompted = false;

//   @override
//   void initState() {
//     super.initState();
//     // _autoDetectLanguage();
//   }

//   // Future<void> _autoDetectLanguage_() async {
//   //   final settingsNotifier = ref.read(settingsProvider.notifier);
//   //   final currentLanguage = ref.read(settingsProvider).language;

//   //   final locationService = LocationService();
//   //   final detectedLang = await locationService.detectLanguageFromLocation();

//   //   if (detectedLang != null) {
//   //     String displayName;
//   //     switch (detectedLang) {
//   //       case 'sw':
//   //         displayName = 'Swahili';
//   //         break;
//   //       case 'fr':
//   //         displayName = 'French';
//   //         break;
//   //       case 'de':
//   //         displayName = 'German';
//   //         break;
//   //       case 'it':
//   //         displayName = 'Italian';
//   //         break;
//   //       default:
//   //         displayName = 'English';
//   //     }

//   //     // Only prompt if the detected language is different and we haven't already asked
//   //     if (displayName != currentLanguage && !_hasPrompted) {
//   //       setState(() {
//   //         _pendingLanguage = displayName;
//   //       });

//   //       // Wait for the first frame to have a valid context
//   //       WidgetsBinding.instance.addPostFrameCallback((_) {
//   //         if (_pendingLanguage != null) {
//   //           _showLanguagePrompt(context, displayName, settingsNotifier);
//   //           setState(() {
//   //             _hasPrompted = true;
//   //             _pendingLanguage = null;
//   //           });
//   //         }
//   //       });
//   //     }
//   //   }
//   // }

//   Locale _getLocale(String languageName) {
//     switch (languageName) {
//       case 'Swahili':
//         return const Locale('sw', 'KE');
//       case 'French':
//         return const Locale('fr', 'FR');
//       case 'German':
//         return const Locale('de', 'DE');
//       case 'Italian':
//         return const Locale('it', 'IT');
//       case 'Russian':
//         return const Locale('ru', 'RU');
//       case 'Chinese':
//         return const Locale('zh', 'CN');
//       case 'Arabic':
//         return const Locale('ar', 'AE');
//       case 'English':
//       default:
//         return const Locale('en', 'US');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final router = ref.watch(appRouterProvider);
//     final textScateProviderState = ref.watch(textScaleProvider);
//     final themeProviderState = ref.watch(themeProvider);
//     final settingsProviderState = ref.watch(settingsProvider);

//     ThemeMode mode = ThemeMode.system;
//     if (settingsProviderState.themeMode == 'Light') mode = ThemeMode.light;
//     if (settingsProviderState.themeMode == 'Dark') mode = ThemeMode.dark;

//     return MaterialApp.router(
//       title: 'Insured',
//       debugShowCheckedModeBanner: false,
//       // theme: AppTheme.darkTheme,
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       // themeMode: themeProviderState.themeMode,
//       themeMode: mode,

//       locale: _getLocale(settingsProviderState.language),
//       // -------------------------------
//       // !!!!!!!!!!!!!!!
//       localizationsDelegates: AppLocalizations.localizationsDelegates,
//       supportedLocales: AppLocalizations.supportedLocales,
//       // !!!!!!!!!!!!!
//       routerConfig: router,
//       builder: (context, child) => MediaQuery(
//         data: MediaQuery.of(context).copyWith(
//           textScaler: TextScaler.linear(textScateProviderState.textScaleFactor),
//         ),
//         child: child!,
//       ),
//     );
//   }
// }

// // // // // import 'package:flutter/material.dart';
// // // // // import 'package:model_viewer_plus/model_viewer_plus.dart';

// // // // // void main() => runApp(const MyApp());

// // // // // String js = '''
// // // // //   const modelViewer = document.querySelector('#change-speed-demo');
// // // // //   // const speeds = [10, 20, 100.5, -1];
// // // // //   const speeds = [1, 2, 0.5, -1];

// // // // //   let i = 0;
// // // // //   const play = () => {
// // // // //     modelViewer.timeScale = speeds[i++%speeds.length];
// // // // //     modelViewer.play({repetitions: 1});
// // // // //   };
// // // // //   modelViewer.addEventListener('load', play);
// // // // //   modelViewer.addEventListener('finished', play);

// // // // // ''';
// // // // // // <model-viewer camera-controls touch-action="pan-y" autoplay animation-name="Running" ar ar-modes="webxr scene-viewer" scale="0.2 0.2 0.2" shadow-intensity="1" src="../../shared-assets/models/RobotExpressive.glb" alt="An animate 3D model of a robot"></model-viewer>

// // // // // class MyApp extends StatelessWidget {
// // // // //   const MyApp({super.key});

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return MaterialApp(
// // // // //       home: Scaffold(
// // // // //         appBar: AppBar(title: const Text('Model Viewer')),

// // // // //         body: ModelViewer(
// // // // //           id: 'change-speed-demo',
// // // // //           autoRotate: true,
// // // // //           rotationPerSecond: "360deg",

// // // // //           // animationName: 'Dance',
// // // // //           animationName: 'Running',
// // // // //           ar: true,
// // // // //           shadowIntensity: 1,
// // // // //           src:
// // // // //               'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
// // // // //           alt: 'An animate 3D model of a robot',
// // // // //           backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
// // // // //           relatedJs: js,
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // import 'package:flutter/material.dart';
// // // // import 'package:model_viewer_plus/model_viewer_plus.dart';

// // // // void main() => runApp(const MyApp());

// // // // const String js = '''
// // // //   const modelViewer = document.querySelector('#change-speed-demo');
// // // //   const speeds = [1, 2, 0.5, -1]; // Animation speed cycles

// // // //   let i = 0;
// // // //   const play = () => {
// // // //     modelViewer.timeScale = speeds[i++ % speeds.length];
// // // //     modelViewer.play({repetitions: 1});
// // // //   };

// // // //   modelViewer.addEventListener('load', play);
// // // //   modelViewer.addEventListener('finished', play);
// // // // ''';

// // // // class MyApp extends StatelessWidget {
// // // //   const MyApp({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return MaterialApp(
// // // //       home: Scaffold(
// // // //         appBar: AppBar(title: const Text('Model Viewer')),

// // // //         body: Center(
// // // //           child: ModelViewer(
// // // //             id: 'change-speed-demo',
// // // //             src:
// // // //                 'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
// // // //             alt: 'An animate 3D model of a robot',
// // // //             autoRotate: true,
// // // //             rotationPerSecond: '360deg',
// // // //             animationName: 'Running',
// // // //             ar: true,
// // // //             arModes: const ['webxr', 'scene-viewer'],
// // // //             scale: '0.2 0.2 0.2',
// // // //             shadowIntensity: 1,
// // // //             backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
// // // //             relatedJs: js,
// // // //             cameraControls: true,
// // // //             touchAction: TouchAction.panY,
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // import 'package:flutter/material.dart';
// // // import 'package:model_viewer_plus/model_viewer_plus.dart';

// // // void main() => runApp(const MaterialApp(home: MyApp()));

// // // class MyApp extends StatefulWidget {
// // //   const MyApp({super.key});

// // //   @override
// // //   State<MyApp> createState() => _MyAppState();
// // // }

// // // class _MyAppState extends State<MyApp> {
// // //   // 1. This variable controls the rotation speed dynamically
// // //   String _rotationSpeed = "0deg";
// // //   bool _isBursting = false;

// // //   // 2. The logic for the 1-second burst
// // //   void _triggerRotationBurst() async {
// // //     if (_isBursting) return; // Prevent multiple clicks during the burst

// // //     setState(() {
// // //       _isBursting = true;
// // //       _rotationSpeed = "360deg"; // Start the spin
// // //     });

// // //     // Wait for exactly 1 second
// // //     await Future.delayed(const Duration(seconds: 3));

// // //     setState(() {
// // //       _rotationSpeed = "0deg"; // Stop the spin
// // //       _isBursting = false;
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('3D Speed Burst'),
// // //         backgroundColor: Colors.blueGrey,
// // //       ),
// // //       body: Stack(
// // //         children: [
// // //           ModelViewer(
// // //             id: 'change-speed-demo',
// // //             src:
// // //                 'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
// // //             alt: 'An animated 3D model of a robot',
// // //             autoRotate: true,
// // //             // 3. We link the property to our state variable here
// // //             rotationPerSecond: _rotationSpeed,
// // //             animationName: 'Running',
// // //             ar: true,
// // //             scale: '0.2 0.2 0.2',
// // //             shadowIntensity: 1,
// // //             backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
// // //             cameraControls: true,
// // //             touchAction: TouchAction.panY,
// // //           ),

// // //           // Instruction overlay
// // //           Positioned(
// // //             top: 20,
// // //             left: 20,
// // //             child: Text(
// // //               "Current Speed: $_rotationSpeed",
// // //               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //       // 4. The Button to trigger the effect
// // //       floatingActionButton: FloatingActionButton.extended(
// // //         onPressed: _triggerRotationBurst,
// // //         backgroundColor: _isBursting ? Colors.orange : Colors.blue,
// // //         label: Text(_isBursting ? "SPINNING!" : "Trigger 1s Burst"),
// // //         icon: const Icon(Icons.speed),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:model_viewer_plus/model_viewer_plus.dart';

// // void main() => runApp(const MaterialApp(home: MyApp()));

// // class MyApp extends StatefulWidget {
// //   const MyApp({super.key});

// //   @override
// //   State<MyApp> createState() => _MyAppState();
// // }

// // class _MyAppState extends State<MyApp> {
// //   // 1. This variable controls the rotation speed dynamically
// //   String _rotationSpeed = "900deg";
// //   bool _isBursting = false;

// //   // 2. The logic for the 1-second burst
// //   void _triggerRotationBurst() async {
// //     if (_isBursting) return; // Prevent multiple clicks during the burst

// //     setState(() {
// //       _isBursting = true;
// //       _rotationSpeed = "00deg"; // Start the spin
// //     });

// //     // Wait for exactly 1 second
// //     await Future.delayed(const Duration(seconds: 10));

// //     setState(() {
// //       _rotationSpeed = "900deg"; // Stop the spin
// //       _isBursting = false;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('3D Speed Burst'),
// //         backgroundColor: Colors.blueGrey,
// //       ),
// //       body: Stack(
// //         children: [
// //           ModelViewer(
// //             id: 'change-speed-demo',
// //             src:
// //                 'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
// //             alt: 'An animated 3D model of a robot',
// //             autoRotate: true,
// //             // 3. We link the property to our state variable here
// //             rotationPerSecond: _rotationSpeed,
// //             animationName: 'Running',
// //             ar: true,
// //             scale: '0.2 0.2 0.2',
// //             shadowIntensity: 1,
// //             backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
// //             cameraControls: true,
// //             touchAction: TouchAction.panY,
// //           ),

// //           // Instruction overlay
// //           Positioned(
// //             top: 20,
// //             left: 20,
// //             child: Text(
// //               "Current Speed: $_rotationSpeed",
// //               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //             ),
// //           ),
// //         ],
// //       ),
// //       // 4. The Button to trigger the effect
// //       floatingActionButton: FloatingActionButton.extended(
// //         onPressed: _triggerRotationBurst,
// //         backgroundColor: _isBursting ? Colors.orange : Colors.blue,
// //         label: Text(_isBursting ? "SPINNING!" : "Trigger 1s Burst"),
// //         icon: const Icon(Icons.speed),
// //       ),
// //     );
// //   }
// // }

// // // // // String js = '''
// // // // //   const modelViewer = document.querySelector('#change-speed-demo');
// // // // //   // const speeds = [10, 20, 100.5, -1];
// // // // //   const speeds = [1, 2, 0.5, -1];

// // // // //   let i = 0;
// // // // //   const play = () => {
// // // // //     modelViewer.timeScale = speeds[i++%speeds.length];
// // // // //     modelViewer.play({repetitions: 1});
// // // // //   };
// // // // //   modelViewer.addEventListener('load', play);
// // // // //   modelViewer.addEventListener('finished', play);

// // // // // ''';
// // // // // // <model-viewer camera-controls touch-action="pan-y" autoplay animation-name="Running" ar ar-modes="webxr scene-viewer" scale="0.2 0.2 0.2" shadow-intensity="1" src="../../shared-assets/models/RobotExpressive.glb" alt="An animate 3D model of a robot"></model-viewer>

// // // // // class MyApp extends StatelessWidget {
// // // // //   const MyApp({super.key});

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return MaterialApp(
// // // // //       home: Scaffold(
// // // // //         appBar: AppBar(title: const Text('Model Viewer')),

// // // // //         body: ModelViewer(
// // // // //           id: 'change-speed-demo',
// // // // //           autoRotate: true,
// // // // //           rotationPerSecond: "360deg",

// // // // //           // animationName: 'Dance',
// // // // //           animationName: 'Running',
// // // // //           ar: true,
// // // // //           shadowIntensity: 1,
// // // // //           src:
// // // // //               'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
// // // // //           alt: 'An animate 3D model of a robot',
// // // // //           backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
// // // // //           relatedJs: js,
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }

// // // // import 'package:flutter/material.dart';
// // // // import 'package:model_viewer_plus/model_viewer_plus.dart';

// // // // void main() => runApp(const MyApp());

// // // // const String js = '''
// // // //   const modelViewer = document.querySelector('#change-speed-demo');
// // // //   const speeds = [1, 2, 0.5, -1]; // Animation speed cycles

// // // //   let i = 0;
// // // //   const play = () => {
// // // //     modelViewer.timeScale = speeds[i++ % speeds.length];
// // // //     modelViewer.play({repetitions: 1});
// // // //   };

// // // //   modelViewer.addEventListener('load', play);
// // // //   modelViewer.addEventListener('finished', play);
// // // // ''';

// // // // class MyApp extends StatelessWidget {
// // // //   const MyApp({super.key});

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return MaterialApp(
// // // //       home: Scaffold(
// // // //         appBar: AppBar(title: const Text('Model Viewer')),

// // // //         body: Center(
// // // //           child: ModelViewer(
// // // //             id: 'change-speed-demo',
// // // //             src:
// // // //                 'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
// // // //             alt: 'An animate 3D model of a robot',
// // // //             autoRotate: true,
// // // //             rotationPerSecond: '360deg',
// // // //             animationName: 'Running',
// // // //             ar: true,
// // // //             arModes: const ['webxr', 'scene-viewer'],
// // // //             scale: '0.2 0.2 0.2',
// // // //             shadowIntensity: 1,
// // // //             backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
// // // //             relatedJs: js,
// // // //             cameraControls: true,
// // // //             touchAction: TouchAction.panY,
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// // // import 'package:flutter/material.dart';
// // // import 'package:model_viewer_plus/model_viewer_plus.dart';

// // // void main() => runApp(const MaterialApp(home: MyApp()));

// // // class MyApp extends StatefulWidget {
// // //   const MyApp({super.key});

// // //   @override
// // //   State<MyApp> createState() => _MyAppState();
// // // }

// // // class _MyAppState extends State<MyApp> {
// // //   // 1. This variable controls the rotation speed dynamically
// // //   String _rotationSpeed = "0deg";
// // //   bool _isBursting = false;

// // //   // 2. The logic for the 1-second burst
// // //   void _triggerRotationBurst() async {
// // //     if (_isBursting) return; // Prevent multiple clicks during the burst

// // //     setState(() {
// // //       _isBursting = true;
// // //       _rotationSpeed = "360deg"; // Start the spin
// // //     });

// // //     // Wait for exactly 1 second
// // //     await Future.delayed(const Duration(seconds: 3));

// // //     setState(() {
// // //       _rotationSpeed = "0deg"; // Stop the spin
// // //       _isBursting = false;
// // //     });
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('3D Speed Burst'),
// // //         backgroundColor: Colors.blueGrey,
// // //       ),
// // //       body: Stack(
// // //         children: [
// // //           ModelViewer(
// // //             id: 'change-speed-demo',
// // //             src:
// // //                 'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
// // //             alt: 'An animated 3D model of a robot',
// // //             autoRotate: true,
// // //             // 3. We link the property to our state variable here
// // //             rotationPerSecond: _rotationSpeed,
// // //             animationName: 'Running',
// // //             ar: true,
// // //             scale: '0.2 0.2 0.2',
// // //             shadowIntensity: 1,
// // //             backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
// // //             cameraControls: true,
// // //             touchAction: TouchAction.panY,
// // //           ),

// // //           // Instruction overlay
// // //           Positioned(
// // //             top: 20,
// // //             left: 20,
// // //             child: Text(
// // //               "Current Speed: $_rotationSpeed",
// // //               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //       // 4. The Button to trigger the effect
// // //       floatingActionButton: FloatingActionButton.extended(
// // //         onPressed: _triggerRotationBurst,
// // //         backgroundColor: _isBursting ? Colors.orange : Colors.blue,
// // //         label: Text(_isBursting ? "SPINNING!" : "Trigger 1s Burst"),
// // //         icon: const Icon(Icons.speed),
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:model_viewer_plus/model_viewer_plus.dart';

// // void main() => runApp(const MaterialApp(home: MyApp()));

// // class MyApp extends StatefulWidget {
// //   const MyApp({super.key});

// //   @override
// //   State<MyApp> createState() => _MyAppState();
// // }

// // class _MyAppState extends State<MyApp> {
// //   // 1. This variable controls the rotation speed dynamically
// //   String _rotationSpeed = "900deg";
// //   bool _isBursting = false;

// //   // 2. The logic for the 1-second burst
// //   void _triggerRotationBurst() async {
// //     if (_isBursting) return; // Prevent multiple clicks during the burst

// //     setState(() {
// //       _isBursting = true;
// //       _rotationSpeed = "00deg"; // Start the spin
// //     });

// //     // Wait for exactly 1 second
// //     await Future.delayed(const Duration(seconds: 10));

// //     setState(() {
// //       _rotationSpeed = "900deg"; // Stop the spin
// //       _isBursting = false;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('3D Speed Burst'),
// //         backgroundColor: Colors.blueGrey,
// //       ),
// //       body: Stack(
// //         children: [
// //           ModelViewer(
// //             id: 'change-speed-demo',
// //             src:
// //                 'https://modelviewer.dev/shared-assets/models/RobotExpressive.glb',
// //             alt: 'An animated 3D model of a robot',
// //             autoRotate: true,
// //             // 3. We link the property to our state variable here
// //             rotationPerSecond: _rotationSpeed,
// //             animationName: 'Running',
// //             ar: true,
// //             scale: '0.2 0.2 0.2',
// //             shadowIntensity: 1,
// //             backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
// //             cameraControls: true,
// //             touchAction: TouchAction.panY,
// //           ),

// //           // Instruction overlay
// //           Positioned(
// //             top: 20,
// //             left: 20,
// //             child: Text(
// //               "Current Speed: $_rotationSpeed",
// //               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //             ),
// //           ),
// //         ],
// //       ),
// //       // 4. The Button to trigger the effect
// //       floatingActionButton: FloatingActionButton.extended(
// //         onPressed: _triggerRotationBurst,
// //         backgroundColor: _isBursting ? Colors.orange : Colors.blue,
// //         label: Text(_isBursting ? "SPINNING!" : "Trigger 1s Burst"),
// //         icon: const Icon(Icons.speed),
// //       ),
// //     );
// //   }
// // }
