import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/constants/url_cosntants.dart';
import 'package:insured/app_2/core/services/biometric_auth_service.dart';
import 'package:insured/app_2/core/services/update_checker.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/utils/text_scale_provider.dart';
import 'package:insured/app_2/core/widgets/card_with_child.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/support_whatsapp_button.dart';
import 'package:insured/app_2/features/settings/settings/widgets/location_info_card.dart';
import 'package:insured/app_2/l10n/app_localizations.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:insured/app_2/providers/client_view_provider.dart';
import 'package:insured/app_2/providers/settings_provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends ConsumerWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isLightMode = settings.themeMode == 'Light';
    // final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: Container(
        decoration: BoxDecoration(
          gradient: isLightMode
              ? LinearGradient(
                  colors: [Color(0xFFFDFDFD), Color(0xFFE8F5E9)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;
                  final children = [
                    _buildAppearanceCard(context, ref, settings, l10n),
                    _buildDisplayCard(context, ref, settings, l10n),
                    _buildInviteAgentsCard(context),
                    _buildSupportCard(context),
                    _buildUpdateCard(context, ref),
                    // _buildNotificationsCard(context, ref, settings, l10n),
                    // _buildLanguageCard(context, ref, settings, l10n),
                    // _buildPrivacyCard(context, ref, settings, l10n),
                    // _buildDataManagementCard(context, ref, l10n),
                    // _buildAccessibilityCard(context, ref, settings, l10n),
                    // _buildPerformanceCard(context, ref, settings, l10n),
                    // _buildAdvancedCard(context, ref, settings, l10n),
                    // _buildLocationCard(context),
                    // _buildDangerZoneCard(context, l10n),
                  ];
                  if (!isWide) {
                    return Column(
                      children: [
                        for (int i = 0; i < children.length; i++) ...[
                          children[i],
                          if (i != children.length - 1)
                            const SizedBox(height: 24),
                        ],
                        const SizedBox(height: 24),
                        _buildVersionLabel(context),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        children: children
                            .map(
                              (card) => SizedBox(
                                width: (constraints.maxWidth - 24) / 2,
                                child: card,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                      _buildVersionLabel(context),
                    ],
                  );
                },
              ),
            ),
            // SettingsDialog(),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context) {
    return const LocationInfoCard();
  }

  Widget _buildVersionLabel(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      children: [
        CustomText(
          InscloudUrls.appName,
          type: CustomTextType.caption,
          color: onSurface.withOpacity(0.45),
        ),
        const SizedBox(height: 2),
        CustomText(
          'Version ${InscloudUrls.appVersion}',
          type: CustomTextType.caption,
          color: onSurface.withOpacity(0.35),
        ),
      ],
    );
  }

  Widget _buildUpdateCard(BuildContext context, WidgetRef ref) {
    final async = ref.watch(updateInfoProvider);
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return async.when(
      loading: () => cardWithChild(
        icon: Icons.system_update_rounded,
        title: 'App version',
        subtitle: 'Version ${InscloudUrls.appVersion}',
        child: const Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            'Checking for updates…',
            type: CustomTextType.caption,
          ),
        ),
      ),
      error: (_, __) => cardWithChild(
        icon: Icons.system_update_rounded,
        title: 'App version',
        subtitle: 'Version ${InscloudUrls.appVersion}',
        child: const Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            'Could not check for updates',
            type: CustomTextType.caption,
            color: Colors.grey,
          ),
        ),
      ),
      data: (info) {
        final available = info != null && info.isUpdateAvailable;
        final days = info?.daysOutdated;
        final isDev =
            ref.watch(authProvider).user?.email == UpdateChecker.devEmail;
        return cardWithChild(
          icon: available
              ? Icons.system_update_rounded
              : Icons.verified_rounded,
          title: 'App version',
          subtitle: available
              ? 'Update available: v${info.latestVersion}'
              : 'You’re up to date',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'Installed: v${InscloudUrls.appVersion}',
                type: CustomTextType.caption,
                color: onSurface.withOpacity(0.55),
              ),
              if (available && days != null) ...[
                const SizedBox(height: 4),
                CustomText(
                  days <= 0
                      ? 'Released today'
                      : 'Your app is $days day${days == 1 ? '' : 's'} behind',
                  type: CustomTextType.caption,
                  color: Colors.orange,
                ),
              ],
              if (available) ...[
                const SizedBox(height: 4),
                CustomText(
                  'Your app is ${info.versionsBehind} '
                  'version${info.versionsBehind == 1 ? '' : 's'} behind',
                  type: CustomTextType.caption,
                  color: Colors.orange,
                ),
              ],
              const SizedBox(height: 12),
              if (available)
                SizedBox(
                  width: double.infinity,
                  child: CustomAdvancedButton(
                    label: 'View update',
                    variant: ButtonVariant.primary,
                    onPressed: () =>
                        UpdateChecker.showUpdateDialog(context, info),
                  ),
                )
              else
                const Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    'You have the latest version installed.',
                    type: CustomTextType.caption,
                    color: Colors.grey,
                  ),
                ),
              if (isDev) ...[
                const Divider(height: 24),
                Row(
                  children: [
                    const Expanded(
                      child: CustomText(
                        'Show update popup on web ',
                        type: CustomTextType.caption,
                      ),
                    ),
                    Switch(
                      value: ref.watch(showUpdateOnWebProvider),
                      onChanged: (v) =>
                          ref.read(showUpdateOnWebProvider.notifier).set(v),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildInviteAgentsCard(BuildContext context) {
    return cardWithChild(
      icon: Icons.share_rounded,
      title: 'Invite other agents',
      subtitle: 'Share the installation page with your team',
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () async {
            await SharePlus.instance.share(
              ShareParams(
                text:
                    'Check out ${InscloudUrls.appName}, Download the app here: ${InscloudUrls.installationPage}',
              ),
            );
          },
          icon: const Icon(Icons.share_rounded),
          label: const Text('Share App'),
        ),
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context) {
    return cardWithChild(
      icon: Icons.support_agent_rounded,
      title: 'Support',
      subtitle:
          'Need help? Contact  ${InscloudUrls.companyName} support on WhatsApp.',
      child: const Align(
        alignment: Alignment.centerLeft,
        child: SupportWhatsappButton(),
      ),
    );
  }

  Widget _buildAppearanceCard(
    BuildContext context,
    WidgetRef ref,
    SettingsState settings,
    AppLocalizations l10n,
  ) {
    return cardWithChild(
      icon: Icons.palette,
      // title: 'Appearance'    ,
      title: l10n.settings_appearanceTitle,
      subtitle: l10n.settings_appearanceSubtitle,
      child: Column(
        children: [
          // Text(l10n.newPolicy),
          _buildSegmentedControl(
            label: l10n.settings_themeLabel,
            options: const ['Light', 'Dark', 'System'],
            value: settings.themeMode,
            onValueChanged: (val) {
              ref.read(settingsProvider.notifier).setThemeMode(val);
            },
          ),
          const SizedBox(height: 16),
          _buildSegmentedControl(
            label: l10n.settings_textSizeLabel,
            options: const ['Smaller', 'Small', 'Default', 'Large', 'Larger'],
            value: settings.textSize,
            onValueChanged: (val) {
              ref.read(settingsProvider.notifier).setTextSize(val);
              final level = textScaleLevelFromString(val);
              ref.read(textScaleProvider).setLevel(level);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayCard_(
    BuildContext context,
    WidgetRef ref,
    SettingsState settings,
    AppLocalizations l10n,
  ) {
    return cardWithChild(
      icon: Icons.laptop,
      title: l10n.settings_DisplayTitle,
      subtitle: l10n.settings_DisplaySubtitle,
      child: Column(
        children: [
          _buildSegmentedControl(
            label: l10n.settings_DefaultViewLabel,
            options: const ['Card View', 'List View'],
            value: settings.defaultView,
            onValueChanged: (val) {
              ref.read(settingsProvider.notifier).setDefaultView(val);
            },
          ),
          const SizedBox(height: 16),
          _buildToggleRow(
            context: context,
            title: l10n.settings_CompactModeTitle,
            description: l10n.settings_CompactModeDescription,
            value: settings.compactMode,
            onChanged: (val) =>
                ref.read(settingsProvider.notifier).setCompactMode(val),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayCard(
    BuildContext context,
    WidgetRef ref,
    SettingsState settings,
    AppLocalizations l10n,
  ) {
    return cardWithChild(
      icon: Icons.laptop,
      title: l10n.settings_DisplayTitle,
      subtitle: l10n.settings_DisplaySubtitle,
      child: Column(
        children: [
          _buildSegmentedControl(
            label: l10n.settings_DefaultViewLabel,
            options: const ['Card View', 'List View'],
            value: settings.defaultView,
            onValueChanged: (val) {
              // Update persistent setting
              ref.read(settingsProvider.notifier).setDefaultView(val);

              // Immediately update the live view mode
              final newMode = val == 'Card View'
                  ? ClientViewMode.grid
                  : ClientViewMode.list;
              ref.read(clientViewModeProvider.notifier).update((_) => newMode);
            },
          ),
          const SizedBox(height: 16),
          _buildToggleRow(
            context: context,
            title: l10n.settings_CompactModeTitle,
            description: l10n.settings_CompactModeDescription,
            value: settings.compactMode,
            onChanged: (val) =>
                ref.read(settingsProvider.notifier).setCompactMode(val),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard(
    BuildContext context,
    WidgetRef ref,
    SettingsState settings,
    AppLocalizations l10n,
  ) {
    return cardWithChild(
      icon: Icons.notifications,
      title: l10n.settings_NotificationsTitle,
      subtitle: l10n.settings_NotificationsSubtitle,
      child: Column(
        children: [
          _buildToggleRow(
            context: context,
            title: l10n.settings_EnableNotificationsTitle,
            description: l10n.settings_EnableNotificationsDescription,
            value: settings.enableNotifications,
            onChanged: (val) =>
                ref.read(settingsProvider.notifier).setEnableNotifications(val),
          ),
          Opacity(
            opacity: settings.enableNotifications ? 1 : 0.2,
            child: IgnorePointer(
              ignoring: !settings.enableNotifications,
              child: Column(
                children: [
                  _buildToggleRow(
                    context: context,
                    title: l10n.settings_EmailNotificationsTitle,
                    description: l10n.settings_EmailNotificationsDescription,
                    value: settings.emailNotifications,
                    onChanged: (val) => ref
                        .read(settingsProvider.notifier)
                        .setEmailNotifications(val),
                  ),

                  _buildToggleRow(
                    context: context,
                    title: l10n.settings_RenewalRemindersTitle,
                    description: l10n.settings_RenewalRemindersDescription,
                    value: settings.renewalReminders,
                    onChanged: (val) => ref
                        .read(settingsProvider.notifier)
                        .setRenewalReminders(val),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    WidgetRef ref,
    SettingsState settings,
    AppLocalizations l10n,
  ) {
    return cardWithChild(
      icon: Icons.language,
      title: l10n.settings_LanguageTitle,
      subtitle: l10n.settings_LanguageSubtitle,
      child: _buildSegmentedControl(
        label: l10n.settings_LanguageLabel,
        options: const [
          'English',
          'Swahili',
          'French',
          'German',
          'Italian',
          'Russian',
          'Chinese',
          'Arabic',
        ],
        value: settings.language,
        onValueChanged: (val) {
          ref.read(settingsProvider.notifier).setLanguage(val);
        },
      ),
    );
  }

  Widget _buildPrivacyCard(
    BuildContext context,
    WidgetRef ref,
    SettingsState settings,
    AppLocalizations l10n,
  ) {
    return cardWithChild(
      icon: Icons.security,
      title: l10n.settings_PrivacyTitle,
      subtitle: l10n.settings_PrivacyTitle,
      child: Column(
        children: [
          _buildToggleRow(
            context: context,
            title: l10n.settings_TwoFactorTitle,
            description: l10n.settings_TwoFactorDescription,
            value: settings.twoFactorAuth,
            // onChanged: (val) =>
            //     ref.read(settingsProvider.notifier).setTwoFactorAuth(val),
            // In settings_screen.dart, when the toggle is pressed:
            onChanged: (val) async {
              if (val) {
                final authenticated = await BiometricAuthService.authenticate(
                  reason: 'Enable two‑factor authentication',
                );
                if (!authenticated) return;
              }
              ref.read(settingsProvider.notifier).setTwoFactorAuth(val);
            },
          ),
          _buildToggleRow(
            context: context,
            title: l10n.settings_ActivityLoggingTitle,
            description: l10n.settings_ActivityLoggingDescription,
            value: settings.activityLogging,
            onChanged: (val) =>
                ref.read(settingsProvider.notifier).setActivityLogging(val),
          ),
          _buildToggleRow(
            context: context,
            title: l10n.settings_ShowSensitiveTitle,
            description: l10n.settings_ShowSensitiveDescription,
            value: settings.showSensitiveData,
            onChanged: (val) =>
                ref.read(settingsProvider.notifier).setShowSensitiveData(val),
          ),
          const Divider(color: Colors.white24),
          const SizedBox(height: 8),
          _buildActionButton(
            label: l10n.settings_ChangePassword,
            icon: Icons.lock,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagementCard(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return cardWithChild(
      icon: Icons.storage,
      title: l10n.settings_DataTitle,
      subtitle: l10n.settings_DataSubtitle,
      child: Column(
        children: [
          _buildActionButton(
            label: l10n.settings_ExportSettings,
            icon: Icons.download,
            onPressed: () async {
              final settings = ref.read(settingsProvider);
              await exportSettings(settings);
            },
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            label: l10n.settings_ImportSettings,
            icon: Icons.upload,
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            label: l10n.settings_DownloadAllData,
            icon: Icons.archive,
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            label: l10n.settings_ClearCache,
            icon: Icons.delete_outline,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilityCard(
    BuildContext context,
    WidgetRef ref,
    SettingsState settings,
    AppLocalizations l10n,
  ) {
    return cardWithChild(
      icon: Icons.visibility,
      title: l10n.settings_AccessibilityTitle,
      subtitle: l10n.settings_AccessibilitySubtitle,
      child: Column(
        children: [
          _buildToggleRow(
            context: context,
            title: l10n.settings_HighContrastTitle,
            description: l10n.settings_HighContrastDescription,
            value: settings.highContrast,
            onChanged: (val) =>
                ref.read(settingsProvider.notifier).setHighContrast(val),
          ),
          _buildToggleRow(
            context: context,
            title: l10n.settings_ReduceMotionTitle,
            description: l10n.settings_ReduceMotionDescription,
            value: settings.reduceMotion,
            onChanged: (val) =>
                ref.read(settingsProvider.notifier).setReduceMotion(val),
          ),
          _buildToggleRow(
            context: context,
            title: l10n.settings_ScreenReaderTitle,
            description: l10n.settings_ScreenReaderDescription,
            value: settings.screenReader,
            onChanged: (val) =>
                ref.read(settingsProvider.notifier).setScreenReader(val),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(
    BuildContext context,
    WidgetRef ref,
    SettingsState settings,
    AppLocalizations l10n,
  ) {
    return cardWithChild(
      icon: Icons.flash_on,
      title: l10n.settings_PerformanceTitle,
      subtitle: l10n.settings_PerformanceSubtitle,
      child: Column(
        children: [
          _buildToggleRow(
            context: context,
            title: l10n.settings_AutoSaveTitle,
            description: l10n.settings_AutoSaveDescription,
            value: settings.autoSave,
            onChanged: (val) =>
                ref.read(settingsProvider.notifier).setAutoSave(val),
          ),
          _buildToggleRow(
            context: context,
            title: l10n.settings_LazyLoadingTitle,
            description: l10n.settings_LazyLoadingDescription,
            value: settings.lazyLoading,
            onChanged: (val) =>
                ref.read(settingsProvider.notifier).setLazyLoading(val),
          ),
          _buildToggleRow(
            context: context,
            title: l10n.settings_OfflineModeTitle,
            description: l10n.settings_OfflineModeDescription,
            value: settings.offlineMode,
            onChanged: (val) =>
                ref.read(settingsProvider.notifier).setOfflineMode(val),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedCard(
    BuildContext context,
    WidgetRef ref,
    SettingsState settings,
    AppLocalizations l10n,
  ) {
    return cardWithChild(
      icon: Icons.settings,
      title: l10n.settings_AdvancedTitle,
      subtitle: l10n.settings_AdvancedSubtitle,
      child: Column(
        children: [
          _buildToggleRow(
            context: context,
            title: l10n.settings_KeyboardShortcutsTitle,
            description: l10n.settings_KeyboardShortcutsDescription,
            value: settings.keyboardShortcuts,
            onChanged: (val) =>
                ref.read(settingsProvider.notifier).setKeyboardShortcuts(val),
          ),
          _buildToggleRow(
            context: context,
            title: l10n.settings_DeveloperModeTitle,
            description: l10n.settings_DeveloperModeDescription,
            value: settings.developerMode,
            onChanged: (val) =>
                ref.read(settingsProvider.notifier).setDeveloperMode(val),
          ),
          _buildToggleRow(
            context: context,
            title: l10n.settings_BetaFeaturesTitle,
            description: l10n.settings_BetaFeaturesDescription,
            value: settings.betaFeatures,
            onChanged: (val) =>
                ref.read(settingsProvider.notifier).setBetaFeatures(val),
          ),
          const Divider(color: Colors.white24),
          const SizedBox(height: 8),
          _buildActionButton(
            label: l10n.settings_ViewKeyboardShortcuts,
            icon: Icons.keyboard,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZoneCard(BuildContext context, AppLocalizations l10n) {
    return cardWithChild(
      icon: Icons.warning,
      title: l10n.settings_DangerTitle,
      subtitle: l10n.settings_DangerSubtitle,
      iconColor: Colors.red,
      child: Column(
        children: [
          _buildActionButton(
            label: l10n.settings_ResetAllSettings,
            icon: Icons.settings_backup_restore,
            borderColor: Colors.amber,
            onPressed: () {},
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            label: l10n.settings_DeleteAllData,
            icon: Icons.delete_forever,
            borderColor: Colors.red,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Helper widgets
  Widget _buildSegmentedControl({
    required String label,
    required List<String> options,
    required String value,
    required void Function(String) onValueChanged,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(label, type: CustomTextType.paragraph),
            const SizedBox(height: 8),
            Row(
              children: options.map((option) {
                final isSelected = option == value;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onValueChanged(option),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark
                                  ? theme.primaryColor
                                  : AppColors.favColourDark)
                            : (isDark
                                  ? Colors.white10
                                  : Colors.black.withOpacity(0.05)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        option,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? (isDark ? Colors.black : Colors.white)
                              : theme.textTheme.bodyMedium?.color,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildToggleRow({
    required BuildContext context,
    required String title,
    required String description,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(title, type: CustomTextType.paragraph),
                CustomText(description, type: CustomTextType.caption),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: isDark
                ? Theme.of(context).primaryColor
                : AppColors.favColourDark,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    Color? borderColor,
    VoidCallback? onPressed,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        // Dynamic colors for buttons
        final defaultContentColor = isDark ? Colors.white70 : Colors.black87;
        final btnBg = isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.black.withOpacity(0.05);

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: borderColor != null
                ? Border.all(color: borderColor, width: 1.5)
                : null,
          ),
          child: TextButton.icon(
            onPressed: onPressed,
            icon: Icon(icon, color: borderColor ?? defaultContentColor),
            label: Text(
              label,
              style: TextStyle(
                color: borderColor ?? defaultContentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: btnBg,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }
}
