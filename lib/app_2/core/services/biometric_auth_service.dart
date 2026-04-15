// // import 'dart:io' show Platform;
// // import 'package:flutter/services.dart';
// // import 'package:local_auth/local_auth.dart';
// // import 'package:flutter_biometric_auth_plus/flutter_biometric_auth_plus.dart'
// //     as bio_plus;

// // class BiometricAuthService {
// //   // For mobile – using local_auth
// //   static final LocalAuthentication _localAuth = LocalAuthentication();

// //   /// Checks if biometric authentication is available on this device.
// //   static Future<bool> isBiometricAvailable() async {
// //     // Use platform‑specific package
// //     if (Platform.isAndroid || Platform.isIOS) {
// //       try {
// //         final bool canAuthenticateWithBiometrics =
// //             await _localAuth.canCheckBiometrics;
// //         final bool canAuthenticate =
// //             canAuthenticateWithBiometrics ||
// //             await _localAuth.isDeviceSupported();
// //         return canAuthenticate;
// //       } catch (e) {
// //         return false;
// //       }
// //     } else {
// //       // Web / desktop
// //       try {
// //         return await bio_plus.FlutterBiometricAuthPlus.isBiometricAvailable();
// //       } catch (e) {
// //         return false;
// //       }
// //     }
// //   }

// //   /// Returns list of available biometric types (for UI hints).
// //   static Future<List<BiometricType>> getAvailableBiometrics() async {
// //     if (Platform.isAndroid || Platform.isIOS) {
// //       try {
// //         return await _localAuth.getAvailableBiometrics();
// //       } catch (e) {
// //         return [];
// //       }
// //     } else {
// //       // The plus package doesn't expose types; return empty or simulate.
// //       return [];
// //     }
// //   }

// //   /// Authenticate the user.
// //   /// Returns `true` if authentication succeeded, `false` otherwise.
// //   static Future<bool> authenticate({
// //     String reason = 'Please authenticate to enable 2FA',
// //   }) async {
// //     if (Platform.isAndroid || Platform.isIOS) {
// //       try {
// //         final bool didAuthenticate = await _localAuth.authenticate(
// //           localizedReason: reason,
// //           options: const AuthenticationOptions(
// //             biometricOnly: false, // allow device PIN/pattern as fallback
// //             stickyAuth: true,
// //           ),
// //         );
// //         return didAuthenticate;
// //       } on PlatformException catch (e) {
// //         print('Auth error: $e');
// //         return false;
// //       }
// //     } else {
// //       // Web / desktop
// //       try {
// //         final result = await bio_plus.FlutterBiometricAuthPlus.authenticate(
// //           promptConfig: bio_plus.PromptConfig(
// //             title: '2FA Required',
// //             subtitle: reason,
// //           ),
// //         );
// //         return result.isSuccess;
// //       } catch (e) {
// //         print('Auth error: $e');
// //         return false;
// //       }
// //     }
// //   }
// // }

// import 'dart:io' show Platform;
// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:flutter_biometric_auth_plus/flutter_biometric_auth_plus.dart'
//     as bio_plus;

// class BiometricAuthService {
//   static final LocalAuthentication _localAuth = LocalAuthentication();

//   /// Checks if biometric authentication is available.
//   static Future<bool> isBiometricAvailable() async {
//     if (Platform.isAndroid || Platform.isIOS) {
//       try {
//         final bool canAuthenticateWithBiometrics =
//             await _localAuth.canCheckBiometrics;
//         final bool canAuthenticate =
//             canAuthenticateWithBiometrics ||
//             await _localAuth.isDeviceSupported();
//         return canAuthenticate;
//       } catch (e) {
//         return false;
//       }
//     } else {
//       // Web / desktop
//       try {
//         return await bio_plus.BiometricAuthPlus.isBiometricAvailable();
//       } catch (e) {
//         return false;
//       }
//     }
//   }

//   /// Returns list of available biometric types (mobile only).
//   static Future<List<BiometricType>> getAvailableBiometrics() async {
//     if (Platform.isAndroid || Platform.isIOS) {
//       try {
//         return await _localAuth.getAvailableBiometrics();
//       } catch (e) {
//         return [];
//       }
//     }
//     return [];
//   }

