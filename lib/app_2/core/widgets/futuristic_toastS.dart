import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A futuristic toast/notification that appears in an overlay.
/// Can be positioned anywhere, self-closes, and includes copy & close buttons.
class FuturisticToastS {
  static OverlayEntry? _currentEntry;
  static Timer? _closeTimer;

  /// Show a toast.
  ///
  /// Parameters:
  /// - [context] : BuildContext to insert overlay.
  /// - [message] : The text to display.
  /// - [duration] : How long to show before auto-dismiss. Use null to keep open until manual close.
  /// - [showCopyButton] : Whether to show a copy-to-clipboard button.
  /// - [showCloseButton] : Whether to show a manual close button.
  /// - [icon] : Optional icon (defaults to Icons.info_outline).
  /// - [iconColor] : Color of the icon (defaults to a cyan gradient).
  /// - [alignment] : Where to position the toast on the screen.
  /// - [margin] : Margin around the toast.
  /// - [onClose] : Callback when toast is closed (either by timer or user).
  static void show({
    required BuildContext context,
    required String message,
    Duration? duration = const Duration(seconds: 3),
    bool showCopyButton = false,
    bool showCloseButton = true,
    IconData? icon,
    Color? iconColor,
    Alignment alignment = Alignment.bottomCenter,
    EdgeInsets margin = const EdgeInsets.all(16),
    VoidCallback? onClose,
  }) {
    // Dismiss any existing toast to avoid stacking (or you could queue them)
    _dismissCurrent();

    // Create the overlay entry
    _currentEntry = OverlayEntry(
      builder: (context) => _FuturisticToastSContent(
        message: message,
        duration: duration,
        showCopyButton: showCopyButton,
        showCloseButton: showCloseButton,
        icon: icon,
        iconColor: iconColor,
        alignment: alignment,
        margin: margin,
        onClose: () {
          _dismissCurrent();
          onClose?.call();
        },
      ),
    );

    // Insert into overlay
    Overlay.of(context).insert(_currentEntry!);

    // Auto-dismiss timer
    if (duration != null) {
      _closeTimer = Timer(duration, () {
        _dismissCurrent();
        onClose?.call();
      });
    }
  }

  /// Manually dismiss the current toast.
  static void dismiss() {
    _dismissCurrent();
  }

  static void _dismissCurrent() {
    _closeTimer?.cancel();
    _closeTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

/// The internal stateful widget that handles animations and interactions.
class _FuturisticToastSContent extends StatefulWidget {
  final String message;
  final Duration? duration;
  final bool showCopyButton;
  final bool showCloseButton;
  final IconData? icon;
  final Color? iconColor;
  final Alignment alignment;
  final EdgeInsets margin;
  final VoidCallback onClose;

  const _FuturisticToastSContent({
    required this.message,
    required this.duration,
    required this.showCopyButton,
    required this.showCloseButton,
    required this.icon,
    required this.iconColor,
    required this.alignment,
    required this.margin,
    required this.onClose,
  });

  @override
  State<_FuturisticToastSContent> createState() =>
      _FuturisticToastSContentState();
}

class _FuturisticToastSContentState extends State<_FuturisticToastSContent>
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

    // Fade from 0 to 1
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    // Slide based on alignment
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

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.message));
    // Optional: sow a tiny feedback (maybe later ill add a subtle tooltip)
    if (mounted) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Copied to clipboard'),
      //     duration: Duration(seconds: 1),
      //     behavior: SnackBarBehavior.floating,
      //   ),
      // );

      FuturisticToastS.show(
        context: context,
        message: 'Copied to clipboard',
        icon: Icons.check_circle,
        iconColor: Colors.greenAccent,
        alignment: Alignment.bottomCenter,
      );
    }
  }

  void _close() {
    // Animate out then call onClose
    _controller.reverse().then((_) {
      widget.onClose();
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Positioned.fill(
  //     child: GestureDetector(
  //       onTap: () {}, // Block taps from passing through (optional)
  //       child: Container(
  //         alignment: widget.alignment,
  //         padding: widget.margin,
  //         child: FadeTransition(
  //           opacity: _fadeAnimation,
  //           child: SlideTransition(
  //             position: _slideAnimation,
  //             child: _buildToastCard(),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Positioned.fill(
  //     child: IgnorePointer(
  //       ignoring: true,
  //       child: Stack(
  //         children: [
  //           // GestureDetector(
  //           //   onTap: _close,
  //           //   child: Container(color: Colors.black.withOpacity(0.001)),
  //           // ),
  //           SafeArea(
  //             child: Align(
  //               alignment: widget.alignment,
  //               child: Padding(
  //                 padding: widget.margin,
  //                 child: IgnorePointer(
  //                   ignoring: false,
  //                   child: FadeTransition(
  //                     opacity: _fadeAnimation,
  //                     child: SlideTransition(
  //                       position: _slideAnimation,
  //                       child: _buildToastCard(),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // Remove the Positioned.fill and IgnorePointer wrapper entirely
    // Let the toast only occupy the space it needs, not the full screen
    return SafeArea(
      child: Align(
        alignment: widget.alignment,
        child: Padding(
          padding: widget.margin,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Material(
                color: Colors.transparent,
                child: _buildToastCard(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToastCard() {
    final iconData = widget.icon ?? Icons.info_outline;
    final iconColor =
        widget.iconColor ??
        (widget.icon == Icons.check_circle
            ? Colors.greenAccent
            : widget.icon == Icons.error
            ? Colors.redAccent
            : const Color(0xFF00E5FF));

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            // filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,

                  colors: isDark
                      ? [
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.03),
                        ]
                      : [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.05),
                        ],
                  // colors: [
                  //   Colors.white.withOpacity(0.15),
                  //   Colors.white.withOpacity(0.05),
                  // ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  width: 1.5,
                  color: Colors.white.withOpacity(0.2),
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
                  // Icon with gradient or glow
                  ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            const Color(0xFF00E5FF),
                            const Color(0xFFAA00FF),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Icon(
                          iconData,
                          color: Colors
                              .white, // color will be replaced by gradient
                          size: 28,
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 1800.ms, color: Colors.white30),
                  const SizedBox(width: 12),
                  // Message
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.showCopyButton) ...[
                    const SizedBox(width: 8),
                    _buildIconButton(
                      icon: Icons.copy,
                      onTap: _copyToClipboard,
                      // tooltip: 'Copy',
                    ),
                  ],
                  if (widget.showCloseButton) ...[
                    const SizedBox(width: 8),
                    _buildIconButton(
                      icon: Icons.close,
                      onTap: _close,
                      // tooltip: 'Close',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    // required String tooltip,
  }) {
    return GestureDetector(
      onTap: onTap,
      // child: Tooltip(
      // message: tooltip,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Icon(icon, color: Colors.white70, size: 18),
      ),
      // ),
    );
  }
}
