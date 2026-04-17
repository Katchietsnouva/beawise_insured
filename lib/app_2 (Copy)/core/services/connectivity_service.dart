// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final connectivityProvider = Provider<ConnectivityService>((ref) {
//   return ConnectivityService();
// });

// class ConnectivityService {
//   final Connectivity _connectivity = Connectivity();

//   // Stream of connectivity changes
//   Stream<List<ConnectivityResult>> get onConnectivityChanged =>
//       _connectivity.onConnectivityChanged;

//   // Check current connectivity
//   Future<bool> hasInternet() async {
//     final result = await _connectivity.checkConnectivity();
//     return result != ConnectivityResult.none;
//   }
// }

// // Provider for current connectivity status
// final internetStatusProvider = StreamProvider<bool>((ref) {
//   final service = ref.watch(connectivityProvider);
//   // Map the list of results to a single boolean: true if NOT none
//   return service.onConnectivityChanged.map(
//     (results) => !results.contains(ConnectivityResult.none),
//   );
// });

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  // Stream that returns true if online, false if offline
  Stream<bool> get connectivityStream => _connectivity.onConnectivityChanged
      .map((List<ConnectivityResult> results) {
        // connectivity_plus returns a list in newer versions
        return !results.contains(ConnectivityResult.none);
      });

  Future<bool> isConnected() async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }
}
