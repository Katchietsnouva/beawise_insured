// lib/app_2/core/utils/settings_TextScaleLevel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/utils/responsive_font_helper.dart';
import 'package:insured/app_2/core/utils/screen_width_layout_provider.dart';
import 'package:insured/app_2/core/utils/text_scale_provider.dart';
import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/theme_provider.dart';

extension TextScaleLevelExtension on TextScaleLevel {
  String get label {
    switch (this) {
      case TextScaleLevel.smaller:
        return 'Smaller';
      case TextScaleLevel.small:
        return 'Small';
      case TextScaleLevel.defaultLevel:
        return 'Default';
      case TextScaleLevel.large:
        return 'Large';
      case TextScaleLevel.larger:
        return 'Larger';
    }
  }
}

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        'Display Settings',
        style: TextStyle(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingsSection(title: 'Text Size', child: _TextScaleSelector()),
            SizedBox(height: 10),
          ],
        ),
      ),
      actions: [],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _TextScaleSelector extends StatelessWidget {
  const _TextScaleSelector();

  @override
  Widget build(BuildContext context) {
    // return Consumer<TextScaleProvider>(
    //   builder: (context, textScaleProvider, child) {
    return Consumer(
      builder: (context, ref, child) {
        final textScaleProviderState = ref.watch(textScaleProvider);
        final theme = Theme.of(context);
        final isSmallScreen = MediaQuery.of(context).size.width < 450;
        final baseFontSize = responsiveFontSize(context, baseSize: 14);
        final selectedColor = theme.primaryColor;
        final selectedBg = selectedColor.withOpacity(0.15);

        if (isSmallScreen) {
          return Column(
            children: TextScaleLevel.values.map((level) {
              return RadioListTile<TextScaleLevel>(
                title: Text(
                  level.label,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                ),
                value: level,
                groupValue: textScaleProviderState.currentLevel,
                onChanged: (newValue) {
                  if (newValue != null) {
                    textScaleProviderState.setLevel(newValue);
                  }
                },
                activeColor: selectedColor,
              );
            }).toList(),
          );
        } else {
          return SegmentedButton<TextScaleLevel>(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (states) => states.contains(MaterialState.selected)
                    ? selectedBg
                    : theme.colorScheme.surface,
              ),
              foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                (states) => states.contains(MaterialState.selected)
                    ? selectedColor
                    : theme.colorScheme.onSurface,
              ),
              side: MaterialStateProperty.resolveWith<BorderSide?>(
                (states) => BorderSide(
                  color: states.contains(MaterialState.selected)
                      ? selectedColor
                      : theme.dividerColor,
                  width: 1.0,
                ),
              ),
            ),
            segments: TextScaleLevel.values.map((level) {
              return ButtonSegment(
                value: level,
                label: Text(
                  level.label,
                  style: TextStyle(fontSize: baseFontSize),
                  textAlign: TextAlign.center,
                ),
              );
            }).toList(),
            selected: {textScaleProviderState.currentLevel},
            onSelectionChanged: (newSelection) {
              textScaleProviderState.setLevel(newSelection.first);
            },
          );
        }
      },
    );
  }
}
