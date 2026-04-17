import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'dart:ui' as ui; // for TextPainter (optional, but included for clarity)
import 'package:insured/app_2/data/models/api_log.dart';

class NotificationCard extends StatelessWidget {
  final ApiLog log;
  final VoidCallback? onTap;
  final VoidCallback? onDismissed;

  const NotificationCard({
    super.key,
    required this.log,
    this.onTap,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final isSuccess = log.status == 'success';
    final statusColor = isSuccess ? Colors.green : Colors.red;
    final statusIcon = isSuccess ? Icons.check_circle : Icons.error;

    // Calculate fill ratio relative to a 10‑second baseline
    final durationSec = log.durationMs / 1000;
    final double baselineSec;
    if (durationSec <= 10) {
      baselineSec = 10;
    } else {
      baselineSec = (durationSec / 10).ceil() * 10.0;
    }
    final fillRatio = (durationSec / baselineSec).clamp(0.0, 1.0);

    return Dismissible(
      key: Key(log.id),
      onDismissed: (_) => onDismissed?.call(),
      background: Container(
        color: Colors.red.withOpacity(0.2),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              elevation: Theme.of(context).brightness == Brightness.light
                  ? 4
                  : 6,
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).colorScheme.surface,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: log.read
                      ? Colors.grey.withOpacity(0.05)
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: log.read
                        ? Colors.grey.withOpacity(0.2)
                        : statusColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(statusIcon, color: statusColor, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  log.endpoint,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: CustomText(
                                  '${_formatRelativeTime(log.timestamp)} ago',
                                  type: CustomTextType.paragraph,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            log.message,
                            type: CustomTextType.paragraph,
                          ),
                          const SizedBox(height: 8),

                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.timer,
                                size: 14,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.5),
                              ),
                              const SizedBox(width: 4),

                              Column(
                                children: [
                                  Text(
                                    "Response time",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.7),
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    // '${log.durationMs} ms',
                                    '${durationSec.toStringAsFixed(3)} sec',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isSuccess
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 4),

                              const SizedBox(width: 4),
                              Expanded(
                                child: SizedBox(
                                  height: 8,
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0, end: fillRatio),
                                    duration: const Duration(milliseconds: 600),
                                    builder:
                                        (context, animatedFillRatio, child) {
                                          return _DurationBar(
                                            fillRatio: animatedFillRatio,
                                            durationMs: log.durationMs,
                                            isSuccess: isSuccess,
                                          );
                                        },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text("${baselineSec} sec"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!log.read)
              Positioned(
                top: 0,
                left: 0,
                child: _BlinkingDot(
                  color: isSuccess ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return '${diff.inSeconds}s';
  }
}

class _DurationBar extends StatelessWidget {
  final double fillRatio;
  final int durationMs;
  final bool isSuccess;

  const _DurationBar({
    required this.fillRatio,
    required this.durationMs,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 20),
      painter: _DurationBarPainter(
        fillRatio: fillRatio,
        durationSec: durationMs / 1000,
        fillColor: isSuccess ? Colors.green : Colors.red,
        backgroundColor: Theme.of(
          context,
        ).colorScheme.onSurface.withOpacity(0.1),
        textStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DurationBarPainter extends CustomPainter {
  final double fillRatio;
  final double durationSec;
  final Color fillColor;
  final Color backgroundColor;
  final TextStyle textStyle;

  _DurationBarPainter({
    required this.fillRatio,
    required this.durationSec,
    required this.fillColor,
    required this.backgroundColor,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    paint.color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    paint.color = fillColor;
    final fillWidth = size.width * fillRatio;
    canvas.drawRect(Rect.fromLTWH(0, 0, fillWidth, size.height), paint);

    if (fillWidth > 0) {
      final textSpan = TextSpan(
        text: '${durationSec.toStringAsFixed(1)}s',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      double x = fillWidth - textPainter.width / 2;
      x = x.clamp(0, size.width - textPainter.width);
      final y = (size.height - textPainter.height) / 2;

      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant _DurationBarPainter oldDelegate) {
    return oldDelegate.fillRatio != fillRatio ||
        oldDelegate.durationSec != durationSec ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

class _BlinkingDot extends StatefulWidget {
  final Color color;
  final double size;
  const _BlinkingDot({this.color = Colors.red, this.size = 10, super.key});

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _animation = Tween(begin: 0.2, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}
