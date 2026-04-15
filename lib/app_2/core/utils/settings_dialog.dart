// widgets/settings_dialog.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/utils/responsive_font_helper.dart';
import 'package:insured/app_2/core/utils/screen_width_layout_provider.dart';
import 'package:insured/app_2/core/utils/text_scale_provider.dart';
import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/theme_provider.dart';
// import 'package:provider/provider.dart';
// import '../logic/theme_provider.dart';
// import '../logic/text_scale_provider.dart';

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
            _SettingsSection(title: 'Theme Mode', child: _ThemeModeSelector()),
            SizedBox(height: 24),
            _SettingsSection(title: 'Text Size', child: _TextScaleSelector()),
            SizedBox(height: 10),
            // Inside SettingsDialog content
            _SettingsSection(
              title: 'Layout Mode',
              // child: Consumer<ScreenWidthLayoutProvider>(
              //   builder: (context, layout, _) {
              child: Consumer(
                builder: (context, ref, _) {
                  final layout = ref.watch(screenWidthLayoutProvider);
                  // builder: (context, layout, _) {
                  return SegmentedButton<ScreenWidthBreakpoint>(
                    selected: {layout.breakpoint},
                    onSelectionChanged: (set) =>
                        layout.setBreakpoint(set.first),
                    segments: const [
                      ButtonSegment(
                        value: ScreenWidthBreakpoint.compact,
                        label: Text('Compact'),
                      ),
                      ButtonSegment(
                        value: ScreenWidthBreakpoint.medium,
                        label: Text('Standard'),
                      ),
                      ButtonSegment(
                        value: ScreenWidthBreakpoint.expanded,
                        label: Text('Wide'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        // NouvaButton(
        //   onPressed: () => Navigator.of(context).pop(),
        //   text: 'Close',
        //   // child: const Text('Close'),
        // ),
      ],
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

class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // return Consumer<ThemeProvider>(
    //   builder: (context, themeProvider, child) {
    return Consumer(
      builder: (context, ref, child) {
        final themeProviderState = ref.watch(themeProvider);
        return Row(
          children: [
            Icon(Icons.light_mode_outlined, color: theme.primaryColor),
            Expanded(
              child: Switch(
                value: themeProviderState.themeMode == ThemeMode.dark,
                onChanged: (value) => themeProviderState.toggleTheme(),
                activeColor: theme.primaryColor,
              ),
            ),
            Icon(Icons.dark_mode_outlined, color: theme.primaryColor),
          ],
        );
      },
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
