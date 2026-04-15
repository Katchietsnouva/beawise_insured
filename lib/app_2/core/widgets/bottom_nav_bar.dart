import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final String currentRoute;

  const BottomNavBar({super.key, required this.currentRoute});

  // Define the navigation items with their route paths, labels, and icons
  static const List<_NavItem> _items = [
    _NavItem(route: '/dashboard', label: 'Dashboard', icon: Icons.dashboard),
    _NavItem(route: '/clients', label: 'Clients', icon: Icons.people),
    _NavItem(
      route: '/motor/quote',
      label: 'Motor Quote',
      icon: Icons.motorcycle,
    ),
    _NavItem(route: '/policies', label: 'Policies', icon: Icons.description),
    _NavItem(route: '/profile', label: 'Profile', icon: Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _items.indexWhere(
      (item) => currentRoute.startsWith(item.route),
    );
    return BottomNavigationBar(
      currentIndex: selectedIndex >= 0 ? selectedIndex : 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(
        context,
      ).colorScheme.onSurface.withOpacity(0.6),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      onTap: (index) {
        final route = _items[index].route;
        context.go(route);
      },
      items: _items.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(item.icon),
          label: item.label,
        );
      }).toList(),
    );
  }
}

class _NavItem {
  final String route;
  final String label;
  final IconData icon;
  const _NavItem({
    required this.route,
    required this.label,
    required this.icon,
  });
}
