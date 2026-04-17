import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';

enum SuperTabBarMode { ColorModeA, ColorModeB }

// optional custom index.
class SuperTabItem {
  final String label;
  final IconData? icon;
  final int?
  index; // i made,  if provided, onTap will be called with this value instead of list position.

  const SuperTabItem({required this.label, this.icon, this.index});
}

class CustomSuperTabBar extends StatelessWidget {
  final List<SuperTabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  final SuperTabBarMode? mode;

  final Color? selectedBackgroundColor;
  final Color? selectedForegroundColor;
  final Color? unselectedBackgroundColor;
  final Color? unselectedForegroundColor;
  final Color? containerBackgroundColor;
  final Color? borderColor;
  final bool showSelectedShadow;
  final double borderRadius;
  final EdgeInsets? tabPadding;
  final Duration animationDuration;

  const CustomSuperTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
    this.mode,
    this.selectedBackgroundColor,
    this.selectedForegroundColor,
    this.unselectedBackgroundColor,
    this.unselectedForegroundColor,
    this.containerBackgroundColor,
    this.borderColor,
    this.showSelectedShadow = false,
    this.borderRadius = 12.0,
    this.tabPadding,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Determine effective colors based on mode (if set) and manual overrides.
    final effectiveColors = _resolveColors(theme, isDark);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: effectiveColors.containerBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: effectiveColors.border),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final item = tabs[index];
          final itemValue =
              item.index ??
              index; // Use custom index if provided, else list index.
          final isSelected = selectedIndex == itemValue;

          final verticalPadding =
              tabPadding?.vertical ??
              (Responsive.isMobile(context) ? 6.0 : 8.0);
          final horizontalPadding = tabPadding?.horizontal ?? 12.0;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(itemValue),
              child: AnimatedContainer(
                duration: animationDuration,
                padding: EdgeInsets.symmetric(
                  vertical: verticalPadding,
                  horizontal: horizontalPadding,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? effectiveColors.selectedBg
                      : effectiveColors.unselectedBg,
                  borderRadius: BorderRadius.circular(borderRadius - 2),
                  boxShadow: isSelected && effectiveColors.showShadow
                      ? [
                          BoxShadow(
                            color: effectiveColors.selectedBg.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (item.icon != null) ...[
                      Icon(
                        item.icon,
                        size: 20,
                        color: isSelected
                            ? effectiveColors.selectedFg
                            : effectiveColors.unselectedFg,
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: CustomText(
                        item.label,
                        type: CustomTextType.paragraph,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: isSelected
                            ? FontWeight.w500
                            : FontWeight.normal,
                        color: isSelected
                            ? effectiveColors.selectedFg
                            : effectiveColors.unselectedFg,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  _ResolvedColors _resolveColors(ThemeData theme, bool isDark) {
    Color? selectedBg = selectedBackgroundColor;
    Color? selectedFg = selectedForegroundColor;
    Color? unselectedBg = unselectedBackgroundColor;
    Color? unselectedFg = unselectedForegroundColor;
    Color? containerBg = containerBackgroundColor;
    Color? border = borderColor;
    bool shadow = showSelectedShadow;

    // --- Apply mode presets if mode is provided and colors not manually overridden ---
    if (mode != null) {
      switch (mode!) {
        case SuperTabBarMode.ColorModeA:
          selectedBg ??= isDark ? theme.colorScheme.surface : Colors.green[900];
          selectedFg ??= isDark ? Colors.greenAccent : Colors.white;
          unselectedBg ??= Colors.transparent;
          unselectedFg ??= theme.colorScheme.onSurface;
          containerBg ??= theme.colorScheme.onSurface.withOpacity(0.1);
          border ??= theme.colorScheme.onSurface.withOpacity(0.2);
          if (!showSelectedShadow) shadow = true;
          break;

        case SuperTabBarMode.ColorModeB:
          selectedBg ??= isDark
              ? const Color(0xFF00FFB2).withOpacity(0.25)
              // : Colors.green[900]?.withOpacity(0.2);
              : Colors.green[900]?.withOpacity(0.8);

          selectedFg ??= isDark ? const Color(0xFF00FFB2) : Colors.white;
          unselectedBg ??= Colors.transparent;
          unselectedFg ??= theme.colorScheme.onSurface;
          containerBg ??= theme.colorScheme.onSurface.withOpacity(0.1);
          border ??= theme.colorScheme.onSurface.withOpacity(0.2);
          // ColorModeB mode doesn't use shadow by default.
          break;
      }
    }

    selectedBg ??= const Color(0xFF00FFB2).withOpacity(0.25);
    selectedFg ??= isDark ? const Color(0xFF00FFB2) : Colors.white;
    unselectedBg ??= Colors.transparent;
    unselectedFg ??= theme.colorScheme.onSurface;
    containerBg ??= theme.colorScheme.onSurface.withOpacity(0.1);
    border ??= theme.colorScheme.onSurface.withOpacity(0.2);

    return _ResolvedColors(
      selectedBg: selectedBg,
      selectedFg: selectedFg,
      unselectedBg: unselectedBg,
      unselectedFg: unselectedFg,
      containerBg: containerBg,
      border: border,
      showShadow: shadow,
    );
  }
}

/// Internal helper to bundle resolved colors.
class _ResolvedColors {
  final Color selectedBg;
  final Color selectedFg;
  final Color unselectedBg;
  final Color unselectedFg;
  final Color containerBg;
  final Color border;
  final bool showShadow;

  _ResolvedColors({
    required this.selectedBg,
    required this.selectedFg,
    required this.unselectedBg,
    required this.unselectedFg,
    required this.containerBg,
    required this.border,
    required this.showShadow,
  });
}


// import 'package:flutter/material.dart';
// import 'package:insured/app_2/core/utils/responsive.dart';
// import 'package:insured/app_2/core/widgets/custom_text.dart';

// class SuperTabItem {
//   final String label;
//   final IconData? icon;

//   const SuperTabItem({required this.label, this.icon});
// }

// class CustomSuperTabBar extends StatelessWidget {
//   final List<SuperTabItem> tabs;
//   final int selectedIndex;
//   final ValueChanged<int> onTap;
//   final Color? selectedBackgroundColor;
//   final Color? selectedForegroundColor;
//   final Color? unselectedBackgroundColor;
//   final Color? unselectedForegroundColor;
//   final Color? containerBackgroundColor;
//   final Color? borderColor;
//   final bool showSelectedShadow;
//   final double borderRadius;
//   final EdgeInsets? tabPadding;
//   final Duration animationDuration;

//   const CustomSuperTabBar({
//     super.key,
//     required this.tabs,
//     required this.selectedIndex,
//     required this.onTap,
//     this.selectedBackgroundColor,
//     this.selectedForegroundColor,
//     this.unselectedBackgroundColor,
//     this.unselectedForegroundColor,
//     this.containerBackgroundColor,
//     this.borderColor,
//     this.showSelectedShadow = false,
//     this.borderRadius = 12.0,
//     this.tabPadding,
//     this.animationDuration = const Duration(milliseconds: 200),
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     // Smart defaults that work out-of-the-box
//     final defaultSelectedBg = const Color(0xFF00FFB2).withOpacity(0.25);
//     // final defaultSelectedFg = isDark ? Colors.black : Colors.white;
//     final defaultSelectedFg = isDark ? Color(0xFF00FFB2) : Colors.white;
//     final defaultUnselectedBg = Colors.transparent;
//     final defaultUnselectedFg = theme.colorScheme.onSurface;
//     final defaultContainerBg = theme.colorScheme.onSurface.withOpacity(0.1);
//     final defaultBorderColor = theme.colorScheme.onSurface.withOpacity(0.2);

//     return Container(
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: containerBackgroundColor ?? defaultContainerBg,
//         borderRadius: BorderRadius.circular(borderRadius),
//         border: Border.all(color: borderColor ?? defaultBorderColor),
//       ),
//       child: Row(
//         children: List.generate(tabs.length, (index) {
//           final isSelected = selectedIndex == index;
//           final item = tabs[index];

//           // Calculate padding based on screen size
//           final verticalPadding =
//               tabPadding?.vertical ??
//               (Responsive.isMobile(context) ? 6.0 : 8.0);
//           final horizontalPadding = tabPadding?.horizontal ?? 12.0;

//           return Expanded(
//             child: GestureDetector(
//               onTap: () => onTap(index),
//               child: AnimatedContainer(
//                 duration: animationDuration,
//                 padding: EdgeInsets.symmetric(
//                   vertical: verticalPadding,
//                   horizontal: horizontalPadding,
//                 ),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? (selectedBackgroundColor ?? defaultSelectedBg)
//                       : (unselectedBackgroundColor ?? defaultUnselectedBg),
//                   borderRadius: BorderRadius.circular(borderRadius - 2),
//                   boxShadow: isSelected && showSelectedShadow
//                       ? [
//                           BoxShadow(
//                             color:
//                                 (selectedBackgroundColor ?? defaultSelectedBg)
//                                     .withOpacity(0.4),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           ),
//                         ]
//                       : null,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     if (item.icon != null) ...[
//                       Icon(
//                         item.icon,
//                         size: 20,
//                         color: isSelected
//                             ? (selectedForegroundColor ?? defaultSelectedFg)
//                             : (unselectedForegroundColor ??
//                                   defaultUnselectedFg),
//                       ),
//                       const SizedBox(width: 8),
//                     ],
//                     Flexible(
//                       child: CustomText(
//                         item.label,
//                         type: CustomTextType.paragraph,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         fontWeight: isSelected
//                             ? FontWeight.w500
//                             : FontWeight.normal,
//                         color: isSelected
//                             ? (selectedForegroundColor ?? defaultSelectedFg)
//                             // .withOpacity(0.8)
//                             : (unselectedForegroundColor ??
//                                   defaultUnselectedFg),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }



//   // Widget _buildClientTabs_() {
//   //   return CustomSuperTabBar(
//   //     tabs: const [
//   //       SuperTabItem(label: 'Existing Client'),
//   //       SuperTabItem(label: 'New Client'),
//   //     ],
//   //     selectedIndex: _clientMode,
//   //     onTap: (index) {
//   //       setState(() {
//   //         _clientMode = index;
//   //         if (index == 1) {
//   //           _selectedClient = null;
//   //           _clearClientControllers();
//   //         }
//   //       });
//   //       final ColorModeBCache = ref.read(ColorModeBSaveCacheProvider);
//   //       ColorModeBCache.put('clientMode', index.toString());
//   //       if (index == 1) ColorModeBCache.remove('selectedClientData');
//   //     },
//   //     // showSelectedShadow: true,
//   //   );
//   // }
