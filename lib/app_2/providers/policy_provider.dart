// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:insured/app_2/data/models/policy_model.dart';
// import 'package:insured/app_2/core/services/api_service.dart';
// import 'package:insured/app_2/providers/auth_provider.dart';

// final policiesProvider = FutureProvider<List<Policy>>((ref) async {
//   final authState = ref.watch(authProvider);
//   if (authState.user == null || authState.authToken == null) {
//     throw Exception('Not authenticated');
//   }
//   final response = await ApiService.getPolicies(
//     agentCode: authState.user!.agentCode,
//     agentKey: authState.user!.agentKey,
//     token: authState.authToken!,
//   );

//   // Adjust parsing based on actual response structure
//   if (response['status'] == 1 || response['status'] == 'success') {
//     final data = response['policies'] ?? response['data'] ?? [];
//     return (data as List)
//         .map((json) => Policy.fromJson(json as Map<String, dynamic>))
//         .toList();
//   } else {
//     throw Exception(response['message'] ?? 'Failed to load policies');
//   }
// });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/core/services/notification_service.dart';
import 'package:insured/app_2/data/models/list_policy_response.dart';
import 'package:insured/app_2/data/models/list_policy_single_response.dart';
// import 'package:insured/app_2/data/models/policy_response.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

class PolicyState {
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int perPage;
  final int currentStatus;
  final PoliciesResponse? response;
  // final Map<int, PoliciesResponse> cachedPages;
  final Map<int, Map<int, PoliciesResponse>>
  cachedPages; // status -> page -> response
  final Set<int> loadingPages;
  final String searchQuery;

  PolicyState({
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.perPage = 10,
    this.currentStatus = 0,
    this.response,
    this.cachedPages = const {},
    this.loadingPages = const {},
    this.searchQuery = '',
  });

