import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/data/models/quote_old_model.dart';

class QuoteDetailScreenOld extends StatelessWidget {
  final Quote_old quote;
  const QuoteDetailScreenOld({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    // final quote = ModalRoute.of(context)!.settings.arguments as Quote;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quote #${quote.id}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Quote Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              _detailRow('Quote ID', quote.id),
              _detailRow('Client ID', quote.clientId),
              _detailRow('Amount', '\$${quote.amount.toStringAsFixed(2)}'),
              _detailRow('Status', quote.status.toUpperCase()),
              const SizedBox(height: 24),
              Center(
                child: CustomAdvancedButton(
                  label: 'Generate PDF',
                  variant: ButtonVariant.secondary,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
