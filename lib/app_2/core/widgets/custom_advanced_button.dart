// import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';

import 'package:insured/app_2/core/utils/responsive.dart';

enum ButtonVariant {
  primary,
  secondary,
  apple,
  google,
  payBtn,
  circular,
  circularPay,
  glow,
  text,
}

enum WarnMode { vibrate, none }

class CustomAdvancedButton extends StatefulWidget {
  final String label;
  final ButtonVariant variant;
  final VoidCallback onPressed;
  final double? height;
  final double? width;
  final Widget? icon;
  final bool iconRight;
  final bool isDisabled;
  final bool? loading;

  final bool Function()? validator;
  final WarnMode warnMode;
  final bool debugLogValidation;
  final double? customFontSize;
  final Color? glowColor;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final TextStyle? labelStyle;
  final Color? color1;
  final Color? color2;
  final Color? textColor;

  /// Minimum gap between two accepted presses. Rapid repeat taps within this
  /// window are ignored so callers can't fire `onPressed` twice from a
  /// double-click before their own loading state kicks in. Set to
  /// [Duration.zero] to opt out.
  final Duration debounceDuration;

  const CustomAdvancedButton({
    super.key,
    required this.label,
    required this.variant,
    required this.onPressed,
    this.height,
    this.width,
    this.icon,
    this.iconRight = false,
    this.isDisabled = false,
    this.loading = false,
    this.validator,
    this.warnMode = WarnMode.vibrate,
    this.debugLogValidation = false,
    this.customFontSize,
    this.glowColor,

    this.prefixText,
    this.prefixStyle,
    this.labelStyle,
    this.color1,
    this.color2,
    this.textColor,
    this.debounceDuration = const Duration(milliseconds: 600),
  });

  @override
  State<CustomAdvancedButton> createState() => _CustomAdvancedButtonState();
}

