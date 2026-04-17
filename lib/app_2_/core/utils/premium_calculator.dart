import 'package:insured/app_2/data/models/motor_quote_request_model.dart';

class PremiumCalculationResult {
  final double totalPremium;
  final double totalTaxes;
  final double newBasicPremium;
  final List<TaxDetail> taxDetails;

  PremiumCalculationResult({
    required this.totalPremium,
    required this.totalTaxes,
    required this.newBasicPremium,
    this.taxDetails = const [],
  });
  @override
  String toString() {
    return '''
      PremiumCalculationResult(
        totalPremium: $totalPremium,
        totalTaxes: $totalTaxes,
        newBasicPremium: $newBasicPremium,
        taxDetails: $taxDetails
      )
    ''';
  }
}

class TaxDetail {
  final String name;
  final double amount;
  TaxDetail({required this.name, required this.amount});
  @override
  String toString() {
    return 'TaxDetail(name: $name, amount: $amount)';
  }
}

class PremiumCalculator {
  static double calculateTotalPremium_(QuoteOption option) {
    final double basicPremium = option.basicPremium;
    final double markup = option.markupValue;

    double pcf = 0;
    double itl = 0;
    double stampDuty = 0;

    for (final tax in option.taxes) {
      final name = tax.tax.toUpperCase();
      final rate = double.tryParse(tax.rate) ?? 0;

      if (name.contains('PCF')) {
        pcf = (rate / 100) * basicPremium;
      }

      if (name.contains('ITL')) {
        itl = (rate / 100) * basicPremium;
      }

      if (name.contains('STAMP')) {
        stampDuty = rate;
      }
    }

    final double taxTotal = pcf + itl + stampDuty;

    final double totalPremium = basicPremium + markup + taxTotal;

    return totalPremium.ceilToDouble();
  }

  static PremiumCalculationResult calculateTotalPremium(QuoteOption option) {
    return _calculatePremium(option, false, false);
  }

  //  with benefit flags
  static PremiumCalculationResult calculateTotalPremiumWithBenefits(
    QuoteOption option,
    bool excessProtectorSelected,
    bool politicalViolenceSelected,
  ) {
    return _calculatePremium(
      option,
      excessProtectorSelected,
      politicalViolenceSelected,
    );
  }

  static PremiumCalculationResult _calculatePremium(
    QuoteOption option,
    bool excessProtectorSelected,
    bool politicalViolenceSelected,
  ) {
    // double basicPremium = option.basicPremium;
    double basicPremium = option.amount;

    // Add benefits if selected
    double totalBenefits = 0;
    for (var benefit in option.benefits) {
      bool include = false;
      if (benefit.name == 'Excess Protector' && excessProtectorSelected) {
        include = true;
      } else if (benefit.name == 'PVT' && politicalViolenceSelected) {
        include = true;
      } else if (benefit.included) {
        //for "name": "PLL",
        // } else if (benefit.included) {
      } else if (benefit.name == 'PLL' && benefit.included) {
        include = true;
      }
      if (include) {
        double amount = benefit.amount > 0 ? benefit.amount : benefit.minimum;
        totalBenefits += amount;
      }
    }
    double newBasic = basicPremium + totalBenefits;

    // Calculate taxes based on new basic
    double pcf = 0;
    double itl = 0;
    double stampDuty = 0;
    List<TaxDetail> taxDetails = [];

    for (final tax in option.taxes) {
      final name = tax.tax.toUpperCase();
      final rate = double.tryParse(tax.rate) ?? 0;
      if (name.contains('PCF')) {
        pcf = (rate / 100) * newBasic;
        taxDetails.add(TaxDetail(name: 'PCF', amount: pcf));
      } else if (name.contains('ITL')) {
        itl = (rate / 100) * newBasic;
        taxDetails.add(TaxDetail(name: 'ITL', amount: itl));
      } else if (name.contains('STAMP')) {
        stampDuty = rate;
        taxDetails.add(TaxDetail(name: 'Stamp Duty', amount: stampDuty));
      }
    }
    final double taxTotal = pcf + itl + stampDuty;
    final double totalPremium = newBasic + taxTotal;
    // return  totalPremium.ceilToDouble();
    return PremiumCalculationResult(
      totalPremium: totalPremium.ceilToDouble(),
      totalTaxes: taxTotal,
      newBasicPremium: newBasic,
      taxDetails: taxDetails,
    );
  }
}
