import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/providers/settings_provider.dart';

class GhostCard extends ConsumerWidget {
  const GhostCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isLightMode = settings.themeMode == 'Light';

    final baseColor = isLightMode
        ? Colors.black.withOpacity(0.15)
        : Colors.white.withOpacity(0.03);

    final borderColor = isLightMode
        ? Colors.black.withOpacity(0.16)
        : Colors.white.withOpacity(0.05);

    final shimmerColor = isLightMode
        ? Colors.black.withOpacity(0.18)
        : Colors.white.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: shimmerColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 120, height: 16, color: shimmerColor),
                const SizedBox(height: 8),
                Container(width: 80, height: 12, color: shimmerColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
