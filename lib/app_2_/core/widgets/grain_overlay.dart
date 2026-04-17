// ─────────────────────────────────────────────
// Grain overlay using CustomPainter
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'dart:math' as math;

class GrainOverlay extends StatelessWidget {
  const GrainOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: CustomPaint(painter: _GrainPainter()));
  }
}

class _GrainPainter extends CustomPainter {
  final _rng = math.Random(42);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.025);
    for (int i = 0; i < 2000; i++) {
      canvas.drawCircle(
        Offset(_rng.nextDouble() * size.width, _rng.nextDouble() * size.height),
        _rng.nextDouble() * 1.2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}
