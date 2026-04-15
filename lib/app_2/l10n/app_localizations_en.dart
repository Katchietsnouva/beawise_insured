// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Insured';

  @override
  String get newPolicy => 'New Motor Policy';

  @override
  String get policy => 'Policy';

  @override
  String get premium => 'Premium';

  @override
  String get claim => 'Claim';

  @override
  String get addClient => 'Add New Client';

  @override
  String welcomeMessage(String name) {
    return 'Welcome back, $name';
  }

  @override
  String get settings_appearanceTitle => 'Appearance';

  @override
  String get settings_appearanceSubtitle => 'Customize how the app looks';

  @override
  String get settings_themeLabel => 'Theme';

  @override
  String get settings_textSizeLabel => 'Text Size';

  @override
  String get settings_DisplayTitle => 'Display';

  @override
  String get settings_DisplaySubtitle => 'Configure default display options';

  @override
  String get settings_DefaultViewLabel => 'Default View';

  @override
  String get settings_CompactModeTitle => 'Compact Mode';

  @override
  String get settings_CompactModeDescription =>
      'Reduce spacing between elements';

  @override
  String get settings_NotificationsTitle => 'Notifications';

  @override
  String get settings_NotificationsSubtitle =>
      'Manage notification preferences';

  @override
  String get settings_EnableNotificationsTitle => 'Enable Notifications';

  @override
  String get settings_EnableNotificationsDescription =>
      'Receive in-app notifications';

  @override
  String get settings_EmailNotificationsTitle => 'Email Notifications';

  @override
  String get settings_EmailNotificationsDescription =>
      'Receive updates via email';

  @override
  String get settings_RenewalRemindersTitle => 'Renewal Reminders';

  @override
  String get settings_RenewalRemindersDescription =>
      'Get notified about upcoming renewals';

  @override
  String get settings_LanguageTitle => 'Language & Region';

  @override
  String get settings_LanguageSubtitle => 'Set your language preferences';

  @override
  String get settings_LanguageLabel => 'Language';

  @override
  String get settings_PrivacyTitle => 'Privacy & Security';

  @override
  String get settings_PrivacySubtitle =>
      'Control your privacy and security settings';

  @override
  String get settings_TwoFactorTitle => 'Two-Factor Authentication';

  @override
  String get settings_TwoFactorDescription => 'Add an extra layer of security';

  @override
  String get settings_ActivityLoggingTitle => 'Activity Logging';

  @override
  String get settings_ActivityLoggingDescription => 'Track account activity';

  @override
  String get settings_ShowSensitiveTitle => 'Show Sensitive Data';

  @override
  String get settings_ShowSensitiveDescription =>
      'Display ID numbers and financial data';

  @override
  String get settings_ChangePassword => 'Change Password';

  @override
  String get settings_DataTitle => 'Data Management';

  @override
  String get settings_DataSubtitle => 'Export, import, and manage your data';

  @override
  String get settings_ExportSettings => 'Export Settings';

  @override
  String get settings_ImportSettings => 'Import Settings';

  @override
  String get settings_DownloadAllData => 'Download All Data';

  @override
  String get settings_ClearCache => 'Clear Cache';

  @override
  String get settings_AccessibilityTitle => 'Accessibility';

  @override
  String get settings_AccessibilitySubtitle => 'Enhance accessibility features';

  @override
  String get settings_HighContrastTitle => 'High Contrast Mode';

  @override
  String get settings_HighContrastDescription =>
      'Increase contrast for better visibility';

  @override
  String get settings_ReduceMotionTitle => 'Reduce Motion';

  @override
  String get settings_ReduceMotionDescription =>
      'Minimize animations and transitions';

  @override
  String get settings_ScreenReaderTitle => 'Screen Reader Support';

  @override
  String get settings_ScreenReaderDescription =>
      'Enhanced screen reader compatibility';

  @override
  String get settings_PerformanceTitle => 'Performance';

  @override
  String get settings_PerformanceSubtitle => 'Optimize app performance';

  @override
  String get settings_AutoSaveTitle => 'Auto-Save';

  @override
  String get settings_AutoSaveDescription => 'Automatically save changes';

  @override
  String get settings_LazyLoadingTitle => 'Lazy Loading';

  @override
  String get settings_LazyLoadingDescription => 'Load content as you scroll';

  @override
  String get settings_OfflineModeTitle => 'Offline Mode';

  @override
  String get settings_OfflineModeDescription =>
      'Work without internet connection';

  @override
  String get settings_AdvancedTitle => 'Advanced';

  @override
  String get settings_AdvancedSubtitle => 'Power user features and shortcuts';

  @override
  String get settings_KeyboardShortcutsTitle => 'Keyboard Shortcuts';

  @override
  String get settings_KeyboardShortcutsDescription =>
      'Enable keyboard navigation';

  @override
  String get settings_DeveloperModeTitle => 'Developer Mode';

  @override
  String get settings_DeveloperModeDescription =>
      'Show advanced debugging options';

  @override
  String get settings_BetaFeaturesTitle => 'Beta Features';

  @override
  String get settings_BetaFeaturesDescription => 'Try experimental features';

  @override
  String get settings_ViewKeyboardShortcuts => 'View Keyboard Shortcuts';

  @override
  String get settings_DangerTitle => 'Danger Zone';

  @override
  String get settings_DangerSubtitle => 'Irreversible actions';

  @override
  String get settings_ResetAllSettings => 'Reset All Settings';

  @override
  String get settings_DeleteAllData => 'Delete All Data';

  @override
  String get sidebar_dashboard => 'Dashboard';

  @override
  String get subtitle_dashboard => 'Underwriting Dashboard';

  @override
  String get sidebar_clients => 'Clients';

  @override
  String get subtitle_clients => 'View and manage all clients';

  @override
  String get sidebar_motorQuote => 'Generate Quote';

  @override
  String get subtitle_motorQuote => 'Manage motor quotes';

  @override
  String get sidebar_policies => 'Production';

  @override
  String get subtitle_policies => 'View production Reports';

  @override
  String get sidebar_production => 'Production';

  @override
  String get subtitle_production => 'View production Reports';

  @override
  String get sidebar_dmvic => 'DMVIC';

  @override
  String get subtitle_dmvic => 'DMVIC-Express';

  @override
  String get sidebar_dmvicDoubleInsurance => 'DMVIC Double Insurance';

  @override
  String get subtitle_dmvicDoubleInsurance => 'Check double insurance';

  @override
  String get sidebar_dmvicStock => 'Cerificate Stock';

  @override
  String get subtitle_dmvicStock => 'Stock Check';

  @override
  String get sidebar_statement => 'Statement';

  @override
  String get subtitle_statement => 'View statements';

  @override
  String get sidebar_renewals => 'Renewals';

  @override
  String get subtitle_renewals => 'Monitor policy renewals';

  @override
  String get sidebar_certificates => 'Cert Extension';

  @override
  String get subtitle_certificates => 'View issued certificates';

  @override
  String get sidebar_quotes => 'My Quotes';

  @override
  String get subtitle_quotes => 'Manage insurance quotes';

  @override
  String get sidebar_settings => 'Settings';

  @override
  String get subtitle_settings => 'App preferences';

  @override
  String get sidebar_profile => 'My Profile';

  @override
  String get subtitle_profile => 'Manage your account';

  @override
  String get sidebar_notifications => 'Notifications';

  @override
  String get subtitle_notifications => 'View all your notifications';

  @override
  String get sidebar_offlineQueueScreen => 'Offline Queue Screen';

  @override
  String get subtitle_offlineQueueScreen => 'View all your offline saves';

  @override
  String get sidebar_logout => 'Logout';

  @override
  String get sidebar_loading => 'Loading...';

  @override
  String get sidebar_add_client => 'Add Client';

  @override
  String get subtitle_add_client => 'Enter new client details';

  @override
  String get subtitle_default => 'Always insured';
}
