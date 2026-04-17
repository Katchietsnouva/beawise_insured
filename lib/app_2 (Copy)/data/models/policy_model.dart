class Policy {
  final int id;
  final String policyNumber;
  final String clientName;
  final DateTime startDate;
  final DateTime endDate;
  final double premium;
  final String status;

  Policy({
    required this.id,
    required this.policyNumber,
    required this.clientName,
    required this.startDate,
    required this.endDate,
    required this.premium,
    required this.status,
  });

  factory Policy.fromJson(Map<String, dynamic> json) {
    return Policy(
      id: json['id'] as int,
      policyNumber: json['policy_number'] as String,
      clientName: json['client_name'] as String,
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      premium: (json['premium'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'policy_number': policyNumber,
      'client_name': clientName,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'premium': premium,
      'status': status,
    };
  }
}
