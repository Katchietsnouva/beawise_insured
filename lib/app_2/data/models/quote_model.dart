class Quote {
  final String id;
  final String clientId;
  final double amount;
  final String status; // 'pending', 'accepted', 'rejected'

  Quote({
    required this.id,
    required this.clientId,
    required this.amount,
    required this.status,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      clientId: json['clientId'],
      amount: json['amount'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'clientId': clientId,
    'amount': amount,
    'status': status,
  };
}
