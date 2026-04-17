import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/data/models/certificate_response.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/data/models/list_dashboard_model.dart';
import 'package:insured/app_2/data/models/list_policy_response.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

final dashboardRecentClientsProvider = FutureProvider<List<Client>>((
  ref,
) async {
  final authState = ref.watch(authProvider);
  final user = authState.user;
  final token = authState.bearerToken;

  if (user == null || token == null) {
    throw Exception('User not authenticated');
  }

  try {
    final response = await ApiService.getClients(
      agentCode: user.agentCode,
      agentKey: user.agentKey,
      token: token,
      page: 1,
      perPage: 3,
    );

    if (response['status'] == 'success' || response['status'] == 1) {
      final clientsData = response['clients'] ?? response['data'] ?? [];
      if (clientsData is List) {
        return clientsData
            .map((json) => Client.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } else {
      throw Exception(response['message'] ?? 'Failed to load clients');
    }
  } catch (e) {
    return [];
  }
});

final dashboardRecentRenewalsProvider = FutureProvider<List<PolicyEntry>>((
  ref,
) async {
  final authState = ref.watch(authProvider);
  final user = authState.user;
  final token = authState.bearerToken;

  if (user == null || token == null) {
    throw Exception('User not authenticated');
  }

  // Default date range: current month start to end of next month
  final now = DateTime.now();
  final start = DateTime(now.year, now.month, -1);
  final end = DateTime(now.year, now.month + 2, 0); // last day of next month
  final startDate = start.toIso8601String().split('T')[0];
  final endDate = end.toIso8601String().split('T')[0];

  try {
    final response = await ApiService.getRenewals(
      agentCode: user.agentCode,
      agentKey: user.agentKey,
      token: token,
      starting: startDate,
      ending: endDate,
      page: 1,
      perPage: 3,
    );

    if (response['status'] == 'success') {
      final policiesData = response['policy'] ?? [];
      if (policiesData is List) {
        return policiesData
            .map((json) => PolicyEntry.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } else {
      throw Exception(response['message'] ?? 'Failed to load renewals');
    }
  } catch (e) {
    return [];
  }
});

final dashboardRecentCertificatesProvider = FutureProvider<List<Certificate>>((
  ref,
) async {
  final authState = ref.watch(authProvider);
  final user = authState.user;
  final token = authState.bearerToken;

  if (user == null || token == null) throw Exception('Not authenticated');

  final now = DateTime.now();
  final start = DateTime(now.year, now.month, 1);
  final end = DateTime(now.year, now.month + 5, 0);
  final startDate = start.toIso8601String().split('T')[0];
  final endDate = end.toIso8601String().split('T')[0];

  try {
    final response = await ApiService.getCertificates(
      agentCode: user.agentCode,
      agentKey: user.agentKey,
      token: token,
      starting: startDate,
      ending: endDate,
      perPage: 3,
      page: 1,
    );

    if (response['status'] == 'success') {
      final certsData = response['certificates'] ?? [];
      if (certsData is List) {
        return certsData
            .map((c) => Certificate.fromJson(c as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  } catch (e) {
    return [];
  }
});

// final dashboardDataProvider = FutureProvider.autoDispose<DashboardData>((
//   ref,
// ) async {
final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final authState = ref.watch(authProvider);
  final user = authState.user;
  final token = authState.bearerToken;

  if (user == null || token == null) {
    throw Exception('User not authenticated');
  }

  final response = await ApiService.getDashboard(
    agentCode: user.agentCode,
    agentKey: user.agentKey,
    token: token,
    ref: ref,
  );

  if (response['status'] == 'success') {
    return DashboardData.fromJson(response);
  } else {
    throw Exception(response['message'] ?? 'Failed to load dashboard');
  }
  // }).autoDispose();
});
