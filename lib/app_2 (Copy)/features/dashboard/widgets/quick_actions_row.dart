import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/card_animation_layout.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';

class QuickActionsRow extends StatelessWidget {
  final VoidCallback onNewClient;
  final VoidCallback onViewQuotes;
  const QuickActionsRow({
    super.key,
    required this.onNewClient,
    required this.onViewQuotes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: CardAnimationLayout(
              index: 5,
              child: _buildActionCard(
                context: context,
                icon: Icons.person_add,
                title: 'Add New Client',
                // subtitle: 'Scan ID to auto-fill details',
                subtitle: 'Enter new client information',
                onTap: onNewClient,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CardAnimationLayout(
              index: 6,
              child: _buildActionCard(
                context: context,
                icon: Icons.description,
                title: 'Generate Quotes',
                subtitle: 'Quick and simple quotes',
                onTap: onViewQuotes,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: Theme.of(context).brightness == Brightness.light ? 4 : 6,
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
                size: 32,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      title,
                      type: CustomTextType.paragraph,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      subtitle,
                      type: CustomTextType.caption,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
