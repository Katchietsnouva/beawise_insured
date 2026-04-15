// lib/app_2/core/utils/settings_ThemeModeSelector.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/utils/responsive_font_helper.dart';
import 'package:insured/app_2/core/utils/screen_width_layout_provider.dart';
import 'package:insured/app_2/core/utils/text_scale_provider.dart';
import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/theme_provider.dart';
import 'package:insured/app_2/providers/settings_provider.dart';

// class ThemeModeSelector extends StatelessWidget {
//   const ThemeModeSelector();

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     // return Consumer<ThemeProvider>(
//     //   builder: (context, themeProvider, child) {
//     return Consumer(
//       builder: (context, ref, child) {
//         final themeProviderState = ref.watch(themeProvider);
//         return Row(
//           children: [
//             Icon(Icons.light_mode_outlined, color: theme.primaryColor),
//             Expanded(
//               child: Switch(
//                 value: themeProviderState.themeMode == ThemeMode.dark,
//                 onChanged: (value) => themeProviderState.toggleTheme(),
//                 activeColor: theme.primaryColor,
//               ),
//             ),
//             Icon(Icons.dark_mode_outlined, color: theme.primaryColor),
//           ],
//         );
//       },
//     );
//   }
// }

class ThemeModeSelector extends ConsumerWidget {
  const ThemeModeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // return Consumer<ThemeProvider>(
    //   builder: (context, themeProvider, child) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    final themeMode = settings.themeMode;

    bool isDark = themeMode == 'Dark';

    return Consumer(
      builder: (context, ref, child) {
        // final themeProviderState = ref.watch(themeProvider);
        return Row(
          children: [
            Icon(Icons.light_mode_outlined, color: theme.primaryColor),
            Expanded(
              child: Switch(
                // value: themeProviderState.themeMode == ThemeMode.dark,
                value: isDark,
                // onChanged: (value) => themeProviderState.toggleTheme(),
                onChanged: (value) {
                  notifier.setThemeMode(value ? 'Dark' : 'Light');
                },

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
