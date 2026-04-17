import 'package:flutter/material.dart';
import 'dart:ui';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double blur;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24.0),
    this.borderRadius = 32.0,
    this.blur = 20.0,
    this.borderColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Material(
      elevation: Theme.of(context).brightness == Brightness.light ? 4 : 6,
      borderRadius: BorderRadius.circular(24),
      // color: Theme.of(context).colorScheme.surface,
      // color: Colors.black.withOpacity(0.3),
      color: isLight
          ? Colors.white.withOpacity(0.05)
          : Colors.black.withOpacity(0.05),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              // color: Colors.black.withOpacity(0.3),
              // color: Theme.of(context).primaryColor,

              //best for dm
              // color: Theme.of(context).primaryColor.withOpacity(0.2),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(borderRadius),
              // border: Border.all(
              //   color: borderColor ?? Colors.white.withOpacity(0.2),
              // ),
              border: Border.all(
                color:
                    // isLight
                    //     ? Colors.greenAccent.withOpacity(0.9)
                    //     :
                    // Colors.white.withOpacity(0.1),
                    Colors.greenAccent.withOpacity(0.5),
              ),
              boxShadow:
                  boxShadow ??
                  [
                    BoxShadow(
                      // color: Colors.black.withOpacity(0.1),
                      color: Colors.black.withOpacity(isLight ? 0.05 : 0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}




// class GlassCard extends StatelessWidget {
//   final Widget child;
//   const GlassCard({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(32),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(32),
//             border: Border.all(color: Colors.white.withOpacity(0.2)),
//           ),
//           // child: child,
//           child: SingleChildScrollView(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }
// }



// class GlassCard extends StatelessWidget {
//   final Widget child;
//   const GlassCard({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(32),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(32),
//             border: Border.all(color: Colors.white.withOpacity(0.2)),
//           ),
//           // child: child,
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: child,
//           ),
//         ),
//       ),
//     );
//   }
// }

