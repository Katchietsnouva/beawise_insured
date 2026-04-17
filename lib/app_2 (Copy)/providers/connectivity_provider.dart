import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/connectivity_service.dart';

final connectivityServiceProvider = Provider((ref) => ConnectivityService());

final connectivityStreamProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityServiceProvider).connectivityStream;
});
