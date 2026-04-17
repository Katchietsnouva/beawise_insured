import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:insured/app_2/core/services/notification_service.dart';
import 'package:insured/app_2/data/models/api_log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
      return NotificationNotifier(ref);
    });

enum NotificationFilter { all, success, error }

enum NotificationSort { newestFirst, oldestFirst }

class NotificationState {
  final List<ApiLog> logs;
  final int unreadCount;
  final NotificationFilter filter;
  final NotificationSort sort;

  NotificationState({
    required this.logs,
    required this.unreadCount,
    this.filter = NotificationFilter.all,
    this.sort = NotificationSort.newestFirst,
  });

  NotificationState copyWith({
    List<ApiLog>? logs,
    int? unreadCount,
    NotificationFilter? filter,
    NotificationSort? sort,
  }) {
    return NotificationState(
      logs: logs ?? this.logs,
      unreadCount: unreadCount ?? this.unreadCount,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final Ref ref;
  static const String _storageKeyPrefix = 'notifications_';

  NotificationNotifier(this.ref)
    : super(NotificationState(logs: [], unreadCount: 0)) {
    NotificationService.init(this);

    _loadLogs();

    // Reload logs when user changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (previous?.user?.email != next.user?.email) {
        _loadLogs();
      }
    });
  }

  String _getStorageKey() {
    final user = ref.read(authProvider).user;
    return user?.email != null
        ? '$_storageKeyPrefix${user!.email}'
        : '$_storageKeyPrefix';
  }

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getStorageKey();
    final String? logsJson = prefs.getString(key);
    if (logsJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(logsJson);
        final logs = decoded.map((e) => ApiLog.fromJson(e)).toList();
        final unreadCount = logs.where((log) => !log.read).length;
        state = state.copyWith(logs: logs, unreadCount: unreadCount);
      } catch (e) {
        print('Error loading notifications: $e');
      }
    }
  }

  Future<void> _saveLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getStorageKey();
    final logsJson = jsonEncode(state.logs.map((log) => log.toJson()).toList());
    await prefs.setString(key, logsJson);
  }

  void addLog({
    required String endpoint,
    required String status,
    required int durationMs,
    required String message,
  }) {
    final newLog = ApiLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      endpoint: endpoint,
      status: status,
      durationMs: durationMs,
      message: message,
      read: false,
    );
    final updatedLogs = [newLog, ...state.logs];
    // Keep only last 100 logs
    if (updatedLogs.length > 100) updatedLogs.removeLast();
    final unreadCount = updatedLogs.where((log) => !log.read).length;
    state = state.copyWith(logs: updatedLogs, unreadCount: unreadCount);
    _saveLogs();
  }

  void markAsRead(String id) {
    final updatedLogs = state.logs.map((log) {
      if (log.id == id) log.read = true;
      return log;
    }).toList();
    final unreadCount = updatedLogs.where((log) => !log.read).length;
    state = state.copyWith(logs: updatedLogs, unreadCount: unreadCount);
    _saveLogs();
  }

  void markAllAsRead() {
    final updatedLogs = state.logs.map((log) {
      log.read = true;
      return log;
    }).toList();
    state = state.copyWith(logs: updatedLogs, unreadCount: 0);
    _saveLogs();
  }

  void clearLogs() {
    state = state.copyWith(logs: [], unreadCount: 0);
    _saveLogs();
  }

  void setFilter(NotificationFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void setSort(NotificationSort sort) {
    state = state.copyWith(sort: sort);
  }
}
