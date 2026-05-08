import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';

class PaymentConfirmationModal extends StatefulWidget {
  final VoidCallback onPaidSuccessfully;
  final VoidCallback onResend;
  final String account;
  final String amount;
  final String businessNo;

  const PaymentConfirmationModal({
    super.key,
    required this.onPaidSuccessfully,
    required this.onResend,
    required this.account,
    required this.amount,
    this.businessNo = "247247",
  });

  @override
  State<PaymentConfirmationModal> createState() =>
      _PaymentConfirmationModalState();
}

class _PaymentConfirmationModalState extends State<PaymentConfirmationModal>
    with SingleTickerProviderStateMixin {
  bool _showOptions = false;

  late final AnimationController _chevronController;
  late final Animation<double> _chevronAngle;

  @override
  void initState() {
    super.initState();
    _chevronController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _chevronAngle = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _chevronController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _chevronController.dispose();
    super.dispose();
  }

  void _toggleOptions() {
    setState(() {
      _showOptions = !_showOptions;
      if (_showOptions) {
        _chevronController.forward();
      } else {
        _chevronController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? const Color(0xFF00FFB2).withOpacity(0.08)
        : Colors.white.withOpacity(0.9);

    return FractionallySizedBox(
      alignment: Alignment.bottomCenter,
      heightFactor: 0.80,

      // child: Container(
      //   padding: const EdgeInsets.all(24),
      //   decoration: BoxDecoration(
      //     color: bgColor,

      //     borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      //   ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ), // Apply the blur effect
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 20),
                Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: isDark ? Colors.greenAccent : Colors.green,
                ),
                const SizedBox(height: 16),
                CustomText('STK Push Sent', type: CustomTextType.subHeader),
                const SizedBox(height: 8),
                Text(
                  'Check your phone and enter your M‑Pesa PIN.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: CustomAdvancedButton(
                        label: 'Paid Successfully?',
                        variant: ButtonVariant.primary,
                        color1: isDark ? Colors.greenAccent : Colors.green[900],
                        color2: Colors.teal,
                        textColor: isDark ? Colors.black : Colors.white,
                        onPressed: () {
                          widget.onPaidSuccessfully();
                          print(
                            "Paid Successfully clicked in PaymentConfirmationModal... x onPaidSuccessfully: ${widget.onPaidSuccessfully}",
                          );
                          // Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── "Didn't receive a push?" toggle row ──────────────────────
                GestureDetector(
                  onTap: _toggleOptions,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.03),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : Colors.black.withOpacity(0.07),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText("Didn't receive a push?"),
                        RotationTransition(
                          turns: _chevronAngle,
                          child: Icon(
                            Icons.expand_more_rounded,
                            color: isDark
                                ? Colors.greenAccent
                                : Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Collapsible options panel ────────────────────────────────
                AnimatedSize(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOut,
                  child: _showOptions
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),

                            // ── SECTION A ── Option 1: Restart payment ───────
                            _SectionCard(
                              isDark: isDark,
                              label: "Section A",
                              title: "Option 1: Restart payment",
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomAdvancedButton(
                                      label: 'Resend Payment',
                                      variant: ButtonVariant.secondary,
                                      onPressed: () {
                                        print(
                                          "Resend Payment clicked in PaymentConfirmationModal... x onResend: ${widget.onResend}",
                                        );
                                        Navigator.pop(context);
                                        widget.onResend();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── SECTION B ── Option 2: Manual Paybill ────────
                            _SectionCard(
                              isDark: isDark,
                              label: "Section B",
                              title: "Option 2: You can also send through:",
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: isDark
                                          ? Colors.white.withOpacity(0.06)
                                          : Colors.black.withOpacity(0.04),
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.white.withOpacity(0.08)
                                            : Colors.black.withOpacity(0.08),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .account_balance_wallet_outlined,
                                              color: isDark
                                                  ? Colors.greenAccent
                                                  : Colors.green[800],
                                            ),
                                            const SizedBox(width: 10),
                                            CustomText(
                                              "M-Pesa Paybill",
                                              type: CustomTextType.subHeader,
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 16),

                                        _buildPaymentRow(
                                          context,
                                          "Business No.",
                                          widget.businessNo,
                                        ),

                                        const SizedBox(height: 12),

                                        _buildPaymentRow(
                                          context,
                                          "Account",
                                          widget.account,
                                        ),

                                        const SizedBox(height: 12),

                                        _buildPaymentRow(
                                          context,
                                          "Amount",
                                          "KES ${widget.amount}",
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomAdvancedButton(
                                          label:
                                              'Click here if Completed Payment successfully',
                                          variant: ButtonVariant.secondary,
                                          color1: isDark
                                              ? Colors.greenAccent
                                              : Colors.green[900],
                                          color2: Colors.teal,
                                          textColor: isDark
                                              ? Colors.black
                                              : Colors.white,
                                          onPressed: () {
                                            widget.onPaidSuccessfully();

                                            print(
                                              "Manual payment confirmation clicked... onPaidSuccessfully: ${widget.onPaidSuccessfully}",
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Reusable section card wrapper ──────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final bool isDark;
  final String label;
  final String title;
  final Widget child;

  const _SectionCard({
    required this.isDark,
    required this.label,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark
            ? Colors.white.withOpacity(0.04)
            : Colors.black.withOpacity(0.02),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : Colors.black.withOpacity(0.06),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.75),
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

Widget _buildPaymentRow(BuildContext context, String label, String value) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
      ),

      SelectableText(
        value,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    ],
  );
}

// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
// import 'package:insured/app_2/core/widgets/custom_text.dart';

// class PaymentConfirmationModal extends StatefulWidget {
//   final VoidCallback onPaidSuccessfully;
//   final VoidCallback onResend;
//   final String account;
//   final String amount;
//   final String businessNo;

//   const PaymentConfirmationModal({
//     super.key,
//     required this.onPaidSuccessfully,
//     required this.onResend,
//     required this.account,
//     required this.amount,
//     this.businessNo = "247247",
//   });

//   @override
//   State<PaymentConfirmationModal> createState() =>
//       _PaymentConfirmationModalState();
// }

// class _PaymentConfirmationModalState extends State<PaymentConfirmationModal> {
//   bool showRestartSection = false;
//   bool showManualSection = false;

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     final bgColor = isDark
//         ? const Color(0xFF00FFB2).withOpacity(0.08)
//         : Colors.white.withOpacity(0.92);

//     return FractionallySizedBox(
//       alignment: Alignment.bottomCenter,
//       heightFactor: 0.82,
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
//         child: Container(
//           padding: const EdgeInsets.all(24),
//           decoration: BoxDecoration(
//             color: bgColor,
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 /// HANDLE
//                 Container(
//                   width: 50,
//                   height: 5,
//                   decoration: BoxDecoration(
//                     color: Theme.of(
//                       context,
//                     ).colorScheme.onSurface.withOpacity(0.3),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 /// ICON
//                 Icon(
//                   Icons.check_circle_outline,
//                   size: 64,
//                   color: isDark ? Colors.greenAccent : Colors.green,
//                 ),

//                 const SizedBox(height: 16),

//                 /// TITLE
//                 CustomText('STK Push Sent', type: CustomTextType.subHeader),

//                 const SizedBox(height: 8),

//                 /// SUBTITLE
//                 Text(
//                   'Check your phone and enter your M-Pesa PIN.',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Theme.of(
//                       context,
//                     ).colorScheme.onSurface.withOpacity(0.7),
//                   ),
//                 ),

//                 const SizedBox(height: 24),

//                 /// PRIMARY ACTION
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CustomAdvancedButton(
//                         label: 'Paid Successfully?',
//                         variant: ButtonVariant.primary,
//                         color1: isDark ? Colors.greenAccent : Colors.green[900],
//                         color2: Colors.teal,
//                         textColor: isDark ? Colors.black : Colors.white,
//                         onPressed: () {
//                           widget.onPaidSuccessfully();

//                           print(
//                             "Paid Successfully clicked in PaymentConfirmationModal...",
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 28),

//                 /// ACCORDIONS
//                 Theme(
//                   data: Theme.of(
//                     context,
//                   ).copyWith(dividerColor: Colors.transparent),
//                   child: Column(
//                     children: [
//                       /// OPTION 1
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(18),
//                           color: isDark
//                               ? Colors.white.withOpacity(0.05)
//                               : Colors.black.withOpacity(0.03),
//                         ),
//                         child: ExpansionTile(
//                           initiallyExpanded: showRestartSection,
//                           onExpansionChanged: (value) {
//                             setState(() {
//                               showRestartSection = value;

//                               if (value) {
//                                 showManualSection = false;
//                               }
//                             });
//                           },
//                           tilePadding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                           ),
//                           childrenPadding: const EdgeInsets.fromLTRB(
//                             16,
//                             0,
//                             16,
//                             16,
//                           ),
//                           leading: Icon(
//                             Icons.refresh_rounded,
//                             color: isDark
//                                 ? Colors.greenAccent
//                                 : Colors.green[700],
//                           ),
//                           trailing: AnimatedRotation(
//                             turns: showRestartSection ? 0.5 : 0,
//                             duration: const Duration(milliseconds: 250),
//                             child: Icon(
//                               Icons.keyboard_arrow_down_rounded,
//                               color: Theme.of(
//                                 context,
//                               ).colorScheme.onSurface.withOpacity(0.7),
//                             ),
//                           ),
//                           title: CustomText("Didn't receive a push?"),
//                           children: [
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: CustomAdvancedButton(
//                                     label: 'Resend Payment',
//                                     variant: ButtonVariant.secondary,
//                                     onPressed: () {
//                                       Navigator.pop(context);

//                                       widget.onResend();
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 18),

//                       /// OPTION 2
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(18),
//                           color: isDark
//                               ? Colors.white.withOpacity(0.05)
//                               : Colors.black.withOpacity(0.03),
//                         ),
//                         child: ExpansionTile(
//                           initiallyExpanded: showManualSection,
//                           onExpansionChanged: (value) {
//                             setState(() {
//                               showManualSection = value;

//                               if (value) {
//                                 showRestartSection = false;
//                               }
//                             });
//                           },
//                           tilePadding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                           ),
//                           childrenPadding: const EdgeInsets.fromLTRB(
//                             16,
//                             0,
//                             16,
//                             16,
//                           ),
//                           leading: Icon(
//                             Icons.account_balance_wallet_outlined,
//                             color: isDark
//                                 ? Colors.greenAccent
//                                 : Colors.green[700],
//                           ),
//                           trailing: AnimatedRotation(
//                             turns: showManualSection ? 0.5 : 0,
//                             duration: const Duration(milliseconds: 250),
//                             child: Icon(
//                               Icons.keyboard_arrow_down_rounded,
//                               color: Theme.of(
//                                 context,
//                               ).colorScheme.onSurface.withOpacity(0.7),
//                             ),
//                           ),
//                           title: CustomText("Pay manually via M-Pesa"),
//                           children: [
//                             const SizedBox(height: 12),

//                             /// PAYBILL CARD
//                             Container(
//                               width: double.infinity,
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(20),
//                                 color: isDark
//                                     ? Colors.white.withOpacity(0.04)
//                                     : Colors.black.withOpacity(0.03),
//                                 border: Border.all(
//                                   color: isDark
//                                       ? Colors.white.withOpacity(0.08)
//                                       : Colors.black.withOpacity(0.08),
//                                 ),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Icon(
//                                         Icons.account_balance_wallet_outlined,
//                                         color: isDark
//                                             ? Colors.greenAccent
//                                             : Colors.green[800],
//                                       ),

//                                       const SizedBox(width: 10),

//                                       CustomText(
//                                         "M-Pesa Paybill",
//                                         type: CustomTextType.subHeader,
//                                       ),
//                                     ],
//                                   ),

//                                   const SizedBox(height: 16),

//                                   _buildPaymentRow(
//                                     context,
//                                     "Business No.",
//                                     widget.businessNo,
//                                   ),

//                                   const SizedBox(height: 12),

//                                   _buildPaymentRow(
//                                     context,
//                                     "Account",
//                                     widget.account,
//                                   ),

//                                   const SizedBox(height: 12),

//                                   _buildPaymentRow(
//                                     context,
//                                     "Amount",
//                                     "KES ${widget.amount}",
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             const SizedBox(height: 18),

//                             /// MANUAL CONFIRM BUTTON
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: CustomAdvancedButton(
//                                     label: 'I Have Completed Payment',
//                                     variant: ButtonVariant.primary,
//                                     color1: isDark
//                                         ? Colors.greenAccent
//                                         : Colors.green[900],
//                                     color2: Colors.teal,
//                                     textColor: isDark
//                                         ? Colors.black
//                                         : Colors.white,
//                                     onPressed: () {
//                                       widget.onPaidSuccessfully();
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _buildPaymentRow(BuildContext context, String label, String value) {
//   final isDark = Theme.of(context).brightness == Brightness.dark;

//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Text(
//         label,
//         style: TextStyle(
//           fontSize: 14,
//           color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
//         ),
//       ),

//       SelectableText(
//         value,
//         style: TextStyle(
//           fontSize: 15,
//           fontWeight: FontWeight.bold,
//           color: isDark ? Colors.white : Colors.black,
//         ),
//       ),
//     ],
//   );
// }

// // import 'dart:ui';

// // import 'package:flutter/material.dart';
// // import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
// // import 'package:insured/app_2/core/widgets/custom_text.dart';

// // class PaymentConfirmationModal extends StatelessWidget {
// //   final VoidCallback onPaidSuccessfully;
// //   final VoidCallback onResend;
// //   final String account;
// //   final String amount;
// //   final String businessNo;

// //   const PaymentConfirmationModal({
// //     super.key,
// //     required this.onPaidSuccessfully,
// //     required this.onResend,
// //     required this.account,
// //     required this.amount,
// //     this.businessNo = "247247",
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final isDark = Theme.of(context).brightness == Brightness.dark;
// //     final bgColor = isDark
// //         ? const Color(0xFF00FFB2).withOpacity(0.08)
// //         : Colors.white.withOpacity(0.9);

// //     return FractionallySizedBox(
// //       alignment: Alignment.bottomCenter,
// //       heightFactor: 0.80,

// //       // child: Container(
// //       //   padding: const EdgeInsets.all(24),
// //       //   decoration: BoxDecoration(
// //       //     color: bgColor,

// //       //     borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
// //       //   ),
// //       child: BackdropFilter(
// //         filter: ImageFilter.blur(
// //           sigmaX: 10.0,
// //           sigmaY: 10.0,
// //         ), // Apply the blur effect
// //         child: Container(
// //           padding: const EdgeInsets.all(24),
// //           decoration: BoxDecoration(
// //             color: bgColor,
// //             borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
// //           ),
// //           child: SingleChildScrollView(
// //             child: Column(
// //               mainAxisSize: MainAxisSize.min,
// //               children: [
// //                 Container(
// //                   width: 50,
// //                   height: 5,
// //                   decoration: BoxDecoration(
// //                     color: Theme.of(
// //                       context,
// //                     ).colorScheme.onSurface.withOpacity(0.3),
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 Icon(
// //                   Icons.check_circle_outline,
// //                   size: 64,
// //                   color: isDark ? Colors.greenAccent : Colors.green,
// //                 ),
// //                 const SizedBox(height: 16),
// //                 CustomText('STK Push Sent', type: CustomTextType.subHeader),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   'Check your phone and enter your M‑Pesa PIN.',
// //                   textAlign: TextAlign.center,
// //                   style: TextStyle(
// //                     color: Theme.of(
// //                       context,
// //                     ).colorScheme.onSurface.withOpacity(0.7),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 24),
// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: CustomAdvancedButton(
// //                         label: 'Paid Successfully?',
// //                         variant: ButtonVariant.primary,
// //                         color1: isDark ? Colors.greenAccent : Colors.green[900],
// //                         color2: Colors.teal,
// //                         textColor: isDark ? Colors.black : Colors.white,
// //                         onPressed: () {
// //                           onPaidSuccessfully();
// //                           print(
// //                             "Paid Successfully clicked in PaymentConfirmationModal... x onPaidSuccessfully: $onPaidSuccessfully",
// //                           );
// //                           // Navigator.pop(context);
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),

// //                 const SizedBox(height: 24),
// //                 // CustomText("Didn't receive a push?"),
// //                 Center(
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     children: [
// //                       CustomAdvancedButton(
// //                         label: "Didn't receive a push?",
// //                         variant: ButtonVariant.text,
// //                         onPressed: () {
// //                           print("Toggling on didnt reeive a push");
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 const SizedBox(height: 12),

// //                 Row(
// //                   children: [
// //                     CustomText("Option 1:"),
// //                     CustomText("Restart payment:"),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 12),

// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: CustomAdvancedButton(
// //                         label: 'Resend Payment',
// //                         variant: ButtonVariant.secondary,
// //                         onPressed: () {
// //                           print(
// //                             "Resend Payment clicked in PaymentConfirmationModal... x onResend: $onResend",
// //                           );
// //                           Navigator.pop(context);
// //                           onResend();
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),

// //                 const SizedBox(height: 24),
// //                 Row(
// //                   children: [
// //                     CustomText("Option 2:"),
// //                     CustomText("You can also send through:"),
// //                   ],
// //                 ),

// //                 const SizedBox(height: 12),

// //                 Container(
// //                   width: double.infinity,
// //                   padding: const EdgeInsets.all(16),
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(20),
// //                     color: isDark
// //                         ? Colors.white.withOpacity(0.06)
// //                         : Colors.black.withOpacity(0.04),
// //                     border: Border.all(
// //                       color: isDark
// //                           ? Colors.white.withOpacity(0.08)
// //                           : Colors.black.withOpacity(0.08),
// //                     ),
// //                   ),
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           Icon(
// //                             Icons.account_balance_wallet_outlined,
// //                             color: isDark
// //                                 ? Colors.greenAccent
// //                                 : Colors.green[800],
// //                           ),
// //                           const SizedBox(width: 10),
// //                           CustomText(
// //                             "M-Pesa Paybill",
// //                             type: CustomTextType.subHeader,
// //                           ),
// //                         ],
// //                       ),

// //                       const SizedBox(height: 16),

// //                       _buildPaymentRow(context, "Business No.", businessNo),

// //                       const SizedBox(height: 12),

// //                       _buildPaymentRow(context, "Account", account),

// //                       const SizedBox(height: 12),

// //                       _buildPaymentRow(context, "Amount", "KES $amount"),
// //                     ],
// //                   ),
// //                 ),

// //                 Row(
// //                   children: [
// //                     Expanded(
// //                       child: CustomAdvancedButton(
// //                         label: 'Click here if Completed Payment successfully',
// //                         variant: ButtonVariant.secondary,
// //                         color1: isDark ? Colors.greenAccent : Colors.green[900],
// //                         color2: Colors.teal,
// //                         textColor: isDark ? Colors.black : Colors.white,
// //                         onPressed: () {
// //                           onPaidSuccessfully();

// //                           print(
// //                             "Manual payment confirmation clicked... onPaidSuccessfully: $onPaidSuccessfully",
// //                           );
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),

// //                 const SizedBox(height: 20),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // Widget _buildPaymentRow(BuildContext context, String label, String value) {
// //   final isDark = Theme.of(context).brightness == Brightness.dark;

// //   return Row(
// //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //     children: [
// //       Text(
// //         label,
// //         style: TextStyle(
// //           fontSize: 14,
// //           color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
// //         ),
// //       ),

// //       SelectableText(
// //         value,
// //         style: TextStyle(
// //           fontSize: 15,
// //           fontWeight: FontWeight.bold,
// //           color: isDark ? Colors.white : Colors.black,
// //         ),
// //       ),
// //     ],
// //   );
// // }
