// ─────────────────────────────────────────────
// Animated blurry orbs background
// ─────────────────────────────────────────────

import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedOrbs extends StatelessWidget {
  final Color glowColor;
  final AnimationController shimmerCtrl;

  const AnimatedOrbs({required this.glowColor, required this.shimmerCtrl});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AnimatedBuilder(
      animation: shimmerCtrl,
      builder: (_, __) {
        final t = shimmerCtrl.value;
        return Stack(
          children: [
            // Primary glow orb
            Positioned(
              top: size.height * 0.05 + math.sin(t * 2 * math.pi) * 20,
              left: size.width * 0.1 + math.cos(t * 2 * math.pi) * 15,
              child: _Orb(
                size: size.width * 0.85,
                color: glowColor.withOpacity(0.18),
                blur: 80,
              ),
            ),
            // Secondary accent orb
            Positioned(
              top: size.height * 0.3 + math.cos(t * 2 * math.pi) * 25,
              right: -size.width * 0.2,
              child: _Orb(
                size: size.width * 0.7,
                color: const Color(0xFF00F0FF).withOpacity(0.10),
                blur: 60,
              ),
            ),
            // Bottom ambient
            Positioned(
              bottom: -size.height * 0.05,
              left: size.width * 0.1,
              child: _Orb(
                size: size.width * 0.8,
                color: Colors.black.withOpacity(0.35),
                blur: 50,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  final double blur;

  const _Orb({required this.size, required this.color, required this.blur});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color, blurRadius: blur, spreadRadius: blur * 0.3),
        ],
      ),
    );
  }
}
