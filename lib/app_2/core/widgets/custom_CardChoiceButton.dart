import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';

/// Data class for each selectable card option
class ButtonCardOption<T> {
  final T key;
  final String title;
  final String? description;
  final Widget? icon; // can be any widget (Icon, Image, etc.)

  ButtonCardOption({
    required this.key,
    required this.title,
    this.description,
    this.icon,
  });
}

/// A responsive grid of selectable cards with optional "View Benefits" button.
///
/// - [options] : list of options to display
/// - [selectedKey] : currently selected option's key
/// - [onSelect] : callback when a card is tapped
/// - [columns] : number of columns on large screens (small screens use columns-1, min 1)
/// - [onViewMore] : optional callback when the "View Benefits" button is tapped
/// - [selectedColor] : color used for border, background, and checkmark when selected (default red)
class ButtonCardChoice<T> extends StatefulWidget {
  final List<ButtonCardOption<T>> options;
  final T? selectedKey;
  final void Function(T) onSelect;
  final int columns;
  final void Function(T)? onViewMore;
  final Color selectedColor;

  const ButtonCardChoice({
    super.key,
    required this.options,
    required this.selectedKey,
    required this.onSelect,
    this.columns = 2,
    this.onViewMore,
    this.selectedColor = Colors.red,
  });

  @override
  State<ButtonCardChoice<T>> createState() => _ButtonCardChoiceState<T>();
}

class _ButtonCardChoiceState<T> extends State<ButtonCardChoice<T>> {
  // Store scale factors for hover/press animations (keyed by option key)
  final Map<T, double> _scales = {};
  final Map<T, bool> _hovered = {};

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive columns: small screen = max(1, widget.columns-1), large = widget.columns
        final isLargeScreen = constraints.maxWidth > 600; // breakpoint
        final crossAxisCount = isLargeScreen
            ? widget.columns
            : (widget.columns > 1 ? widget.columns - 1 : 1);

        return GridView.builder(
          shrinkWrap: true, // so it doesn't force infinite height
          physics: const NeverScrollableScrollPhysics(), // let parent scroll
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2, // adjust to your liking
          ),
          itemCount: widget.options.length,
          itemBuilder: (context, index) {
            final option = widget.options[index];
            final isSelected = widget.selectedKey == option.key;
            final scale = _scales[option.key] ?? 1.0;
            final isHovered = _hovered[option.key] ?? false;

            return AnimatedScale(
              scale: scale,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: MouseRegion(
                onEnter: (_) => _setHovered(option.key, true),
                onExit: (_) => _setHovered(option.key, false),
                child: GestureDetector(
                  onTapDown: (_) => _setScale(option.key, 0.95),
                  onTapUp: (_) => _setScale(option.key, 1.0),
                  onTapCancel: () => _setScale(option.key, 1.0),
                  onTap: () => widget.onSelect(option.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? widget.selectedColor
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                      color: isSelected
                          ? widget.selectedColor.withOpacity(0.1)
                          : (isHovered ? Colors.grey.shade50 : Colors.white),
                      boxShadow: isHovered
                          ? [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (option.icon != null) ...[
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? widget.selectedColor.withOpacity(0.2)
                                      : Colors.grey.shade200,
                                ),
                                child: IconTheme(
                                  data: IconThemeData(
                                    color: isSelected
                                        ? widget.selectedColor
                                        : Colors.grey.shade700,
                                    size: 20,
                                  ),
                                  child: option.icon!,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: CustomText(
                                option.title,
                                type: CustomTextType.paragraph,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Description (if any)
                        if (option.description != null) ...[
                          Text(
                            option.description!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                        ],
                        const Spacer(),
                        // Bottom row: View Benefits button (if provided) + checkmark
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (widget.onViewMore != null)
                              GestureDetector(
                                onTap: () {
                                  // Stop propagation to the parent card
                                  widget.onViewMore!(option.key);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: widget.selectedColor.withOpacity(
                                      0.1,
                                    ),
                                  ),
                                  child: Text(
                                    'View Benefits',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: widget.selectedColor,
                                    ),
                                  ),
                                ),
                              )
                            else
                              const SizedBox.shrink(),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                color: widget.selectedColor,
                                size: 24,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _setScale(T key, double scale) {
    setState(() {
      _scales[key] = scale;
    });
  }

  void _setHovered(T key, bool hovered) {
    setState(() {
      _hovered[key] = hovered;
    });
  }
}




// // USEAGE:
// //
// final options = [
//   ButtonCardOption<String>(
//     key: 'basic',
//     title: 'Basic Cover',
//     description: 'Essential protection at an affordable price.',
//     icon: Icon(Icons.shield),
//   ),
//   ButtonCardOption<String>(
//     key: 'premium',
//     title: 'Premium Cover',
//     description: 'Comprehensive coverage with extra benefits.',
//     icon: Icon(Icons.verified),
//   ),
// ];

// String? selectedOption;

// ButtonCardChoice<String>(
//   options: options,
//   selectedKey: selectedOption,
//   onSelect: (key) => setState(() => selectedOption = key),
//   columns: 2, // optional, default 2
//   onViewMore: (key) {
//     // Handle "View Benefits" tap
//     print('View benefits for $key');
//   },
//   selectedColor: Colors.blue, // customize
// ) 