class _CustomAdvancedButtonState extends State<CustomAdvancedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isHovering = false;

  late final Animation<double> _scale;
  bool get _isDisabled => widget.isDisabled || (widget.loading ?? false);

  /// Timestamp of the last accepted press, used to swallow rapid double-taps.
  DateTime? _lastPressedAt;

  /// True when a press should be ignored because it lands within
  /// [CustomAdvancedButton.debounceDuration] of the previous accepted one.
  bool get _isWithinDebounce {
    final last = _lastPressedAt;
    if (last == null || widget.debounceDuration == Duration.zero) return false;
    return DateTime.now().difference(last) < widget.debounceDuration;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _isDisabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: IgnorePointer(
        // ignoring: widget.isDisabled || widget.loading,
        ignoring: _isDisabled || (widget.loading ?? false),
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: GestureDetector(
            onTapDown: _isDisabled ? null : (_) => _controller.forward(),
            // onTapUp: widget.isDisabled
            //     ? null
            //     : (_) {
            //         _controller.reverse();
            //         HapticFeedback.lightImpact();
            //         widget.onPressed();
            //       },
            onTapUp: _isDisabled
                ? null
                : (_) {
                    _controller.reverse();

                    // Debounce: swallow a second tap that lands too soon after
                    // the previous accepted one (double-click protection).
                    if (_isWithinDebounce) return;
                    _lastPressedAt = DateTime.now();

                    if (widget.validator != null && !widget.validator!()) {
                      debugPrint(
                        'CustomAdvancedButton: Validation failed – fields are required.',
                      ); // 👈 add this
                      print(widget.validator);
                      print(widget.validator!());
                      // debugPrint(widget.validator!());

                      if (!widget.debugLogValidation) {
                        debugPrint(
                          'CustomAdvancedButton: Validation failed for "${widget.label}"',
                        );
                      }

                      // if (widget.warnMode == WarnMode.vibrate) {
                      //   HapticFeedback.heavyImpact();
                      // }
                      if (Theme.of(context).platform !=
                              TargetPlatform.windows &&
                          Theme.of(context).platform != TargetPlatform.macOS &&
                          Theme.of(context).platform != TargetPlatform.linux) {
                        HapticFeedback.vibrate();
                      }

                      // FuturisticToastT.show(
                      //   context: context,
                      //   message: "Fill fields for email and password",
                      //   errors: {
                      //     "Required Fields": [
                      //       "Email is required",
                      //       "Password is required",
                      //     ],
                      //   },
                      //   icon: Icons.warning_amber_rounded,
                      //   alignment: Alignment.topCenter,
                      //   duration: const Duration(seconds: 6),
                      // );

                      // return;
                    }

                    HapticFeedback.lightImpact();
                    widget.onPressed();
                  },

            onTapCancel: _isDisabled ? null : () => _controller.reverse(),
            child: AnimatedBuilder(
              animation: _scale,
              builder: (_, child) => Transform.scale(
                scale: _isDisabled ? 1.0 : _scale.value,
                child: child,
              ),
              child: Opacity(
                opacity: _isDisabled ? 0.5 : 1.0,
                child: _buildButton(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return _PrimaryButton(
          isHovering: _isHovering,
          label: widget.label,
          icon: widget.icon,
          height: widget.height,
          width: widget.width,
          iconRight: widget.iconRight,
          // isDisabled: widget.isDisabled,
          isDisabled: _isDisabled,
          isloading: widget.loading,
          customFontSize: widget.customFontSize,
          color1: widget.color1,
          color2: widget.color2,
          textColor: widget.textColor,
        );
      case ButtonVariant.secondary:
        return _SecondaryButton(
          isHovering: _isHovering,
          label: widget.label,
          icon: widget.icon,
          height: widget.height,
          width: widget.width,
          iconRight: widget.iconRight,
          // isDisabled: widget.isDisabled,
          isDisabled: _isDisabled,
          isloading: widget.loading,
          customFontSize: widget.customFontSize,
          color1: widget.color1,
          color2: widget.color2,
        );
      case ButtonVariant.apple:
        return _AppleButton(label: widget.label, isDisabled: _isDisabled);
      case ButtonVariant.google:
        return _GoogleButton(label: widget.label, isDisabled: _isDisabled);

      case ButtonVariant.payBtn:
        return _PayButton(
          label: widget.label,
          icon: widget.icon,
          height: widget.height,
          width: widget.width,
          isDisabled: _isDisabled,
          isloading: widget.loading,
          isHovering: _isHovering,
          color1: widget.color1,
          color2: widget.color2,
        );
      case ButtonVariant.circular:
        return _CircularButton(
          icon: widget.icon,
          size: widget.height ?? widget.width ?? 60,
          isDisabled: _isDisabled,
          isloading: widget.loading,
          isHovering: _isHovering,
        );
      case ButtonVariant.glow:
        return _GlowButton(
          isHovering: _isHovering,
          label: widget.label,
          icon: widget.icon,
          height: widget.height,
          width: widget.width,
          iconRight: widget.iconRight,
          isDisabled: _isDisabled,
          isloading: widget.loading,
          customFontSize: widget.customFontSize,
          // glowColor: (widget as dynamic).glowColor ?? AppColors.favColour,
          // glowColor: widget.glowColor ?? AppColors.favColour,
          glowColor: widget.glowColor ?? widget.color1 ?? AppColors.favColour,
        );
      case ButtonVariant.circularPay:
        return _CircularPayButton(
          icon: widget.icon,
          size: widget.height ?? widget.width ?? 60,
          isDisabled: _isDisabled,
          isloading: widget.loading,
          isHovering: _isHovering,
        );
      case ButtonVariant.text:
        return _TextButton(
          // prefixText: "Don't have an account? ",
          label: widget.label,
          onPressed: widget.onPressed,
          isDisabled: _isDisabled,
          isloading: widget.loading,
          prefixText: widget.prefixText,
          prefixStyle: widget.prefixStyle,
          labelStyle: widget.labelStyle,
          isHovering: _isHovering,
        );
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final double? height;
  final double? width;
  final bool iconRight;
  final bool isDisabled;
  final bool? isloading;
  final bool isHovering;
  final double? customFontSize;
  final Color? color1;
  final Color? color2;
  final Color? textColor;

  const _PrimaryButton({
    required this.label,
    this.icon,
    this.height,
    final this.width,
    this.iconRight = false,
    this.isDisabled = false,
    this.isloading = false,
    this.isHovering = false,
    this.customFontSize,
    this.color1,
    this.color2,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Gradient effectiveGradient;
    // final btnPrColor = AppColors.favColour;
    final btnPrColor = color1 ?? AppColors.favColour;

    // final btnSecColor = AppColors.favColour_sec;
    // final btnSecColor = AppColors.favColourDark;
    final btnSecColor = color2 ?? color1 ?? AppColors.favColourDark;

    final brandGradient = LinearGradient(
      colors: [btnPrColor, btnSecColor],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    final darkGradientOverlay = LinearGradient(
      colors: [btnPrColor.withOpacity(0.65), btnSecColor.withOpacity(0.65)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    final lightHoverGradient = LinearGradient(
      colors: [btnPrColor, btnSecColor],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    if (isDisabled) {
      effectiveGradient = LinearGradient(
        colors: isDark
            ? [const Color(0xFF2A3A4A), const Color(0xFF1E2A38)]
            : [const Color(0xFFD0D0D0), const Color(0xFFB0B0B0)],
      );
    } else if (isDark) {
      effectiveGradient = isHovering ? darkGradientOverlay : brandGradient;
    } else {
      effectiveGradient = isHovering ? lightHoverGradient : brandGradient;
    }

    return Container(
      // width: double.infinity,
      // height: height ?? 56,
      height: height ?? (Responsive.isMobile(context) ? 40 : 48),
      width: isHovering && width != null ? width! * 1.1 : width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),

        gradient: effectiveGradient,
        boxShadow: (isDisabled || (isloading ?? false))
            ? []
            : [
                BoxShadow(
                  color: isDark
                      ? (isHovering
                            ? Color(0xFF00FFC8).withOpacity(0.18)
                            : Color(0xFF00FFC8).withOpacity(0.12))
                      : (isHovering
                            ? Colors.white.withOpacity(0.3)
                            : Colors.white.withOpacity(0.2)),
                  blurRadius: isDark ? (isHovering ? 12 : 8) : 20,
                  spreadRadius: isDark ? (isHovering ? 0.5 : 0.2) : 2,
                ),
              ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // if (icon != null) Icon(icon, color: Colors.black87),
              // if (icon != null) const SizedBox(width: 8),
              if (icon != null && !iconRight) ...[
                // Icon(icon, color: Colors.black87),
                icon!,

                const SizedBox(width: 8),
              ],

              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: TextStyle(
                  fontSize: customFontSize ?? 14,
                  fontWeight: FontWeight.w400,
                  // color: (isDisabled || (isloading ?? false))
                  // color: (isDisabled) ? Colors.white70 : Colors.black87,
                  // color: (isDisabled) ? Colors.white70 : Colors.white70,
                  // Disabled/loading fill is a theme-aware grey, so pick a
                  // label colour that stays readable on it: light grey text on
                  // the dark (dark-mode) fill, dark grey text on the light one.
                  color: isDisabled
                      ? (isDark ? Colors.white70 : Colors.black45)
                      : (textColor ?? Colors.white70),
                ),
              ),
              SizedBox(width: 6),
              if (isloading ?? false)
                const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.animatedOrbsGlow_2,
                  ),
                ),
              if (icon != null && iconRight) ...[
                const SizedBox(width: 8),
                // Icon(icon, color: Colors.black87),
                icon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final double? height;
  final double? width;
  final bool iconRight;
  final bool isDisabled;
  final bool? isloading;
  final bool isHovering;
  final double? customFontSize;
  final Color? color1;
  final Color? color2;

  const _SecondaryButton({
    required this.label,
    this.icon,
    this.height,
    this.width,
    this.iconRight = false,
    this.isDisabled = false,
    this.isloading = false,
    this.isHovering = false,
    this.customFontSize,
    this.color1,
    this.color2,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          // width: double.infinity,
          width: width,
          // height: height ?? 56,
          height: height ?? (Responsive.isMobile(context) ? 40 : 48),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: (isDisabled || (isloading ?? false))
                ? (isLight
                      ? Colors.black.withOpacity(0.2)
                      : Colors.white.withOpacity(0.05))
                : (isLight
                      ? Colors.black.withOpacity(isHovering ? 0.65 : 0.6)
                      : Colors.white.withOpacity(isHovering ? 0.2 : 0.1)),
            border: Border.all(
              color: (isDisabled || (isloading ?? false))
                  ? Colors.white.withOpacity(0.1)
                  : Colors.white.withOpacity(isHovering ? 0.3 : 0.2),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null && !iconRight) ...[
                    // Icon(icon, color: Colors.white),
                    // FaIcon(icon, color: Colors.white, size: 18),
                    icon!,

                    const SizedBox(width: 8),
                  ],
                  if (icon != null) const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                        fontSize: customFontSize ?? 14,
                        fontWeight: FontWeight.w400,
                        // Disabled/loading fill is a light grey in light theme
                        // and near-transparent white in dark theme; use a dark
                        // label on the former, a light one on the latter.
                        color: (isDisabled || (isloading ?? false))
                            ? (isLight ? Colors.black38 : Colors.white38)
                            : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 6),

                  if (isloading ?? false) ...[
                    const SizedBox(width: 8),
                    const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.animatedOrbsGlow_2,
                      ),
                    ),
                  ],
                  if (icon != null && iconRight) ...[
                    const SizedBox(width: 8),
                    // Icon(icon, color: Colors.white),
                    // FaIcon(icon, color: Colors.white, size: 18),
                    icon!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppleButton extends StatelessWidget {
  final String label;
  final bool isDisabled;

  const _AppleButton({required this.label, this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return _SecondaryButton(
      label: label,
      // icon: Icons.apple,
      icon: Icon(Icons.apple),
      isDisabled: isDisabled,
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final String label;
  final bool isDisabled;

  const _GoogleButton({required this.label, this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return _SecondaryButton(
      label: label,
      icon: FaIcon(FontAwesomeIcons.google),
      isDisabled: isDisabled,
    );
  }
}

class _PayButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final double? height;
  final double? width;
  final bool isDisabled;
  final bool? isloading;
  final bool isHovering;
  final Color? color1;
  final Color? color2;

  const _PayButton({
    required this.label,
    this.icon,
    this.height,
    this.width,
    this.isDisabled = false,
    this.isloading = false,
    this.isHovering = false,
    this.color1,
    this.color2,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final color = isDark
    //     ? AppColors.favColour.withOpacity(0.9)
    //     : AppColors.favColourDark!.withOpacity(0.9);

    // final baseColor = isDark ? AppColors.favColour : AppColors.favColourDark!;
    final resolvedColor1 =
        color1 ?? (isDark ? AppColors.favColour : AppColors.favColourDark!);
    final resolvedColor2 = color2 ?? resolvedColor1;

    // final activeColor = baseColor.withOpacity(0.9);
    final activeColor = resolvedColor1.withOpacity(0.9);

    final disabledColor = isDark
        ? Colors.grey[600]!.withOpacity(0.5)
        : Colors.grey[500]!.withOpacity(0.6);

    final effectiveColor = isDisabled ? disabledColor : activeColor;
    final borderColor = isDisabled
        ? effectiveColor.withOpacity(0.3)
        : effectiveColor.withOpacity(0.5);

    return Container(
      // width: width ?? double.infinity,
      width: width,
      // height: height ?? 56,
      height: height ?? (Responsive.isMobile(context) ? 40 : 48),
      // padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        // color: isDark
        //     ? AppColors.favColour.withOpacity(isHovering ? 0.25 : 0.2)
        //     : AppColors.favColourDark!.withOpacity(isHovering ? 0.25 : 0.2),
        color: (color1 == null)
            ? (isDark
                  ? AppColors.favColour.withOpacity(isHovering ? 0.25 : 0.2)
                  : AppColors.favColourDark!.withOpacity(
                      isHovering ? 0.25 : 0.2,
                    ))
            : null,
        gradient: color1 != null && color2 != null
            ? LinearGradient(
                colors: isDisabled
                    ? [color1!.withOpacity(0.25), color2!.withOpacity(0.25)]
                    : [
                        color1!.withOpacity(isHovering ? 0.30 : 0.22),
                        color2!.withOpacity(isHovering ? 0.30 : 0.22),
                      ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,

        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color:
              // isDark
              //     ? AppColors.favColour.withOpacity(0.5)
              //     : AppColors.favColourDark!.withOpacity(0.5),
              isDisabled
              ? effectiveColor.withOpacity(0.15) // very faint background
              // : (isDark
              //       ? AppColors.favColour.withOpacity(isHovering ? 0.25 : 0.2)
              //       : AppColors.favColourDark!.withOpacity(
              //           isHovering ? 0.25 : 0.2,
              //         )),
              : resolvedColor1.withOpacity(isHovering ? 0.55 : 0.40),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          icon ?? Icon(Icons.payment, color: effectiveColor),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                // color: color,
                color: isDisabled ? effectiveColor : effectiveColor,
                // fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isloading ?? false) ...[
            const SizedBox(width: 12),
            SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: effectiveColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CircularButton extends StatelessWidget {
  final Widget? icon;
  final double size;
  final bool isDisabled;
  final bool? isloading;
  final bool isHovering;

  const _CircularButton({
    this.icon,
    this.size = 60,
    this.isDisabled = false,
    this.isloading = false,
    this.isHovering = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Gradient effectiveGradient;
    final btnPrColor = AppColors.favColour;
    // final btnSecColor = AppColors.favColour_sec;
    final btnSecColor = AppColors.favColourDark;

    final brandGradient = LinearGradient(
      colors: [btnPrColor, btnSecColor],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    final darkGradientOverlay = LinearGradient(
      colors: [btnPrColor.withOpacity(0.65), btnSecColor.withOpacity(0.65)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    final lightHoverGradient = LinearGradient(
      colors: [btnPrColor, btnSecColor],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    if (isDisabled) {
      effectiveGradient = LinearGradient(
        colors: isDark
            ? [const Color(0xFF2A3A4A), const Color(0xFF1E2A38)]
            : [const Color(0xFFD0D0D0), const Color(0xFFB0B0B0)],
      );
    } else if (isDark) {
      effectiveGradient = isHovering ? darkGradientOverlay : brandGradient;
    } else {
      effectiveGradient = isHovering ? lightHoverGradient : brandGradient;
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: isHovering ? size * 1.1 : size,
      height: isHovering ? size * 1.1 : size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // gradient: isDisabled
        //     ? LinearGradient(colors: [Color(0xFF1A2E2B), Color(0xFF132624)])
        //     : LinearGradient(
        //         begin: Alignment.topLeft,
        //         end: Alignment.bottomRight,
        //         colors: isHovering
        //             ? [Color(0xFF66E6C9), Color(0xFF66C6E6)]
        //             : [Color(0xFF00FFB2), Color(0xFF00C2FF)],
        // ),
        gradient: effectiveGradient,

        boxShadow: (isDisabled || (isloading ?? false))
            ? []
            : [
                BoxShadow(
                  color: Colors.white.withOpacity(isHovering ? 0.3 : 0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
      ),
      child: Center(
        child: (isloading ?? false)
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.black87,
                ),
              )
            : icon != null
            ? IconTheme(
                data: const IconThemeData(color: Colors.black87, size: 26),
                child: icon!,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

// 4. New _GlowButton class — add after _CircularButton
class _GlowButton extends StatelessWidget {
  final String label;
  final Widget? icon;
  final double? height;
  final double? width;
  final bool iconRight;
  final bool isDisabled;
  final bool? isloading;
  final bool isHovering;
  final double? customFontSize;
  final Color glowColor;

  const _GlowButton({
    required this.label,
    this.icon,
    this.height,
    this.width,
    this.iconRight = false,
    this.isDisabled = false,
    this.isloading = false,
    this.isHovering = false,
    this.customFontSize,
    this.glowColor = AppColors.favColour,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      // height: height ?? 44,
      height: height ?? (Responsive.isMobile(context) ? 40 : 44),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHovering
              ? glowColor.withOpacity(0.7)
              : Colors.white.withOpacity(0.15),
        ),
        boxShadow: isHovering
            ? [
                BoxShadow(
                  color: glowColor.withOpacity(0.25),
                  blurRadius: 15,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: Colors.white.withOpacity(isDisabled ? 0.02 : 0.05),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null && !iconRight) ...[
                  icon!,
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDisabled
                          ? glowColor.withOpacity(0.4)
                          : glowColor,
                      fontWeight: FontWeight.bold,
                      fontSize: customFontSize ?? 16,
                    ),
                  ),
                ),
                if (isloading ?? false) ...[
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: glowColor,
                    ),
                  ),
                ],
                if (icon != null && iconRight) ...[
                  const SizedBox(width: 8),
                  icon!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CircularPayButton extends StatelessWidget {
  final Widget? icon;
  final double size;
  final bool isDisabled;
  final bool? isloading;
  final bool isHovering;

  const _CircularPayButton({
    this.icon,
    this.size = 60,
    this.isDisabled = false,
    this.isloading = false,
    this.isHovering = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark
        ? AppColors.favColour.withOpacity(0.9)
        : AppColors.favColourDark!.withOpacity(0.9);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: isHovering ? size * 1.1 : size,
      height: isHovering ? size * 1.1 : size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark
            ? AppColors.favColour.withOpacity(isHovering ? 0.25 : 0.2)
            : AppColors.favColourDark!.withOpacity(isHovering ? 0.25 : 0.2),
        border: Border.all(
          color: isDark
              ? AppColors.favColour.withOpacity(0.5)
              : AppColors.favColourDark!.withOpacity(0.5),
        ),
        boxShadow: isHovering && !isDisabled
            ? [
                BoxShadow(
                  color: activeColor.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(
        child: (isloading ?? false)
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: activeColor,
                ),
              )
            : icon != null
            ? IconTheme(
                data: IconThemeData(color: activeColor, size: 26),
                child: icon!,
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _TextButton extends StatelessWidget {
  final String? prefixText;
  final String label;

  final TextStyle? prefixStyle;
  final TextStyle? labelStyle;

  final VoidCallback onPressed;
  final bool isDisabled;
  final bool? isloading;
  final bool isHovering;

  const _TextButton({
    super.key,
    this.prefixText,
    required this.label,
    this.prefixStyle,
    this.labelStyle,
    required this.onPressed,
    this.isDisabled = false,
    this.isloading = false,
    this.isHovering = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isDisabled || (isloading ?? false)) ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isHovering && !isDisabled
              ? Theme.of(context).colorScheme.onSurface.withOpacity(0.03)
              : Colors.transparent,
        ),
        child: Opacity(
          opacity: (isDisabled || (isloading ?? false)) ? 0.5 : 1.0,
          child: Container(
            child: RichText(
              text: TextSpan(
                children: [
                  if (prefixText != null)
                    TextSpan(
                      text: prefixText,
                      style:
                          prefixStyle ??
                          const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  const TextSpan(text: " "),
                  TextSpan(
                    text: label,
                    style:
                        labelStyle ??
                        TextStyle(
                          color: AppColors.favColour,
                          fontSize: 16,
                          // fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
