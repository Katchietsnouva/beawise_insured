import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/theme/custom_text_styles.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String hint;
  final String? hintLabel;
  final IconData icon;
  final T? value;
  // i Kept this as DropdownMenuItem so my other screens don't break
  final List<DropdownMenuItem<T>>? items;
  // final Map<String, List<T>>? groupedItems;
  final Map<String, List<dynamic>>? groupedItems;
  final void Function(T?) onChanged;
  final bool enabled;
  final bool isRequired;
  final String? Function(T?)? validator;
  final String? cacheKey;
  final MemoryCacheService? cache;

  const CustomDropdown({
    super.key,
    required this.hint,
    this.hintLabel,
    required this.icon,
    required this.value,
    this.items,
    this.groupedItems,
    required this.onChanged,
    this.enabled = true,
    this.isRequired = false,
    this.validator,
    this.cacheKey,
    this.cache,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final TextEditingController textEditingController = TextEditingController();
  late ValueNotifier<T?> _valueNotifier;

  @override
  void initState() {
    super.initState();
    T? initial = widget.value;

    // if (initial == null && widget.cacheKey != null && widget.cache != null) {
    //   final cached = widget.cache!.get(widget.cacheKey!);
    //   if (cached != null) {
    //     final match = widget.items?.firstWhere(
    //       (item) => item.value.toString() == cached,
    //       orElse: () => widget.items!.first,
    //     );
    //     initial = match?.value;
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       widget.onChanged(initial);
    //     });
    //   }
    // }

    // Inside initState
    if (initial == null && widget.cacheKey != null && widget.cache != null) {
      final cached = widget.cache!.get(widget.cacheKey!);
      if (cached != null) {
        if (widget.groupedItems != null) {
          outerLoop:
          for (var list in widget.groupedItems!.values) {
            for (var item in list) {
              T val = (item is List) ? item[0] as T : item as T;
              if (val.toString() == cached) {
                initial = val;
                break outerLoop;
              }
            }
          }
        } else {
          // Fallback for standard items
          final match = widget.items?.firstWhere(
            (item) => item.value.toString() == cached,
            orElse: () => widget.items!.first,
          );
          initial = match?.value;
        }

        if (initial != null) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => widget.onChanged(initial),
          );
        }
      }
    }
    _valueNotifier = ValueNotifier(initial);
    // _valueNotifier = ValueNotifier(widget.value);
  }

  @override
  void didUpdateWidget(CustomDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _valueNotifier.value = widget.value;
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _valueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final onSurface = theme.colorScheme.onSurface;
    final surface = theme.colorScheme.surface;
    bool _isMenuOpen = false;

    List<DropdownItem<T>> convertedItems = [];

    // if (widget.groupedItems != null) {
    //   widget.groupedItems!.forEach((category, items) {
    //     final bool isUngrouped = category.toLowerCase() == 'ungrouped';
    //     if (!isUngrouped) {
    //       convertedItems.add(
    //         DropdownItem<T>(
    //           value: null,
    //           enabled: false,
    //           child: Container(
    //             padding: const EdgeInsets.symmetric(vertical: 4),
    //             child: CustomText(
    //               category,
    //               type: CustomTextType.caption,
    //               fontWeight: FontWeight.bold,
    //               // color: theme.primaryColor,
    //             ),
    //           ),
    //         ),
    //       );
    //     }

    //     for (var item in items) {
    //       convertedItems.add(
    //         DropdownItem<T>(
    //           value: item,
    //           child: Padding(
    //             padding: EdgeInsets.only(left: isUngrouped ? 0 : 16),
    //             child: Text(item.toString()),
    //           ),
    //         ),
    //       );
    //     }
    //   });
    if (widget.groupedItems != null) {
      widget.groupedItems!.forEach((category, items) {
        // final bool isUngrouped = category.toLowerCase() == 'ungrouped';
        final bool isUngrouped = category.toLowerCase().startsWith('ungrouped');

        if (!isUngrouped) {
          convertedItems.add(
            DropdownItem<T>(
              value: null,
              enabled: false,
              child: Opacity(
                opacity: 0.5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CustomText(
                    category,
                    type: CustomTextType.caption,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }

        // 2. Sub-items with Tuple Check
        for (var item in items) {
          T itemValue;
          String itemLabel;

          if (item is List && item.length >= 2) {
            // It's a [Value, Label] pair
            itemValue = item[0] as T;
            itemLabel = item[1].toString();
          } else {
            // It's just a raw value
            itemValue = item as T;
            itemLabel = item.toString();
          }

          // convertedItems.add(
          //   DropdownItem<T>(
          //     value: itemValue,
          //     child: Padding(
          //       padding: EdgeInsets.only(left: isUngrouped ? 0 : 16),
          //       child: Text(itemLabel), // User sees the Label
          //     ),
          //   ),
          // );
          // final bool isSelected = _valueNotifier.value == itemValue;
          final bool isSelected =
              _valueNotifier.value?.toString() == itemValue?.toString();
          // final bool isSelected = _isMenuOpen && _valueNotifier.value == itemValue;

          convertedItems.add(
            DropdownItem<T>(
              value: itemValue,
              child: Container(
                width: double.infinity,
                // Match the padding of your headers
                padding: EdgeInsets.only(
                  left: isUngrouped ? 8 : 16,
                  top: 8,
                  bottom: 8,
                  right: 8,
                ),
                decoration: BoxDecoration(
                  // Light background highlight for the selected item
                  color: isSelected
                      ? (!isDark
                            ? AppColors.favColourDark!.withOpacity(0.3)
                            : theme.primaryColor.withOpacity(0.1))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),

                // child: CustomText(
                //   itemLabel,
                //   color: isSelected
                //       ? (Theme.of(context).brightness == Brightness.light
                //             ? Colors.green[900]
                //             : theme.primaryColor)
                //       : onSurface,
                //   fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                // ),
                child: Text(
                  itemLabel,
                  style: TextStyle(
                    // Bold text and primary color for the selected item
                    fontWeight: isSelected ? FontWeight.w400 : FontWeight.w300,
                    color: isSelected
                        ? (isDark ? AppColors.favColour : theme.primaryColor)
                        : onSurface,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }
      });
      // } else if (widget.items != null) {
      //   // Fallback for your old code
      //   convertedItems = widget.items!.map((item) {
      //     return DropdownItem<T>(
      //       value: item.value, child: item.child);
      //   }).toList();
      // }
    } else if (widget.items != null) {
      // Build highlighted items for plain lists
      for (var item in widget.items!) {
        final itemValue = item.value;
        final itemChild = item.child;
        final isSelected = _valueNotifier.value == itemValue;

        convertedItems.add(
          DropdownItem<T>(
            value: itemValue,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 8,
                top: 8,
                bottom: 8,
                right: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    // ? (Theme.of(context).brightness == Brightness.light
                    //       ? Colors.green[700]!.withOpacity(0.3)
                    //       : theme.primaryColor.withOpacity(0.1))
                    ? (!isDark
                          ? AppColors.favColourDark!.withOpacity(0.3)
                          : theme.primaryColor.withOpacity(0.1))
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      // ? (Theme.of(context).brightness == Brightness.light
                      //       ? Colors.green[900]
                      //       : theme.primaryColor)
                      // ? (isDark ? Colors.white : _DropdownTokens.blue)
                      ? (isDark ? AppColors.favColour : theme.primaryColor)
                      : onSurface,
                  fontSize: 12,
                ),
                child: itemChild,
              ),
            ),
          ),
        );
      }
    }

    // // Convert standard DropdownMenuItem to the package's DropdownItem
    // final List<DropdownItem<T>> convertedItems = widget.items.map((item) {
    //   return DropdownItem<T>(value: item.value, child: item.child);
    // }).toList();

    final int selectableCount = widget.groupedItems != null
        ? widget.groupedItems!.values
              .expand((list) => list)
              .where((item) => item != null)
              .length
        : (widget.items?.length ?? 0);
    final bool showSearch = selectableCount > 5;

    return Material(
      elevation: theme.brightness == Brightness.light ? 4 : 6,
      borderRadius: BorderRadius.circular(16),
      color: surface,
      child: DropdownButtonFormField2<T>(
        isExpanded: true,
        // v3.0.0 uses valueListenable instead of value/initialValue
        valueListenable: _valueNotifier,
        items: convertedItems,
        selectedItemBuilder: (BuildContext context) {
          return convertedItems.map((item) {
            // We need to extract just the label from the complex item child
            // or just return a plain Text widget.
            // Since some items are headers (value == null), we handle them gracefully.
            return Container(
              alignment: Alignment.centerLeft,
              child: Text(
                // This finds the label text. If it's a header, it won't be shown anyway
                // as headers are disabled and can't be selected.
                _extractTextFromItem(item.child),
                style: CustomTextStyles.style(
                  context,
                  type: CustomTextType.paragraph,
                  fontSize: 12,
                ).copyWith(color: onSurface),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList();
        },
        onChanged: widget.enabled
            ? (val) {
                if (val == null) return;

                _valueNotifier.value = val;
                if (widget.cacheKey != null && widget.cache != null) {
                  widget.cache!.put(widget.cacheKey!, val?.toString());
                }
                widget.onChanged(val);
              }
            : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        // decoration: InputDecoration(
        //   filled: true,
        //   fillColor: surface.withOpacity(0.7),
        //   prefixIcon: Icon(widget.icon, color: onSurface.withOpacity(0.7)),
        //   hintText: widget.hintLabel,
        //   label: Text.rich(
        //     TextSpan(
        //       children: [
        //         TextSpan(
        //           text: widget.hint,
        //           style: CustomTextStyles.style(
        //             context,
        //             type: CustomTextType.caption,
        //           ),
        //         ),
        //         if (widget.isRequired)
        //           const TextSpan(
        //             text: ' *',
        //             style: TextStyle(color: Colors.red),
        //           ),
        //       ],
        //     ),
        //   ),
        //   contentPadding: const EdgeInsets.symmetric(vertical: 8),
        //   border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        // ),
        decoration: _buildInputDecoration(theme, onSurface, surface),

        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: surface.withOpacity(0.95),
            boxShadow: [
              BoxShadow(
                color: AppColors.favColour.withOpacity(isDark ? 0.15 : 0.08),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          offset: const Offset(0, -8),
        ),
        dropdownSearchData: showSearch
            ? DropdownSearchData<T>(
                searchController: textEditingController,
                searchBarWidgetHeight: 50,
                searchBarWidget: Container(
                  height: 50,
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    controller: textEditingController,
                    style: CustomTextStyles.style(
                      context,
                      type: CustomTextType.paragraph,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: AppColors.favColour.withOpacity(0.8),
                          width: 0.9,
                        ),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return item.value.toString().toLowerCase().contains(
                    searchValue.toLowerCase(),
                  );
                },
              )
            : null,
        onMenuStateChange: (isOpen) {
          setState(() {
            _isMenuOpen = isOpen;
          });
          if (!isOpen) textEditingController.clear();
        },
        validator: widget.validator,
      ),
    );
  }

  _buildInputDecoration(ThemeData theme, Color onSurface, Color surface) {
    return InputDecoration(
      filled: true,
      fillColor: surface.withOpacity(0.7),
      prefixIcon: Icon(widget.icon, color: onSurface.withOpacity(0.7)),
      hintText: widget.hintLabel,
      hintStyle: CustomTextStyles.style(
        context,
        type: CustomTextType.caption,
        // fontSize: 11,
      ).copyWith(color: onSurface.withOpacity(0.7)),
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: widget.hint,
              style: CustomTextStyles.style(
                context,
                type: CustomTextType.caption,
              ),
            ),
            if (widget.isRequired)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: theme.brightness == Brightness.light
              ? onSurface.withOpacity(0.5)
              : surface.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: theme.brightness == Brightness.light
              ? onSurface.withOpacity(0.3)
              : surface.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: theme.brightness == Brightness.light
              ? AppColors.favColourDark.withOpacity(0.6)
              : AppColors.favColourDark.withOpacity(0.6),
          width: 1.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// Helper to extract the actual values from your [Value, Label] pairs
List<String> getFlatValuesCustomDropdown(List<dynamic> items) {
  return items.map((item) {
    if (item is List && item.isNotEmpty) return item[0].toString();
    return item.toString();
  }).toList();
}

String _extractTextFromItem_(Widget child) {
  if (child is Container) {
    // If it's our highlighted container, drill down to the Text widget
    final containerChild = child.child;
    if (containerChild is Text) {
      return containerChild.data ?? '';
    }
  } else if (child is CustomText) {
    // If it's a header
    return child.text;
  } else if (child is Text) {
    return child.data ?? '';
  }
  return '';
}

String _extractTextFromItem(Widget child) {
  if (child is Container) {
    final containerChild = child.child;
    if (containerChild is DefaultTextStyle) {
      // New structure for plain items: Container > DefaultTextStyle > Text
      final textWidget = containerChild.child;
      if (textWidget is Text) {
        return textWidget.data ?? '';
      }
    } else if (containerChild is Padding) {
      // Old grouped items might have Padding > Text
      final paddedChild = containerChild.child;
      if (paddedChild is Text) {
        return paddedChild.data ?? '';
      }
    } else if (containerChild is Text) {
      // Simple Container > Text (grouped items without padding)
      return containerChild.data ?? '';
    }
  } else if (child is CustomText) {
    return child.text;
  } else if (child is Text) {
    return child.data ?? '';
  }
  return '';
}
