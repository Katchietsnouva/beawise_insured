class ApiLog {
  final String id;
  final DateTime timestamp;
  final String endpoint;
  final String status; // 'success' or 'error'
  final int durationMs;
  final String message;
  bool read;

  ApiLog({
    required this.id,
    required this.timestamp,
    required this.endpoint,
    required this.status,
    required this.durationMs,
    required this.message,
    this.read = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'endpoint': endpoint,
    'status': status,
    'durationMs': durationMs,
    'message': message,
    'read': read,
  };

  factory ApiLog.fromJson(Map<String, dynamic> json) => ApiLog(
    id: json['id'],
    timestamp: DateTime.parse(json['timestamp']),
    endpoint: json['endpoint'],
    status: json['status'],
    durationMs: json['durationMs'],
    message: json['message'],
    read: json['read'] ?? false,
  );
}
