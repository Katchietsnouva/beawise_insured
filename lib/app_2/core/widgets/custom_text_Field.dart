import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/theme/app_theme.dart' show AppColors;
import 'package:insured/app_2/core/theme/custom_text_styles.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:intl/intl.dart';

class CustomTextField extends StatefulWidget {
  final String hint;
  final String? hintLabel;
  final IconData icon;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool enabled;
  final bool isRequired;
  final bool isDateField;
  final String? Function(String?)? validator;
  //  yo search-related properties
  final bool isSearchField;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSearchChanged;
  final Duration debounceDuration;

  // yo external callback for field submitted (e.g., Enter key)
  final ValueChanged<String>? onFieldSubmitted;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool isEmail;
  final bool isNumber;
  final String? validationMessage;
  final bool toNumberCommaFormat; //  to Toggle commas
  final bool allowDecimal;
  final String? cacheKey;
  final MemoryCacheService? cache;
  final int? minNumberOfChar;
  final int? maxNumberOfChar;
  final int? maxNumberOfCharHL;
  final bool isPin;
  final bool forceUppercase;
  final ValueNotifier<bool>? validityNotifier;

  const CustomTextField({
    super.key,
    this.hintLabel,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.isRequired = false,
    this.isDateField = false,
    this.validator,
    this.minDate,
    this.maxDate,

    this.isSearchField = false,
    this.onChanged,
    this.onSearchChanged,
    this.debounceDuration = const Duration(milliseconds: 500),
    this.onFieldSubmitted,
    this.isNumber = false,
    this.isEmail = false,
    this.validationMessage,
    this.toNumberCommaFormat = false,
    this.allowDecimal = false,
    this.cacheKey,
    this.cache,
    this.minNumberOfChar,
    this.maxNumberOfChar,
    this.maxNumberOfCharHL,
    this.isPin = false,
    this.forceUppercase = false,
    this.validityNotifier,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  late bool _isEmpty;
  bool _isHovering = false;
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _isEmpty = widget.controller.text.isEmpty;
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {
          _isEmpty = widget.controller.text.isEmpty;
        });
      }
    });
    _focusNode.addListener(() {
      if (mounted) setState(() {});
    });
    widget.controller.addListener(_onControllerChanged);
    _focusNode.addListener(() {
      if (mounted) setState(() {});
    });

    if (widget.cacheKey != null && widget.cache != null) {
      final cached = widget.cache!.get(widget.cacheKey!);
      if (cached != null &&
          cached.isNotEmpty &&
          widget.controller.text.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            widget.controller.text = cached;
            widget.controller.selection = TextSelection.collapsed(
              offset: cached.length,
            );
          }
        });
      }
    }
  }

  String? _runValidation(String? value) {
    final trimmedValue = value?.trim() ?? '';
    final rawValue = value?.replaceAll(',', '') ?? '';

    if (widget.validator != null) return widget.validator!(value);
    if (widget.isRequired && (value == null || value.trim().isEmpty)) {
      return widget.validationMessage ?? ' ';
    }
    if (widget.isEmail && trimmedValue.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(trimmedValue))
        return 'Enter a valid email address';
    }
    if (widget.toNumberCommaFormat && rawValue.isNotEmpty) {
      if (double.tryParse(rawValue) == null) return 'Invalid number';
    }
    if (widget.minNumberOfChar != null && trimmedValue.isNotEmpty) {
      if (trimmedValue.length < widget.minNumberOfChar!) {
        return 'Minimum ${widget.minNumberOfChar} characters required';
      }
    }
    if (widget.maxNumberOfChar != null && trimmedValue.isNotEmpty) {
      if (trimmedValue.length > widget.maxNumberOfChar!) {
        return 'Maximum ${widget.maxNumberOfChar} characters allowed';
      }
    }
    if (widget.isPin && trimmedValue.isNotEmpty) {
      final pinRegex = RegExp(r'^[A-Za-z][0-9]{9}[A-Za-z]$');
      if (trimmedValue.length != 11) return 'PIN must be exactly 11 characters';
      if (!pinRegex.hasMatch(trimmedValue))
        return 'Invalid PIN format (e.g. A123456789B)';
    }
    return null;
  }

  void _onControllerChanged() {
    if (!mounted) return;

    final String value = widget.controller.text;
    final bool newIsEmpty = value.isEmpty;

    if (newIsEmpty != _isEmpty) {
      setState(() {
        _isEmpty = newIsEmpty;
      });
    }

    // ✅ Update notifier immediately on every keystroke
    widget.validityNotifier?.value = _runValidation(value) == null;

    if (widget.cacheKey != null && widget.cache != null) {
      widget.cache!.put(widget.cacheKey!, value);
    }

    // Call immediate onChanged if provided
    widget.onChanged?.call(value);

    // Debounced search callback
    if (widget.isSearchField && widget.onSearchChanged != null) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(widget.debounceDuration, () {
        if (mounted) {
          widget.onSearchChanged!.call(widget.controller.text);
        }
      });
    }
  }

  void _toggleObscure() {
    setState(() => _obscureText = !_obscureText);
  }

  void _clearSearch() {
    widget.controller.clear();
    // Manually trigger the listener already does, but we need to update UI
    setState(() {});
    // Also trigger search with empty string immediately? Usually cleared.
    if (widget.isSearchField && widget.onSearchChanged != null) {
      _debounceTimer?.cancel();
      widget.onSearchChanged!.call('');
    }
  }

  Future<void> _selectDate() async {
    DateTime initial = widget.controller.text.isNotEmpty
        ? DateFormat('yyyy-MM-dd').parse(widget.controller.text)
        : DateTime.now();

    DateTime? picked = await showDatePicker(
      context: context,
      // initialDate: DateTime.now(),
      // firstDate: DateTime(1900),
      // lastDate: DateTime(2100),
      initialDate: initial,
      firstDate: widget.minDate ?? DateTime(1900),
      // lastDate: widget.maxDate ?? DateTime.now(),
      lastDate: widget.maxDate ?? DateTime(2100),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.primaryColor,
              onPrimary: theme.colorScheme.onPrimary,
              surface: theme.colorScheme.surface,
              onSurface: theme.colorScheme.onSurface,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted = DateFormat('yyyy-MM-dd').format(picked);
      widget.controller.text = formatted;
      setState(() => _isEmpty = false);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _debounceTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final surface = theme.colorScheme.surface;

    Widget? suffixIcon;
    if (widget.isDateField) {
      suffixIcon = Icon(
        Icons.calendar_today,
        color: onSurface.withOpacity(0.7),
        size: Responsive.isMobile(context) ? 18 : 22,
      );
    } else if (widget.obscureText) {
      suffixIcon = GestureDetector(
        onTap: _toggleObscure,
        child: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: onSurface.withOpacity(0.7),
          size: Responsive.isMobile(context) ? 18 : 22,
        ),
      );
    } else if (widget.isSearchField && !_isEmpty) {
      suffixIcon = IconButton(
        icon: Icon(
          Icons.clear,
          color: onSurface.withOpacity(0.7),
          size: Responsive.isMobile(context) ? 18 : 22,
        ),
        onPressed: _clearSearch,
        splashRadius: 20,
      );
    }

    ValueChanged<String>? onFieldSubmitted;
    if (widget.onFieldSubmitted != null) {
      onFieldSubmitted = widget.onFieldSubmitted;
    } else if (widget.isSearchField) {
      onFieldSubmitted = (value) {
        // When user presses "search" on keyboard, trigger immediate search

        if (widget.onSearchChanged != null) {
          _debounceTimer?.cancel();
          widget.onSearchChanged!.call(value);
        }
      };
    }

    final hasErrorMessage =
        widget.validationMessage != null &&
        widget.validationMessage!.isNotEmpty;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Material(
        elevation: theme.brightness == Brightness.light ? 4 : 6,
        borderRadius: BorderRadius.circular(16),
        color: theme.brightness == Brightness.dark
            ? surface.withOpacity(_isHovering ? 1.0 : 0.2)
            : surface.withOpacity(_isHovering ? 1.0 : 0.6),
        // color: Colors.white,
        // shadowColor: theme.brightness == Brightness.dark
        //     ??Colors.white.withOpacity(0.4),
        // : Colors.white,
        child: Container(
          decoration: BoxDecoration(
            // color: Colors.white.withOpacity(_isHovering ? 0.15 : 0.1),
            // color: surface.withOpacity(_isHovering ? 0.9 : 0.75),
            color: theme.brightness == Brightness.dark
                ? surface.withOpacity(_isHovering ? 1.0 : 0.2)
                : surface.withOpacity(_isHovering ? 1.0 : 0.8),
            borderRadius: BorderRadius.circular(16),
          ),

          child: TextFormField(
            // Inside TextFormField
            inputFormatters: [
              if (widget.forceUppercase) UpperCaseTextInputFormatter(),

              if (widget.isEmail)
                TextInputFormatter.withFunction((oldValue, newValue) {
                  return newValue.copyWith(text: newValue.text.toLowerCase());
                }),
              // if (widget.isNumber) FilteringTextInputFormatter.digitsOnly,
              // // if (widget.isNumber || widget.toNumberCommaFormat)
              // //   FilteringTextInputFormatter.allow(
              // //     RegExp(widget.allowDecimal ? r'[\d.]' : r'[\d]'),
              // //   ),
              // if (widget.isNumber && !widget.toNumberCommaFormat)
              //   FilteringTextInputFormatter.digitsOnly,
              // if (widget.toNumberCommaFormat)
              //   ThousandsSeparatorInputFormatter(
              //     allowDecimal: widget.allowDecimal,
              //   ),

              // FIX: Only use digitsOnly if we DON'T want decimals and DON'T want commas
              if (widget.isNumber &&
                  !widget.allowDecimal &&
                  !widget.toNumberCommaFormat)
                FilteringTextInputFormatter.digitsOnly,

              // Use the custom formatter for commas + decimals
              if (widget.toNumberCommaFormat)
                ThousandsSeparatorInputFormatter(
                  allowDecimal: widget.allowDecimal,
                ),

              if (widget.isPin) KraPinInputFormatter(),
              if (widget.maxNumberOfCharHL != null)
                LengthLimitingTextInputFormatter(widget.maxNumberOfCharHL),
            ],
            focusNode: _focusNode,

            cursorColor: onSurface,
            cursorErrorColor: Colors.red,
            enabled: widget.enabled,
            readOnly: widget.isDateField,
            // keyboardType: widget.keyboardType,
            keyboardType: widget.isPin
                ? TextInputType.text
                : (widget.isNumber || widget.toNumberCommaFormat)
                ? TextInputType.numberWithOptions(decimal: widget.allowDecimal)
                : widget.keyboardType,
            controller: widget.controller,
            textCapitalization: widget.isPin
                ? TextCapitalization.characters
                : TextCapitalization.none,
            obscureText: _obscureText,
            style: CustomTextStyles.style(
              context,
              type: CustomTextType.paragraph,
            ),
            // style: CustomTextStyles.style(
            //   context,
            //   type: CustomTextType.paragraph,
            // ).copyWith(fontWeight: FontWeight.normal),
            onTap: widget.isDateField ? _selectDate : null,

            onFieldSubmitted: onFieldSubmitted,
            // --- Validation Logic ---
            // validator:
            //     widget.validator ??
            //     (value) {
            //       if (widget.isRequired &&
            //           (value == null || value.trim().isEmpty)) {
            //         return 'This field is required';
            //       }
            //       return null;
            //     },
            validator: (value) {
              final trimmedValue = value?.trim() ?? '';
              final rawValue = value?.replaceAll(',', '') ?? '';

              if (widget.validator != null) {
                return widget.validator!(value);
              }

              if (widget.isRequired &&
                  (value == null || value.trim().isEmpty)) {
                // return 'This field is required';
                // return widget.validationMessage ?? 'This field is required';
                return widget.validationMessage ?? ' ';
              }

              if (widget.isEmail && trimmedValue.isNotEmpty) {
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(trimmedValue)) {
                  return 'Enter a valid email address';
                }
              }
              // if (widget.isNumber && trimmedValue.isNotEmpty) {
              //   if (int.tryParse(trimmedValue) == null) {
              //     return 'Please enter a valid number';
              //   }
              // }
              if (widget.toNumberCommaFormat && rawValue.isNotEmpty) {
                if (double.tryParse(rawValue) == null) return 'Invalid number';
              }

              // --- Character length validation ---
              if (widget.minNumberOfChar != null && trimmedValue.isNotEmpty) {
                if (trimmedValue.length < widget.minNumberOfChar!) {
                  return 'Minimum ${widget.minNumberOfChar} characters required';
                }
              }
              if (widget.maxNumberOfChar != null && trimmedValue.isNotEmpty) {
                if (trimmedValue.length > widget.maxNumberOfChar!) {
                  return 'Maximum ${widget.maxNumberOfChar} characters allowed';
                }
              }

              // --- PIN validation (KRA style) ---
              if (widget.isPin && trimmedValue.isNotEmpty) {
                final pinRegex = RegExp(r'^[A-Za-z][0-9]{9}[A-Za-z]$');
                if (trimmedValue.length != 11) {
                  return 'PIN must be exactly 11 characters';
                }
                if (!pinRegex.hasMatch(trimmedValue)) {
                  return 'Invalid PIN format (e.g. A123456789B)';
                }
              }

              String? result = _runValidation(
                value,
              ); // extract your existing logic into this helper
              // // Push validity after frame so FormField has settled
              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   widget.validityNotifier?.value = result == null;
              // });
              // _runValidation(value);

              return result;
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,

            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hintLabel,
              hintStyle: CustomTextStyles.style(
                context,
                type: CustomTextType.caption,
              ),
              // prefixIcon: Icon(
              //   widget.icon,
              //   color: onSurface.withOpacity(0.7),
              //   size: Responsive.isMobile(context) ? 18 : 24,
              // ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 26,
                ), // increase right to push text further
                child: Icon(
                  widget.icon,
                  color: onSurface.withOpacity(0.7),
                  size: Responsive.isMobile(context) ? 18 : 24,
                ),
              ),
              // suffixIcon: widget.isDateField
              //     ? Icon(Icons.calendar_today, color: onSurface.withOpacity(0.7))
              //     : (widget.obscureText
              //           ? GestureDetector(
              //               onTap: _toggleObscure,
              //               child: Icon(
              //                 _obscureText
              //                     ? Icons.visibility_off
              //                     : Icons.visibility,
              //                 color: onSurface.withOpacity(0.7),
              //               ),
              //             )
              //           : null),
              suffixIcon: suffixIcon,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: onSurface.withOpacity(0.2)),
              ),
              // focusedBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(16),
              //   borderSide: BorderSide(color: onSurface.withOpacity(0.5)),
              // ),
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
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.5,
                ),
              ),

              // focusedErrorBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(16),
              //   borderSide: const BorderSide(
              //     color: Colors.redAccent,
              //     width: 1.5,
              //   ),
              // ),
              errorStyle: TextStyle(
                color: hasErrorMessage ? Colors.redAccent : Colors.transparent,
                // color: Colors.transparent,
                fontWeight: FontWeight.bold,
                height: hasErrorMessage ? null : 0,
                fontSize: hasErrorMessage ? null : 0,
              ),

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              label: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: widget.hint,
                      style: CustomTextStyles.style(
                        context,
                        type: CustomTextType.caption,
                        // color: _focusNode.hasFocus || !_isEmpty
                        //     ? Colors.white70
                        //     : Colors.white54,
                      ),
                    ),
                    if (widget.isRequired)
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                  ],
                ),
              ),
              floatingLabelStyle: TextStyle(color: onSurface.withOpacity(0.7)),
            ),
          ),
        ),
      ),
    );
  }
}

class ThousandsFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Remove commas
    String digitsOnly = newValue.text.replaceAll(',', '');

    if (digitsOnly.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Parse number
    final number = int.tryParse(digitsOnly);
    if (number == null) return oldValue;

    // Format with commas
    final newText = _formatter.format(number);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class ThousandsSeparatorInputFormatter_ extends TextInputFormatter {
  final bool allowDecimal;
  ThousandsSeparatorInputFormatter_({this.allowDecimal = false});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    // 1. Remove all non-numeric characters (except the decimal point)
    String stripped = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Handle multiple decimal points (only allow the first one)
    if (stripped.split('.').length > 2) return oldValue;

    // 2. Split into Integer and Fractional parts
    List<String> parts = stripped.split('.');
    String integerPart = parts[0];
    String? fractionalPart = parts.length > 1 ? parts[1] : null;

    // 3. Format the integer part with commas
    final formatter = NumberFormat('#,###', 'en_US');
    String formattedInteger = "";
    if (integerPart.isNotEmpty) {
      formattedInteger = formatter.format(int.parse(integerPart));
    }

    // 4. Reconstruct the string
    String finalString = formattedInteger;
    if (fractionalPart != null && allowDecimal) {
      finalString += '.$fractionalPart';
    } else if (newValue.text.endsWith('.') && allowDecimal) {
      finalString += '.';
    }

    // 5. Calculate cursor position (Selection) logic
    // This prevents the cursor from jumping to the end
    int newSelectionIndex =
        newValue.selection.end + (finalString.length - newValue.text.length);

    return TextEditingValue(
      text: finalString,
      selection: TextSelection.collapsed(
        offset: newSelectionIndex.clamp(0, finalString.length),
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final bool allowDecimal;
  ThousandsSeparatorInputFormatter({this.allowDecimal = false});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    // 1. Allow numbers and ONE decimal point only
    String stripped = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Prevent multiple decimals
    if (stripped.split('.').length > 2) return oldValue;

    // 2. Split Integer and Fractional parts
    List<String> parts = stripped.split('.');
    String integerPart = parts[0];
    String? fractionalPart = parts.length > 1 ? parts[1] : null;

    // 3. Format the integer part
    final formatter = NumberFormat('#,###', 'en_US');
    String formattedInteger = "";

    if (integerPart.isNotEmpty) {
      // Use tryParse to avoid crashes on extremely long numbers
      int? parsedInt = int.tryParse(integerPart);
      if (parsedInt != null) {
        formattedInteger = formatter.format(parsedInt);
      } else {
        formattedInteger = integerPart; // Fallback
      }
    }

    // 4. Rebuild the string
    String finalString = formattedInteger;
    if (fractionalPart != null && allowDecimal) {
      finalString += '.$fractionalPart';
    } else if (newValue.text.endsWith('.') && allowDecimal) {
      finalString += '.';
    }

    // 5. Smart Cursor Positioning
    // Calculate how many characters were added/removed (like commas)
    int diff = finalString.length - newValue.text.length;
    int newOffset = newValue.selection.end + diff;

    return TextEditingValue(
      text: finalString,
      selection: TextSelection.collapsed(
        offset: newOffset.clamp(0, finalString.length),
      ),
    );
  }
}

class KraPinInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.toUpperCase();

    // Remove invalid characters (only allow A-Z and 0-9)
    text = text.replaceAll(RegExp(r'[^A-Z0-9]'), '');

    // Limit to 11 chars
    if (text.length > 11) {
      text = text.substring(0, 11);
    }

    // Enforce structure: first + last = letter, middle = digits
    StringBuffer buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      String char = text[i];

      if (i == 0 || i == 10) {
        // First & last must be letters
        if (RegExp(r'[A-Z]').hasMatch(char)) {
          buffer.write(char);
        }
      } else {
        // Middle must be digits
        if (RegExp(r'[0-9]').hasMatch(char)) {
          buffer.write(char);
        }
      }
    }

    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class UpperCaseTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final upperText = newValue.text.toUpperCase();
    return newValue.copyWith(text: upperText);
  }
}

extension NumericControllerX on TextEditingController {
  String get numericText => text.replaceAll(',', '');
  double? get doubleValue => double.tryParse(numericText);
  int? get intValue => int.tryParse(numericText);
}
