import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimens.dart';
import 'glass_card.dart';

class GlassInputField extends StatefulWidget {
  final String label;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;

  const GlassInputField({
    super.key,
    required this.label,
    this.obscureText = false,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<GlassInputField> createState() => _GlassInputFieldState();
}

class _GlassInputFieldState extends State<GlassInputField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocusChange);
    _obscureText = widget.obscureText;
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      blurIntensity: 5,
      padding: EdgeInsets.zero,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isFocused ? AppColors.accentGreen : Colors.transparent,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusL),
        ),
        child: TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.obscureText ? _obscureText : false,
          keyboardType: widget.keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: const TextStyle(color: AppColors.textSecondary),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spacingM,
              vertical: AppDimens.spacingM,
            ),
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() => _obscureText = !_obscureText);
                    },
                  )
                : null,
          ),
          validator: widget.validator,
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:insured/core/widgets/glass_card.dart';

// class GlassInputField extends StatefulWidget {
//   final String label;
//   final bool obscureText;
//   final TextEditingController controller;
//   final String? Function(String?)? validator;

//   const GlassInputField({
//     Key? key,
//     required this.label,
//     this.obscureText = false,
//     required this.controller,
//     this.validator,
//   }) : super(key: key);

//   @override
//   _GlassInputFieldState createState() => _GlassInputFieldState();
// }

// class _GlassInputFieldState extends State<GlassInputField> {
//   bool _isFocused = false;
//   late final FocusNode _focusNode;
//   bool _obscureText = true;

//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode()
//       ..addListener(() {
//         setState(() => _isFocused = _focusNode.hasFocus);
//       });
//     _obscureText = widget.obscureText;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GlassCard(
//       blurIntensity: 5,
//       padding: EdgeInsets.zero,
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: _isFocused ? AppColors.accentGreen : Colors.transparent,
//             width: 1.5,
//           ),
//         ),
//         child: TextFormField(
//           controller: widget.controller,
//           focusNode: _focusNode,
//           obscureText: widget.obscureText ? _obscureText : false,
//           decoration: InputDecoration(
//             labelText: widget.label,
//             border: InputBorder.none,
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 14,
//             ),
//             suffixIcon: widget.obscureText
//                 ? IconButton(
//                     icon: Icon(
//                       _obscureText ? Icons.visibility_off : Icons.visibility,
//                     ),
//                     onPressed: () =>
//                         setState(() => _obscureText = !_obscureText),
//                   )
//                 : null,
//           ),
//           validator: widget.validator,
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }
// }
