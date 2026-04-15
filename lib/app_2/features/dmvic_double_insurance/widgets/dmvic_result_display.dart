import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/features/policies/widgets/pesapal_payment_modal_stk.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class DmvicResultDisplay extends ConsumerStatefulWidget {
  final Map<String, dynamic> result;
  final VoidCallback onRetry;
  final String? registration;
  final String? startDate;
  final String? endDate;

  const DmvicResultDisplay({
    super.key,
    required this.result,
    required this.onRetry,
    this.registration,
    this.startDate,
    this.endDate,
  });

  @override
  ConsumerState<DmvicResultDisplay> createState() => _DmvicResultDisplayState();
}

class _DmvicResultDisplayState extends ConsumerState<DmvicResultDisplay> {
  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final isSuccess = result['success'] == true;
    final hasConflict = isSuccess && result['insurer'] != null;
    final hasError = !isSuccess && !hasConflict;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasConflict
            ? Colors.orange.withOpacity(0.15)
            : (!hasError
                  ? Colors.red.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasConflict
              ? Colors.orange
              : (!hasError ? Colors.red : Colors.green.withOpacity(0.5)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                hasConflict
                    ? Icons.warning_amber_rounded
                    : (hasError ? Icons.error_outline : Icons.check_circle),
                color: hasConflict
                    ? Colors.orange
                    : (hasError ? Colors.red : Colors.green),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      hasConflict
                          ? "Already has coverage with ${result['insurer']} ending ${result['CoverEndDate']}. You can't continue."
                          : (hasError
                                ? (result['message'] ?? "Verification failed")
                                : "No active insurance found. You're good to go!"),
                      type: CustomTextType.caption,
                      fontWeight: FontWeight.bold,
                    ),
                    if (hasConflict) ...[
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => setState(() => _showMore = !_showMore),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomText(
                              _showMore ? "View less" : "View more",
                              color: Colors.blue,
                            ),
                            Icon(
                              _showMore
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              size: 18,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 250),
                        crossFadeState: _showMore
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: const SizedBox(),
                        secondChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _buildDetailRow("End Date", result['CoverEndDate']),
                            _buildDetailRow("Cert No", result['CertificateNo']),
                            _buildDetailRow("Insurer", result['insurer']),
                            _buildDetailRow("Chassis", result['chassis']),
                          ],
                        ),
                      ),
                    ],
                    // if (hasError) ...[
                    //   const SizedBox(height: 12),
                    //   CustomAdvancedButton(
                    //     label: "Try Again",
                    //     variant: ButtonVariant.secondary,
                    //     height: 36,
                    //     onPressed: widget.onRetry,
                    //   ),
                    // ],
                    // if (hasConflict && result['CoverEndDate'] != null) ...[
                    //   const SizedBox(height: 12),
                    //   CustomAdvancedButton(
                    //     label: "Pay Shortfall",
                    //     variant: ButtonVariant.primary,
                    //     height: 36,
                    //     onPressed: () {
                    //       final authState = ref.read(authProvider);
                    //       PesapalPaymentModalStk.show(
                    //         context,
                    //         {
                    //           "account": widget.registration ?? "",
                    //           "amount": 0,
                    //           "phone": "",
                    //         },
                    //         token: authState.bearerToken!,
                    //         user: authState.user,
                    //         balance: 0, // adjust if needed
                    //       );
                    //     },
                    //   ),
                    // ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          CustomText(
            '$label: ',
            type: CustomTextType.caption,
            fontWeight: FontWeight.bold,
          ),
          CustomText(
            value ?? 'N/A',
            type: CustomTextType.caption,
            // color: value == null || value.isEmpty ? Colors.grey : Colors.black,
            color: value == null || value.isEmpty
                ? Colors.grey
                : Theme.of(context).colorScheme.onSurface,
          ),
        ],
      ),
    );
  }
}
