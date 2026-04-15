import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insured/app_2/core/constants/url_cosntants.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastS.dart';
import 'package:insured/app_2/features/policies/widgets/pesapal_payment_confirmation_modal.dart';

class PesapalPaymentModalStk {
  static void show(
    BuildContext context,
    Map<String, dynamic> paymentData, {
    required String token,
    required dynamic user,
    required double balance,
    required double installationBalance,
    VoidCallback? onPaymentConfirmed,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: 0.90,
          child: _StkPaymentWidget(
            paymentData: paymentData,
            token: token,
            user: user,
            balance: balance,
            installationBalance: installationBalance,
            onPaymentConfirmed: onPaymentConfirmed,
          ),
        );
      },
    );
  }
}

class _StkPaymentWidget extends StatefulWidget {
  final Map<String, dynamic> paymentData;
  final String token;
  final dynamic user;
  final double balance;
  final double installationBalance;
  final VoidCallback? onPaymentConfirmed;

  const _StkPaymentWidget({
    required this.paymentData,
    required this.token,
    required this.user,
    required this.balance,
    required this.installationBalance,
    this.onPaymentConfirmed,
  });

  @override
  State<_StkPaymentWidget> createState() => _StkPaymentWidgetState();
}

class _StkPaymentWidgetState extends State<_StkPaymentWidget> {
  bool loading = false;

  late TextEditingController amountController;
  late TextEditingController phoneController;
  bool isPhoneValid = false;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(
      text: widget.paymentData["amount"].toString(),
    );
    phoneController = TextEditingController(
      text: widget.paymentData["phone"].toString(),
    );

    phoneController.addListener(_validatePhone);

    // initial validation
    _validatePhone();
  }

  void _validatePhone() {
    final phone = phoneController.text.trim();

    final isValid = RegExp(r'^\d{10}$').hasMatch(phone);

    setState(() {
      isPhoneValid = isValid;
    });
  }

  Future<void> _sendStkPush() async {
    setState(() => loading = true);
    const baseUrl = InscloudUrls.stkPush;

    try {
      final updatedData = Map<String, dynamic>.from(widget.paymentData);
      updatedData["amount"] = amountController.text;
      updatedData["phone"] = phoneController.text;

      print("Herer is the updatedData being sent for STK Push: $updatedData");
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
          'X-Agent-Code': widget.user.agentCode,
          'X-Agent-Key': widget.user.agentKey,
        },
        body: jsonEncode(updatedData),
      );

      // if (response.statusCode == 200) {
      //   _showMessage(context, "STK push sent. Check your phone.", true);
      //   if (!mounted) return;
      //   Navigator.pop(context);
      // } else {

      print("STK Push response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        if (!mounted) return;

        // First pop the STK modal
        Navigator.pop(context);

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => PaymentConfirmationModal(
            onPaidSuccessfully: () {
              // Close confirmation modal
              // Navigator.pop(ctx);
              // Execute the success callback (will close policy modal, navigate, refresh, reopen)
              print(
                "debuggin if this runs on pesapal_payment_modal_stk.dart... y1 : widget.onPaymentConfirmed: ${widget.onPaymentConfirmed}",
              );
              widget.onPaymentConfirmed?.call();
            },
            onResend: () {
              // Close confirmation modal and re-show STK modal
              // Navigator.pop(ctx);
              // Re-show the STK modal with same parameters
              print(
                "debuggin if this runs on pesapal_payment_modal_stk.dart... y2 widget.onPaymentConfirmed: ${widget.onPaymentConfirmed}",
              );
              PesapalPaymentModalStk.show(
                context,
                widget.paymentData,
                token: widget.token,
                user: widget.user,
                balance: widget.balance,
                installationBalance: widget.installationBalance,
                onPaymentConfirmed: widget.onPaymentConfirmed,
              );
            },
          ),
        );
      } else {
        _showMessage(context, "Payment failed (${response.statusCode})", false);
        setState(() => loading = false);
      }
    } catch (e) {
      _showMessage(context, "Error sending payment: $e", false);
      // if (!mounted) return;
      // Navigator.pop(context);
      setState(() => loading = false);
    }
  }

  void _showMessage(BuildContext context, String message, bool success) {
    FuturisticToastS.show(
      context: context,
      message: message,
      icon: success ? Icons.check_circle : Icons.error,
      iconColor: success ? Colors.green[700] : Colors.redAccent,
      alignment: Alignment.topCenter,
    );
  }

  InputDecoration _inputDecoration(String label, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
      filled: true,
      fillColor: isDark
          ? Colors.white.withOpacity(0.08)
          : Colors.black.withOpacity(0.05),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final paymentData = widget.paymentData;
    final balance = widget.balance;
    final installationBalance = widget.installationBalance;

    // Light Mode specific colors
    final bgColor = isDark
        ? const Color(0xFF00FFB2).withOpacity(0.08)
        : Colors.white.withOpacity(0.9);

    final cardColor = isDark
        ? Colors.white.withOpacity(0.08)
        : Colors.grey[100];

    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle Bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: subTextColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40), // keeps title centered

                  CustomText(
                    "Confirm STK Payment",
                    color: textColor,
                    fontWeight: FontWeight.normal,
                    type: CustomTextType.subHeader,
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : Colors.black.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: loading
                            ? null
                            : () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close_rounded,
                          color: subTextColor,
                          size: 22,
                        ),
                        tooltip: "Cancel Transaction",
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText("Outstanding Balance:", color: subTextColor),
                        CustomText(
                          "${ceilCurrency(balance)}",
                          color: isDark
                              ? Colors.greenAccent
                              : Colors.green[700],
                          type: CustomTextType.subHeader,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          "Installation Balance:",
                          color: subTextColor,
                        ),
                        CustomText(
                          "${ceilCurrency(installationBalance)}",
                          color: isDark
                              ? Colors.greenAccent
                              : Colors.green[700],
                          type: CustomTextType.subHeader,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: isDark
                      ? null
                      : Border.all(color: Colors.black.withOpacity(0.03)),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.greenAccent : Colors.green[700],
                      ),
                      decoration: _inputDecoration("Amount (KES)", isDark),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: textColor),
                      decoration: _inputDecoration("Phone Number", isDark),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      "Account: ${paymentData["account"]}",
                      style: TextStyle(color: subTextColor, fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// INSTRUCTIONS
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withOpacity(0.35)
                      : Colors.blueGrey[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: isDark ? Colors.white60 : Colors.blueGrey,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "You will receive an M-Pesa prompt. Enter your PIN to pay.",
                        style: TextStyle(color: subTextColor, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// PAY BUTTON
              CustomAdvancedButton(
                label: 'Click To Pay',
                variant: ButtonVariant.payBtn,
                loading: loading,
                // isDisabled: true,
                isDisabled: !isPhoneValid || loading,
                onPressed: loading ? () {} : _sendStkPush,
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
