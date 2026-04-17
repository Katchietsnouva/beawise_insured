import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/features/dmvic_double_insurance/widgets/dmvic_result_display.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:insured/app_2/providers/dmvic_provider.dart';
import 'package:intl/intl.dart';

class DmvicDoubleInsuranceModal extends ConsumerStatefulWidget {
  const DmvicDoubleInsuranceModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DmvicDoubleInsuranceModal(),
    );
  }

  @override
  ConsumerState<DmvicDoubleInsuranceModal> createState() =>
      _DmvicDoubleInsuranceModalState();
}

class _DmvicDoubleInsuranceModalState
    extends ConsumerState<DmvicDoubleInsuranceModal> {
  final _registrationController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _registrationController.dispose();
    super.dispose();
  }

  Map<String, dynamic>? _result;

  Future<void> _submit() async {
    if (_registrationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a registration number')),
      );
      return;
    }

    // setState(() => _isLoading = true);
    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      final authState = ref.read(authProvider);
      final token = authState.bearerToken;
      if (token == null) throw Exception('Not authenticated');

      final now = DateTime.now();
      final startDate = DateFormat('yyyy-MM-dd').format(now);
      final expiringDate = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime(now.year, 12, 31));

      final response = await ApiService.postDmvicDoubleInsurance(
        token: token,
        registration: _registrationController.text.trim(),
        startDate: startDate,
        expiringDate: expiringDate,
      );

      // ref.read(dmvicDoubleInsuranceResultProvider.notifier).state =
      //     AsyncValue.data(response);
      setState(() => _result = response);
    } catch (e, stack) {
      // ref.read(dmvicDoubleInsuranceResultProvider.notifier).state =
      //     AsyncValue.error(e, stack);
      setState(() => _result = {'success': false, 'message': e.toString()});
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final result = ref.watch(dmvicDoubleInsuranceResultProvider);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          ),
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height * 0.75,
            ),

            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'Double Insurance Check',
                              type: CustomTextType.header,
                            ),
                            CustomText(
                              'Enter a vehicle registration number',
                              type: CustomTextType.caption,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Divider(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.3),
                    height: 32,
                  ),

                  CustomTextField(
                    controller: _registrationController,
                    hintLabel: 'Registration Number',
                    hint: 'e.g. KCX352U',
                    icon: Icons.directions_car,
                  ),
                  const SizedBox(height: 20),
                  CustomAdvancedButton(
                    label: 'Check Double Insurance',
                    onPressed: _submit,
                    loading: _isLoading,
                    variant: ButtonVariant.primary,
                  ),
                  if (_result == null) const SizedBox(height: 120),
                  // // if (result != null) ...[
                  // //   const SizedBox(height: 24),
                  // //   result.when(
                  // //     data: (data) => _buildResultCard(data),
                  // //     loading: () =>
                  // //         const Center(child: CircularProgressIndicator()),
                  // //     error: (err, _) => Text(
                  // //       'Error: $err',
                  // //       style: const TextStyle(color: Colors.redAccent),
                  // //     ),
                  // //   ),
                  // // ],
                  // if (_dmvicResult != null) ...[
                  //   const SizedBox(height: 12),
                  //   DmvicResultDisplay(
                  //     result: _dmvicResult!,
                  //     onRetry: _checkDoubleInsurance,
                  //     registration: regnoCtrl.text,
                  //     startDate: startDateCtrl.text,
                  //     endDate: endDateCtrl.text,
                  //   ),
                  // ],
                  ///////
                  if (_result != null) ...[
                    const SizedBox(height: 16),
                    DmvicResultDisplay(
                      result: _result!,
                      onRetry: _submit,
                      registration: _registrationController.text,
                      // startDate: _startDateController.text,
                      // endDate: _endDateController.text,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> data) {
    final bool success = data['success'] ?? false;
    final String coverEndDate = data['CoverEndDate'] ?? 'N/A';
    final String certNo = data['CertificateNo'] ?? 'N/A';
    final String insurer = data['insurer'] ?? 'N/A';
    final String registration = data['registration'] ?? 'N/A';
    final String chassis = data['chassis'] ?? 'N/A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.warning,
              color: success ? Colors.green : Colors.orange,
              size: 28,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: CustomText(
                success ? 'Valid Coverage Found' : 'No Valid Coverage',
                type: CustomTextType.header,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Divider(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
          height: 32,
        ),
        _buildInfoRow(Icons.event, 'Cover End Date', coverEndDate),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.confirmation_number, 'Certificate No', certNo),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.business, 'Insurer', insurer),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.directions_car, 'Registration', registration),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.settings, 'Chassis', chassis),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.orange),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(label, type: CustomTextType.paragraph),
              const SizedBox(height: 2),
              CustomText(value, type: CustomTextType.caption),
            ],
          ),
        ),
      ],
    );
  }
}

class DmvicModalLauncher extends StatefulWidget {
  const DmvicModalLauncher();

  @override
  State<DmvicModalLauncher> createState() => DmvicModalLauncherState();
}

