import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/core/services/api_service.dart';

class PesapalPaymentModal extends StatefulWidget {
  final double amount;
  final String riskNote;
  final String clientName;
  final String insurer;

  const PesapalPaymentModal({
    super.key,
    required this.amount,
    required this.riskNote,
    required this.clientName,
    required this.insurer,
  });

  @override
  State<PesapalPaymentModal> createState() => _PesapalPaymentModalState();
}

class _PesapalPaymentModalState extends State<PesapalPaymentModal> {
  String? redirectUrl;
  String? orderTrackingId;
  String? paymentStatus;
  bool loading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _initiatePesapal();
  }

  Future<void> _initiatePesapal() async {
    try {
      final orderId =
          'POL-${widget.riskNote}-${DateTime.now().millisecondsSinceEpoch}';

      final data = await ApiService.submitPesapalOrder(
        orderId: orderId,
        amount: widget.amount,
        description: 'Policy Payment - Risk Note ${widget.riskNote}',
        phone: '254759924037',
        email: 'philipaswa01@gmail.com',
        callbackUrl:
            'https://yourapp.com/payment/callback', // change to your real callback
      );

      if (data['redirect_url'] != null) {
        setState(() {
          redirectUrl = data['redirect_url'];
          orderTrackingId = data['order_tracking_id'];
          loading = false;
        });
        _startPolling();
      } else {
        setState(() => hasError = true);
      }
    } catch (e) {
      setState(() => hasError = true);
    }
  }

  void _startPolling() {
    if (orderTrackingId == null) return;
    Future.delayed(const Duration(seconds: 5), () async {
      if (!mounted) return;
      final status = await ApiService.getPesapalStatus(orderTrackingId!);
      setState(
        () => paymentStatus =
            status['payment_status_description'] ?? 'Processing...',
      );

      if (status['status_code'] == 1) {
        if (mounted) Navigator.pop(context);
      } else {
        _startPolling();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF00FFB2).withOpacity(0.1),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  'Complete Payment',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Amount Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      'KSH ${widget.amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),
                    Text(
                      'Risk Note: ${widget.riskNote}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      widget.clientName,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              if (loading)
                const CircularProgressIndicator(color: Colors.white)
              else if (hasError)
                const Text(
                  'Payment failed. Try again.',
                  style: TextStyle(color: Colors.redAccent),
                )
              else if (redirectUrl != null)
                SizedBox(
                  height: 500,
                  child: WebViewWidget(
                    controller: WebViewController()
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..loadRequest(Uri.parse(redirectUrl!)),
                  ),
                ),

              if (paymentStatus != null)
                Text(
                  'Status: $paymentStatus',
                  style: const TextStyle(color: Colors.white70),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
