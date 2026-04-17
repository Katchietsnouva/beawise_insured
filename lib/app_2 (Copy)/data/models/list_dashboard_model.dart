class DashboardData {
  final int numberOfClients;
  final PoliciesData policies;
  final int renewalsDue;
  final double commission;
  final int quotes;
  final PeriodData period;

  DashboardData({
    required this.numberOfClients,
    required this.policies,
    required this.renewalsDue,
    required this.commission,
    required this.quotes,
    required this.period,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return DashboardData(
      numberOfClients: data['number_of_clients'] ?? 0,
      policies: PoliciesData.fromJson(data['policies'] ?? {}),
      renewalsDue: data['renewals_due'] ?? 0,
      commission: (data['commission'] ?? 0).toDouble(),
      quotes: data['quotes'] ?? 0,
      period: PeriodData.fromJson(data['period'] ?? {}),
    );
  }
}

class PoliciesData {
  final int count;
  final double grossPremium;
  final double receipted;
  final double balance;

  PoliciesData({
    required this.count,
    required this.grossPremium,
    required this.receipted,
    required this.balance,
  });

  factory PoliciesData.fromJson(Map<String, dynamic> json) {
    return PoliciesData(
      count: json['count'] ?? 0,
      grossPremium: (json['gross_premium'] ?? 0).toDouble(),
      receipted: (json['receipted'] ?? 0).toDouble(),
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }
}

class PeriodData {
  final String yearStart;
  final String yearEnd;
  final String monthStart;
  final String monthEnd;

  PeriodData({
    required this.yearStart,
    required this.yearEnd,
    required this.monthStart,
    required this.monthEnd,
  });

  factory PeriodData.fromJson(Map<String, dynamic> json) {
    return PeriodData(
      yearStart: json['year_start'] ?? '',
      yearEnd: json['year_end'] ?? '',
      monthStart: json['month_start'] ?? '',
      monthEnd: json['month_end'] ?? '',
    );
  }
}