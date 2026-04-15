import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

final clientSearchProvider =
    StateNotifierProvider<ClientSearchNotifier, AsyncValue<List<Client>>>((
      ref,
    ) {
      return ClientSearchNotifier(ref);
    });

class ClientSearchNotifier extends StateNotifier<AsyncValue<List<Client>>> {
  final Ref ref;
  Timer? _debounce;

  ClientSearchNotifier(this.ref) : super(const AsyncValue.data([]));

  void search(String query) {
    _debounce?.cancel();
    if (query.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      state = const AsyncValue.loading();
      try {
        final authState = ref.read(authProvider);
        final user = authState.user;
        final token = authState.bearerToken;
        if (user == null || token == null) throw Exception('Not authenticated');

        final response = await ApiService.getClients(
          agentCode: user.agentCode,
          agentKey: user.agentKey,
          token: token,
          page: 1,
          perPage: 100,
          search: query,
        );

        if (response['status'] == 'success' || response['status'] == 1) {
          final clientsData = response['clients'] ?? response['data'] ?? [];
          final allClients = clientsData is List
              ? clientsData
                    .map(
                      (json) => Client.fromJson(json as Map<String, dynamic>),
                    )
                    .toList()
              : <Client>[];

          final q = query.toLowerCase();
          final filtered = allClients
              .where(
                (c) =>
                    c.name.toLowerCase().contains(q) ||
                    c.client_no.toLowerCase().contains(q) ||
                    c.email.toLowerCase().contains(q) ||
                    c.mobile.toLowerCase().contains(q),
              )
              .toList();

          state = AsyncValue.data(filtered);
          print(
            "this this is the search result: ${filtered.length} items for query: '$query'",
          );
        } else {
          state = AsyncValue.error('Search failed', StackTrace.current);
        }
      } catch (e, stack) {
        state = AsyncValue.error(e.toString(), stack);
      }
    });
  }

  void clear() {
    _debounce?.cancel();
    state = const AsyncValue.data([]);
  }
}
