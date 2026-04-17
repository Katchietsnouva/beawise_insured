// import 'package:insured/app_2/core/models/api_log.dart';
import 'package:insured/app_2/providers/notification_provider.dart';

class NotificationService {
  static NotificationNotifier? _notifier;
  static final List<Map<String, dynamic>> _pendingLogs = [];

  /// Call this once from the notifier's constructor.
  static void init(NotificationNotifier notifier) {
    _notifier = notifier;
    // Flush any logs that arrived before the notifier was ready
    for (var log in _pendingLogs) {
      _notifier!.addLog(
        endpoint: log['endpoint'],
        status: log['status'],
        durationMs: log['durationMs'],
        message: log['message'],
      );
    }
    _pendingLogs.clear();
  }

  /// Public method for logging API calls. Safe to call even if notifier isn't initialised yet.
  static void addLog({
    required String endpoint,
    required String status,
    required int durationMs,
    required String message,
  }) {
    if (_notifier != null) {
      _notifier!.addLog(
        endpoint: endpoint,
        status: status,
        durationMs: durationMs,
        message: message,
      );
    } else {
      _pendingLogs.add({
        'endpoint': endpoint,
        'status': status,
        'durationMs': durationMs,
        'message': message,
      });
    }
  }
}
