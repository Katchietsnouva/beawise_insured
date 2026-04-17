class Quote_old {
  final String id;
  final String clientId;
  final double amount;
  final String status; // 'pending', 'accepted', 'rejected'

  Quote_old({
    required this.id,
    required this.clientId,
    required this.amount,
    required this.status,
  });

  factory Quote_old.fromJson(Map<String, dynamic> json) {
    return Quote_old(
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
