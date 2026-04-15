import 'package:flutter/material.dart';
import '../constants/app_dimens.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final Widget button = isOutlined
        ? OutlinedButton(onPressed: onPressed, child: Text(text))
        : ElevatedButton(onPressed: onPressed, child: Text(text));

    return _ScaleButton(child: button);
  }
}

class _ScaleButton extends StatefulWidget {
  final Widget child;

  const _ScaleButton({required this.child});

  @override
  State<_ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<_ScaleButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..value = 1.0;
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.reverse();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.forward();
  }

  void _handleTapCancel() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(scale: _animation, child: widget.child),
    );
  }
}

// import 'package:flutter/material.dart';

// class PrimaryButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final bool isOutlined;

//   const PrimaryButton({
//     Key? key,
//     required this.text,
//     required this.onPressed,
//     this.isOutlined = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final button = isOutlined
//         ? OutlinedButton(
//             onPressed: onPressed,
//             style: OutlinedButton.styleFrom(
//               side: const BorderSide(color: Colors.white, width: 1.5),
//               shape: const StadiumBorder(),
//               padding: const EdgeInsets.symmetric(vertical: 14),
//             ),
//             child: Text(text, style: const TextStyle(color: Colors.white)),
//           )
//         : ElevatedButton(
//             onPressed: onPressed,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.accentGreen,
//               foregroundColor: Colors.white,
//               shape: const StadiumBorder(),
//               padding: const EdgeInsets.symmetric(vertical: 14),
//             ),
//             child: Text(text),
//           );

//     return TweenAnimationBuilder(
//       tween: Tween(begin: 1.0, end: 1.0),
//       duration: const Duration(milliseconds: 100),
//       builder: (context, scale, child) {
//         return Transform.scale(scale: scale, child: child);
//       },
//       child: button,
//     );
//   }
// }
