import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:intl/intl.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';

class PolicyDetailsModal extends StatelessWidget {
  final dynamic policyEntry;
  const PolicyDetailsModal({super.key, required this.policyEntry});

  @override
  Widget build(BuildContext context) {
    final policy = policyEntry.policy ?? policyEntry['policy'];
    final client = policyEntry.client ?? policyEntry['client'];
    final currency = NumberFormat.currency(locale: 'en_US', symbol: 'KES ');

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
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
                      Text(
                        client?.name ?? 'Unknown Client',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Policy: ${policy?.risknote ?? policy?.policyNo ?? 'N/A'}',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const Divider(color: Colors.white10, height: 32),

              Row(
                children: [
                  _buildStatCard(
                    'Premium',
                    ceilCurrency(policy?.amount ?? 0),
                    Icons.account_balance_wallet,
                    Colors.greenAccent,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    'Sum Insured',
                    ceilCurrency(policy?.sumInsured ?? 0),
                    Icons.shield,
                    Colors.blueAccent,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Policy Details
              const Text(
                "Policy Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              // _buildDetailRow('Risk Note', policy?.risknote ?? 'N/A'),
              _buildDetailRow(
                'Risk Note',
                policy?.risknote?.toString() ?? 'N/A',
              ),
              _buildDetailRow('Insurer', policy?.insurer ?? 'N/A'),
              _buildDetailRow('Product', policy?.product ?? 'N/A'),
              _buildDetailRow(
                'Period',
                // '${policy?.starting ?? ''} → ${policy?.ending ?? ''}',
                '${formatHumanDate(policy?.starting ?? '')} → ${formatHumanDate(policy?.ending ?? '')}',
              ),

              if (policy?.reg != null)
                _buildDetailRow('Registration', policy!.reg),
              _buildDetailRow(
                'Sum Insured',
                ceilCurrency(policy?.sumInsured ?? 0),
              ),
              _buildDetailRow('Premium', ceilCurrency(policy?.amount ?? 0)),
              _buildDetailRow('Balance', ceilCurrency(policy?.balance ?? 0)),
              _buildDetailRow(
                'Commission',
                ceilCurrency(policy?.commission ?? 0),
              ),

              _buildDetailRow('Transaction', policy?.transaction ?? 'N/A'),

              const SizedBox(height: 24),

              const Text(
                "Client Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              _buildDetailRow('Client No', client?.clientNo ?? 'N/A'),
              _buildDetailRow('Phone', client?.mobile ?? 'N/A'),
              _buildDetailRow('Email', client?.email ?? 'N/A'),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
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
