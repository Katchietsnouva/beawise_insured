import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/utils/premium_calculator.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/data/models/motor_quote_request_model.dart';
import 'package:insured/app_2/features/dashboard/widgets/id_badge_premium.dart';
import 'package:insured/app_2/features/motor/quoter_benefit_providers.dart';
import 'package:insured/app_2/features/motor/widgets/QuoteDetailsPopupModal.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class QuoteOptionCard extends ConsumerStatefulWidget {
  final QuoteOption option;
  final VoidCallback onSelect;

  const QuoteOptionCard({
    super.key,
    required this.option,
    required this.onSelect,
  });

  @override
  ConsumerState<QuoteOptionCard> createState() => _QuoteOptionCardState();
}

class _QuoteOptionCardState extends ConsumerState<QuoteOptionCard> {
  late final option = widget.option;
  late final onSelect = widget.onSelect;

  final String pathPrefix = (kIsWeb && kDebugMode) ? '' : 'assets';

  String getInsurerImage(String insurerName) {
    if (insurerName.contains('Sanlam')) {
      return '${pathPrefix}/images/sanlam_insurance.png';
    }

    if (insurerName.contains('Geminia')) {
      return '${pathPrefix}/images/geminia_insurance.png';
    }

    if (insurerName.contains('APA')) {
      return '${pathPrefix}/images/apa_insurance.png';
    }

    if (insurerName.contains('APA Medical')) {
      return '${pathPrefix}/images/apa_medical_insurance.png';
    }

    if (insurerName.contains('Jubilee Allianz')) {
      return '${pathPrefix}/images/jubilee_allianz_insurance.png';
    }

    if (insurerName.contains('Fidelity')) {
      return '${pathPrefix}/images/fidelity_insurance.png';
    }

    if (insurerName.contains('Prudential Life')) {
      return '${pathPrefix}/images/prudential_life_insurance.png';
    }

    if (insurerName.contains('Monarch')) {
      return '${pathPrefix}/images/monarch.png';
    }

    return '${pathPrefix}/images/default_insurance.png';
  }

  void _openDetails(BuildContext context, PremiumCalculationResult result) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => QuoteDetailsModal(
        option: option,
        result: result,
        onSelect: widget.onSelect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final excessProtectorSelected = ref.watch(excessProtectorProvider);
    // ref.read(excessProtectorProvider.notifier).state = true;
    final politicalViolenceSelected = ref.watch(politicalViolenceProvider);

    final currency = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');
    final logoPath = getInsurerImage(option.insurer);
    print(
      "excessProtectorSelected is $excessProtectorSelected and politicalViolenceSelected ${politicalViolenceSelected}  ",
    );
    final result = PremiumCalculator.calculateTotalPremiumWithBenefits(
      option,
      excessProtectorSelected,
      politicalViolenceSelected,
    );

    return InkWell(
      onTap: () => _openDetails(context, result),
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface.withOpacity(0.08),
                Theme.of(context).colorScheme.surface.withOpacity(0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          margin: const EdgeInsets.only(top: 10, bottom: 10, right: 4, left: 4),
          padding: EdgeInsets.all(10),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: AppColors.favColour,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.favColour.withOpacity(0.7),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: Container(
                                width: Responsive.isMobile(context) ? 40 : 120,
                                height: Responsive.isMobile(context) ? 40 : 120,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  logoPath,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: CustomText(
                                option.insurer,
                                type: CustomTextType.subHeader,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      BadgePremium(text: currency.format(option.amount)),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Opacity(opacity: 0.3, child: Divider(height: 1)),
                  ),

                  CustomText(
                    '${currency.format(result.totalPremium.round())}',
                    type: CustomTextType.subHeader,
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: CustomAdvancedButton(
                          label: 'Details',
                          onPressed: () => _openDetails(context, result),
                          customFontSize: 12,
                          height: 40,
                          variant: ButtonVariant.secondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: CustomAdvancedButton(
                          label: 'Select',
                          variant: ButtonVariant.primary,
                          onPressed: onSelect,
                          customFontSize: 12,
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.blueAccent),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
