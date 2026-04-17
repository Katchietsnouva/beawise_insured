import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/providers/notification_provider.dart';

class NotificationIcon extends ConsumerWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(
      notificationProvider.select((state) => state.unreadCount),
    );

    final location = GoRouterState.of(context).uri.path;
    final isActive = location.startsWith('/notifications');

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.go('/notifications'),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.notifications_none,
              color: isActive
                  ? Colors.orange
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  unreadCount > 9 ? '9+' : unreadCount.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}




// Consumer(
//               builder: (context, ref, _) {
//                 final unreadCount = ref.watch(
//                   notificationProvider.select((state) => state.unreadCount),
//                 );

//                 final location = GoRouterState.of(context).uri.path;
//                 final isActive = location.startsWith('/notifications');

//                 return InkWell(
//                   borderRadius: BorderRadius.circular(20),
//                   onTap: () => context.go('/notifications'),
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8),
//                         child: Icon(
//                           Icons.notifications_none,
//                           color: isActive ? Colors.orange : Colors.white,
//                         ),
//                       ),

//                       if (unreadCount > 0)
//                         Positioned(
//                           right: 2,
//                           top: 2,
//                           child: Container(
//                             padding: const EdgeInsets.all(2),
//                             decoration: BoxDecoration(
//                               color: Colors.red,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             constraints: const BoxConstraints(
//                               minWidth: 16,
//                               minHeight: 16,
//                             ),
//                             child: Text(
//                               unreadCount > 9 ? '9+' : unreadCount.toString(),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 10,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             ),












          // Consumer(

          //   builder: (context, ref, _) {
          //     final unreadCount = ref.watch(
          //       notificationProvider.select((state) => state.unreadCount),
          //     );

          //     final location = GoRouterState.of(context).uri.path;
          //     final isActive = location.startsWith('/notifications');

          //     return InkWell(
          //       borderRadius: BorderRadius.circular(20),
          //       onTap: () => context.go('/notifications'),
          //       child: Stack(
          //         clipBehavior: Clip.none,
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.all(8),
          //             child: Icon(
          //               Icons.notifications_none,
          //               color: isActive ? Colors.orange : Colors.white,
          //             ),
          //           ),

          //           if (unreadCount > 0)
          //             Positioned(
          //               right: 2,
          //               top: 2,
          //               child: Container(
          //                 padding: const EdgeInsets.all(2),
          //                 decoration: BoxDecoration(
          //                   color: Colors.red,
          //                   borderRadius: BorderRadius.circular(10),
          //                 ),
          //                 constraints: const BoxConstraints(
          //                   minWidth: 16,
          //                   minHeight: 16,
          //                 ),
          //                 child: Text(
          //                   unreadCount > 9 ? '9+' : unreadCount.toString(),
          //                   style: const TextStyle(
          //                     color: Colors.white,
          //                     fontSize: 10,
          //                   ),
          //                   textAlign: TextAlign.center,
          //                 ),
          //               ),
          //             ),
          //         ],
          //       ),
          //     );
          //   },
          // ),  