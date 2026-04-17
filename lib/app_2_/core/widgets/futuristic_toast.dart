import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FuturisticToast {
  static OverlayEntry? _currentEntry;
  static Timer? _closeTimer;

  /// Show a simple text toast.
  static void show({
    required BuildContext context,
    required String message,
    Duration? duration = const Duration(seconds: 3),
    bool showCopyButton = true,
    bool showCloseButton = true,
    IconData? icon,
    Color? iconColor,
    Alignment alignment = Alignment.bottomCenter,
    EdgeInsets margin = const EdgeInsets.all(16),
    VoidCallback? onClose,
  }) {
    final child = _DefaultToastContent(
      message: message,
      showCopyButton: showCopyButton,
      showCloseButton: showCloseButton,
      icon: icon,
      iconColor: iconColor,
      onClose: onClose ?? () => dismiss(),
    );
    showWidget(
      context: context,
      child: child,
      duration: duration,
      alignment: alignment,
      margin: margin,
      onClose: onClose,
    );
  }

  /// Show a custom widget toast.
  static void showWidget({
    required BuildContext context,
    required Widget child,
    Duration? duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
    EdgeInsets margin = const EdgeInsets.all(16),
    VoidCallback? onClose,
  }) {
    _dismissCurrent();

    _currentEntry = OverlayEntry(
      builder: (context) => _FuturisticToastContent(
        child: child,
        duration: duration,
        alignment: alignment,
        margin: margin,
        onClose: () {
          _dismissCurrent();
          onClose?.call();
        },
      ),
    );

    Overlay.of(context).insert(_currentEntry!);

    if (duration != null) {
      _closeTimer = Timer(duration, () {
        _dismissCurrent();
        onClose?.call();
      });
    }
  }

  static void dismiss() => _dismissCurrent();

  static void _dismissCurrent() {
    _closeTimer?.cancel();
    _closeTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

// Internal widget that handles animations
class _FuturisticToastContent extends StatefulWidget {
  final Widget child;
  final Duration? duration;
  final Alignment alignment;
  final EdgeInsets margin;
  final VoidCallback onClose;

  const _FuturisticToastContent({
    required this.child,
    required this.duration,
    required this.alignment,
    required this.margin,
    required this.onClose,
  });

  @override
  State<_FuturisticToastContent> createState() =>
      _FuturisticToastContentState();
}

class _FuturisticToastContentState extends State<_FuturisticToastContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    Offset beginOffset;
    switch (widget.alignment) {
      case Alignment.topCenter:
      case Alignment.topLeft:
      case Alignment.topRight:
        beginOffset = const Offset(0, -0.5);
        break;
      case Alignment.bottomCenter:
      case Alignment.bottomLeft:
      case Alignment.bottomRight:
        beginOffset = const Offset(0, 0.5);
        break;
      case Alignment.centerLeft:
        beginOffset = const Offset(-0.5, 0);
        break;
      case Alignment.centerRight:
        beginOffset = const Offset(0.5, 0);
        break;
      default:
        beginOffset = Offset.zero;
    }

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    _controller.reverse().then((_) => widget.onClose());
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {}, // block taps
        child: Container(
          alignment: widget.alignment,
          padding: widget.margin,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Material(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: widget.child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Default simple toast content (text + optional buttons)
class _DefaultToastContent extends StatelessWidget {
  final String message;
  final bool showCopyButton;
  final bool showCloseButton;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback onClose;

  const _DefaultToastContent({
    required this.message,
    required this.showCopyButton,
    required this.showCloseButton,
    required this.icon,
    required this.iconColor,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIcon = icon ?? Icons.info_outline;
    final effectiveIconColor =
        iconColor ??
        (icon == Icons.check_circle
            ? Colors.greenAccent
            : icon == Icons.error
            ? Colors.redAccent
            : const Color(0xFF00E5FF));

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        // filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00E5FF).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.purple.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: -5,
                offset: const Offset(-4, 0),
              ),
            ],
          ),
          child: Row(
            children: [
              // Glowing icon
              ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF00E5FF), Color(0xFFAA00FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Icon(effectiveIcon, color: Colors.white, size: 28),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 1800.ms, color: Colors.white30),
              const SizedBox(width: 12),
              // Message
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.3,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                  ),
                ),
              ),
              if (showCopyButton) ...[
                const SizedBox(width: 8),
                _buildIconButton(
                  icon: Icons.copy,
                  tooltip: 'Copy',
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: message));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
              if (showCloseButton) ...[
                const SizedBox(width: 8),
                _buildIconButton(
                  icon: Icons.close,
                  tooltip: 'Close',
                  onTap: onClose,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: tooltip,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(icon, color: Colors.white70, size: 18),
        ),
      ),
    );
  }
}
