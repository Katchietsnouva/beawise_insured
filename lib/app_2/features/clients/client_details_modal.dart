import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientDetailsModal extends StatelessWidget {
  final Client client;

  const ClientDetailsModal({super.key, required this.client});

  Future<void> _callClient(String phone) async {
    final Uri uri = Uri.parse("tel:$phone");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String normalizePhone(String phone) {
    if (phone.startsWith("0")) {
      return "+254${phone.substring(1)}";
    }
    return phone;
  }

  Future<void> _sendEmail(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri.encodeFull(
        'subject=Insurance Inquiry&body=Hello ${client.name},',
      ),
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Color(0xFF00FFB2).withOpacity(0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomText(
                      client.name,
                      type: CustomTextType.subHeader,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              Divider(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),

              const SizedBox(height: 12),

              _buildDetailRow('Client No', client.client_no),
              _buildDetailRow('Email', client.email),
              _buildDetailRow('Mobile', client.mobile),
              _buildDetailRow('Status', client.status ?? 'Unknown'),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: _actionButton(
                      icon: Icons.phone,
                      label: "Call Client",
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.greenAccent
                          : Color.fromARGB(255, 19, 72, 23),
                      // onTap: () => _callClient(client.mobile),
                      onTap: () => _callClient(normalizePhone(client.mobile)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _actionButton(
                      icon: Icons.email,
                      label: "Send Email",
                      color: Colors.blueAccent,
                      onTap: () => _sendEmail(client.email),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(label, type: CustomTextType.paragraph),
          CustomText(value, type: CustomTextType.caption),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
