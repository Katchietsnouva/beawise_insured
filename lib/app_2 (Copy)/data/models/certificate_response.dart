class CertificateDetail {
  final String type;
  final String number;
  final String regno;
  final String startDate;
  final String endDate;
  final int daysToExpiry;

  CertificateDetail({
    required this.type,
    required this.number,
    required this.regno,
    required this.startDate,
    required this.endDate,
    required this.daysToExpiry,
  });

  factory CertificateDetail.fromJson(Map<String, dynamic> json) {
    return CertificateDetail(
      type: json['type'] ?? '',
      number: json['number'] ?? '',
      regno: json['regno'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      daysToExpiry: json['days_to_expiry'] ?? 0,
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

class CertificatePolicy {
  final int id;
  final int riskNote;
  final String? policyNo;
  final String insurer;
  final double premium;
  final double paid;
  final double balance;
  final bool? issueCert;
  final IssueCertData? issueCertData;

  CertificatePolicy({
    required this.id,
    required this.riskNote,
    this.policyNo,
    required this.insurer,
    required this.premium,
    required this.paid,
    required this.balance,

    this.issueCert,
    this.issueCertData,
  });

  factory CertificatePolicy.fromJson(Map<String, dynamic> json) {
    return CertificatePolicy(
      id: json['id'] ?? 0,
      riskNote: json['risk_note'] ?? 0,
      policyNo: json['policy_no'],
      insurer: json['insurer'] ?? '',
      premium: (json['premium'] ?? 0).toDouble(),
      paid: (json['paid'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
      issueCert: json['issue_cert'],
      issueCertData: json['issue_cert_data'] != null
          ? IssueCertData.fromJson(json['issue_cert_data'])
          : null,
    );
  }
}

class CertificateClient {
  final String name;
  final String mobile;

  CertificateClient({required this.name, required this.mobile});
  factory CertificateClient.fromJson(Map<String, dynamic> json) {
    return CertificateClient(
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
}

class Certificate {
  final int id;
  final CertificateDetail certificate;
  final CertificatePolicy policy;
  final CertificateClient client;

  Certificate({
    required this.id,
    required this.certificate,
    required this.policy,
    required this.client,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'] ?? 0,
      certificate: CertificateDetail.fromJson(json['certificate'] ?? {}),
      policy: CertificatePolicy.fromJson(json['policy'] ?? {}),
      client: CertificateClient.fromJson(json['client'] ?? {}),
    );
  }
}

class CertificatePagination {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final int? from;
  final int? to;
  final bool hasMore;
  final String? nextPageUrl;
  final String? prevPageUrl;

  CertificatePagination({
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

  factory CertificatePagination.fromJson(Map<String, dynamic> json) {
    return CertificatePagination(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      from: json['from'],
      to: json['to'],
      hasMore: json['has_more'] ?? false,
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
    );
  }
}

class CertificatesResponse {
  final String status;
  final String message;
  final int certificateCount;
  final List<Certificate> certificates;
  final Map<String, dynamic> filters;
  final CertificatePagination pagination;

  bool get isSuccess => status == 'success';

  CertificatesResponse({
    required this.status,
    required this.message,
    required this.certificateCount,
    required this.certificates,
    required this.filters,
    required this.pagination,
  });

  factory CertificatesResponse.fromJson(Map<String, dynamic> json) {
    final certList = json['certificates'] as List? ?? [];
    return CertificatesResponse(
      status: json['status']?.toString() ?? 'error',
      message: json['message']?.toString() ?? '',
      certificateCount: json['certificate_count'] ?? 0,
      certificates: certList
          .map((c) => Certificate.fromJson(c as Map<String, dynamic>))
          .toList(),
      filters: json['filters'] ?? {},
      pagination: CertificatePagination.fromJson(json['pagination'] ?? {}),
    );
  }
}
