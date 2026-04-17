import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/data/models/list_statement_response.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

class StatementState {
  final bool isLoading;
  final String? error;
  final String startDate;
  final String endDate;
  final int currentPage;
  final int perPage;
  final StatementResponse? response;
  final Map<int, StatementResponse> cachedPages;
  final Set<int> loadingPages;

  StatementState({
    this.isLoading = false,
    this.error,
    required this.startDate,
    required this.endDate,
    this.currentPage = 1,
    this.perPage = 10,
    this.response,
    this.cachedPages = const {},
    this.loadingPages = const {},
  });

  StatementState copyWith({
    bool? isLoading,
    String? error,
    String? startDate,
    String? endDate,
    int? currentPage,
    int? perPage,
    StatementResponse? response,
    Map<int, StatementResponse>? cachedPages,
    Set<int>? loadingPages,
  }) {
    return StatementState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      response: response ?? this.response,
      cachedPages: cachedPages ?? this.cachedPages,
      loadingPages: loadingPages ?? this.loadingPages,
    );
  }
}

class StatementNotifier extends StateNotifier<StatementState> {
  final Ref ref;

  static String _defaultStartDate() {
    final now = DateTime.now();
    final threeMonthsAgo = DateTime(now.year, now.month - 3, 1);
    return threeMonthsAgo.toIso8601String().split('T')[0];
  }

  static String _defaultEndDate() {
    final now = DateTime.now();
    return now.toIso8601String().split('T')[0];
  }

  StatementNotifier(this.ref)
    // : super(StatementState(startDate: _todayString(), endDate: _todayString()));
    : super(
        StatementState(
          startDate: _defaultStartDate(),
          endDate: _defaultEndDate(),
        ),
      );

  static String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> setDateRange({
    required String start,
    required String end,
  }) async {
    state = state.copyWith(
      startDate: start,
      endDate: end,
      currentPage: 1,
      cachedPages: {},
    );
    await fetchPage(1);
  }

  Future<void> setPerPage(int perPage) async {
    if (perPage == state.perPage) return;
    state = state.copyWith(perPage: perPage, currentPage: 1, cachedPages: {});
    await fetchPage(1);
  }

  Future<void> fetchPage(int page) async {
    // If page is cached, use it
    if (state.cachedPages.containsKey(page)) {
      state = state.copyWith(
        currentPage: page,
        response: state.cachedPages[page],
      );
      return;
    }

    // Prevent duplicate loading
    if (state.loadingPages.contains(page)) return;

    state = state.copyWith(
      loadingPages: {...state.loadingPages, page},
      error: null,
    );

    try {
      final authState = ref.read(authProvider);
      final user = authState.user;
      final token = authState.bearerToken;

      if (user == null || token == null) {
        throw Exception('User not authenticated');
      }

      final result = await ApiService.getStatement(
        agentCode: user.agentCode,
        agentKey: user.agentKey,
        token: token,
        startDate: state.startDate,
        endDate: state.endDate,
        page: page,
        perPage: state.perPage,
      );

      final response = StatementResponse.fromJson(result);
      if (response.isSuccess) {
        final newCache = Map<int, StatementResponse>.from(state.cachedPages);
        newCache[page] = response;

        state = state.copyWith(
          currentPage: page,
          response: response,
          cachedPages: newCache,
          loadingPages: {...state.loadingPages}..remove(page),
          error: null,
        );
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      state = state.copyWith(
        loadingPages: {...state.loadingPages}..remove(page),
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
    final newCache = Map<int, StatementResponse>.from(state.cachedPages);
    newCache.remove(state.currentPage);
    state = state.copyWith(cachedPages: newCache);
    await fetchPage(state.currentPage);
  }
}

final statementProvider =
    StateNotifierProvider<StatementNotifier, StatementState>((ref) {
      return StatementNotifier(ref);
    });
