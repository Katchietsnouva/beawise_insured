import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

/// Fields the filter dialog can toggle to narrow the display.
const kClientSearchFields = ['name', 'phone', 'email'];

/// Human-readable labels for the filter fields.
const kClientSearchFieldLabels = {
  'name': 'Name',
  'phone': 'Phone',
  'email': 'Email',
};

/// No fields enabled by default: we show everything the server returns and
/// only narrow when the user explicitly enables a field. See
/// [ClientSearchNotifier._applyFieldFilters] for the semantics.
final clientSearchFieldsProvider = StateProvider<Set<String>>((ref) => {});

/// Comma-separated labels of the active narrowing filters (e.g. "Name, Phone"),
/// or `null` when no narrowing is in effect — i.e. no fields, or all of them,
/// are enabled, in which case the server results are shown untouched.
String? activeClientFilterLabel(Set<String> fields) {
  if (fields.isEmpty || fields.length == kClientSearchFields.length) {
    return null;
  }
  return kClientSearchFields
      .where(fields.contains)
      .map((f) => kClientSearchFieldLabels[f]!)
      .join(', ');
}

class ClientSearchState {
  final String query;
  final AsyncValue<List<Client>> results;

  const ClientSearchState({
    this.query = '',
    this.results = const AsyncValue.data([]),
  });

  /// True while the user has an active search query.
  bool get isActive => query.isNotEmpty;

  ClientSearchState copyWith({
    String? query,
    AsyncValue<List<Client>>? results,
  }) {
    return ClientSearchState(
      query: query ?? this.query,
      results: results ?? this.results,
    );
  }
}

final clientSearchProvider =
    StateNotifierProvider<ClientSearchNotifier, ClientSearchState>((ref) {
      return ClientSearchNotifier(ref);
    });

class ClientSearchNotifier extends StateNotifier<ClientSearchState> {
  final Ref ref;
  Timer? _debounce;

  ClientSearchNotifier(this.ref) : super(const ClientSearchState());

  void search(String query) {
    _debounce?.cancel();
    final q = query.trim();
    if (q.isEmpty) {
      state = const ClientSearchState();
      return;
    }
    state = ClientSearchState(query: q, results: const AsyncValue.loading());
    _debounce = Timer(const Duration(milliseconds: 500), () => _run(q));
  }

  /// Re-run the current query (e.g. after the filter fields changed).
  void refresh() {
    if (state.isActive) _run(state.query);
  }

  Future<void> _run(String query) async {
    try {
      final authState = ref.read(authProvider);
      final user = authState.user;
      final token = authState.bearerToken;
      if (user == null || token == null) throw Exception('Not authenticated');

      final response = await ApiService.searchClients(
        agentCode: user.agentCode,
        agentKey: user.agentKey,
        token: token,
        query: query,
      );

      // Ignore stale responses (query changed or cleared while in flight)
      if (!mounted || query != state.query) return;

      if (response['status'] == 'success' || response['status'] == 1) {
        final clientsData = response['clients'] ?? response['data'] ?? [];
        final clients = clientsData is List
            ? clientsData
                  .map((json) => Client.fromJson(json as Map<String, dynamic>))
                  .toList()
            : <Client>[];

        final filtered = _applyFieldFilters(clients, query);
        state = state.copyWith(results: AsyncValue.data(filtered));
        print(
          "this this is the search result: ${filtered.length} items for query: '$query'",
        );
      } else {
        state = state.copyWith(
          results: AsyncValue.error(
            response['message'] ?? 'Search failed',
            StackTrace.current,
          ),
        );
      }
    } catch (e, stack) {
      if (!mounted || query != state.query) return;
      state = state.copyWith(results: AsyncValue.error(e, stack));
    }
  }

  /// By default (no fields enabled, or all of them) we display exactly what
  /// the server returns — so any match the backend makes, including on fields
  /// we don't know about here, still shows up. Only a partial selection
  /// narrows the display, keeping just the rows whose query matches one of the
  /// enabled fields.
  List<Client> _applyFieldFilters(List<Client> clients, String query) {
    final fields = ref.read(clientSearchFieldsProvider);
    if (fields.isEmpty || fields.length == kClientSearchFields.length) {
      return clients;
    }
    final q = query.toLowerCase();
    return clients.where((c) {
      final byName =
          fields.contains('name') && c.name.toLowerCase().contains(q);
      final byPhone =
          fields.contains('phone') && c.mobile.toLowerCase().contains(q);
      final byEmail =
          fields.contains('email') && c.email.toLowerCase().contains(q);
      return byName || byPhone || byEmail;
    }).toList();
  }

  void clear() {
    _debounce?.cancel();
    state = const ClientSearchState();
  }
}
