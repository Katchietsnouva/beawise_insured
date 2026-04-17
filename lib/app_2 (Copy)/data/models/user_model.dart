class User {
  final int id;
  final int agentId;
  final String name;
  final String email;
  final String phone;
  final String company;
  final String agentCode;
  final String agentKey;

  User({
    required this.id,
    required this.agentId,
    required this.name,
    required this.email,
    required this.phone,
    required this.company,
    required this.agentCode,
    required this.agentKey,
  });

  @override
  String toString() {
    return '''
    User(
      id: $id,
      agentId: $agentId,
      name: $name,
      email: $email,
      phone: $phone,
      company: $company,
      agentCode: $agentCode
      agent_key: $agentKey,

    )
    ''';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      agentId: json['agent_id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      company: json['company'] as String,
      agentCode: json['agent_code'] as String,
      agentKey: json['agent_key'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'agent_id': agentId,
      'name': name,
      'email': email,
      'phone': phone,
      'company': company,
      'agent_code': agentCode,
      'agent_key': agentKey,
    };
  }
}
