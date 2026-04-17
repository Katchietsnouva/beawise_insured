import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CardAnimationLayout extends StatefulWidget {
  final Widget child;
  final int index;
  final String?
  className; // Equivalent to className, used as key or for styling
  final bool bounce;
  final bool bounceX;
  final bool animateOnce;
  const CardAnimationLayout({
    super.key,
    required this.child,
    required this.index,
    this.className,
    this.bounce = false,
    this.bounceX = false,
    this.animateOnce = false,
  });

  static void clearAnimationCache([String? namespace]) {
    if (namespace != null) {
      _animatedKeys.removeWhere((k) => k.startsWith('${namespace}_'));
    } else {
      _animatedKeys.clear();
    }
  }

  static final Set<String> _animatedKeys = {};

  @override
  State<CardAnimationLayout> createState() => _CardAnimationLayoutState();
}

class _CardAnimationLayoutState extends State<CardAnimationLayout> {
  String get _cacheKey => '${widget.className ?? 'card'}_${widget.index}';

  bool get _alreadyAnimated =>
      widget.animateOnce &&
      CardAnimationLayout._animatedKeys.contains(_cacheKey);

  void _markDone() {
    if (widget.animateOnce) {
      CardAnimationLayout._animatedKeys.add(_cacheKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_alreadyAnimated) {
      return widget.child;
    }
    // Base animation: fade in and scale
    var animatedWidget = widget.child
        .animate(onComplete: (_) => _markDone())
        .fadeIn(
          duration: const Duration(milliseconds: 600),
          delay: Duration(milliseconds: widget.index * 400),
        )
        .scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(1.0, 1.0),
          duration: const Duration(milliseconds: 600),
          delay: Duration(milliseconds: widget.index * 400),
        );

    // Add bounce effect if enabled
    if (widget.bounce) {
      animatedWidget = animatedWidget
          .then()
          .move(
            begin: const Offset(0, 0),
            end: const Offset(0, -10),
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeInOut,
          )
          .then()
          .move(
            begin: const Offset(0, -10),
            end: const Offset(0, 0),
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeInOut,
          );
    }

    // Add horizontal bounce effect if enabled
    if (widget.bounceX) {
      animatedWidget = animatedWidget
          .then()
          .move(
            begin: const Offset(0, 0),
            end: const Offset(10, 0),
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeInOut,
          )
          .then()
          .move(
            begin: const Offset(10, 0),
            end: const Offset(0, 0),
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeInOut,
          );
    }

    return animatedWidget;
  }

  @override
  void initState() {
    super.initState();

    // Handle periodic bounce animations
    if (widget.bounce || widget.bounceX) {
      Future.delayed(Duration(milliseconds: widget.index * 250), () {
        if (!mounted) return;
        // Repeat bounce every 5 seconds
        Animate.restartOnHotReload = true;
        widget.child
            .animate(
              onPlay: (controller) =>
                  controller.repeat(period: const Duration(seconds: 5)),
            )
            .then()
            .move(
              begin: const Offset(0, 0),
              end: widget.bounce
                  ? const Offset(0, -10)
                  : widget.bounceX
                  ? const Offset(10, 0)
                  : const Offset(0, 0),
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeInOut,
            )
            .then()
            .move(
              begin: widget.bounce
                  ? const Offset(0, -10)
                  : widget.bounceX
                  ? const Offset(10, 0)
                  : const Offset(0, 0),
              end: const Offset(0, 0),
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeInOut,
            );
      });
    }
  }
}

// // lib/widgets/card_animation_container.dart

// import 'package:flutter/material.dart';

// class CardAnimationLayout extends StatefulWidget {
//   final Widget child;
//   final int index;
//   final Duration? delay;
//   final bool bounce;
//   final bool bounceX;
//   final EdgeInsetsGeometry? padding;
//   final EdgeInsetsGeometry? margin;

//   const CardAnimationLayout({
//     Key? key,
//     required this.child,
//     required this.index,
//     this.delay,
//     this.bounce = false,
//     this.bounceX = false,
//     this.padding,
//     this.margin,
//   }) : super(key: key);

//   @override
//   State<CardAnimationLayout> createState() => _CardAnimationLayoutState();
// }

// class _CardAnimationLayoutState extends State<CardAnimationLayout>
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _scaleAnimation;
//   late Animation<double> _opacityAnimation;
//   late Animation<double> _bounceAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );

//     final delay = widget.delay ?? Duration(milliseconds: widget.index * 400);

//     Future.delayed(delay, () {
//       if (mounted) _controller.forward();
//     });

//     _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeOut),
//     );

//     _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _controller, curve: Curves.easeOut),
//     );

//     if (widget.bounce || widget.bounceX) {
//       _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
//         CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
//       );

//       // Start bounce loop
//       Future.delayed(Duration(milliseconds: 600 * widget.index), () {
//         if (widget.bounce || widget.bounceX) {
//           _controller.repeat(reverse: true, period: const Duration(seconds: 5));
//         }
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (_, child) {
//         final bounceOffset = widget.bounce
//             ? Offset(0, -_bounceAnimation.value)
//             : widget.bounceX
//                 ? Offset(_bounceAnimation.value, 0)
//                 : Offset.zero;

//         return Transform.translate(
//           offset: bounceOffset,
//           child: AnimatedOpacity(
//             opacity: _opacityAnimation.value,
//             duration: const Duration(milliseconds: 600),
//             child: AnimatedScale(
//               scale: _scaleAnimation.value,
//               duration: const Duration(milliseconds: 600),
//               child: Container(
//                 padding: widget.padding,
//                 margin: widget.margin,
//                 child: child,
//               ),
//             ),
//           ),
//         );
//       },
//       child: widget.child,
//     );
//   }
// }
