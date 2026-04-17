import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/icon_scale_helper.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';

class cardWithChild extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;
  final Color? iconColor;

  const cardWithChild({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return GlassCard(
      blur: 20,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isLightMode ? Colors.green[900] : Colors.greenAccent,
                // iconColor ??
                size: responsiveIconSize(context),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(title, type: CustomTextType.subHeader),
                    CustomText(subtitle, type: CustomTextType.caption),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white24),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
