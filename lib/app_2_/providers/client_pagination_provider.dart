import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/core/services/notification_service.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:insured/app_2/providers/client_search_provider.dart';

class ClientsPaginationState {
  final bool isLoading;
  final int currentPage;
  final int perPage;
  final int totalClients;
  final int lastPage;
  final List<Client> currentPageClients;
  final Map<int, List<Client>> cachedPages;
  final Set<int> loadingPages;
  final String? searchQuery;
  final Map<String, dynamic> filters;
  final String? error;
  final bool hasMore;

  ClientsPaginationState({
    this.isLoading = false,
    this.currentPage = 1,
    this.perPage = 10,
    this.totalClients = 0,
    this.lastPage = 1,
    this.currentPageClients = const [],
    this.cachedPages = const {},
    this.loadingPages = const {},
    this.searchQuery,
    this.filters = const {},
    this.error,
    this.hasMore = false,
  });

  ClientsPaginationState copyWith({
    bool? isLoading,
    int? currentPage,
    int? perPage,
    int? totalClients,
    int? lastPage,
    List<Client>? currentPageClients,
    Map<int, List<Client>>? cachedPages,
    Set<int>? loadingPages,
    String? searchQuery,
    Map<String, dynamic>? filters,
    String? error,
    bool? hasMore,
  }) {
    return ClientsPaginationState(
      isLoading: isLoading ?? this.isLoading,
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      totalClients: totalClients ?? this.totalClients,
      lastPage: lastPage ?? this.lastPage,
      currentPageClients: currentPageClients ?? this.currentPageClients,
      cachedPages: cachedPages ?? this.cachedPages,
      loadingPages: loadingPages ?? this.loadingPages,
      searchQuery: searchQuery ?? this.searchQuery,
      filters: filters ?? this.filters,
      error: error ?? this.error,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class ClientsPaginationNotifier extends StateNotifier<ClientsPaginationState> {
  final Ref ref;

  ClientsPaginationNotifier(this.ref) : super(ClientsPaginationState());

  Future<void> fetchPage(int page, {BuildContext? context}) async {
    final stopwatch = Stopwatch()..start();

    if (state.cachedPages.containsKey(page)) {
      state = state.copyWith(
        currentPage: page,
        currentPageClients: state.cachedPages[page]!,
        isLoading: false,
      );
      return;
    }

    if (state.loadingPages.contains(page)) return;

    state = state.copyWith(
      loadingPages: {...state.loadingPages, page},
      isLoading: true,
      error: null,
    );

    try {
      final authState = ref.read(authProvider);
      final user = authState.user;
      final token = authState.bearerToken;

      if (user == null || token == null) {
        throw Exception('User not authenticated');
      }

      final response = await ApiService.getClients(
        agentCode: user.agentCode,
        agentKey: user.agentKey,
        token: token,
        page: page,
        perPage: state.perPage,
        // search: state.searchQuery,
      );

      if (response['status'] == 1 || response['status'] == 'success') {
        stopwatch.stop();
        NotificationService.addLog(
          endpoint: 'fetching clients',
          status: 'success',
          durationMs: stopwatch.elapsedMilliseconds,
          message: 'Clients Fetched successful. ',
        );

        final clientsData = response['clients'] ?? response['data'] ?? [];
        final clients = clientsData is List
            ? clientsData
                  .map((json) => Client.fromJson(json as Map<String, dynamic>))
                  .toList()
            : <Client>[];

        final paginationData = response['pagination'] ?? {};
        final total = paginationData['total'] ?? clients.length;
        final lastPage = paginationData['last_page'] ?? 1;
        final hasMore = paginationData['has_more'] ?? (page < lastPage);

        final newCache = Map<int, List<Client>>.from(state.cachedPages);
        newCache[page] = clients;

        state = state.copyWith(
          currentPage: page,
          perPage: state.perPage,
          totalClients: total,
          lastPage: lastPage,
          currentPageClients: clients,
          cachedPages: newCache,
          loadingPages: {...state.loadingPages}..remove(page),
          hasMore: hasMore,
          isLoading: false,
          error: null,
        );
      } else {
        stopwatch.stop();
        NotificationService.addLog(
          endpoint: 'fetching clients',
          status: 'error',
          durationMs: stopwatch.elapsedMilliseconds,
          message: 'Clients Fetched failed. ',
        );
        // FuturisticToastT.show(
        //   context: context,
        //   message: 'Required fields: fill fields for email and password',
        //   errors: response['message'],
        //   icon: Icons.gpp_bad_outlined,
        //   alignment: Alignment.topCenter,
        //   duration: const Duration(seconds: 6),
        // );
        throw Exception(response['message'] ?? 'Failed to load clients');
      }
    } catch (e) {
      stopwatch.stop();
      NotificationService.addLog(
        endpoint: 'fetching clients',
        status: 'error',
        durationMs: stopwatch.elapsedMilliseconds,
        message: 'Clients Fetched failed. ',
      );
      state = state.copyWith(
        loadingPages: {...state.loadingPages}..remove(page),
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> setPerPage(int newPerPage) async {
    if (newPerPage == state.perPage) return;
    state = state.copyWith(
      perPage: newPerPage,
      currentPage: 1,
      cachedPages: {},
      loadingPages: {},
      error: null,
    );
    await fetchPage(1);
  }

  Future<void> nextPage() async {
    if (state.currentPage < state.lastPage &&
        !state.loadingPages.contains(state.currentPage + 1)) {
      await fetchPage(state.currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (state.currentPage > 1 &&
        !state.loadingPages.contains(state.currentPage - 1)) {
      await fetchPage(state.currentPage - 1);
    }
  }

  Future<void> refreshCurrentPage() async {
    // Invalidate cache for current page
    final newCache = Map<int, List<Client>>.from(state.cachedPages);
    newCache.remove(state.currentPage);
    state = state.copyWith(cachedPages: newCache);
    await fetchPage(state.currentPage);
  }

  Future<void> refreshAllAndReset() async {
    // final newCachedPages = Map<int, Map<int, ClientsResponse>>.from(
    //   state.cachedPages,
    // );
    // Dump all pages for the current status (if you have status filtering)
    // newCachedPages[state.currentStatus ?? 0] = {};

    state = state.copyWith(
      currentPage: 1,
      cachedPages: {},
      loadingPages: {},
      // response: null,
      isLoading: true,
    );
    // await fetchPage(1, forceRefresh: true);
    await fetchPage(1);
  }

  // Search (client-side filtering on current page only – could be extended)
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void onSearchChanged(String query) {
    // if (_debounce?.isActive ?? false) _debounce?.cancel();
    // _debounce = Timer(const Duration(milliseconds: 500), () {
    ref.read(clientSearchProvider.notifier).search(query);
    ref.read(clientsPaginationProvider.notifier).setSearchQuery(query);
    // });

    if (query.isEmpty) {
      ref.read(clientSearchProvider.notifier).clear();
    }
  }

  void setFilters(Map<String, dynamic> filters) {
    state = state.copyWith(filters: filters);
  }

  List<Client> getFilteredClients() {
    if (state.searchQuery == null || state.searchQuery!.isEmpty) {
      return state.currentPageClients;
    }
    final query = state.searchQuery!.toLowerCase();
    return state.currentPageClients.where((client) {
      return client.name.toLowerCase().contains(query) ||
          client.client_no.toLowerCase().contains(query) ||
          client.email.toLowerCase().contains(query) ||
          client.mobile.toLowerCase().contains(query);
    }).toList();
  }
}

final clientsPaginationProvider =
    StateNotifierProvider<ClientsPaginationNotifier, ClientsPaginationState>((
      ref,
    ) {
      return ClientsPaginationNotifier(ref);
    });
