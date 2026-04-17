// lib/app_2/providers/client_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/api_auth_provider.dart';
import 'package:insured/app_2/core/services/notification_service.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

final clientsProvider = FutureProvider<List<Client>>((ref) async {
  final stopwatch = Stopwatch()..start();
  final authState = ref.watch(authProvider);
  final user = authState.user;

  if (user == null) {
    throw Exception('User session not found. Please log in.');
  }

  try {
    print('📡 Fetching fresh token for client list...');
    // final token = await ref.read(apiAuthProvider.notifier).getAuthToken();
    final token = await ApiService.getAuthToken();
    final token_1 = authState.bearerToken;

    print(
      '📡 Fetching clients with token: ${token}, more on token_1: ${token_1} ',
    );
    print(
      '👤 Agent code: ${authState.user!.agentCode}, key: ${authState.user!.agentKey}. Fetching list...',
    );

    if (token_1 == null) {
      // return;
      throw Exception('User not authenticated');
    }

    final response = await ApiService.getClients(
      agentCode: user.agentCode,
      agentKey: user.agentKey,
      token: token_1,
    );

    print('📦 Clients API response: $response');

    if (response['status'] == 1 || response['status'] == 'success') {
      stopwatch.stop();
      NotificationService.addLog(
        endpoint: 'fetching clients version A',
        status: 'success',
        durationMs: stopwatch.elapsedMilliseconds,
        message: 'Clients Fetched successful. ',
      );

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
    stopwatch.stop();
    NotificationService.addLog(
      endpoint: 'fetching clients version A',
      status: 'error',
      durationMs: stopwatch.elapsedMilliseconds,
      message: 'Clients Fetched failed. ',
    );
    print('❌ clientsProvider Error: $e');
    throw Exception('Failed to fetch clients: $e');
  }
});


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