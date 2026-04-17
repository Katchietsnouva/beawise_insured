import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/profile_avatar.dart';

class DashboardHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onNewClient;

  const DashboardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onNewClient,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.white70)),
          ],
        ),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: onNewClient,
              icon: const Icon(Icons.add),
              label: const Text('New Client'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const ProfileAvatar(),
          ],
        ),
      ],
    );
  }
}