class DmvicModalLauncherState extends State<DmvicModalLauncher> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      DmvicDoubleInsuranceModal.show(context).then((_) {
        if (!mounted) return;
        // Use GoRouter to navigate to dashboard
        GoRouter.of(context).go('/dashboard');
      });
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:insured/app_2/core/services/api_service.dart';
// import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
// import 'package:insured/app_2/core/widgets/custom_text.dart';
// import 'package:insured/app_2/core/widgets/glass_card.dart';
// import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
// import 'package:insured/app_2/providers/auth_provider.dart';
// import 'package:insured/app_2/providers/dmvic_provider.dart';
// import 'package:intl/intl.dart';

// class DmvicDoubleInsuranceScreen extends ConsumerStatefulWidget {
//   const DmvicDoubleInsuranceScreen({super.key});

//   @override
//   ConsumerState<DmvicDoubleInsuranceScreen> createState() =>
//       _DmvicDoubleInsuranceScreenState();
// }

// class _DmvicDoubleInsuranceScreenState
//     extends ConsumerState<DmvicDoubleInsuranceScreen> {
//   final _registrationController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void dispose() {
//     _registrationController.dispose();
//     super.dispose();
//   }

//   Future<void> _submit() async {
//     if (_registrationController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a registration number')),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       final authState = ref.read(authProvider);
//       final token = authState.bearerToken;
//       if (token == null) throw Exception('Not authenticated');

//       final now = DateTime.now();
//       final startDate = DateFormat('yyyy-MM-dd').format(now);
//       final expiringDate = DateFormat(
//         'yyyy-MM-dd',
//       ).format(DateTime(now.year, 12, 31));

//       final response = await ApiService.postDmvicDoubleInsurance(
//         token: token,
//         registration: _registrationController.text.trim(),
//         startDate: startDate,
//         expiringDate: expiringDate,
//       );

//       ref.read(dmvicDoubleInsuranceResultProvider.notifier).state =
//           AsyncValue.data(response);
//       print('📦 DMVIC Double Insurance Response: $response');
//     } catch (e, stack) {
//       ref.read(dmvicDoubleInsuranceResultProvider.notifier).state =
//           AsyncValue.error(e, stack);
//       print('❌ Error: $e');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final result = ref.watch(dmvicDoubleInsuranceResultProvider);

//     return Scaffold(
//       appBar: AppBar(
//         // title: const Text(
//         //   'DMVIC Double Insurance',
//         //   style: TextStyle(color: Colors.white),
//         // ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Container(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               // Input Card
//               GlassCard(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       CustomText(
//                         'Check for Double Insurance',
//                         type: CustomTextType.subHeader,
//                       ),
//                       const SizedBox(height: 20),
//                       CustomTextField(
//                         controller: _registrationController,
//                         hintLabel: 'Registration Number',
//                         hint: 'e.g. KCX352U',
//                         icon: Icons.directions_car,
//                       ),
//                       const SizedBox(height: 20),
//                       Center(
//                         child: CustomAdvancedButton(
//                           width: 400,
//                           label: 'Check Double Insurance',
//                           onPressed: _submit,
//                           loading: _isLoading,
//                           variant: ButtonVariant.primary,
//                           // variant: ButtonVariant.secondary,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Result Display
//               if (result != null)
//                 result.when(
//                   data: (data) => _buildResultCard(data),
//                   loading: () =>
//                       const Center(child: CircularProgressIndicator()),
//                   error: (err, stack) => GlassCard(
//                     child: Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Text(
//                         'Error: $err',
//                         style: const TextStyle(color: Colors.redAccent),
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildResultCard(Map<String, dynamic> data) {
//     final bool success = data['success'] ?? false;
//     final String coverEndDate = data['CoverEndDate'] ?? 'N/A';
//     final String certNo = data['CertificateNo'] ?? 'N/A';
//     final String insurer = data['insurer'] ?? 'N/A';
//     final String registration = data['registration'] ?? 'N/A';
//     final String chassis = data['chassis'] ?? 'N/A';

//     return GlassCard(
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   success ? Icons.check_circle : Icons.warning,
//                   color: success ? Colors.green : Colors.orange,
//                   size: 28,
//                 ),
//                 const SizedBox(width: 10),
//                 Flexible(
//                   child: CustomText(
//                     success ? 'Valid Coverage Found' : 'No Valid Coverage',
//                     type: CustomTextType.header,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//             const Divider(color: Colors.white24, height: 30),

//             _buildInfoRow(Icons.event, 'Cover End Date', coverEndDate),
//             const SizedBox(height: 12),
//             _buildInfoRow(Icons.confirmation_number, 'Certificate No', certNo),
//             const SizedBox(height: 12),
//             _buildInfoRow(Icons.business, 'Insurer', insurer),
//             const SizedBox(height: 12),
//             _buildInfoRow(Icons.directions_car, 'Registration', registration),
//             const SizedBox(height: 12),
//             _buildInfoRow(Icons.settings, 'Chassis', chassis),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Icon(icon, size: 20, color: Colors.orange),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomText(label, type: CustomTextType.paragraph),
//               const SizedBox(height: 2),
//               CustomText(value, type: CustomTextType.caption),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
