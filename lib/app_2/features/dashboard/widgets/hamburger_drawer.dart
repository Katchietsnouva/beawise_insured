import 'package:flutter/material.dart';

class HamburgerDrawer extends StatelessWidget {
  const HamburgerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0A1A17),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            'INSURED',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Color(0xFF00FFB2),
            ),
          ),
          const SizedBox(height: 40),
          _buildMenuItem(
            Icons.dashboard,
            'Dashboard',
            isActive: true,
            onTap: () {},
          ),
          _buildMenuItem(Icons.people, 'Clients', onTap: () {}),
          _buildMenuItem(Icons.description, 'Quotes', onTap: () {}),
          _buildMenuItem(Icons.factory, 'Production', onTap: () {}),
          _buildMenuItem(Icons.assignment, 'Statement', onTap: () {}),
          _buildMenuItem(Icons.autorenew, 'Renewals', onTap: () {}),
          const Spacer(),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text('PA'),
            ),
            title: const Text(
              'Philip Aswa',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'philip@insured.com',
              style: TextStyle(color: Colors.white60),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.logout, color: Colors.white70),
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String label, {
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.orange : Colors.white60),
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.orange : Colors.white70,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }
}
