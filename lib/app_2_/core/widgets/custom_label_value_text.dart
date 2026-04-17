import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';

/// Displays a label (with opacity 0.8) and a value side by side or in a row.
/// The label is styled as caption, the value can be customized.
class CustomLabelValueText extends StatelessWidget {
  final String label;
  final String value;
  final CustomTextType valueType; // default to caption, can be paragraph etc.
  final double labelOpacity;
  final bool spaceBetween; // if true, puts label and value at ends (for Row)
  final bool inline; // if true, shows in a single Row; else Column

  const CustomLabelValueText({
    super.key,
    required this.label,
    required this.value,
    this.valueType = CustomTextType.caption,
    this.labelOpacity = 0.8,
    this.spaceBetween = false,
    this.inline = true,
  });

  @override
  Widget build(BuildContext context) {
    final labelWidget = Opacity(
      opacity: labelOpacity,
      child: CustomText(
        '$label: ',
        type: CustomTextType.caption,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    final valueWidget = CustomText(
      value,
      type: valueType,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    if (inline) {
      return Row(
        mainAxisAlignment: spaceBetween
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        children: [
          labelWidget,
          const SizedBox(width: 4),
          Expanded(child: valueWidget),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [labelWidget, const SizedBox(height: 2), valueWidget],
      );
    }
  }
}
