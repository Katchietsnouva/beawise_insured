// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:insured/app_2/data/models/client_model.dart';
// // import 'package:insured/app_2/data/repositories/client_repository.dart';

// // final clientRepositoryProvider = Provider<ClientRepository>((ref) {
// //   return ClientRepository();
// // });

// // final clientsProvider = FutureProvider<List<Client>>((ref) async {
// //   final repo = ref.watch(clientRepositoryProvider);
// //   return repo.getClients();
// // });

// // final clientDetailProvider = FutureProvider.family<Client?, String>((
// //   ref,
// //   clientId,
// // ) async {
// //   final repo = ref.watch(clientRepositoryProvider);
// //   final clients = await repo.getClients();
// //   return clients.firstWhere((c) => c.id == clientId);
// // });

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:insured/app_2/core/services/api_auth_provider.dart';
// import 'package:insured/app_2/data/models/client_model.dart';
// import 'package:insured/app_2/core/services/api_service.dart';
// import 'package:insured/app_2/providers/auth_provider.dart';

// final clientsProvider = FutureProvider<List<Client>>((ref) async {
//   final authState = ref.watch(authProvider);
//   if (authState.user == null || authState.authToken == null) {
//     throw Exception('Not authenticated');
//   }

//   final token = await ref.read(apiAuthProvider.notifier).getAuthToken();
//   final response = await ApiService.getClients(
//     agentCode: authState.user!.agentCode,
//     agentKey: authState.user!.agentKey,
//     // token: authState.authToken!,
//     token: token,
//   );

//   // Parse response – adjust based on actual API structure
//   if (response['status'] == 1 || response['status'] == 'success') {
//     final data = response['clients'] ?? response['data'] ?? [];
//     return (data as List)
//         .map((json) => Client.fromJson(json as Map<String, dynamic>))
//         .toList();
//   } else {
//     throw Exception(response['message'] ?? 'Failed to load clients');
//   }
// });

// lib/app_2/providers/client_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/api_auth_provider.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

final clientsProvider = FutureProvider<List<Client>>((ref) async {
  final authState = ref.watch(authProvider);
  final user = authState.user;

  // 1. Check if user is logged in
  if (user == null) {
    throw Exception('User session not found. Please log in.');
  }

  try {
    print('📡 Fetching fresh token for client list...');
    // 2. Fetch the token ACTIVELY (just like you do in AddClientScreen)
    final token = await ref.read(apiAuthProvider.notifier).getAuthToken();

    print('📡 Fetching clients with token: ${authState.bearerToken}');
    print(
      '👤 Agent code: ${authState.user!.agentCode}, key: ${authState.user!.agentKey}',
    );

    print('👤 Agent: ${user.agentCode}, Fetching list...');

    final response = await ApiService.getClients(
      agentCode: user.agentCode,
      agentKey: user.agentKey,
      token: token,
    );

    print('📦 Clients API response: $response');

    if (response['status'] == 1 || response['status'] == 'success') {
      final data = response['clients'] ?? response['data'] ?? [];
      if (data is List) {
        return data
            .map((json) => Client.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Unexpected data format');
      }
    } else {
      throw Exception(response['message'] ?? 'Failed to load clients');
    }
  } catch (e) {
    print('❌ clientsProvider Error: $e');
    // If it's a 401 or auth error, this will be caught here
    throw Exception('Failed to fetch clients: $e');
  }

  // // final authState = ref.read(authProvider);
  // final user = authState.user;

  // if (authState.user == null) {
  //   throw Exception('User not authenticated');
  // }
  // if (authState.authToken == null) {
  //   throw Exception('Authentication token missing. Please log in again.');
  // }

  // // final user = authState.user!;

  // final response = await ApiService.getClients(
  //   // agentCode: authState.user!.agentCode,
  //   // agentKey: authState.user!.agentKey,
  //   agentCode: user!.agentCode,
  //   agentKey: user.agentKey,
  //   token: authState.authToken!,
  // );

  // print('📦 Clients API response: $response');

  // // Adjust parsing to match your actual API structure
  // if (response['status'] == 1 || response['status'] == 'success') {
  //   final data = response['clients'] ?? response['data'] ?? [];
  //   if (data is List) {
  //     return data
  //         .map((json) => Client.fromJson(json as Map<String, dynamic>))
  //         .toList();
  //   } else {
  //     throw Exception('Unexpected data format');
  //   }
  // } else {
  //   throw Exception(response['message'] ?? 'Failed to load clients');
  // }
});
