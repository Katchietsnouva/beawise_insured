import 'dart:convert';

class SinglePolicyResponse {
  final String status;
  final String message;
  final SinglePolicy? policy;
  final Map<String, dynamic>? errors;

  bool get isSuccess => status == 'success';

  SinglePolicyResponse({
    required this.status,
    required this.message,
    this.policy,
    this.errors,
  });

  factory SinglePolicyResponse.fromJson(Map<String, dynamic> json) {
    return SinglePolicyResponse(
      status: json['status']?.toString() ?? 'error',
      message: json['message']?.toString() ?? '',
      policy: json['policy'] != null
          ? SinglePolicy.fromJson(json['policy'] as Map<String, dynamic>)
          : null,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }
}

class IssueCertData {
  final double requiredPaid;
  final double received;
  final double shortfall;

  IssueCertData({
    required this.requiredPaid,
    required this.received,
    required this.shortfall,
  });

  factory IssueCertData.fromJson(Map<String, dynamic> json) {
    return IssueCertData(
      requiredPaid: (json['required_paid'] ?? 0).toDouble(),
      received: (json['received'] ?? 0).toDouble(),
      shortfall: (json['shortfall'] ?? 0).toDouble(),
    );
  }
}

class SinglePolicy {
  final int id;
  final int? marineDmvic;
  final int status;
  final String transaction;
  final String? policyNo;
  final String insurer;
  final String client;
  final String product;
  final String? subCover;
  final String startDate;
  final String endDate;
  final String salesType;
  final int riskNote;
  final String? riskNoteLink;
  final double sumInsured;
  final double premium;
  final String currency;
  final double receipted;
  final double balance;
  final List<dynamic> receiptAllocations;
  final List<dynamic> vehicles;
  final List<dynamic> claims;
  final List<dynamic> policyDocuments;
  final List<dynamic> clientDocuments;

  final bool? issueCert;
  final IssueCertData? issueCertData;

  SinglePolicy({
    required this.id,
    this.marineDmvic,
    required this.status,
    required this.transaction,
    this.policyNo,
    required this.insurer,
    required this.client,
    required this.product,
    this.subCover,
    required this.startDate,
    required this.endDate,
    required this.salesType,
    required this.riskNote,
    this.riskNoteLink,
    required this.sumInsured,
    required this.premium,
    required this.currency,
    required this.receipted,
    required this.balance,
    required this.receiptAllocations,
    required this.vehicles,
    required this.claims,
    required this.policyDocuments,
    required this.clientDocuments,
    this.issueCert,
    this.issueCertData,
  });

  factory SinglePolicy.fromJson(Map<String, dynamic> json) {
    return SinglePolicy(
      id: json['id'] ?? 0,
      marineDmvic: json['marine_dmvic'],
      status: json['status'] ?? 0,
      transaction: json['transaction'] ?? '',
      policyNo: json['policy_no'],
      insurer: json['insurer'] ?? '',
      client: json['client']?.toString() ?? '',
      product: json['product'] ?? '',
      subCover: json['sub_cover'],
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      salesType: json['sales_type'] ?? '',
      riskNote: json['risk_note'] ?? 0,
      riskNoteLink: json['risk_note_link'],
      sumInsured: (json['sum_insured'] ?? 0).toDouble(),
      premium: (json['premium'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'KES',
      receipted: (json['receipted'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
      receiptAllocations: json['receipt_allocations'] ?? [],
      vehicles: json['vehicles'] ?? [],
      claims: json['claims'] ?? [],
      policyDocuments: json['policy_documents'] ?? [],
      clientDocuments: json['client_documents'] ?? [],
      issueCert: json['issue_cert'],
      issueCertData: json['issue_cert_data'] != null
          ? IssueCertData.fromJson(json['issue_cert_data'])
          : null,
    );
  }
}