//   /// Authenticate the user.
//   /// Returns `true` if authentication succeeded.
//   static Future<bool> authenticate({
//     String reason = 'Please authenticate to enable 2FA',
//   }) async {
//     if (Platform.isAndroid || Platform.isIOS) {
//       try {
//         final bool didAuthenticate = await _localAuth.authenticate(
//           localizedReason: reason,
//           options: AuthenticationOptions(
//             biometricOnly: false, // allow device PIN/pattern as fallback
//             stickyAuth: true,
//           ), // 👈 no `const` here
//         );
//         return didAuthenticate;
//       } on PlatformException catch (e) {
//         print('Auth error: $e');
//         return false;
//       }
//     } else {
//       // Web / desktop
//       try {
//         final result = await bio_plus.BiometricAuthPlus.authenticate(
//           promptConfig: bio_plus.PromptConfig(
//             title: '2FA Required',
//             subtitle: reason,
//           ),
//         );
//         return result.isSuccess;
//       } catch (e) {
//         print('Auth error: $e');
//         return false;
//       }
//     }
//   }
// }

import 'package:flutter/foundation.dart'; // For kIsWeb
// import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:flutter_biometric_auth_plus/flutter_biometric_auth_plus.dart'
//     as bio_plus;

class BiometricAuthService {
  // // For mobile – using local_auth
  // static final LocalAuthentication _localAuth = LocalAuthentication();

  static final LocalAuthentication _auth = LocalAuthentication();

  // /// Checks if biometric authentication is available on this device.
  // static Future<bool> isBiometricAvailable() async {
  //   // Use platform‑specific package
  //   if (Platform.isAndroid || Platform.isIOS) {
  //     try {
  //       final bool canAuthenticateWithBiometrics =
  //           await _localAuth.canCheckBiometrics;
  //       final bool canAuthenticate =
  //           canAuthenticateWithBiometrics ||
  //           await _localAuth.isDeviceSupported();
  //       return canAuthenticate;
  //     } catch (e) {
  //       return false;
  //     }
  //   } else {
  //     // Web / desktop
  //     try {
  //       return await bio_plus.FlutterBiometricAuthPlus.isBiometricAvailable();
  //     } catch (e) {
  //       return false;
  //     }
  //   }
  // }

  /// Checks if the hardware supports biometrics or device PIN
  static Future<bool> isBiometricAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } catch (e) {
      debugPrint('Error checking availability: $e');
      return false;
    }
  }

  // /// Returns list of available biometric types (for UI hints).
  // static Future<List<BiometricType>> getAvailableBiometrics() async {
  //   if (Platform.isAndroid || Platform.isIOS) {
  //     try {
  //       return await _localAuth.getAvailableBiometrics();
  //     } catch (e) {
  //       return [];
  //     }
  //   } else {
  //     // The plus package doesn't expose types; return empty or simulate.
  //     return [];
  //   }
  // }

  // /// Authenticate the user.
  // /// Returns `true` if authentication succeeded, `false` otherwise.
  // static Future<bool> authenticate({
  //   String reason = 'Please authenticate to enable 2FA',
  // }) async {
  //   if (Platform.isAndroid || Platform.isIOS) {
  //     try {
  //       final bool didAuthenticate = await _localAuth.authenticate(
  //         localizedReason: reason,
  //         options: const AuthenticationOptions(
  //           biometricOnly: false, // allow device PIN/pattern as fallback
  //           stickyAuth: true,
  //         ),
  //       );
  //       return didAuthenticate;
  //     } on PlatformException catch (e) {
  //       print('Auth error: $e');
  //       return false;
  //     }
  //   } else {
  //     // Web / desktop
  //     try {
  //       final result = await bio_plus.FlutterBiometricAuthPlus.authenticate(
  //         promptConfig: bio_plus.PromptConfig(
  //           title: '2FA Required',
  //           subtitle: reason,
  //         ),
  //       );
  //       return result.isSuccess;
  //     } catch (e) {
  //       print('Auth error: $e');
  //       return false;
  //     }
  //   }
  // }

  /// The main auth method - Works on Mobile, Web, and Desktop
  static Future<bool> authenticate({
    String reason = 'Please authenticate to proceed',
  }) async {
    try {
      // return await _auth.authenticate(
      //   localizedReason: reason,
      //   options: const AuthenticationOptions(
      //     stickyAuth: true,
      //     biometricOnly: false, // Allows PIN/Pattern/Windows Hello fallback
      //   ),
      // );
      // In the version you are using, parameters are passed directly
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false, // allow device PIN/pattern as fallback
        // Note: 'stickyAuth' and 'options' are removed because they
        // aren't in the version your IDE is showing.
      );
    } on PlatformException catch (e) {
      debugPrint('Auth error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      debugPrint('General auth error: $e');
      return false;
    }
  }
}
