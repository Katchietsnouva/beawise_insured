import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/providers/certificate_provider.dart';
import 'package:intl/intl.dart';
import 'dart:ui';

class CertificatesScreen extends ConsumerStatefulWidget {
  const CertificatesScreen({super.key});

  @override
  ConsumerState<CertificatesScreen> createState() => _CertificatesScreenState();
}

class _CertificatesScreenState extends ConsumerState<CertificatesScreen> {
  final DateFormat _displayFormat = DateFormat('dd.MM.yy');
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _initDatesFromState();
  }

  void _initDatesFromState() {
    final state = ref.read(certificateProvider);
    _startDate = DateTime.tryParse(state.startDate) ?? DateTime.now();
    _endDate = DateTime.tryParse(state.endDate) ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(certificateProvider);
    final notifier = ref.read(certificateProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF050505), // Pure Void
      appBar: AppBar(
        title: const Text(
          "TERMINAL_CERT_V1",
          style: TextStyle(
            fontFamily: 'Monospace',
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF00FFB2)),
            onPressed: () => notifier.refreshCurrentPage(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildNeonFilterBar(),
          Expanded(
            child: state.isLoading && state.response == null
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00FFB2)),
                  )
                : _buildGrid(state),
          ),
          _buildBottomGlitchNav(state, notifier),
        ],
      ),
    );
  }

  Widget _buildNeonFilterBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(1), // Gradient border trick
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF00FFB2), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Icon(Icons.radar, color: Color(0xFF00FFB2), size: 18),
            const SizedBox(width: 12),
            Text(
              "RANGE: ${_displayFormat.format(_startDate!)} > ${_displayFormat.format(_endDate!)}",
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Monospace',
                fontSize: 12,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _selectDateRange,
              child: const Text(
                "CHANGE_PARAMS",
                style: TextStyle(
                  color: Color(0xFF00FFB2),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(CertificateState state) {
    final certs = state.response?.certificates ?? [];
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: certs.length,
      itemBuilder: (context, index) => _buildMonolithCard(certs[index]),
    );
  }

  Widget _buildMonolithCard(dynamic cert) {
    bool isExpired = DateTime.parse(
      cert.certificate.endDate,
    ).isBefore(DateTime.now());
    final accent = isExpired ? Colors.redAccent : const Color(0xFF00FFB2);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Stack(
        children: [
          // Background Glass
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  border: Border(left: BorderSide(color: accent, width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cert.certificate.regno.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                        Text(
                          isExpired ? "STATUS: HALTED" : "STATUS: ACTIVE",
                          style: TextStyle(
                            color: accent,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Monospace',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildRow("CLIENT", cert.client.name.toUpperCase()),
                    _buildRow("INSURER", cert.policy.insurer.toUpperCase()),
                    _buildRow("EXPIRY", cert.certificate.endDate),
                    const Divider(color: Colors.white10, height: 32),
                    Row(
                      children: [
                        const Text(
                          "PREMIUM: ",
                          style: TextStyle(color: Colors.white30, fontSize: 10),
                        ),
                        Text(
                          "KES ${cert.policy.premium}",
                          style: TextStyle(
                            color: accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Glitch Corner
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: accent),
                  right: BorderSide(color: accent),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white24,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              val,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomGlitchNav(
    CertificateState state,
    CertificateNotifier notifier,
  ) {
    final pagination = state.response?.pagination;
    if (pagination == null) return const SizedBox();

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navBtn(
            "PREV",
            pagination.currentPage > 1 ? notifier.previousPage : null,
          ),
          Text(
            "${pagination.currentPage} / ${pagination.lastPage}",
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Monospace',
              fontSize: 12,
            ),
          ),
          _navBtn(
            "NEXT",
            pagination.currentPage < pagination.lastPage
                ? notifier.nextPage
                : null,
          ),
        ],
      ),
    );
  }

  Widget _navBtn(String label, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: onTap == null ? Colors.white10 : const Color(0xFF00FFB2),
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    /* Logic stays the same */
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:insured/app_2/core/theme/custom_text_styles.dart';
// import 'package:insured/app_2/core/utils/formatHumanDate.dart';
// import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
// import 'package:insured/app_2/core/widgets/custom_text.dart';
// import 'package:insured/app_2/core/widgets/glass_card.dart';
// import 'package:insured/app_2/data/models/certificate_response.dart';
// // import 'package:insured/app_2/features/certificates/widgets/certificate_card.dart';
// import 'package:insured/app_2/providers/certificate_provider.dart';
// import 'package:intl/intl.dart';

// class CertificatesScreen extends ConsumerStatefulWidget {
//   const CertificatesScreen({super.key});

//   @override
//   ConsumerState<CertificatesScreen> createState() => _CertificatesScreenState();
// }

// class _CertificatesScreenState extends ConsumerState<CertificatesScreen> {
//   final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
//   DateTime? _startDate;
//   DateTime? _endDate;

//   @override
//   void initState() {
//     super.initState();
//     _initDatesFromState();
//   }

//   void _initDatesFromState() {
//     final state = ref.read(certificateProvider);
//     try {
//       _startDate = DateTime.parse(state.startDate);
//       _endDate = DateTime.parse(state.endDate);
//     } catch (_) {
//       final now = DateTime.now();
//       _startDate = DateTime(now.year, now.month, 1);
//       _endDate = DateTime(now.year, now.month + 1, 0);
//     }
//   }

//   Future<void> _selectDateRange() async {
//     final DateTime? start = await showDatePicker(
//       context: context,
//       initialDate: _startDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (start != null) {
//       final DateTime? end = await showDatePicker(
//         context: context,
//         initialDate: _endDate ?? start,
//         firstDate: start,
//         lastDate: DateTime.now().add(const Duration(days: 365)),
//       );
//       if (end != null) {
//         setState(() {
//           _startDate = start;
//           _endDate = end;
//         });
//         await ref
//             .read(certificateProvider.notifier)
//             .setDateRange(
//               start: _dateFormat.format(start),
//               end: _dateFormat.format(end),
//             );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(certificateProvider);
//     final notifier = ref.read(certificateProvider.notifier);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.refresh,
//               color: Theme.of(context).colorScheme.onSurface,
//             ),
//             onPressed: () => notifier.refreshCurrentPage(),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Date range selector
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: _selectDateRange,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 16,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withOpacity(0.05),
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.2),
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(Icons.date_range, color: Colors.white70),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               _startDate == null || _endDate == null
//                                   ? 'Select Date Range'
//                                   : '${_dateFormat.format(_startDate!)} – ${_dateFormat.format(_endDate!)}',
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           _buildPaginationControls(state, notifier),
//           Expanded(
//             child: state.isLoading && state.response == null
//                 ? const Center(child: CircularProgressIndicator())
//                 : state.error != null && state.response == null
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Error: ${state.error}',
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                         const SizedBox(height: 16),
//                         CustomAdvancedButton(
//                           width: 200,
//                           height: 40,
//                           label: 'Retry',
//                           onPressed: () => notifier.refreshCurrentPage(),
//                           variant: ButtonVariant.primary,
//                         ),
//                       ],
//                     ),
//                   )
//                 : state.response?.certificates.isEmpty ?? true
//                 ? const Center(
//                     child: CustomText(
//                       'No certificates found',
//                       type: CustomTextType.subHeader,
//                     ),
//                   )
//                 : _buildCertificateList(state),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaginationControls(
//     CertificateState state,
//     CertificateNotifier notifier,
//   ) {
//     final pagination = state.response?.pagination;
//     if (pagination == null) return const SizedBox();

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               const CustomText(
//                 // 'Items per page: ',
                    ' ',
//                 type: CustomTextType.paragraph,
//               ),
//               DropdownButton<int>(
//                 value: state.perPage,
//                 dropdownColor: const Color(0xFF1E293B),
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//                 items: [5, 10, 20, 50, 100].map((v) {
//                   return DropdownMenuItem(value: v, child: CustomText('$v'));
//                 }).toList(),
//                 onChanged: (val) {
//                   if (val != null) notifier.setPerPage(val);
//                 },
//               ),
//             ],
//           ),
//           Row(
//             children: [
//               CustomText(
//                 '${pagination.currentPage} of ${pagination.lastPage}',
//                 type: CustomTextType.paragraph,
//               ),
//               const SizedBox(width: 16),
//               IconButton(
//                 icon: Icon(
//                   Icons.chevron_left,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//                 onPressed: pagination.currentPage > 1
//                     ? () => notifier.previousPage()
//                     : null,
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.chevron_right,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//                 onPressed: pagination.currentPage < pagination.lastPage
//                     ? () => notifier.nextPage()
//                     : null,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCertificateList(CertificateState state) {
//     final certs = state.response!.certificates;
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: certs.length,
//       itemBuilder: (ctx, i) => Padding(
//         padding: const EdgeInsets.only(bottom: 12),
//         child: _buildCertificateCard(certs[i]),
//       ),
//     );
//   }

//   Widget _buildCertificateCard(Certificate cert) {
//     final currency = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.white.withOpacity(0.1)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: Colors.orange.withOpacity(0.2),
//                 child: Text(cert.client.name[0].toUpperCase()),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomText(
//                       cert.client.name,
//                       type: CustomTextType.subHeader,
//                     ),
//                     CustomText(
//                       'Certificate No: ${cert.certificate.number}',
//                       type: CustomTextType.caption,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           CustomText(
//             'Reg No: ${cert.certificate.regno}',
//             type: CustomTextType.paragraph,
//           ),
//           CustomText(
//             'Insurer: ${cert.policy.insurer}',
//             type: CustomTextType.paragraph,
//           ),
//           CustomText(
//             'Period: ${cert.certificate.startDate} → ${cert.certificate.endDate}',
//             type: CustomTextType.paragraph,
//           ),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CustomText(
//                 'Premium: ${currency.format(cert.policy.premium)}',
//                 type: CustomTextType.caption,
//               ),
//               CustomText(
//                 'Balance: ${currency.format(cert.policy.balance)}',
//                 type: CustomTextType.caption,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
