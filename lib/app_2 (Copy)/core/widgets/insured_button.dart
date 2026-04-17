// // import 'dart:ffi';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:ui';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:insured/app_2/core/constants/app_colors.dart';
// import 'package:insured/app_2/core/widgets/futuristic_toastT.dart';

// enum ButtonVariant { primary, secondary, apple, google }

// enum WarnMode { vibrate, none }

// class InsuredButton extends StatefulWidget {
//   final String label;
//   final ButtonVariant variant;
//   final VoidCallback onPressed;
//   final double? height;
//   final double? width;
//   final IconData? icon;
//   final bool iconRight;
//   final bool isDisabled;
//   final bool? loading;

//   final bool Function()? validator;
//   final WarnMode warnMode;
//   final bool debugLogValidation;

//   const InsuredButton({
//     super.key,
//     required this.label,
//     required this.variant,
//     required this.onPressed,
//     this.height,
//     this.width,
//     this.icon,
//     this.iconRight = false,
//     this.isDisabled = false,
//     this.loading = false,
//     this.validator,
//     this.warnMode = WarnMode.vibrate,
//     this.debugLogValidation = false,
//   });

//   @override
//   State<InsuredButton> createState() => _InsuredButtonState();
// }

// class _InsuredButtonState extends State<InsuredButton>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _scale;
//   bool get _isDisabled => widget.isDisabled || (widget.loading ?? false);

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 120),
//     );
//     _scale = Tween<double>(
//       begin: 1.0,
//       end: 0.96,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   @override
//   Widget build(BuildContext context) {
//     return IgnorePointer(
//       // ignoring: widget.isDisabled || widget.loading,
//       ignoring: _isDisabled || (widget.loading ?? false),
//       child: GestureDetector(
//         onTapDown: _isDisabled ? null : (_) => _controller.forward(),
//         // onTapUp: widget.isDisabled
//         //     ? null
//         //     : (_) {
//         //         _controller.reverse();
//         //         HapticFeedback.lightImpact();
//         //         widget.onPressed();
//         //       },
//         onTapUp: _isDisabled
//             ? null
//             : (_) {
//                 _controller.reverse();

//                 if (widget.validator != null && !widget.validator!()) {
//                   debugPrint(
//                     'InsuredButton: Validation failed – fields are required.',
//                   ); // 👈 add this
//                   print(widget.validator);
//                   print(widget.validator!());
//                   // debugPrint(widget.validator!());

//                   if (!widget.debugLogValidation) {
//                     debugPrint(
//                       'InsuredButton: Validation failed for "${widget.label}"',
//                     );
//                   }

//                   // if (widget.warnMode == WarnMode.vibrate) {
//                   //   HapticFeedback.heavyImpact();
//                   // }
//                   if (Theme.of(context).platform != TargetPlatform.windows &&
//                       Theme.of(context).platform != TargetPlatform.macOS &&
//                       Theme.of(context).platform != TargetPlatform.linux) {
//                     HapticFeedback.vibrate();
//                   }

//                   // FuturisticToastT.show(
//                   //   context: context,
//                   //   message: "Fill fields for email and password",
//                   //   errors: {
//                   //     "Required Fields": [
//                   //       "Email is required",
//                   //       "Password is required",
//                   //     ],
//                   //   },
//                   //   icon: Icons.warning_amber_rounded,
//                   //   alignment: Alignment.topCenter,
//                   //   duration: const Duration(seconds: 6),
//                   // );

//                   // return;
//                 }

//                 HapticFeedback.lightImpact();
//                 widget.onPressed();
//               },

//         onTapCancel: _isDisabled ? null : () => _controller.reverse(),
//         child: AnimatedBuilder(
//           animation: _scale,
//           builder: (_, child) => Transform.scale(
//             scale: _isDisabled ? 1.0 : _scale.value,
//             child: child,
//           ),
//           child: Opacity(
//             opacity: _isDisabled ? 0.5 : 1.0,
//             child: _buildButton(),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildButton() {
//     switch (widget.variant) {
//       case ButtonVariant.primary:
//         return _PrimaryButton(
//           label: widget.label,
//           icon: widget.icon,
//           height: widget.height,
//           width: widget.width,
//           iconRight: widget.iconRight,
//           // isDisabled: widget.isDisabled,
//           isDisabled: _isDisabled,
//           isloading: widget.loading,
//         );
//       case ButtonVariant.secondary:
//         return _SecondaryButton(
//           label: widget.label,
//           icon: widget.icon,
//           height: widget.height,
//           width: widget.width,
//           iconRight: widget.iconRight,
//           // isDisabled: widget.isDisabled,
//           isDisabled: _isDisabled,
//           isloading: widget.loading,
//         );
//       case ButtonVariant.apple:
//         return _AppleButton(label: widget.label, isDisabled: _isDisabled);
//       case ButtonVariant.google:
//         return _GoogleButton(label: widget.label, isDisabled: _isDisabled);
//     }
//   }
// }

