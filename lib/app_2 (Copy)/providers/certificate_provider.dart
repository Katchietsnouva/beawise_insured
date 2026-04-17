import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/data/models/certificate_response.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

class CertificateState {
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int perPage;
  final String startDate;
  final String endDate;
  final CertificatesResponse? response;
  final Map<int, CertificatesResponse> cachedPages;
  final Set<int> loadingPages;

  CertificateState({
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.perPage = 10,
    required this.startDate,
    required this.endDate,
    this.response,
    this.cachedPages = const {},
    this.loadingPages = const {},
  });

  CertificateState copyWith({
    bool? isLoading,
    String? error,
    int? currentPage,
    int? perPage,
    String? startDate,
    String? endDate,
    CertificatesResponse? response,
    Map<int, CertificatesResponse>? cachedPages,
    Set<int>? loadingPages,
  }) {
    return CertificateState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      response: response ?? this.response,
      cachedPages: cachedPages ?? this.cachedPages,
      loadingPages: loadingPages ?? this.loadingPages,
    );
  }
}

class CertificateNotifier extends StateNotifier<CertificateState> {
  final Ref ref;

  CertificateNotifier(this.ref)
    : super(
        CertificateState(
          startDate: _defaultStartDate(),
          endDate: _defaultEndDate(),
        ),
      ) {
    fetchPage(1);
  }

  static String _defaultStartDate() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    return start.toIso8601String().split('T')[0];
  }

  static String _defaultEndDate() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month + 3, 0);
    return end.toIso8601String().split('T')[0];
  }

  Future<void> setPerPage(int perPage) async {
    if (perPage == state.perPage) return;
    state = state.copyWith(perPage: perPage, currentPage: 1, cachedPages: {});
    await fetchPage(1);
  }

  Future<void> setDateRange({
    required String start,
    required String end,
  }) async {
    if (start == state.startDate && end == state.endDate) return;
    state = state.copyWith(
      startDate: start,
      endDate: end,
      currentPage: 1,
      cachedPages: {},
    );
    await fetchPage(1);
  }

  Future<void> fetchPage(int page, {bool forceRefresh = false}) async {
    if (!forceRefresh && state.cachedPages.containsKey(page)) {
      print("Returning cached page $page");
      // if (state.cachedPages.containsKey(page)) {
      state = state.copyWith(
        currentPage: page,
        response: state.cachedPages[page],
      );
      return;
    }

    if (!forceRefresh && state.loadingPages.contains(page)) {
      print("Page $page is already loading, skipping...");
      return;
    }

    state = state.copyWith(
      loadingPages: {...state.loadingPages, page},
      isLoading: true,
      error: null,
    );

    try {
      final authState = ref.read(authProvider);
      final user = authState.user;
      final token = authState.bearerToken;

      if (user == null || token == null)
        throw Exception('User not authenticated');

      final result = await ApiService.getCertificates(
        agentCode: user.agentCode,
        agentKey: user.agentKey,
        token: token,
        starting: state.startDate,
        ending: state.endDate,
        perPage: state.perPage,
        page: page,
      );

      final response = CertificatesResponse.fromJson(result);
      if (response.isSuccess) {
        final newCache = Map<int, CertificatesResponse>.from(state.cachedPages);
        newCache[page] = response;

        state = state.copyWith(
          currentPage: page,
          response: response,
          cachedPages: newCache,
          loadingPages: {...state.loadingPages}..remove(page),
          isLoading: false,
          error: null,
        );
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      state = state.copyWith(
        loadingPages: {...state.loadingPages}..remove(page),
        error: e.toString(),
        isLoading: false,
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
    final newCache = Map<int, CertificatesResponse>.from(state.cachedPages);
    newCache.remove(state.currentPage);
    state = state.copyWith(cachedPages: newCache, response: null);
    await fetchPage(state.currentPage, forceRefresh: true);
  }
}

final certificateProvider =
    StateNotifierProvider<CertificateNotifier, CertificateState>((ref) {
      return CertificateNotifier(ref);
    });
