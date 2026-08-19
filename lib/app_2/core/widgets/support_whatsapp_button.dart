import 'package:flutter/material.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportWhatsappButton extends StatefulWidget {
  final bool compact;

  const SupportWhatsappButton({super.key, this.compact = false});

  @override
  State<SupportWhatsappButton> createState() => _SupportWhatsappButtonState();
}

class _SupportWhatsappButtonState extends State<SupportWhatsappButton> {
  late final Future<String> _supportFuture = _loadSupport();

  Future<String> _loadSupport() async {
    try {
      return await ApiService.getAppSupport();
    } catch (_) {
      return 'Support number to reach...';
    }
  }

  String? _localSupportNumber(String supportText) {
    final match = RegExp(r'0(?:[\s().-]*\d){9}').firstMatch(supportText);
    if (match == null) return null;
    final digits = match.group(0)!.replaceAll(RegExp(r'\D'), '');
    return digits.length == 10 ? digits : null;
  }

  Future<void> _openWhatsapp(String supportText) async {
    final localNumber = _localSupportNumber(supportText);
    if (localNumber == null) return;
    final number = '254${localNumber.substring(1)}';
    final uri = Uri.parse('https://wa.me/$number');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF25D366);
    return FutureBuilder<String>(
      future: _supportFuture,
      builder: (context, snapshot) {
        final text = snapshot.data;
        final localNumber = text == null ? null : _localSupportNumber(text);
        final label = widget.compact
            ? 'WhatsApp'
            : localNumber == null
            ? 'WhatsApp Support'
            : 'WhatsApp: $localNumber';
        return Semantics(
          button: true,
          label: 'Contact support on WhatsApp',
          child: TextButton.icon(
            onPressed: text == null || localNumber == null
                ? null
                : () => _openWhatsapp(text),
            icon: Icon(Icons.chat_rounded, color: color, size: 18),
            label: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
          ),
        );
      },
    );
  }
}
