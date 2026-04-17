import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that formats API responses beautifully.
class ResponseDisplay extends StatelessWidget {
  final ResponseType type;
  final String? message;
  final Map<String, dynamic>? rawData;
  final String? token;
  final Map<String, List<String>>? fieldErrors;
  final int? otpExpiryMinutes;

  const ResponseDisplay.success({
    Key? key,
    required this.message,
    required this.rawData,
    this.token,
    this.otpExpiryMinutes,
  }) : type = ResponseType.success,
       fieldErrors = null,
       super(key: key);

  const ResponseDisplay.error({
    Key? key,
    required this.message,
    required this.rawData,
    this.fieldErrors,
  }) : type = ResponseType.error,
       token = null,
       otpExpiryMinutes = null,
       super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and status
          Row(
            children: [
              Icon(
                type == ResponseType.success ? Icons.check_circle : Icons.error,
                color: type == ResponseType.success
                    ? Colors.greenAccent
                    : Colors.redAccent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                type == ResponseType.success ? 'Success' : 'Error',
                style: TextStyle(
                  color: type == ResponseType.success
                      ? Colors.greenAccent
                      : Colors.redAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Message
          if (message != null && message!.isNotEmpty) ...[
            Text(
              message!,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 12),
          ],
          // Token if present
          if (token != null) ...[
            _buildInfoRow(context, 'Token', token!, canCopy: true),
            const SizedBox(height: 8),
          ],
          // OTP expiry
          if (otpExpiryMinutes != null) ...[
            _buildInfoRow(context, 'OTP Expires', '$otpExpiryMinutes minutes'),
            const SizedBox(height: 8),
          ],
          // Field errors
          if (fieldErrors != null && fieldErrors!.isNotEmpty) ...[
            const Text(
              'Validation Errors:',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            ...fieldErrors!.entries.expand((entry) {
              return entry.value.map((errorMsg) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      Expanded(
                        child: Text(
                          '${entry.key}: $errorMsg',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
            }).toList(),
          ],
          // Copy raw JSON button
          if (rawData != null) ...[
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: jsonEncode(rawData)));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Raw JSON copied to clipboard'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.copy, size: 16, color: Colors.white70),
                label: const Text(
                  'Copy Raw JSON',
                  style: TextStyle(color: Colors.white70),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool canCopy = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ),
        Expanded(
          child: canCopy
              ? GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied!'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Text(
                          value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.copy, size: 14, color: Colors.white54),
                    ],
                  ),
                )
              : Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
        ),
      ],
    );
  }
}

enum ResponseType { success, error }
