import 'dart:convert';

// Client info inside policy
class PolicyClient {
  final String name;
  final String clientNo;
  final String mobile;
  final String email;

  PolicyClient({
    required this.name,
    required this.clientNo,
    required this.mobile,
    required this.email,
  });

  factory PolicyClient.fromJson(Map<String, dynamic> json) {
    return PolicyClient(
      name: json['name'] ?? '',
      clientNo: json['client_no'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
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

class PolicyDetail {
  final int id;
  final int risknote;
  final String insurer;
  final String product;
  final String starting;
  final String ending;
  final String? subCover;
  final String? motorClass;
  final String transaction;
  final String? policyNo;
  final String salesType;
  final double sumInsured;
  final double basic;
  final double tax;
  final double amount;
  final double receipted;
  final double balance;
  final double comRate;
  final double commission;
  final String? reg;
  final bool? issueCert;
  final IssueCertData? issueCertData;
  final int premiumInstalments;

  PolicyDetail({
    required this.id,
    required this.risknote,
    required this.insurer,
    required this.product,
    required this.starting,
    required this.ending,
    this.subCover,
    this.motorClass,
    required this.transaction,
    this.policyNo,
    required this.salesType,
    required this.sumInsured,
    required this.basic,
    required this.tax,
    required this.amount,
    required this.receipted,
    required this.balance,
    required this.comRate,
    required this.commission,
    this.reg,
    this.issueCert,
    this.issueCertData,
    required this.premiumInstalments,
  });

  factory PolicyDetail.fromJson(Map<String, dynamic> json) {
    return PolicyDetail(
      id: json['id'] ?? 0,
      risknote: json['risknote'] ?? 0,
      insurer: json['insurer'] ?? '',
      product: json['product'] ?? '',
      starting: json['starting'] ?? '',
      ending: json['ending'] ?? '',
      subCover: json['sub_cover'],
      motorClass: json['motor_class'],
      transaction: json['transaction'] ?? '',
      policyNo: json['policy_no'],
      salesType: json['sales_type'] ?? '',
      sumInsured: (json['sum_insured'] ?? 0).toDouble(),
      basic: (json['basic'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      receipted: (json['receipted'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
      comRate: (json['com_rate'] ?? 0).toDouble(),
      commission: (json['commission'] ?? 0).toDouble(),
      reg: json['reg'],
      issueCert: json['issue_cert'],
      issueCertData: json['issue_cert_data'] != null
          ? IssueCertData.fromJson(json['issue_cert_data'])
          : null,
      premiumInstalments: json['premium_instalments'] ?? 0,
    );
  }
}

// Combined policy entry
class PolicyEntry {
  final PolicyClient client;
  final PolicyDetail policy;

  PolicyEntry({required this.client, required this.policy});

  factory PolicyEntry.fromJson(Map<String, dynamic> json) {
    return PolicyEntry(
      client: PolicyClient.fromJson(json['client'] ?? {}),
      policy: PolicyDetail.fromJson(json['policy'] ?? {}),
    );
  }
}

// Pagination (reuse from list_client_model if same structure)
class Pagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final int? from;
  final int? to;
  final bool hasMore;
  final String? nextPageUrl;
  final String? prevPageUrl;

  Pagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    this.from,
    this.to,
    required this.hasMore,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      from: json['from'],
      to: json['to'],
      hasMore: json['has_more'] ?? false,
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
    );
  }
}

// Main response
class PoliciesResponse {
  final String status;
  final String message;
  final List<PolicyEntry> policies;
  final Pagination pagination;

  bool get isSuccess => status == 'success';

  PoliciesResponse({
    required this.status,
    required this.message,
    required this.policies,
    required this.pagination,
  });

  factory PoliciesResponse.fromJson(Map<String, dynamic> json) {
    final policyList = json['policy'] as List? ?? [];
    return PoliciesResponse(
      status: json['status']?.toString() ?? 'error',
      message: json['message']?.toString() ?? '',
      policies: policyList
          .map((e) => PolicyEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}
