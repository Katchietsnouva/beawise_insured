import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/core/utils/error_parser.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/features/policies/widgets/pesapal_payment_modal_stk.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:intl/intl.dart';

class IssueCertificateModal extends ConsumerStatefulWidget {
  final String policyId;

  const IssueCertificateModal({super.key, required this.policyId});

  static Future<void> show(BuildContext context, String policyId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.9,
        child: IssueCertificateModal(policyId: policyId),
      ),
    );
  }

  @override
  ConsumerState<IssueCertificateModal> createState() =>
      _IssueCertificateModalState();
}

class _IssueCertificateModalState extends ConsumerState<IssueCertificateModal> {
  bool _isLoading = false;
  Map<String, dynamic>? _result;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _result = null;
    });
    try {
      final authState = ref.read(authProvider);
      final user = authState.user;
      final token = authState.bearerToken;
      if (user == null || token == null) throw Exception('Not authenticated');
      final response = await ApiService.issueCertificate(
        policyId: widget.policyId,
        agentCode: user.agentCode,
        agentKey: user.agentKey,
        token: token,
      );
      setState(() => _result = response);
    } catch (e) {
      setState(() => _result = {'status': 'error', 'message': e.toString()});
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat('#,##0.00', 'en_US');
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 20),

            // Header row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.verified_outlined, size: 18),
                ),
                const SizedBox(width: 12),

                // Title
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        'Issue certificate',
                        type: CustomTextType.subHeader,
                      ),
                    ],
                  ),
                ),

                // ❌ Close button (NEW)
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(height: 1),
            const SizedBox(height: 24),

            if (_result == null) _buildIdle(),
            if (_result != null) _buildResult(_result!, currency),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildIdle() => Column(
    children: [
      CustomText(
        // 'This will submit a request to DMVIC to issue the motor certificate for this policy.',
        'Certificate will be sent to your registered email.',
        type: CustomTextType.paragraph,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      CustomAdvancedButton(
        icon: Icon(Icons.verified),
        label: 'Confirm Issue Certificate',
        onPressed: _submit,
        loading: _isLoading,
        variant: ButtonVariant.primary,
      ),
      // SizedBox(
      //   width: double.infinity,
      //   child: FilledButton.icon(
      //     icon: const Icon(Icons.verified_outlined, size: 18),
      //     label: _isLoading
      //         ? const SizedBox(
      //             width: 18,
      //             height: 18,
      //             child: CircularProgressIndicator(
      //               strokeWidth: 2,
      //               color: Colors.white,
      //             ),
      //           )
      //         : const Text('Confirm & issue certificate'),
      //     onPressed: _isLoading ? null : _submit,
      //     style: FilledButton.styleFrom(
      //       padding: const EdgeInsets.symmetric(vertical: 14),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(12),
      //       ),
      //     ),
      //   ),
      // ),
      const SizedBox(height: 10),
    ],
  );

  Widget _buildResult_(Map<String, dynamic> result, NumberFormat currency) {
    final isSuccess =
        result['status'] == 'success' || result['success'] == true;
    final message = (result['message'] ?? '').toString();

    if (!isSuccess && message.toLowerCase().contains('insufficient payment')) {
      return _buildInsufficientPayment(result, currency);
    }
    if (!isSuccess) return _buildError(result);
    return _buildSuccess(message);
  }

  Widget _buildResult(Map<String, dynamic> result, NumberFormat currency) {
    final isSuccess =
        result['status'] == 'success' || result['success'] == true;
    final message = (result['message'] ?? '').toString();

    if (!isSuccess) {
      final msgLower = message.toLowerCase();
      if (msgLower.contains('insufficient') && msgLower.contains('payment')) {
        return _buildInsufficientPayment(result, currency);
      }
      return _buildError(result);
    }
    return _buildSuccess(message);
  }

  Widget _buildInsufficientPayment_(
    Map<String, dynamic> result,
    NumberFormat currency,
  ) {
    final data = result['data'] as Map<String, dynamic>? ?? {};
    final required = (data['required_paid'] ?? 0).toDouble();
    final received = (data['received'] ?? 0).toDouble();
    final shortfall = (data['shortfall'] ?? 0).toDouble();
    final pctPaid = required > 0 ? (received / required).clamp(0.0, 1.0) : 0.0;

    debugPrint('RAW result: $result');
    debugPrint('DATA map: $data');
    debugPrint('required_paid: ${data['required_paid']}');
    debugPrint('received: ${data['received']}');
    debugPrint('shortfall: ${data['shortfall']}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bannerTile(
          color: Colors.orange,
          icon: Icons.warning_amber_rounded,
          title: 'Insufficient payment',
          subtitle: 'Top up your balance to issue this certificate.',
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _row('Required', 'KES ${ceilCurrency(required)}'),
              const SizedBox(height: 10),
              _row('Received', 'KES ${ceilCurrency(received)}'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Shortfall', style: TextStyle(fontSize: 13)),
                  Text(
                    'KES ${ceilCurrency(shortfall)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: pctPaid,
                  minHeight: 6,
                  backgroundColor: Theme.of(
                    context,
                  ).dividerColor.withOpacity(0.2),
                  color: Colors.orange,
                ),
              ),
              // const SizedBox(height: 6),
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: Text(
              //     '${(pctPaid * 100).toStringAsFixed(0)}% paid',
              //     style: TextStyle(
              //       fontSize: 11,
              //       color: Theme.of(context).colorScheme.onSurfaceVariant,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              final authState = ref.read(authProvider);
              PesapalPaymentModalStk.show(
                context,
                {'account': widget.policyId, 'amount': shortfall, 'phone': ''},
                token: authState.bearerToken!,
                user: authState.user,
                balance: shortfall,
                // installationBalance: null,
                installationBalance: shortfall ?? 0,
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Pay KES ${ceilCurrency(shortfall)}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildInsufficientPayment(
    Map<String, dynamic> result,
    NumberFormat currency,
  ) {
    Map<String, dynamic> data = result['data'] as Map<String, dynamic>? ?? {};

    // final required__ = (data['required_paid'] ?? 0).toDouble();
    // final received__ = (data['received'] ?? 0).toDouble();
    // final shortfall__ = (data['shortfall'] ?? 0).toDouble();
    // final pctPaid__ = required__ > 0
    //     ? (received__ / required__).clamp(0.0, 1.0)
    //     : 0.0;

    debugPrint('RAW result: $result');
    debugPrint('DATA map: $data');
    debugPrint('required_paid: ${data['required_paid']}');
    debugPrint('received: ${data['received']}');
    debugPrint('shortfall: ${data['shortfall']}');

    // If data is empty, try to extract JSON from the message string
    if (data.isEmpty && result['message'] != null) {
      final msg = result['message'].toString();
      final start = msg.indexOf('{');
      final end = msg.lastIndexOf('}');
      if (start != -1 && end != -1) {
        try {
          final jsonStr = msg.substring(start, end + 1);
          final parsed = jsonDecode(jsonStr) as Map<String, dynamic>;
          if (parsed.containsKey('data')) {
            data = parsed['data'] as Map<String, dynamic>? ?? {};
          } else {
            data = parsed;
          }
        } catch (e) {
          debugPrint('Failed to parse JSON from message: $e');
        }
      }
    }

    final required = (data['required_paid'] ?? 0).toDouble();
    final received = (data['received'] ?? 0).toDouble();
    final shortfall = (data['shortfall'] ?? 0).toDouble();
    final pctPaid = required > 0 ? (received / required).clamp(0.0, 1.0) : 0.0;

    debugPrint('DATA map after fallback: $data');
    debugPrint(
      'required_paid: $required, received: $received, shortfall: $shortfall',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _bannerTile(
          color: Colors.orange,
          icon: Icons.warning_amber_rounded,
          title: 'Insufficient payment',
          subtitle: 'Top up your balance to issue this certificate.',
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _row('Required', 'KES ${ceilCurrency(required)}'),
              const SizedBox(height: 10),
              _row('Received', 'KES ${ceilCurrency(received)}'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Shortfall', style: TextStyle(fontSize: 13)),
                  Text(
                    'KES ${ceilCurrency(shortfall)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: pctPaid,
                  minHeight: 6,
                  backgroundColor: Theme.of(
                    context,
                  ).dividerColor.withOpacity(0.2),
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        CustomAdvancedButton(
          width: double.infinity,
          label: 'Pay KES ${ceilCurrency(shortfall)}',
          variant: ButtonVariant.payBtn,
          onPressed: () {
            final authState = ref.read(authProvider);
            PesapalPaymentModalStk.show(
              context,
              {
                'account': widget.policyId,
                'amount': ceilToShilling(shortfall),
                'phone': '',
              },
              token: authState.bearerToken!,
              user: authState.user,
              balance: shortfall,
              installationBalance: shortfall,
              // Once payment is confirmed, clear the stale "insufficient
              // payment" result and re-issue so the error banner can't persist.
              onPaymentConfirmed: () {
                if (mounted) _submit();
              },
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  /// Flattens a Laravel-style `errors` map ({field: [msg, ...]}) into readable
  /// lines for the banner subtitle. Returns '' when there are no field errors.
  String _flattenErrors(Map<String, dynamic>? errors) {
    if (errors == null || errors.isEmpty) return '';
    final lines = <String>[];
    errors.forEach((_, value) {
      if (value is List) {
        lines.addAll(value.map((e) => e.toString()));
      } else if (value != null) {
        lines.add(value.toString());
      }
    });
    return lines.join('\n');
  }

  Widget _buildError(Map<String, dynamic> result) {
    final errorCode = result['error_code']?.toString();

    // The failure arrives in several shapes (see msc/err/*.jpeg):
    //  - {"status":"error","message":"Policy period has already expired."}
    //  - {"success":false,"message":"...","errors":{"field":["detail", ...]}}
    //  - either of the above wrapped as an "Exception: {json}" string in
    //    result['message'].
    // Parse the message string first (this unwraps "Exception: {json}"), then
    // fall back to any sibling `errors` map on the raw result.
    final parsed = ErrorParser.fromRaw(result['message'] ?? result);
    final message = parsed.message.isNotEmpty
        ? parsed.message
        : (result['message']?.toString() ?? 'Something went wrong');

    final fieldErrors =
        parsed.errors ??
        (result['errors'] is Map<String, dynamic>
            ? result['errors'] as Map<String, dynamic>
            : null);

    // Enumerate the field-level details into the subtitle; otherwise keep the
    // generic hint.
    final details = _flattenErrors(fieldErrors);
    final subtitle = details.isNotEmpty
        ? details
        : 'Check the policy details and try again.';

    return Column(
      children: [
        _bannerTile(
          color: Colors.red,
          icon: Icons.error_outline_rounded,
          title: errorCode != null ? '$errorCode · $message' : message,
          subtitle: subtitle,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _submit,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Try again'),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSuccess(String message) => Column(
    children: [
      Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFFE8F5E9),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check_rounded, size: 28, color: Colors.green),
      ),
      const SizedBox(height: 14),
      const Text(
        'Certificate issued',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 6),
      Text(
        message.isNotEmpty
            ? message
            : 'The certificate has been successfully issued.',
        style: TextStyle(
          fontSize: 13,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
      SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: () => Navigator.pop(context),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Done'),
        ),
      ),
    ],
  );

  // ─── helpers ──────────────────────────────────────────────────────────────

  Widget _bannerTile({
    required Color color,
    required IconData icon,
    required String title,
    required String subtitle,
  }) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: color.withOpacity(0.25), width: 0.5),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: color.withOpacity(0.8)),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _row(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 13)),
      Text(
        value,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    ],
  );
}

// class _IssueCertificateModalState extends ConsumerState<IssueCertificateModal> {
//   bool _isLoading = false;
//   Map<String, dynamic>? _result;

//   Future<void> _submit() async {
//     setState(() {
//       _isLoading = true;
//       _result = null;
//     });

//     try {
//       final authState = ref.read(authProvider);
//       final user = authState.user;
//       final token = authState.bearerToken;

//       if (user == null || token == null) {
//         throw Exception('Not authenticated');
//       }

//       final response = await ApiService.issueCertificate(
//         policyId: widget.policyId,
//         agentCode: user.agentCode,
//         agentKey: user.agentKey,
//         token: token,
//       );

//       setState(() {
//         _result = response;
//       });
//     } catch (e) {
//       setState(() {
//         _result = {'status': 'error', 'message': e.toString()};
//       });
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   void _payShortfall(double shortfall, String account) {
//     final paymentData = {"account": account, "amount": shortfall, "phone": ""};
//     final authState = ref.read(authProvider);
//     PesapalPaymentModalStk.show(
//       context,
//       paymentData,
//       token: authState.bearerToken!,
//       user: authState.user,
//       balance: shortfall,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currency = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');

//     return Container(
//       padding: EdgeInsets.only(
//         left: 24,
//         right: 24,
//         top: 20,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 24,
//       ),
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const SizedBox(height: 20),
//             const CustomText('Issue Certificate', type: CustomTextType.header),
//             const SizedBox(height: 20),

//             // Submit button
//             CustomAdvancedButton(
//               icon: Icon(Icons.verified),
//               label: 'Confirm Issue Certificate',
//               onPressed: _submit,
//               loading: _isLoading,
//               variant: ButtonVariant.primary,
//             ),
//             const SizedBox(height: 24),

//             // Result display
//             if (_result != null) _buildResultCard(_result!, currency),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildResultCard(Map<String, dynamic> result, NumberFormat currency) {
//     final status = result['status'] ?? result['success'];
//     final isSuccess = status == 'success' || status == true;
//     final message = result['message'] ?? '';

//     // Handle insufficient payment error
//     if (!isSuccess &&
//         message.toLowerCase().contains('insufficient payment') &&
//         result.containsKey('data')) {
//       final data = result['data'];
//       final requiredPaid = (data['required_paid'] ?? 0).toDouble();
//       final received = (data['received'] ?? 0).toDouble();
//       final shortfall = (data['shortfall'] ?? 0).toDouble();
//       final account = result['account'] ?? widget.policyId;

//       return GlassCard(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               const Icon(
//                 Icons.warning_amber_rounded,
//                 size: 48,
//                 color: Colors.orange,
//               ),
//               const SizedBox(height: 12),
//               CustomText(
//                 'Insufficient Payment',
//                 type: CustomTextType.subHeader,
//                 fontWeight: FontWeight.bold,
//               ),
//               const SizedBox(height: 8),
//               CustomText(
//                 'You need to pay an additional ${ceilCurrency(shortfall)} to issue this certificate.',
//                 type: CustomTextType.paragraph,
//               ),
//               const SizedBox(height: 16),
//               _buildDetailRow(
//                 'Required Payment',
//                 ceilCurrency(requiredPaid),
//               ),
//               _buildDetailRow('Amount Received', ceilCurrency(received)),
//               _buildDetailRow('Shortfall', ceilCurrency(shortfall)),
//               const SizedBox(height: 20),
//               CustomAdvancedButton(
//                 label: 'Pay Shortfall (${ceilCurrency(shortfall)})',
//                 variant: ButtonVariant.primary,
//                 onPressed: () => _payShortfall(shortfall, account),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     // General error
//     if (!isSuccess) {
//       final errorCode = result['error_code'];
//       return GlassCard(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               const Icon(Icons.error_outline, size: 48, color: Colors.red),
//               const SizedBox(height: 12),
//               CustomText(
//                 'Certificate Issuance Failed',
//                 type: CustomTextType.subHeader,
//               ),
//               const SizedBox(height: 8),
//               if (errorCode != null)
//                 CustomText(
//                   'Error Code: $errorCode',
//                   type: CustomTextType.caption,
//                 ),
//               CustomText(message, type: CustomTextType.paragraph),
//               const SizedBox(height: 20),
//               CustomAdvancedButton(
//                 label: 'Try Again',
//                 variant: ButtonVariant.secondary,
//                 onPressed: _submit,
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     // Success
//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const Icon(Icons.check_circle, size: 48, color: Colors.green),
//             const SizedBox(height: 12),
//             CustomText(
//               'Certificate Issued Successfully',
//               type: CustomTextType.subHeader,
//             ),
//             const SizedBox(height: 8),
//             CustomText(
//               message.isNotEmpty ? message : 'The certificate has been issued.',
//               type: CustomTextType.paragraph,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           CustomText(label, type: CustomTextType.paragraph),
//           CustomText(
//             value,
//             type: CustomTextType.paragraph,
//             fontWeight: FontWeight.bold,
//           ),
//         ],
//       ),
//     );
//   }
// }

/////////////
///
///

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:insured/app_2/core/services/api_service.dart';
// import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
// import 'package:insured/app_2/core/widgets/custom_text.dart';
// import 'package:insured/app_2/providers/auth_provider.dart';
// import 'package:insured/app_2/providers/certificateBtnProvider.dart';

// class IssueCertificateModal extends ConsumerStatefulWidget {
//   final String policyId;

//   const IssueCertificateModal({super.key, required this.policyId});

//   static Future<void> show(BuildContext context, String policyId) {
//     return showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => IssueCertificateModal(policyId: policyId),
//     );
//   }

//   @override
//   ConsumerState<IssueCertificateModal> createState() =>
//       _IssueCertificateModalState();
// }

// class _IssueCertificateModalState extends ConsumerState<IssueCertificateModal> {
//   bool _isLoading = false;

//   Future<void> _submit() async {
//     setState(() => _isLoading = true);

//     try {
//       final authState = ref.read(authProvider);
//       final user = authState.user;
//       final token = authState.bearerToken;

//       if (user == null || token == null) {
//         throw Exception('Not authenticated');
//       }

//       final response = await ApiService.issueCertificate(
//         policyId: widget.policyId,
//         agentCode: user.agentCode,
//         agentKey: user.agentKey,
//         token: token,
//       );

//       ref.read(issueCertificateResultProvider.notifier).state = AsyncValue.data(
//         response,
//       );
//     } catch (e, stack) {
//       ref.read(issueCertificateResultProvider.notifier).state =
//           AsyncValue.error(e, stack);
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final result = ref.watch(issueCertificateResultProvider);

//     return ConstrainedBox(
//       constraints: BoxConstraints(
//         minHeight: MediaQuery.of(context).size.height * 0.75,
//       ),
//       child: IntrinsicHeight(
//         child: Container(
//           padding: EdgeInsets.only(
//             left: 24,
//             right: 24,
//             top: 20,
//             bottom: MediaQuery.of(context).viewInsets.bottom + 24,
//           ),
//           decoration: BoxDecoration(
//             color: Theme.of(context).scaffoldBackgroundColor,
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 20),

//               const CustomText(
//                 'Issue Certificate',
//                 type: CustomTextType.header,
//               ),

//               const SizedBox(height: 20),

//               CustomAdvancedButton(
//                 icon: Icon(Icons.verified),
//                 label: 'Confirm Issue certificate',
//                 onPressed: _submit,
//                 loading: _isLoading,
//                 variant: ButtonVariant.primary,
//               ),

//               if (result != null) ...[
//                 const SizedBox(height: 24),
//                 result.when(
//                   data: (data) => Text("Success: ${data.toString()}"),
//                   loading: () =>
//                       const Center(child: CircularProgressIndicator()),
//                   error: (err, _) => Text(
//                     'Error: $err',
//                     style: const TextStyle(color: Colors.red),
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
