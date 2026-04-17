// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class ProfileAvatar extends StatefulWidget {
//   const ProfileAvatar({super.key});

//   @override
//   State<ProfileAvatar> createState() => _ProfileAvatarState();
// }

// class _ProfileAvatarState extends State<ProfileAvatar> {
//   bool _isHovering = false;

//   @override
//   Widget build(BuildContext context) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _isHovering = true),
//       onExit: (_) => setState(() => _isHovering = false),
//       child: Stack(
//         children: [
//           const CircleAvatar(
//             backgroundColor: Colors.orange,
//             child: Text('P', style: TextStyle(color: Colors.white)),
//           ),
//           if (_isHovering)
//             Positioned(
//               top: 50,
//               right: 0,
//               child: Material(
//                 elevation: 8,
//                 borderRadius: BorderRadius.circular(12),
//                 child: Container(
//                   width: 200,
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF1E293B),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.white24),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const CircleAvatar(
//                         radius: 20,
//                         backgroundColor: Colors.orange,
//                         child: Text('P'),
//                       ),
//                       const SizedBox(height: 8),
//                       const Text(
//                         'Philip Aswa',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const Text(
//                         'philipaswa01@gmail.com',
//                         style: TextStyle(color: Colors.white70, fontSize: 12),
//                       ),
//                       const SizedBox(height: 4),
//                       const Text(
//                         'Admin',
//                         style: TextStyle(color: Colors.orange, fontSize: 10),
//                       ),
//                       const Divider(color: Colors.white24),
//                       SizedBox(
//                         width: double.infinity,
//                         child: Builder(
//                           builder: (BuildContext innerContext) {
//                             // ← new clean context
//                             return ElevatedButton(
//                               onPressed: () {
//                                 GoRouter.of(innerContext).go('/profile');
//                                 // or context.go() will now also usually work
//                               },
//                               child: const Text('View Profile'),
//                             );
//                           },
//                         ),
//                         // child: ElevatedButton(
//                         //   onPressed: () {
//                         //     // context.push('/profile');
//                         //     GoRouter.of(context).go(
//                         //       '/profile',
//                         //     ); // ← use GoRouter.of() instead of context.go()
//                         //   },
//                         //   style: ElevatedButton.styleFrom(
//                         //     backgroundColor: Colors.orange,
//                         //     foregroundColor: Colors.white,
//                         //     shape: RoundedRectangleBorder(
//                         //       borderRadius: BorderRadius.circular(8),
//                         //     ),
//                         //   ),
//                         //   child: const Text('View Profile'),
//                         // ),
//                       ),
//                       const SizedBox(height: 8),
//                       SizedBox(
//                         width: double.infinity,
//                         child: OutlinedButton.icon(
//                           onPressed: () {
//                             // Logout
//                           },
//                           icon: const Icon(Icons.logout, color: Colors.white70),
//                           label: const Text(
//                             'Logout',
//                             style: TextStyle(color: Colors.white70),
//                           ),
//                           style: OutlinedButton.styleFrom(
//                             side: const BorderSide(color: Colors.white24),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/core/widgets/custom_circular_avatar.dart';
import 'package:insured/app_2/data/models/user_model.dart';

class ProfileAvatar extends StatefulWidget {
  final User user;
  const ProfileAvatar({required this.user});

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  bool _isHovering = false;
  Timer? _hoverTimer;

  void _showMenu() {
    _hoverTimer?.cancel();
    if (!_isHovering) {
      // setState(() => _isHovering = true);
    }
  }

  void _hideMenuWithDelay() {
    _hoverTimer?.cancel();
    _hoverTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => _isHovering = false);
      }
    });
  }

  @override
  void dispose() {
    _hoverTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _showMenu(),
      onExit: (_) => _hideMenuWithDelay(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// ========================
          /// Avatar (Trigger)
          /// ========================
          // CircleAvatar(
          //   radius: 20,
          //   backgroundColor: Colors.orange,
          //   child: Text(
          //     widget.user.email.length >= 2
          //         // name.length >= 2
          //         // ? widget.user.email.substring(0, 2)
          //         ? widget.user.email[0].toUpperCase() +
          //               widget.user.email[1].toLowerCase()
          //         : widget.user.email.substring(0, 1).toUpperCase(),
          //     style: const TextStyle(
          //       fontSize: 18,
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          CustomCircularAvatar(user: widget.user.name),

          /// ========================
          /// Dropdown Popup
          /// ========================
          if (_isHovering)
            Positioned(
              top: 42, // Slight overlap removes hover gap issue
              right: 0,
              child: MouseRegion(
                onEnter: (_) => _showMenu(),
                onExit: (_) => _hideMenuWithDelay(),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  shadowColor: Colors.black.withOpacity(0.4),
                  child: Container(
                    width: 220,
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
                        /// ========================
                        /// User Info Section
                        /// ========================
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

                        /// ========================
                        /// View Profile Button
                        /// ========================
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _hoverTimer?.cancel();
                              setState(() => _isHovering = false);

                              context.go('/profile');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'View Profile',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// ========================
                        /// Logout Button
                        /// ========================
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _hoverTimer?.cancel();
                              setState(() => _isHovering = false);
                              GoRouter.of(context).go('/onboarding'); // ✅ fixed
                              // TODO: logout logic
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
