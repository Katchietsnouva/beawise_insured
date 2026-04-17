import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('it'),
    Locale('ru'),
    Locale('sw'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Insured'**
  String get appTitle;

  /// No description provided for @newPolicy.
  ///
  /// In en, this message translates to:
  /// **'New Motor Policy'**
  String get newPolicy;

  /// No description provided for @policy.
  ///
  /// In en, this message translates to:
  /// **'Policy'**
  String get policy;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @claim.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get claim;

  /// No description provided for @addClient.
  ///
  /// In en, this message translates to:
  /// **'Add New Client'**
  String get addClient;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String welcomeMessage(String name);

  /// No description provided for @settings_appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settings_appearanceTitle;

  /// No description provided for @settings_appearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize how the app looks'**
  String get settings_appearanceSubtitle;

  /// No description provided for @settings_themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settings_themeLabel;

  /// No description provided for @settings_textSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get settings_textSizeLabel;

  /// No description provided for @settings_DisplayTitle.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get settings_DisplayTitle;

  /// No description provided for @settings_DisplaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure default display options'**
  String get settings_DisplaySubtitle;

  /// No description provided for @settings_DefaultViewLabel.
  ///
  /// In en, this message translates to:
  /// **'Default View'**
  String get settings_DefaultViewLabel;

  /// No description provided for @settings_CompactModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Compact Mode'**
  String get settings_CompactModeTitle;

  /// No description provided for @settings_CompactModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Reduce spacing between elements'**
  String get settings_CompactModeDescription;

  /// No description provided for @settings_NotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settings_NotificationsTitle;

  /// No description provided for @settings_NotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage notification preferences'**
  String get settings_NotificationsSubtitle;

  /// No description provided for @settings_EnableNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get settings_EnableNotificationsTitle;

  /// No description provided for @settings_EnableNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive in-app notifications'**
  String get settings_EnableNotificationsDescription;

  /// No description provided for @settings_EmailNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get settings_EmailNotificationsTitle;

  /// No description provided for @settings_EmailNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive updates via email'**
  String get settings_EmailNotificationsDescription;

  /// No description provided for @settings_RenewalRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Renewal Reminders'**
  String get settings_RenewalRemindersTitle;

  /// No description provided for @settings_RenewalRemindersDescription.
  ///
  /// In en, this message translates to:
  /// **'Get notified about upcoming renewals'**
  String get settings_RenewalRemindersDescription;

  /// No description provided for @settings_LanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language & Region'**
  String get settings_LanguageTitle;

  /// No description provided for @settings_LanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set your language preferences'**
  String get settings_LanguageSubtitle;

  /// No description provided for @settings_LanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_LanguageLabel;

  /// No description provided for @settings_PrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get settings_PrivacyTitle;

  /// No description provided for @settings_PrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control your privacy and security settings'**
  String get settings_PrivacySubtitle;

  /// No description provided for @settings_TwoFactorTitle.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Authentication'**
  String get settings_TwoFactorTitle;

  /// No description provided for @settings_TwoFactorDescription.
  ///
  /// In en, this message translates to:
  /// **'Add an extra layer of security'**
  String get settings_TwoFactorDescription;

  /// No description provided for @settings_ActivityLoggingTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity Logging'**
  String get settings_ActivityLoggingTitle;

  /// No description provided for @settings_ActivityLoggingDescription.
  ///
  /// In en, this message translates to:
  /// **'Track account activity'**
  String get settings_ActivityLoggingDescription;

  /// No description provided for @settings_ShowSensitiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Show Sensitive Data'**
  String get settings_ShowSensitiveTitle;

  /// No description provided for @settings_ShowSensitiveDescription.
  ///
  /// In en, this message translates to:
  /// **'Display ID numbers and financial data'**
  String get settings_ShowSensitiveDescription;

  /// No description provided for @settings_ChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get settings_ChangePassword;

  /// No description provided for @settings_DataTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get settings_DataTitle;

  /// No description provided for @settings_DataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export, import, and manage your data'**
  String get settings_DataSubtitle;

  /// No description provided for @settings_ExportSettings.
  ///
  /// In en, this message translates to:
  /// **'Export Settings'**
  String get settings_ExportSettings;

  /// No description provided for @settings_ImportSettings.
  ///
  /// In en, this message translates to:
  /// **'Import Settings'**
  String get settings_ImportSettings;

  /// No description provided for @settings_DownloadAllData.
  ///
  /// In en, this message translates to:
  /// **'Download All Data'**
  String get settings_DownloadAllData;

  /// No description provided for @settings_ClearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get settings_ClearCache;

  /// No description provided for @settings_AccessibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settings_AccessibilityTitle;

  /// No description provided for @settings_AccessibilitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enhance accessibility features'**
  String get settings_AccessibilitySubtitle;

  /// No description provided for @settings_HighContrastTitle.
  ///
  /// In en, this message translates to:
  /// **'High Contrast Mode'**
  String get settings_HighContrastTitle;

  /// No description provided for @settings_HighContrastDescription.
  ///
  /// In en, this message translates to:
  /// **'Increase contrast for better visibility'**
  String get settings_HighContrastDescription;

  /// No description provided for @settings_ReduceMotionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reduce Motion'**
  String get settings_ReduceMotionTitle;

  /// No description provided for @settings_ReduceMotionDescription.
  ///
  /// In en, this message translates to:
  /// **'Minimize animations and transitions'**
  String get settings_ReduceMotionDescription;

  /// No description provided for @settings_ScreenReaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Screen Reader Support'**
  String get settings_ScreenReaderTitle;

  /// No description provided for @settings_ScreenReaderDescription.
  ///
  /// In en, this message translates to:
  /// **'Enhanced screen reader compatibility'**
  String get settings_ScreenReaderDescription;

  /// No description provided for @settings_PerformanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get settings_PerformanceTitle;

  /// No description provided for @settings_PerformanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optimize app performance'**
  String get settings_PerformanceSubtitle;

  /// No description provided for @settings_AutoSaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-Save'**
  String get settings_AutoSaveTitle;

  /// No description provided for @settings_AutoSaveDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically save changes'**
  String get settings_AutoSaveDescription;

  /// No description provided for @settings_LazyLoadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Lazy Loading'**
  String get settings_LazyLoadingTitle;

  /// No description provided for @settings_LazyLoadingDescription.
  ///
  /// In en, this message translates to:
  /// **'Load content as you scroll'**
  String get settings_LazyLoadingDescription;

  /// No description provided for @settings_OfflineModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get settings_OfflineModeTitle;

  /// No description provided for @settings_OfflineModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Work without internet connection'**
  String get settings_OfflineModeDescription;

  /// No description provided for @settings_AdvancedTitle.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get settings_AdvancedTitle;

  /// No description provided for @settings_AdvancedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Power user features and shortcuts'**
  String get settings_AdvancedSubtitle;

  /// No description provided for @settings_KeyboardShortcutsTitle.
  ///
  /// In en, this message translates to:
  /// **'Keyboard Shortcuts'**
  String get settings_KeyboardShortcutsTitle;

  /// No description provided for @settings_KeyboardShortcutsDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable keyboard navigation'**
  String get settings_KeyboardShortcutsDescription;

  /// No description provided for @settings_DeveloperModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Developer Mode'**
  String get settings_DeveloperModeTitle;

  /// No description provided for @settings_DeveloperModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Show advanced debugging options'**
  String get settings_DeveloperModeDescription;

  /// No description provided for @settings_BetaFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Beta Features'**
  String get settings_BetaFeaturesTitle;

  /// No description provided for @settings_BetaFeaturesDescription.
  ///
  /// In en, this message translates to:
  /// **'Try experimental features'**
  String get settings_BetaFeaturesDescription;

  /// No description provided for @settings_ViewKeyboardShortcuts.
  ///
  /// In en, this message translates to:
  /// **'View Keyboard Shortcuts'**
  String get settings_ViewKeyboardShortcuts;

  /// No description provided for @settings_DangerTitle.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get settings_DangerTitle;

  /// No description provided for @settings_DangerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Irreversible actions'**
  String get settings_DangerSubtitle;

  /// No description provided for @settings_ResetAllSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset All Settings'**
  String get settings_ResetAllSettings;

  /// No description provided for @settings_DeleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete All Data'**
  String get settings_DeleteAllData;

  /// No description provided for @sidebar_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get sidebar_dashboard;

  /// No description provided for @subtitle_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Underwriting Dashboard'**
  String get subtitle_dashboard;

  /// No description provided for @sidebar_clients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get sidebar_clients;

  /// No description provided for @subtitle_clients.
  ///
  /// In en, this message translates to:
  /// **'View and manage all clients'**
  String get subtitle_clients;

  /// No description provided for @sidebar_motorQuote.
  ///
  /// In en, this message translates to:
  /// **'Generate Quote'**
  String get sidebar_motorQuote;

  /// No description provided for @subtitle_motorQuote.
  ///
  /// In en, this message translates to:
  /// **'Manage motor quotes'**
  String get subtitle_motorQuote;

  /// No description provided for @sidebar_policies.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get sidebar_policies;

  /// No description provided for @subtitle_policies.
  ///
  /// In en, this message translates to:
  /// **'View production Reports'**
  String get subtitle_policies;

  /// No description provided for @sidebar_production.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get sidebar_production;

  /// No description provided for @subtitle_production.
  ///
  /// In en, this message translates to:
  /// **'View production Reports'**
  String get subtitle_production;

  /// No description provided for @sidebar_dmvic.
  ///
  /// In en, this message translates to:
  /// **'DMVIC'**
  String get sidebar_dmvic;

  /// No description provided for @subtitle_dmvic.
  ///
  /// In en, this message translates to:
  /// **'DMVIC-Express'**
  String get subtitle_dmvic;

  /// No description provided for @sidebar_dmvicDoubleInsurance.
  ///
  /// In en, this message translates to:
  /// **'DMVIC Double Insurance'**
  String get sidebar_dmvicDoubleInsurance;

  /// No description provided for @subtitle_dmvicDoubleInsurance.
  ///
  /// In en, this message translates to:
  /// **'Check double insurance'**
  String get subtitle_dmvicDoubleInsurance;

  /// No description provided for @sidebar_dmvicStock.
  ///
  /// In en, this message translates to:
  /// **'Cerificate Stock'**
  String get sidebar_dmvicStock;

  /// No description provided for @subtitle_dmvicStock.
  ///
  /// In en, this message translates to:
  /// **'Stock Check'**
  String get subtitle_dmvicStock;

  /// No description provided for @sidebar_statement.
  ///
  /// In en, this message translates to:
  /// **'Statement'**
  String get sidebar_statement;

  /// No description provided for @subtitle_statement.
  ///
  /// In en, this message translates to:
  /// **'View statements'**
  String get subtitle_statement;

  /// No description provided for @sidebar_renewals.
  ///
  /// In en, this message translates to:
  /// **'Renewals'**
  String get sidebar_renewals;

  /// No description provided for @subtitle_renewals.
  ///
  /// In en, this message translates to:
  /// **'Monitor policy renewals'**
  String get subtitle_renewals;

  /// No description provided for @sidebar_certificates.
  ///
  /// In en, this message translates to:
  /// **'Cert Extension'**
  String get sidebar_certificates;

  /// No description provided for @subtitle_certificates.
  ///
  /// In en, this message translates to:
  /// **'View issued certificates'**
  String get subtitle_certificates;

  /// No description provided for @sidebar_quotes.
  ///
  /// In en, this message translates to:
  /// **'My Quotes'**
  String get sidebar_quotes;

  /// No description provided for @subtitle_quotes.
  ///
  /// In en, this message translates to:
  /// **'Manage insurance quotes'**
  String get subtitle_quotes;

  /// No description provided for @sidebar_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get sidebar_settings;

  /// No description provided for @subtitle_settings.
  ///
  /// In en, this message translates to:
  /// **'App preferences'**
  String get subtitle_settings;

  /// No description provided for @sidebar_profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get sidebar_profile;

  /// No description provided for @subtitle_profile.
  ///
  /// In en, this message translates to:
  /// **'Manage your account'**
  String get subtitle_profile;

  /// No description provided for @sidebar_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get sidebar_notifications;

  /// No description provided for @subtitle_notifications.
  ///
  /// In en, this message translates to:
  /// **'View all your notifications'**
  String get subtitle_notifications;

  /// No description provided for @sidebar_offlineQueueScreen.
  ///
  /// In en, this message translates to:
  /// **'Offline Queue Screen'**
  String get sidebar_offlineQueueScreen;

  /// No description provided for @subtitle_offlineQueueScreen.
  ///
  /// In en, this message translates to:
  /// **'View all your offline saves'**
  String get subtitle_offlineQueueScreen;

  /// No description provided for @sidebar_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get sidebar_logout;

  /// No description provided for @sidebar_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get sidebar_loading;

  /// No description provided for @sidebar_add_client.
  ///
  /// In en, this message translates to:
  /// **'Add Client'**
  String get sidebar_add_client;

  /// No description provided for @subtitle_add_client.
  ///
  /// In en, this message translates to:
  /// **'Enter new client details'**
  String get subtitle_add_client;

  /// No description provided for @subtitle_default.
  ///
  /// In en, this message translates to:
  /// **'Always insured'**
  String get subtitle_default;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'fr',
    'it',
    'ru',
    'sw',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ru':
      return AppLocalizationsRu();
    case 'sw':
      return AppLocalizationsSw();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