// class _PrimaryButton extends StatelessWidget {
//   final String label;
//   final IconData? icon;
//   final double? height;
//   final double? width;
//   final bool iconRight;
//   final bool isDisabled;
//   final bool? isloading;

//   const _PrimaryButton({
//     required this.label,
//     this.icon,
//     this.height,
//     final this.width,
//     this.iconRight = false,
//     this.isDisabled = false,
//     this.isloading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // width: double.infinity,
//       height: height ?? 56,
//       width: width,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(30),

//         // gradient: (isDisabled || (isloading ?? false))
//         //     ? const LinearGradient(
//         //         colors: [Color(0xFFBBBBBB), Color(0xFFAAAAAA)],
//         //       )
//         //     : const LinearGradient(colors: [Colors.white, Color(0xFFEEEEEE)]),
//         gradient: (isDisabled)
//             ? const LinearGradient(
//                 colors: [Color(0xFF1A2E2B), Color(0xFF132624)],
//               )
//             : const LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [Color(0xFF00FFB2), Color(0xFF00C2FF)],
//               ),
//         boxShadow: (isDisabled || (isloading ?? false))
//             ? []
//             : [
//                 BoxShadow(
//                   color: Colors.white.withOpacity(0.2),
//                   blurRadius: 20,
//                   spreadRadius: 2,
//                 ),
//               ],
//       ),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // if (icon != null) Icon(icon, color: Colors.black87),
//               // if (icon != null) const SizedBox(width: 8),
//               if (icon != null && !iconRight) ...[
//                 Icon(icon, color: Colors.black87),
//                 const SizedBox(width: 8),
//               ],

//               Text(
//                 label,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 softWrap: false,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   // color: (isDisabled || (isloading ?? false))
//                   color: (isDisabled) ? Colors.white70 : Colors.black87,
//                 ),
//               ),
//               SizedBox(width: 6),
//               if (isloading ?? false)
//                 const SizedBox(
//                   height: 18,
//                   width: 18,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: AppColors.cyan,
//                   ),
//                 ),
//               if (icon != null && iconRight) ...[
//                 const SizedBox(width: 8),
//                 Icon(icon, color: Colors.black87),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SecondaryButton extends StatelessWidget {
//   final String label;
//   final IconData? icon;
//   final double? height;
//   final double? width;
//   final bool iconRight;
//   final bool isDisabled;
//   final bool? isloading;

//   const _SecondaryButton({
//     required this.label,
//     this.icon,
//     this.height,
//     this.width,
//     this.iconRight = false,
//     this.isDisabled = false,
//     this.isloading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(30),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
//         child: Container(
//           // width: double.infinity,
//           width: width,
//           height: height ?? 56,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30),
//             color: (isDisabled || (isloading ?? false))
//                 ? Colors.white.withOpacity(0.05)
//                 : Colors.white.withOpacity(0.1),
//             border: Border.all(
//               color: (isDisabled || (isloading ?? false))
//                   ? Colors.white.withOpacity(0.1)
//                   : Colors.white.withOpacity(0.2),
//             ),
//           ),
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   if (icon != null && !iconRight) ...[
//                     // Icon(icon, color: Colors.white),
//                     FaIcon(icon, color: Colors.white, size: 18),
//                     const SizedBox(width: 8),
//                   ],
//                   if (icon != null) const SizedBox(width: 8),
//                   Flexible(
//                     child: Text(
//                       label,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       softWrap: false,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                         color: (isDisabled || (isloading ?? false))
//                             ? Colors.white38
//                             : Colors.white,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 6),

//                   if (isloading ?? false) ...[
//                     const SizedBox(width: 8),
//                     const SizedBox(
//                       height: 18,
//                       width: 18,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: AppColors.cyan,
//                       ),
//                     ),
//                   ],
//                   if (icon != null && iconRight) ...[
//                     const SizedBox(width: 8),
//                     // Icon(icon, color: Colors.white),
//                     FaIcon(icon, color: Colors.white, size: 18),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _AppleButton extends StatelessWidget {
//   final String label;
//   final bool isDisabled;

//   const _AppleButton({required this.label, this.isDisabled = false});

//   @override
//   Widget build(BuildContext context) {
//     return _SecondaryButton(
//       label: label,
//       icon: Icons.apple,
//       isDisabled: isDisabled,
//     );
//   }
// }

// class _GoogleButton extends StatelessWidget {
//   final String label;
//   final bool isDisabled;

//   const _GoogleButton({required this.label, this.isDisabled = false});

//   @override
//   Widget build(BuildContext context) {
//     return _SecondaryButton(
//       label: label,
//       icon: FontAwesomeIcons.google,
//       isDisabled: isDisabled,
//     );
//   }
// }
