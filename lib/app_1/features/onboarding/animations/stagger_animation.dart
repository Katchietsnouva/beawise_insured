import 'package:flutter/material.dart';

class StaggerAnimation extends StatefulWidget {
  final List<Widget> children;
  final Duration delayBetween;
  final Duration animationDuration;

  const StaggerAnimation({
    super.key,
    required this.children,
    this.delayBetween = const Duration(milliseconds: 100),
    this.animationDuration = const Duration(milliseconds: 400),
  });

  @override
  State<StaggerAnimation> createState() => _StaggerAnimationState();
}

class _StaggerAnimationState extends State<StaggerAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          widget.animationDuration +
          widget.delayBetween * (widget.children.length - 1),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.children.length, (index) {
        final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  index *
                      widget.delayBetween.inMilliseconds /
                      _controller.duration!.inMilliseconds,
                  (index * widget.delayBetween.inMilliseconds +
                          widget.animationDuration.inMilliseconds) /
                      _controller.duration!.inMilliseconds,
                  curve: Curves.easeOut,
                ),
              ),
            );
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.2),
              end: Offset.zero,
            ).animate(animation),
            child: widget.children[index],
          ),
        );
      }),
    );
  }
}
