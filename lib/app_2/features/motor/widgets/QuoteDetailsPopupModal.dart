import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/utils/premium_calculator.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_checkbox.dart'
    show CustomCheckbox;
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/features/motor/quoter_benefit_providers.dart';
import 'package:intl/intl.dart';
import 'package:insured/app_2/data/models/motor_quote_request_model.dart';

class QuoteDetailsModal extends ConsumerStatefulWidget {
  final QuoteOption option;
  final PremiumCalculationResult result;
  // final bool excessProtectorSelected;
  // final ValueChanged<bool?> onExcessProtectorChanged;
  final VoidCallback onSelect;

  const QuoteDetailsModal({
    super.key,
    required this.option,
    required this.result,
    required this.onSelect,
  });

  // const QuoteDetailsModal({super.key});

  @override
  ConsumerState<QuoteDetailsModal> createState() => _QuoteDetailsModalState();
}

class _QuoteDetailsModalState extends ConsumerState<QuoteDetailsModal> {
  late final onSelect = widget.onSelect;

  @override
  Widget build(BuildContext context) {
    final excessProtectorSelected = ref.watch(excessProtectorProvider);
    // ref.read(excessProtectorProvider.notifier).state = true;
    final politicalViolenceSelected = ref.watch(politicalViolenceProvider);

    final option = widget.option;
    final result = widget.result;
    final resulT = PremiumCalculator.calculateTotalPremiumWithBenefits(
      option,
      excessProtectorSelected,
      politicalViolenceSelected,
    );
    print('Here is the res obj: \n$resulT');
    // late final MemoryCacheService _cache;
    final MemoryCacheService _cache = MemoryCacheService();
    final currency = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');
    // final activeBenefits = option.activeBenefits;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final whiteSurface = Theme.of(context).colorScheme.surface;
    final themeSurface = Theme.of(context).colorScheme.surface;
    final themeText = Theme.of(context).colorScheme.onSurface;

    Widget excessProtector = CustomCheckbox(
      // value: _excessProtector
      // value: widget.excessProtectorSelected,
      value: ref.watch(excessProtectorProvider),
      label: 'Excess Protector',
      cacheKey: 'motor_excess_protector',
      cache: _cache,
      // onChanged: (val) { widget.onExcessProtectorChanged(val); },
      onChanged: (val) {
        ref.read(excessProtectorProvider.notifier).state = val ?? false;
      },
    );

    Widget politicalViolence = CustomCheckbox(
      // value: _politicalViolence,
      // value: widget.politicalViolenceSelected,
      value: ref.watch(politicalViolenceProvider),
      label: 'Political Violence and Terrorism',
      cacheKey: 'motor_political_violence',
      cache: _cache,
      // activeColor: isDark?,
      onChanged: (val) {
        // widget.onPoliticalViolenceChanged(val);
        ref.read(politicalViolenceProvider.notifier).state = val ?? false;
      },
    );
    return BackdropFilter(
      // filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          // color: const Color(0xFF1E293B).withOpacity(0.8)
          color: isDark
              ? const Color(0xFF00FFB2).withOpacity(0.1)
              : themeSurface,

          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(color: themeSurface.withOpacity(0.1)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: themeSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomText(
                            option.insurer,
                            type: CustomTextType.header,
                          ),
                          SizedBox(width: 10),
                          CustomText(
                            "(insurer)",
                            type: CustomTextType.subHeader,
                          ),
                        ],
                      ),
                      Opacity(
                        opacity: 0.7,
                        child: CustomText(
                          'Premium Breakdown',
                          type: CustomTextType.paragraph,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: themeText.withOpacity(0.7)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              //                const SizedBox(height: 24),
              Divider(color: themeText, height: 24),

              const SizedBox(height: 12),
              // Financial Breakdown Table
              const CustomText("Financials:", type: CustomTextType.subHeader),
              const SizedBox(height: 24),

              // _buildDetailRow('Rate Type', option.rateType),
              // _buildDetailRow('Basic Premium',currency.format(option.basicPremium),),
              // _buildDetailRow('Rate', '${option.rate}%'),
              // _buildDetailRow('Calculated', currency.format(option.calculated)),
              // _buildDetailRow('Total Premium', currency.format(resulT.totalPremium.round())),
              // _buildDetailRow('Minimum', option.minimum != null ? currency.format(option.minimum) : 'N/A'),
              // _buildDetailRow('Markup', '${option.markup}%'),
              // _buildDetailRow('Markup Value',currency.format(option.markupValue)),
              // _buildDetailRow( 'Agent Commission Rate', '${option.agentComRate}%'),
              const SizedBox(height: 12),

              Row(
                children: [
                  _buildStatCard(
                    context,
                    isDark,
                    themeSurface,
                    themeText,
                    'Basic Premium',
                    // currency.format(option.calculated),
                    currency.format(resulT.newBasicPremium.round()),
                    Icons.account_balance_wallet,
                    color: !isDark ? Colors.green[900]! : Colors.greenAccent,
                  ),
                  const SizedBox(width: 12),

                  _buildStatCard(
                    context,
                    isDark,
                    themeSurface,
                    themeText,
                    'Total Premium',
                    // currency.format(premium.round()),
                    // `totalPremium` already includes the markup (calculator is
                    // seeded from `option.amount` = basic + markup). Adding
                    // `option.markupValue` again double-counts it.
                    currency.format(resulT.totalPremium.round()),
                    // '${option.rate}%',
                    Icons.payments,
                    color: !isDark ? Colors.green[900]! : Colors.greenAccent,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Divider(color: themeText, height: 24),
              const CustomText(
                "Taxes & Levies:",
                type: CustomTextType.subHeader,
              ),
              const SizedBox(height: 12),
              ...resulT.taxDetails.map(
                (tax) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(tax.name, type: CustomTextType.paragraph),
                      CustomText(
                        currency.format(tax.amount),
                        type: CustomTextType.paragraph,
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomText(
                      "Total Taxes",
                      type: CustomTextType.subHeader,
                    ),
                    CustomText(
                      currency.format(resulT.totalTaxes.round()),
                      type: CustomTextType.subHeader,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Divider(color: themeText, height: 24),

              // const Divider(color: Colors.white10, height: 24),

              // const Text(
              //   "Taxes & Levies",
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // const SizedBox(height: 8),
              // ...option.taxes.map(
              //   (tax) => _buildDetailRow(
              //     tax.tax,
              //     tax.calculations == "Duty"
              //         ? currency.format(double.tryParse(tax.rate) ?? 0)
              //         : "${tax.rate}%",
              //   ),
              // ),
              // StatCardRow(
              //   cards: [
              //     ...option.taxes.map(
              //       (tax) => StatCardData(
              //         label: tax.tax,
              //         value: tax.calculations == "Duty"
              //             ? currency.format(double.tryParse(tax.rate) ?? 0)
              //             : "${tax.rate}%",
              //         // icon: Icons.attach_money,
              //         icon: Icons.money_sharp,
              //         color: Colors.greenAccent,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 4),

              // if (!isTuktuk && !isMotorcycle) ...[
              if (!option.benefits.isEmpty) ...{
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Optional Benefits:',
                      type: CustomTextType.paragraph,
                    ),
                    const SizedBox(height: 4),

                    // !Responsive.isMobile(context)
                    //     ? Row(
                    //         children: [
                    //           Expanded(child: excessProtector),
                    //           const SizedBox(width: 12),
                    //           Expanded(child: politicalViolence),
                    //         ],
                    //       )
                    //     : Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           excessProtector,
                    //           const SizedBox(height: 12),
                    //           politicalViolence,
                    //         ],
                    //       ),
                  ],
                ),
              },
              // ],
              // const CustomText(
              //   "Benefits Included:",
              //   type: CustomTextType.paragraph,
              // ),
              const SizedBox(height: 12),

              option.benefits.isEmpty
                  // activeBenefits.isEmpty
                  ? Opacity(
                      opacity: 0.7,
                      child: CustomText(
                        "No benefits included in this policy.",
                        type: CustomTextType.caption,
                      ),
                    )
                  : Column(
                      children: option.benefits.map((b) {
                        final isExcessProtector = b.name == 'Excess Protector';
                        final isPVT = b.name == 'PVT';
                        final isActive =
                            b.included ||
                            (b.name == 'Excess Protector' &&
                                excessProtectorSelected) ||
                            (b.name == 'PVT' && politicalViolenceSelected);
                        return _buildBenefitRow(
                          b,
                          currency,
                          isActive: isActive,
                          onChanged: b.included
                              ? null // always-on, locked
                              : isExcessProtector
                              ? (_) =>
                                    ref
                                            .read(
                                              excessProtectorProvider.notifier,
                                            )
                                            .state =
                                        !excessProtectorSelected
                              : isPVT
                              ? (_) =>
                                    ref
                                            .read(
                                              politicalViolenceProvider
                                                  .notifier,
                                            )
                                            .state =
                                        !politicalViolenceSelected
                              : null,
                        );
                      }).toList(),
                    ),
              const SizedBox(height: 20),

              Row(
                children: [
                  // Expanded(
                  //   child: CustomAdvancedButton(
                  //     label: 'Details',
                  //     onPressed: () => _openDetails(context, result),
                  //     customFontSize: 12,
                  //     height: 40,
                  //     variant: ButtonVariant.secondary,
                  //   ),
                  // ),
                  Expanded(
                    flex: 1,
                    child: CustomAdvancedButton(
                      label: 'Proceed',
                      variant: ButtonVariant.primary,
                      onPressed: onSelect,
                      customFontSize: 12,
                      // height: 40,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    bool isDark,
    Color themeSurface,
    Color themeText,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    color ??= Theme.of(context).colorScheme.surface;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeText.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: themeText.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color.withOpacity(0.8)),
            const SizedBox(height: 8),
            CustomText(label, type: CustomTextType.paragraph),
            CustomText(value, type: CustomTextType.subHeader),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(label, type: CustomTextType.paragraph),
          CustomText(value, type: CustomTextType.caption),
        ],
      ),
    );
  }

  Widget _buildBenefitChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.blueAccent, fontSize: 12),
      ),
    );
  }

  Widget _buildBenefitRow(
    Benefit b,
    NumberFormat currency, {
    bool isActive = false,
    ValueChanged<bool?>? onChanged,
  }) {
    final effectiveAmount = b.amount > 0 ? b.amount : b.minimum;

    double numericRate = 0;
    try {
      numericRate = double.parse(b.rate.toString());
    } catch (_) {
      numericRate = 0;
    }

    // Determine display
    String rateDisplay;
    if (numericRate < 40) {
      rateDisplay = '${b.rate}%';
    } else {
      rateDisplay = currency.format(numericRate);
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onChanged != null ? () => onChanged(!isActive) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? !isDark
                    ? Colors.green[100]!.withOpacity(0.9)
                    : Colors.greenAccent.withOpacity(0.10)
              : Colors.blueAccent.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? Colors.greenAccent.withOpacity(0.55)
                : Colors.blueAccent.withOpacity(0.2),
            width: isActive ? 1.5 : 1.0,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.greenAccent.withOpacity(0.15),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // CustomCheckbox(
            //   value: isActive,
            //   label: '',
            //   cacheKey: 'benefit_${b.name}',
            //   cache: MemoryCacheService(),
            //   onChanged: onChanged ?? (_) {}, // no-op when locked
            // ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomText(b.name, type: CustomTextType.subHeader),
                      if (isActive) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 11,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.greenAccent.withOpacity(0.15)
                          : Colors.blueAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // child: Text(
                    //   '${b.rate}% rate',
                    //   style: TextStyle(
                    //     color: isActive ? Colors.greenAccent : Colors.blueAccent,
                    //     fontSize: 11,
                    //   ),
                    // ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ?numericRate < 40
                            ? Icon(
                                Icons.percent,
                                size: 11,
                                color: isActive
                                    ? isDark
                                          ? Colors.greenAccent
                                          : Colors.black
                                    : Colors.blueAccent,
                              )
                            : null,
                        const SizedBox(width: 4),
                        Text(
                          rateDisplay,
                          style: TextStyle(
                            color: isActive
                                ? isDark
                                      ? Colors.greenAccent
                                      : Colors.black
                                : Colors.blueAccent,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currency.format(effectiveAmount),
                  style: TextStyle(
                    color: isActive
                        ? isDark
                              ? Colors.greenAccent
                              : Colors.black
                        : Colors.white54,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (isActive)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.greenAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Included',
                      style: TextStyle(
                        color: isDark ? Colors.greenAccent : Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                // else if (b.minimum > 0 && b.calculated < b.minimum)
                //   CustomText('min applies', type: CustomTextType.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatCardRow extends StatelessWidget {
  final List<StatCardData> cards;
  // Reusable widget for multiple stat cards

  const StatCardRow({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: cards
            .map(
              (card) => Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        card.icon,
                        size: 18,
                        color: card.color.withOpacity(0.8),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Opacity(
                              opacity: 0.6,
                              child: CustomText(
                                card.label,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                type: CustomTextType.paragraph,
                              ),
                            ),
                            CustomText(
                              card.value,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              type: CustomTextType.subHeader,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class StatCardData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  StatCardData({
    required this.label,
    required this.value,
    required this.icon,
    this.color = Colors.white70,
  });
}
