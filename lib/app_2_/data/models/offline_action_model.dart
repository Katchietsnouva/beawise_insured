enum OfflineActionType { createClient }

enum OfflineActionStatus { pending, sending, success, error }

class OfflineAction {
  final String id;
  final OfflineActionType type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  OfflineActionStatus status;
  String? errorMessage;
  int retryCount;

  OfflineAction({
    required this.id,
    required this.type,
    required this.data,
    required this.createdAt,
    this.status = OfflineActionStatus.pending,
    this.errorMessage,
    this.retryCount = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.index,
    'data': data,
    'createdAt': createdAt.toIso8601String(),
    'status': status.index,
    'errorMessage': errorMessage,
    'retryCount': retryCount,
  };

  factory OfflineAction.fromJson(Map<String, dynamic> json) {
    return OfflineAction(
      id: json['id'],
      type: OfflineActionType.values[json['type']],
      data: Map<String, dynamic>.from(json['data']),
      createdAt: DateTime.parse(json['createdAt']),
      status: OfflineActionStatus.values[json['status'] ?? 0],
      errorMessage: json['errorMessage'],
      retryCount: json['retryCount'] ?? 0,
    );
  }
}
