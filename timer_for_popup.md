
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({super.key});

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Stack(
        clipBehavior:
            Clip.none, // Crucial: allows the dropdown to appear outside bounds
        children: [
          // The avatar itself (trigger area)
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.orange,
            child: const Text(
              'P',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Dropdown menu - only visible when hovering
          if (_isHovering)
            Positioned(
              top: 48, // Slightly below avatar (adjust as needed)
              right: 0,
              child: MouseRegion(
                // Nested MouseRegion keeps it open while hovering over the popup itself
                onEnter: (_) => setState(() => _isHovering = true),
                onExit: (_) => setState(() => _isHovering = false),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  shadowColor: Colors.black.withOpacity(0.4),
                  child: Container(
                    width: 220, // Slightly wider for better readability
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.12)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // User info header
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.orange,
                              child: Text(
                                'P',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Philip Aswa',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Admin',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'philipaswa01@gmail.com',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Colors.white24, height: 1),

                        const SizedBox(height: 12),

                        // Buttons
                        SizedBox(
                          width: double.infinity,
                          child: Builder(
                            builder: (BuildContext innerContext) {
                              return ElevatedButton(
                                onPressed: () {
                                  setState(
                                    () => _isHovering = false,
                                  ); // Optional: close dropdown
                                  GoRouter.of(innerContext).go('/profile');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'View Profile',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // TODO: Implement logout logic
                              // e.g. context.read<AuthProvider>().logout();
                              // then: GoRouter.of(context).go('/login');
                              setState(() => _isHovering = false);
                            },
                            icon: const Icon(
                              Icons.logout,
                              size: 18,
                              color: Colors.white70,
                            ),
                            label: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.white70),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white24),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
