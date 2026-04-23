import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastS.dart';

class FuturisticToastT {
  static OverlayEntry? _currentEntry;
  static Timer? _closeTimer;

  static void show({
    required BuildContext context,
    required String message,
    Map<String, dynamic>? errors, // Added structured errors
    Duration? duration = const Duration(seconds: 6),
    bool showCopyButton = false,
    bool showCloseButton = true,
    IconData? icon,
    Color? iconColor,
    Alignment alignment = Alignment.topCenter,
    EdgeInsets margin = const EdgeInsets.all(16),
    VoidCallback? onClose,
  }) {
    _dismissCurrent();

    _currentEntry = OverlayEntry(
      builder: (context) => _FuturisticToastTContent(
        message: message,
        errors: errors,
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

    Overlay.of(context).insert(_currentEntry!);

    if (duration != null) {
      _closeTimer = Timer(duration, () {
        _dismissCurrent();
        onClose?.call();
      });
    }
  }

  static void _dismissCurrent() {
    _closeTimer?.cancel();
    _closeTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _FuturisticToastTContent extends StatefulWidget {
  final String message;
  final Map<String, dynamic>? errors;
  final Duration? duration;
  final bool showCopyButton;
  final bool showCloseButton;
  final IconData? icon;
  final Color? iconColor;
  final Alignment alignment;
  final EdgeInsets margin;
  final VoidCallback onClose;

  const _FuturisticToastTContent({
    required this.message,
    this.errors,
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
  State<_FuturisticToastTContent> createState() =>
      _FuturisticToastTContentState();
}

class _FuturisticToastTContentState extends State<_FuturisticToastTContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 400.ms);
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _copyToClipboard() {
    String textToCopy = widget.message;
    if (widget.errors != null) {
      textToCopy = jsonEncode({
        "message": widget.message,
        "errors": widget.errors,
      });
    }
    Clipboard.setData(ClipboardData(text: textToCopy));
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: const Text('Error log copied!'), duration: 1.seconds),
    // );

    FuturisticToastS.show(
      context: context,
      message: 'Error log copied!',
      icon: Icons.check_circle,
      iconColor: Colors.greenAccent,
      alignment: Alignment.bottomCenter,
      duration: 5.seconds,
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Positioned.fill(
    //   child: Material(
    //     color: Colors.transparent,
    //     child: Container(
    //       alignment: widget.alignment,
    //       padding: widget.margin,
    //       child: FadeTransition(
    //         opacity: _fadeAnimation,
    //         child: SlideTransition(
    //           position: _slideAnimation,
    //           child: _buildToastCard(),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              // GestureDetector(
              //   onTap: widget.onClose,
              //   child: Container(color: Colors.black.withOpacity(0.001)),
              // ),
              SafeArea(
                child: Align(
                  alignment: widget.alignment,
                  child: Padding(
                    padding: widget.margin,
                    child: IgnorePointer(
                      ignoring: false,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: _buildToastCard(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToastCard() {
    final iconData = widget.icon ?? Icons.error_outline;

    return Container(
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          // filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.white.withOpacity(0.9)
                      : Colors.black.withOpacity(0.7),
                  Theme.of(context).brightness == Brightness.light
                      ? Colors.white.withOpacity(0.7)
                      : Colors.black.withOpacity(0.5),
                  // Colors.black.withOpacity(0.5),
                  // Colors.red.withOpacity(0.92),
                  // Colors.red.withOpacity(0.82),
                  // Theme.of(context).colorScheme.surface.withOpacity(0.8),
                  // Theme.of(context).colorScheme.surface.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(iconData, color: Colors.redAccent, size: 28)
                        .animate(onPlay: (c) => c.repeat())
                        .shimmer(duration: 2.seconds),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomText(
                        widget.message,
                        type: CustomTextType.paragraph,
                      ),
                    ),
                    if (widget.showCopyButton)
                      _buildIconButton(Icons.copy, _copyToClipboard),
                    if (widget.showCloseButton)
                      _buildIconButton(
                        Icons.close,
                        () =>
                            _controller.reverse().then((_) => widget.onClose()),
                      ),
                  ],
                ),

                if (widget.errors != null && widget.errors!.isNotEmpty) ...[
                  Divider(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.4),
                    height: 24,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.errors!.entries.map((entry) {
                          return _buildErrorSection(entry.key, entry.value);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorSection(String title, dynamic errorList) {
    List<dynamic> list = errorList is List ? errorList : [errorList.toString()];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.replaceAll('_', ' ').toUpperCase(),
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          ...list.map(
            (err) => Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.circle, size: 6, color: Colors.redAccent),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomText(
                      err.toString(),
                      type: CustomTextType.caption,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorSection_(String title, dynamic errorList) {
    List<dynamic> list = errorList is List ? errorList : [errorList.toString()];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.replaceAll('_', ' ').toUpperCase(),
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          ...list.map(
            (err) => Padding(
              padding: const EdgeInsets.only(top: 2, left: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "• ",
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.1),
                    ),
                  ),
                  Expanded(
                    child: CustomText(
                      err.toString(),
                      type: CustomTextType.paragraph,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        size: 20,
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}
