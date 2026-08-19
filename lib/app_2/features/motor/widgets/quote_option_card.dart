import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/utils/insurer_assets_util.dart';
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

const _kMotorAccent = Color(0xFF1B5E82);
const _kMotorAccentLight = Color(0xFF2A7FAF);

final String pathPrefix = (kIsWeb && kDebugMode) ? '' : 'assets';

class _QuoteOptionCardState extends ConsumerState<QuoteOptionCard> {
  QuoteOption get option => widget.option;
  VoidCallback get onSelect => widget.onSelect;

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

  void _showContextMenu(BuildContext context, PremiumCalculationResult result) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasCoverageLimits = option.limitsOfLiability.isNotEmpty;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F1629) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: CustomText(
                option.insurer,
                color: isDark ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(
                Icons.receipt_long_rounded,
                color: isDark ? Colors.white70 : Colors.black54,
                size: 20,
              ),
              title: CustomText(
                'View Details & Benefits',
                type: CustomTextType.paragraph,
              ),
              onTap: () {
                Navigator.pop(context);
                _openDetails(context, result);
              },
            ),

            Opacity(
              opacity: hasCoverageLimits ? 1.0 : 0.4,
              child: ListTile(
                leading: Icon(
                  Icons.shield_outlined,
                  color: isDark ? Colors.white70 : Colors.black54,
                  size: 20,
                ),
                title: CustomText(
                  'Coverage Limits',
                  type: CustomTextType.paragraph,
                ),
                onTap: hasCoverageLimits
                    ? () {
                        Navigator.pop(context);
                        _openLimits(context);
                      }
                    : null,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _openLimits(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _LimitsSheet(option: option),
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
      onTap: () => _showContextMenu(context, result),
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
                      // BadgePremium(text: currency.format(option.amount)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _CertificateStatusPill(
                            available: option.certificateAvailable,
                          ),
                          const SizedBox(height: 6),
                          // BadgePremium(text: currency.format(option.amount)),
                        ],
                      ),
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

class _CertificateStatusPill extends StatelessWidget {
  final bool available;

  const _CertificateStatusPill({required this.available});

  @override
  Widget build(BuildContext context) {
    final color = available ? const Color(0xFF25C88A) : Colors.orangeAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            available ? Icons.verified_rounded : Icons.info_outline_rounded,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            'Cert Enabled · ${available ? 'TRUE' : 'FALSE'}',
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _LimitsSheet extends StatelessWidget {
  final QuoteOption option;
  const _LimitsSheet({required this.option});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F1629) : Colors.white;

    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.85,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: _kMotorAccentLight,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Coverage Limits',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          option.insurer,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: isDark ? Colors.white38 : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: isDark ? Colors.white38 : Colors.black26,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            if (option.limitsOfLiability.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    'No limits of liability specified\nfor this option.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  controller: ctrl,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  itemCount: option.limitsOfLiability.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: isDark
                        ? Colors.white10
                        : Colors.black.withValues(alpha: 0.06),
                  ),
                  itemBuilder: (_, i) {
                    final l = option.limitsOfLiability[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _kMotorAccent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.verified_user_rounded,
                              color: _kMotorAccentLight,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.item,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'KES ${l.limit}',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: _kMotorAccentLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
