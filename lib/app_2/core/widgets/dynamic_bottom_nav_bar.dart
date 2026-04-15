import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/providers/current_screen_title_provider.dart';

class DynamicBottomNavBar extends ConsumerWidget {
  const DynamicBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTitle = ref.watch(currentScreenTitleProvider);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(
        context,
      ).colorScheme.onSurface.withOpacity(0.6),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      currentIndex: 0, // Not used for selection, just for appearance
      onTap: (index) {
        if (index == 0) {
          // Home
          context.go('/dashboard');
        } else {
          // If the dynamic item is tapped, we could optionally do nothing,
          // or we could refresh the current page. For now, we do nothing.
        }
      },
      items: [
        const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
          icon: const Icon(Icons.location_city),
          label: currentTitle,
        ),
      ],
    );
  }
}
