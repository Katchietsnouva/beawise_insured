import 'package:flutter/material.dart';

class BadgePremium extends StatelessWidget {
  final String text;

  const BadgePremium({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isDark ? Colors.greenAccent : Colors.green[900],
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
