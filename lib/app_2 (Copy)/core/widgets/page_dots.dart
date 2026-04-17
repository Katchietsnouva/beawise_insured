// ─────────────────────────────────────────────
// Page indicator dots
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';

class PageDots extends StatelessWidget {
  final int count;
  final int current;
  final Color activeColor;
  final Function(int)? onDotTapped;

  const PageDots({
    required this.count,
    required this.current,
    required this.activeColor,
    this.onDotTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return GestureDetector(
          onTap: () => onDotTapped?.call(i),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 32 : 12,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: active ? activeColor : Colors.white.withOpacity(0.25),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: activeColor.withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        );
      }),
    );
  }
}
