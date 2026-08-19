// Request payload for /motor/quote
class MotorQuoteRequest {
  final double value;
  final String coverPeriod; // "annual" or "tor"
  final int year;
  final String vehicleClass; // "Motor", "Tuktuk", "Motorcycle"
  final String coverage; // e.g. "Private"
  final String scope; // "TPO", "Comprehensive"
  final String subcover;
  final double tonnage;
  final int pll; // number of passengers
  final String make;
  final String model;
  final List<int> insurerIds; // empty for all

  MotorQuoteRequest({
    required this.value,
    required this.coverPeriod,
    required this.year,
    required this.vehicleClass,
    required this.coverage,
    required this.scope,
    required this.subcover,
    required this.tonnage,
    required this.pll,
    required this.make,
    required this.model,
    required this.insurerIds,
  });

  Map<String, dynamic> toJson() => {
    'value': value,
    'cover_period': coverPeriod,
    'year': year,
    'class': vehicleClass,
    'coverage': coverage,
    'scope': scope,
    'subcover': subcover,
    'tonnage': tonnage,
    'pll': pll,
    'make': make,
    'model': model,
    'insurer_id': insurerIds,
  };
}

class Benefit {
  final int id;
  final String name;
  final String rate;
  final double calculated;
  final double minimum;
  final double amount;
  final bool included;

  // Benefit.fromJson(Map<String, dynamic> json)
  //   : id = json['id'],
  //     name = json['name'],
  //     rate = json['rate'],
  //     calculated = (json['calculated'] ?? 0).toDouble(),
  //     minimum = (json['minimum'] ?? 0).toDouble(),
  //     amount = (json['amount'] ?? 0).toDouble();

  Benefit.fromJson(Map<String, dynamic> json)
    : id = json['id'] ?? 0,
      name = json['name'] ?? '',
      rate = json['rate']?.toString() ?? '0',
      calculated = (json['calculated'] ?? 0).toDouble(),
      minimum = (json['minimum'] ?? 0).toDouble(),
      amount = (json['amount'] ?? 0).toDouble(),
      included = json['included'] ?? false;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'rate': rate,
    'calculated': calculated,
    'minimum': minimum,
    'amount': amount,
    'included': included,
  };
}

class LimitsOfLiability {
  final int benefitId;
  final String item;
  final String limit;

  LimitsOfLiability({
    required this.benefitId,
    required this.item,
    required this.limit,
  });

  factory LimitsOfLiability.fromJson(Map<String, dynamic> json) {
    return LimitsOfLiability(
      benefitId: json['benefit_id'] ?? 0,
      item: json['item'] ?? '',
      limit: json['limit']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'benefit_id': benefitId,
    'item': item,
    'limit': limit,
  };
}

// Individual option returned by the API
class QuoteOption {
  final int premiumInstalments;
  final int insurerId;
  final String insurer;
  final bool certificateAvailable;
  final String rateType;
  final double rate;
  final double calculated;
  final double? minimum;
  final double basicPremium;
  final double amount;
  final double markup;
  final double markupValue;
  final double agentComRate;
  // final List<dynamic> benefits;
  final List<Benefit> benefits;
  final List<QuoteTax> taxes;
  final List<LimitsOfLiability> limitsOfLiability;

  QuoteOption({
    required this.premiumInstalments,
    required this.insurerId,
    required this.insurer,
    required this.certificateAvailable,
    required this.rateType,
    required this.rate,
    required this.calculated,
    this.minimum,
    required this.basicPremium,
    required this.amount,
    required this.markup,
    required this.markupValue,
    required this.agentComRate,
    required this.benefits,
    required this.taxes,
    required this.limitsOfLiability,
  });

  List<Benefit> get activeBenefits => benefits
      .where((b) => b.amount > 0 || b.minimum > 0 || b.rate != '0')
      .toList();

  factory QuoteOption.fromJson(Map<String, dynamic> json) {
    return QuoteOption(
      premiumInstalments: json['premium_instalments'] ?? 1,
      insurerId: json['insurer_id'],
      insurer: json['insurer'],
      certificateAvailable: json['certificate_available'] == true,
      rateType: json['rate_type'],
      // rate: (json['rate'] as num).toDouble(),
      rate: parseDouble(json['rate']),
      // calculated: (json['calculated'] as num).toDouble(),
      calculated: parseDouble(json['calculated']),
      minimum: json['minimum'] != null ? parseDouble(json['minimum']) : null,
      basicPremium: parseDouble(json['basic_premium']),
      amount: parseDouble(json['amount']),
      // markup: (json['markup'] as num).toDouble(),
      markup: parseDouble(json['markup']),
      // markupValue: (json['markup_value'] as num).toDouble(),
      markupValue: parseDouble(json['markup_value']),
      // agentComRate: (json['agent_com_rate'] as num).toDouble(),
      agentComRate: parseDouble(json['agent_com_rate']),

      // minimum: json['minimum'] != null
      //     ? (json['minimum'] as num).toDouble()
      //     : null,
      // basicPremium: (json['basic_premium'] as num).toDouble(),
      // benefits: json['benefits'] ?? [],
      benefits: (json['benefits'] as List? ?? [])
          .map((b) => Benefit.fromJson(b))
          .toList(),
      taxes: (json['taxes'] as List).map((t) => QuoteTax.fromJson(t)).toList(),
      limitsOfLiability: (json['limits_of_liability'] as List? ?? [])
          .map((l) => LimitsOfLiability.fromJson(l))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'premium_instalments': premiumInstalments,
      'insurer_id': insurerId,
      'insurer': insurer,
      'certificate_available': certificateAvailable,
      'rate_type': rateType,
      'rate': rate,
      'calculated': calculated,
      'minimum': minimum,
      'basic_premium': basicPremium,
      'amount': amount,
      'markup': markup,
      'markup_value': markupValue,
      'agent_com_rate': agentComRate,
      // 'benefits': benefits,
      'benefits': benefits.map((b) => b.toJson()).toList(),
      'taxes': taxes.map((t) => t.toJson()).toList(),
      'limits_of_liability': limitsOfLiability.map((l) => l.toJson()).toList(),
    };
  }
}

class QuoteTax {
  final int id;
  final String tax;
  final String rate;
  final String calculations;

  QuoteTax({
    required this.id,
    required this.tax,
    required this.rate,
    required this.calculations,
  });

  factory QuoteTax.fromJson(Map<String, dynamic> json) {
    return QuoteTax(
      id: json['id'],
      tax: json['tax'],
      rate: json['rate'].toString(),
      // rate: parseDouble(json['rate']),
      calculations: json['calculations'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'tax': tax, 'rate': rate, 'calculations': calculations};
  }
}

class MotorQuoteResponse {
  final String status;
  final String message;
  final List<QuoteOption> options;

  MotorQuoteResponse({
    required this.status,
    required this.message,
    required this.options,
  });

  factory MotorQuoteResponse.fromJson(Map<String, dynamic> json) {
    return MotorQuoteResponse(
      status: json['status'],
      message: json['message'],
      options: (json['options'] as List)
          .map((o) => QuoteOption.fromJson(o))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'options': options.map((o) => o.toJson()).toList(),
    };
  }
}

double parseDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
