class StatementEntry {
  final String date;
  final String ref;
  final String type;
  final String policyNo;
  final dynamic policyId;
  final dynamic transId;
  final String client;
  final String description;
  final double dr;
  final double cr;
  final double balance;

  StatementEntry({
    required this.date,
    required this.ref,
    required this.type,
    required this.policyNo,
    required this.policyId,
    required this.transId,
    required this.client,
    required this.description,
    required this.dr,
    required this.cr,
    required this.balance,
  });

  factory StatementEntry.fromJson(Map<String, dynamic> json) {
    return StatementEntry(
      date: json['Date'] ?? '',
      ref: json['Ref'] ?? '',
      type: json['Type'] ?? '',
      policyNo: json['policy_no'] ?? '',
      policyId: json['Policy ID'] ?? '',
      transId: json['Trans ID'] ?? '',
      client: json['client'] ?? '',
      description: json['description'] ?? '',
      dr: (json['DR'] ?? 0).toDouble(),
      cr: (json['CR'] ?? 0).toDouble(),
      balance: (json['Balance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    "Date": date,
    "Ref": ref,
    "Type": type,
    "policy_no": policyNo,
    "Policy ID": policyId,
    "Trans ID": transId,
    "client": client,
    "description": description,
    "DR": dr,
    "CR": cr,
    "Balance": balance,
  };
}

class StatementTotals {
  final double totalDr;
  final double totalCr;
  final double totalBalance;

  StatementTotals({
    required this.totalDr,
    required this.totalCr,
    required this.totalBalance,
  });

  factory StatementTotals.fromJson(Map<String, dynamic> json) {
    return StatementTotals(
      totalDr: (json['tdr'] ?? 0).toDouble(),
      totalCr: (json['tcr'] ?? 0).toDouble(),
      totalBalance: (json['tbl'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    "tdr": totalDr,
    "tcr": totalCr,
    "tbl": totalBalance,
  };
}
