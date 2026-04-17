import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

// Provider for insurers list with caching (5 minutes)
// final insurersProvider = FutureProvider<List<dynamic>>((ref) async {
//   final cache = ref.read(memoryCacheProvider);
//   final cached = cache.get<List>('insurers');
//   if (cached != null) {
//     print('✅ Using cached insurers');
//     return cached;
//   }

//   final authState = ref.read(authProvider);
//   final token = authState.bearerToken;
//   if (token == null) throw Exception('Not authenticated');

//   final response = await ApiService.getInsurers(token: token);
//   // Adjust based on actual API response structure
//   final List<dynamic> insurers = response['data'] ?? response['insurers'] ?? [];

//   // Cache for 5 minutes
//   cache.set('insurers', insurers, duration: const Duration(minutes: 5));
//   return insurers;
// });

// // Provider for DMVIC Double Insurance result
// final dmvicDoubleInsuranceResultProvider =
//     StateProvider<AsyncValue<Map<String, dynamic>>?>((ref) => null);

// // Provider for DMVIC Stock result
// final dmvicStockResultProvider =
//     StateProvider<AsyncValue<Map<String, dynamic>>?>((ref) => null);

// Provider for insurers list with simple caching (no expiry)
final insurersProvider = FutureProvider<List<dynamic>>((ref) async {
  final cache = ref.read(memoryCacheProvider);
  // Check if we have cached data
  if (cache.containsKey('insurers')) {
    // final cached = cache.get<List<dynamic>>('insurers');
    final cached = cache.get('insurers');
    // _companyCtrl = TextEditingController(text: cache.get('company') ?? '');

    if (cached != null) {
      print('✅ Using cached insurers');
      return cached;
    }
  }

  final authState = ref.read(authProvider);
  final token = authState.bearerToken;
  if (token == null) throw Exception('Not authenticated');

  final response = await ApiService.getInsurers(
    token: token);
  // Adjust based on actual API response structure
  final List<dynamic> insurers = response['data'] ?? response['insurers'] ?? [];

  // final validInsurers = insurers.where((insurer) => insurer['dmvic_id'] != 0).toList();

  // print('📦 Fetched insurers: ${validInsurers.length} items');

  // Store in cache
  cache.put('insurers', insurers);
  return insurers;
});

// Providers for results (keep these as they are)
final dmvicDoubleInsuranceResultProvider =
    StateProvider<AsyncValue<Map<String, dynamic>>?>((ref) => null);

final dmvicStockResultProvider =
    StateProvider<AsyncValue<Map<String, dynamic>>?>((ref) => null);
