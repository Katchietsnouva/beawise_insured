import 'package:flutter/material.dart';

class IdBadge extends StatelessWidget {
  final String? id;
  final Color color;
  final bool uppercase;

  const IdBadge({
    super.key,
    this.id,
    this.color = Colors.blue,
    this.uppercase = true,
  });

  String get _displayText => (id?.isNotEmpty ?? false) ? id! : 'N/A';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        uppercase ? _displayText.toUpperCase() : _displayText,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