  PolicyState copyWith({
    bool? isLoading,
    String? error,
    int? currentPage,
    int? perPage,
    int? currentStatus,
    PoliciesResponse? response,
    // Map<int, PoliciesResponse>? cachedPages,
    Map<int, Map<int, PoliciesResponse>>? cachedPages,
    Set<int>? loadingPages,
    String? searchQuery,
  }) {
    return PolicyState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      currentStatus: currentStatus ?? this.currentStatus,
      response: response ?? this.response,
      cachedPages: cachedPages ?? this.cachedPages,
      loadingPages: loadingPages ?? this.loadingPages,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class PolicyNotifier extends StateNotifier<PolicyState> {
  final Ref ref;

  PolicyNotifier(this.ref) : super(PolicyState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> setStatus(int? status) async {
    if (status == state.currentStatus) return;
    state = state.copyWith(
      // currentStatus: status,
      currentStatus: status ?? 0,
      currentPage: 1,
      // cachedPages: {},
    );
    await fetchPage(1);
  }

  Future<void> setPerPage(int perPage) async {
    if (perPage == state.perPage) return;
    state = state.copyWith(perPage: perPage, currentPage: 1, cachedPages: {});
    await fetchPage(1);
  }

  // Future<void> fetchPage(int page) async {
  Future<void> fetchPage(int page, {bool forceRefresh = false}) async {
    print(
      "policy fetch (Production/quote) initiated: Page $page (Force: $forceRefresh)",
    );
    final statusCache = state.cachedPages[state.currentStatus] ?? {};

    // if (!forceRefresh && state.cachedPages.containsKey(page)) {
    if (!forceRefresh && statusCache.containsKey(page)) {
      print("Returning cached page $page for status ${state.currentStatus}");
      state = state.copyWith(
        currentPage: page,
        // response: state.cachedPages[page],
        response: statusCache[page],
        // response: state.cachedPages[state.currentStatus][page] ?? {},
        // response: state.cachedPages[state.currentStatus]?[page],
      );
      return;
    }

    if (!forceRefresh && state.loadingPages.contains(page)) {
      print("Page $page is already loading, skipping...");
      return;
    }

    state = state.copyWith(
      loadingPages: {...state.loadingPages, page},
      // isLoading: forceRefresh ? true : state.isLoading,
      isLoading: true,
      response: forceRefresh ? null : state.response,
      error: null,
    );
    final stopwatch = Stopwatch()..start();

    try {
      final authState = ref.read(authProvider);
      final user = authState.user;
      final token = authState.bearerToken;

      if (user == null || token == null) {
        throw Exception('User not authenticated');
      }
      print("About to access the policy fetch api");
      final result = await ApiService.getPolicies(
        agentCode: user.agentCode,
        agentKey: user.agentKey,
        token: token,
        page: page,
        perPage: state.perPage,
        status: state.currentStatus,
        ref: ref,
      );

      final response = PoliciesResponse.fromJson(result);
      if (response.isSuccess) {
        stopwatch.stop();
        NotificationService.addLog(
          endpoint:
              'Fetching policies for ${state.perPage} items in  page $page  with status  ${state.currentStatus} ',
          status: 'success',
          durationMs: stopwatch.elapsedMilliseconds,
          message: 'Fetching policies successful  ',
        );

        // final newCache = Map<int, PoliciesResponse>.from(state.cachedPages);/
        final newStatusCache = Map<int, PoliciesResponse>.from(
          state.cachedPages[state.currentStatus] ?? {},
        );
        // newCache[page] = response;
        newStatusCache[page] = response;
        final newCachedPages = Map<int, Map<int, PoliciesResponse>>.from(
          state.cachedPages,
        );
        newCachedPages[state.currentStatus] = newStatusCache;

        state = state.copyWith(
          currentPage: page,
          response: response,
          // cachedPages: newCache,
          cachedPages: newCachedPages,
          isLoading: false,
          loadingPages: {...state.loadingPages}..remove(page),
          error: null,
        );
      } else {
        stopwatch.stop();
        NotificationService.addLog(
          endpoint:
              'Fetching policies for ${state.perPage} items in  page $page  with status  ${state.currentStatus} ',
          status: 'error',
          durationMs: stopwatch.elapsedMilliseconds,
          message: 'Fetching policies failed  ',
        );
        throw Exception(response.message);
      }
    } catch (e) {
      stopwatch.stop();
      NotificationService.addLog(
        endpoint:
            'Fetching policies for ${state.perPage} items in  page $page  with status  ${state.currentStatus} ',
        status: 'error',
        durationMs: stopwatch.elapsedMilliseconds,
        message: 'Fetching policies failed  ',
      );
      state = state.copyWith(
        loadingPages: {...state.loadingPages}..remove(page),
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> nextPage() async {
    final lastPage = state.response?.pagination.lastPage ?? 1;
    if (state.currentPage < lastPage &&
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
    // final newCache = Map<int, PoliciesResponse>.from(state.cachedPages);
    final newStatusCache = Map<int, PoliciesResponse>.from(
      state.cachedPages[state.currentStatus] ?? {},
    );

    // newCache.remove(state.currentPage);
    newStatusCache.remove(state.currentPage);
    // state = state.copyWith(cachedPages: newCache);
    final newCachedPages = Map<int, Map<int, PoliciesResponse>>.from(
      state.cachedPages,
    );
    newCachedPages[state.currentStatus] = newStatusCache;
    state = state.copyWith(cachedPages: newCachedPages);

    // await fetchPage(state.currentPage);
    await fetchPage(state.currentPage, forceRefresh: true);
  }

  Future<void> refreshAllAndReset() async {
    // state = state.copyWith(cachedPages: {}, currentPage: 1, response: null);
    // await fetchPage(1, forceRefresh: true);

    // 1. Grab the master cache
    final newCachedPages = Map<int, Map<int, PoliciesResponse>>.from(
      state.cachedPages,
    );

    // 2. DUMP all the pages for the currently selected status
    newCachedPages[state.currentStatus] = {};

    // 3. Reset the state back to Page 1 and apply the cleared cache
    state = state.copyWith(currentPage: 1, cachedPages: newCachedPages);

    // 4. Fetch Page 1 fresh from the server
    await fetchPage(1, forceRefresh: true);
  }

  // Future<Map<String, dynamic>?> fetchPolicyById(int policyId) async {
  Future<SinglePolicyResponse?> fetchPolicyById(int policyId) async {
    try {
      final authState = ref.read(authProvider);
      final user = authState.user;
      final token = authState.bearerToken;

      if (user == null || token == null) {
        throw Exception('User not authenticated');
      }

      final result = await ApiService.getPolicyById(
        agentCode: user.agentCode,
        agentKey: user.agentKey,
        token: token,
        policyId: policyId,
      );

      // return result;
      print("✅ Full Policy Response: for getPolicyById: $policyId");
      print(result);
      return SinglePolicyResponse.fromJson(result);
    } catch (e) {
      print('❌ fetchPolicyById error: $e');
      rethrow;
    }
  }
}

final policyProvider = StateNotifierProvider<PolicyNotifier, PolicyState>((
  ref,
) {
  return PolicyNotifier(ref);
});
