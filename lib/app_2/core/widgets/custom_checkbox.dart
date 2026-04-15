import 'package:flutter/material.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final Color? activeColor;
  final Color? textColor;
  final String? cacheKey;
  final MemoryCacheService? cache;
  final double? fontSize;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.activeColor,
    this.textColor,
    this.cacheKey,
    this.cache,
    this.fontSize,
  });

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  void initState() {
    super.initState();

    if (widget.cacheKey != null && widget.cache != null) {
      final cached = widget.cache!.get(widget.cacheKey!);
      if (cached != null) {
        final cachedVal = cached == 'true';
        if (cachedVal != widget.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) widget.onChanged(cachedVal);
          });
        }
      }
    }
  }

  void _handleChange(bool newVal) {
    if (widget.cacheKey != null && widget.cache != null) {
      widget.cache!.put(widget.cacheKey!, newVal.toString());
    }
    widget.onChanged(newVal);
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.textColor ?? Theme.of(context).colorScheme.onSurface;
    final activeColor =
        widget.activeColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.greenAccent
            : Colors.green[900]!);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _handleChange(!widget.value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: widget.value,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(horizontal: -4, vertical: -2),

            activeColor: activeColor,
            onChanged: (val) => _handleChange(val ?? false),
          ),
          Flexible(
            child: CustomText(
              widget.label,
              color: color,
              fontSize: widget.fontSize,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
