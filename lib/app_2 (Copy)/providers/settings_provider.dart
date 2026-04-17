import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_riverpod/legacy.dart'
    show StateNotifier, StateNotifierProvider;
import 'package:insured/app_2/core/services/biometric_auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:html' as html;

// import 'package:insured/app_2/core/utils/web_download.dart'
//     if (dart.library.html) 'package:insured/app_2/core/utils/web_download_stub.dart';

import 'package:insured/app_2/core/utils/web_download_stub.dart'
    if (dart.library.html) 'package:insured/app_2/core/utils/web_download.dart';

const String _kThemeMode = 'themeMode';
const String _kTextSize = 'textSize';
const String _kDefaultView = 'defaultView';
const String _kCompactMode = 'compactMode';
const String _kEnableNotifications = 'enableNotifications';
const String _kEmailNotifications = 'emailNotifications';
const String _kRenewalReminders = 'renewalReminders';
const String _kLanguage = 'language';
const String _kTwoFactorAuth = 'twoFactorAuth';
const String _kActivityLogging = 'activityLogging';
const String _kShowSensitiveData = 'showSensitiveData';
const String _kHighContrast = 'highContrast';
const String _kReduceMotion = 'reduceMotion';
const String _kScreenReader = 'screenReader';
const String _kAutoSave = 'autoSave';
const String _kLazyLoading = 'lazyLoading';
const String _kOfflineMode = 'offlineMode';
const String _kKeyboardShortcuts = 'keyboardShortcuts';
const String _kDeveloperMode = 'developerMode';
const String _kBetaFeatures = 'betaFeatures';
const String _kOfflineModeEnabled = 'offlineModeEnabled';

class SettingsState {
  final String themeMode;
  final String textSize;
  final String defaultView;
  final bool compactMode;
  final bool enableNotifications;
  final bool emailNotifications;
  final bool renewalReminders;
  final String language;
  final bool twoFactorAuth;
  final bool activityLogging;
  final bool showSensitiveData;
  final bool highContrast;
  final bool reduceMotion;
  final bool screenReader;
  final bool autoSave;
  final bool lazyLoading;
  final bool offlineMode;
  final bool keyboardShortcuts;
  final bool developerMode;
  final bool betaFeatures;
  final bool offlineModeEnabled;

  SettingsState({
    required this.themeMode,
    required this.textSize,
    required this.defaultView,
    required this.compactMode,
    required this.enableNotifications,
    required this.emailNotifications,
    required this.renewalReminders,
    required this.language,
    required this.twoFactorAuth,
    required this.activityLogging,
    required this.showSensitiveData,
    required this.highContrast,
    required this.reduceMotion,
    required this.screenReader,
    required this.autoSave,
    required this.lazyLoading,
    required this.offlineMode,
    required this.keyboardShortcuts,
    required this.developerMode,
    required this.betaFeatures,
    required this.offlineModeEnabled,
  });

  SettingsState copyWith({
    String? themeMode,
    String? textSize,
    String? defaultView,
    bool? compactMode,
    bool? enableNotifications,
    bool? emailNotifications,
    bool? renewalReminders,
    String? language,
    bool? twoFactorAuth,
    bool? activityLogging,
    bool? showSensitiveData,
    bool? highContrast,
    bool? reduceMotion,
    bool? screenReader,
    bool? autoSave,
    bool? lazyLoading,
    bool? offlineMode,
    bool? keyboardShortcuts,
    bool? developerMode,
    bool? betaFeatures,
    bool? offlineModeEnabled,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      textSize: textSize ?? this.textSize,
      defaultView: defaultView ?? this.defaultView,
      compactMode: compactMode ?? this.compactMode,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      renewalReminders: renewalReminders ?? this.renewalReminders,
      language: language ?? this.language,
      twoFactorAuth: twoFactorAuth ?? this.twoFactorAuth,
      activityLogging: activityLogging ?? this.activityLogging,
      showSensitiveData: showSensitiveData ?? this.showSensitiveData,
      highContrast: highContrast ?? this.highContrast,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      screenReader: screenReader ?? this.screenReader,
      autoSave: autoSave ?? this.autoSave,
      lazyLoading: lazyLoading ?? this.lazyLoading,
      offlineMode: offlineMode ?? this.offlineMode,
      keyboardShortcuts: keyboardShortcuts ?? this.keyboardShortcuts,
      developerMode: developerMode ?? this.developerMode,
      betaFeatures: betaFeatures ?? this.betaFeatures,
      offlineModeEnabled: offlineModeEnabled ?? this.offlineModeEnabled,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(_defaultState()) {
    _loadFromStorage();
  }

  static SettingsState _defaultState() {
    return SettingsState(
      themeMode: 'System',
      textSize: 'Medium',
      defaultView: 'List View',
      compactMode: false,
      enableNotifications: true,
      emailNotifications: false,
      renewalReminders: true,
      language: 'English',
      twoFactorAuth: false,
      activityLogging: true,
      showSensitiveData: true,
      highContrast: false,
      reduceMotion: false,
      screenReader: false,
      autoSave: true,
      lazyLoading: true,
      offlineMode: false,
      keyboardShortcuts: true,
      developerMode: false,
      betaFeatures: false,
      offlineModeEnabled: false,
    );
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(
      themeMode: prefs.getString(_kThemeMode) ?? state.themeMode,
      textSize: prefs.getString(_kTextSize) ?? state.textSize,
      defaultView: prefs.getString(_kDefaultView) ?? state.defaultView,
      compactMode: prefs.getBool(_kCompactMode) ?? state.compactMode,
      enableNotifications:
          prefs.getBool(_kEnableNotifications) ?? state.enableNotifications,
      emailNotifications:
          prefs.getBool(_kEmailNotifications) ?? state.emailNotifications,
      renewalReminders:
          prefs.getBool(_kRenewalReminders) ?? state.renewalReminders,
      language: prefs.getString(_kLanguage) ?? state.language,
      twoFactorAuth: prefs.getBool(_kTwoFactorAuth) ?? state.twoFactorAuth,
      activityLogging:
          prefs.getBool(_kActivityLogging) ?? state.activityLogging,
      showSensitiveData:
          prefs.getBool(_kShowSensitiveData) ?? state.showSensitiveData,
      highContrast: prefs.getBool(_kHighContrast) ?? state.highContrast,
      reduceMotion: prefs.getBool(_kReduceMotion) ?? state.reduceMotion,
      screenReader: prefs.getBool(_kScreenReader) ?? state.screenReader,
      autoSave: prefs.getBool(_kAutoSave) ?? state.autoSave,
      lazyLoading: prefs.getBool(_kLazyLoading) ?? state.lazyLoading,
      offlineMode: prefs.getBool(_kOfflineMode) ?? state.offlineMode,
      keyboardShortcuts:
          prefs.getBool(_kKeyboardShortcuts) ?? state.keyboardShortcuts,
      developerMode: prefs.getBool(_kDeveloperMode) ?? state.developerMode,
      betaFeatures: prefs.getBool(_kBetaFeatures) ?? state.betaFeatures,
      offlineModeEnabled:
          prefs.getBool(_kOfflineModeEnabled) ?? state.offlineModeEnabled,
    );
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    // state = state.copyWith(themeMode: prefs.getString('themeMode') ?? state.themeMode);
  }

  Future<void> save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) prefs.setString(key, value);
    if (value is bool) prefs.setBool(key, value);
  }

  void setThemeMode(String value) {
    state = state.copyWith(themeMode: value);
    save(_kThemeMode, value);
  }

  void setTextSize(String value) {
    state = state.copyWith(textSize: value);
    save(_kTextSize, value);
  }

  void setDefaultView(String value) {
    state = state.copyWith(defaultView: value);
    save(_kDefaultView, value);
  }

  void setCompactMode(bool value) {
    state = state.copyWith(compactMode: value);
    save(_kCompactMode, value);
  }

  void setEnableNotifications(bool value) {
    state = state.copyWith(enableNotifications: value);
    save(_kEnableNotifications, value);
  }

  void setEmailNotifications(bool value) {
    state = state.copyWith(emailNotifications: value);
    save(_kEmailNotifications, value);
  }

  void setRenewalReminders(bool value) {
    state = state.copyWith(renewalReminders: value);
    save(_kRenewalReminders, value);
  }

  void setLanguage(String value) {
    state = state.copyWith(language: value);
    save(_kLanguage, value);
  }

  Future<void> setTwoFactorAuth(bool value) async {
    if (value == true) {
      // Attempt to authenticate before enabling
      final success = await BiometricAuthService.authenticate(
        reason: 'Enable two‑factor authentication',
      );
      if (!success) {
        // If authentication fails, keep it disabled and maybe show a message.
        return; // don't change state
      }
    }
    state = state.copyWith(twoFactorAuth: value);
    save(_kTwoFactorAuth, value);
  }

  void setActivityLogging(bool value) {
    state = state.copyWith(activityLogging: value);
    save(_kActivityLogging, value);
  }

  void setShowSensitiveData(bool value) {
    state = state.copyWith(showSensitiveData: value);
    save(_kShowSensitiveData, value);
  }

  void setHighContrast(bool value) {
    state = state.copyWith(highContrast: value);
    save(_kHighContrast, value);
  }

  void setReduceMotion(bool value) {
    state = state.copyWith(reduceMotion: value);
    save(_kReduceMotion, value);
  }

  void setScreenReader(bool value) {
    state = state.copyWith(screenReader: value);
    save(_kScreenReader, value);
  }

  void setAutoSave(bool value) {
    state = state.copyWith(autoSave: value);
    save(_kAutoSave, value);
  }

  void setLazyLoading(bool value) {
    state = state.copyWith(lazyLoading: value);
    save(_kLazyLoading, value);
  }

  void setOfflineMode(bool value) {
    state = state.copyWith(offlineMode: value);
    save(_kOfflineMode, value);
  }

  void setKeyboardShortcuts(bool value) {
    state = state.copyWith(keyboardShortcuts: value);
    save(_kKeyboardShortcuts, value);
  }

  void setDeveloperMode(bool value) {
    state = state.copyWith(developerMode: value);
    save(_kDeveloperMode, value);
  }

  void setBetaFeatures(bool value) {
    state = state.copyWith(betaFeatures: value);
    save(_kBetaFeatures, value);
  }

  void setOfflineModeEnabled(bool value) {
    state = state.copyWith(offlineModeEnabled: value);
    save(_kOfflineModeEnabled, value);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    final notifier = SettingsNotifier();
    notifier.load();
    return notifier;
  },
);

Future<void> exportSettings_(SettingsState settings) async {
  final data = {
    "themeMode": settings.themeMode,
    "textSize": settings.textSize,
    "defaultView": settings.defaultView,
    "compactMode": settings.compactMode,
    "enableNotifications": settings.enableNotifications,
    "emailNotifications": settings.emailNotifications,
    "renewalReminders": settings.renewalReminders,
    "language": settings.language,
    "twoFactorAuth": settings.twoFactorAuth,
    "activityLogging": settings.activityLogging,
    "showSensitiveData": settings.showSensitiveData,
    "highContrast": settings.highContrast,
    "reduceMotion": settings.reduceMotion,
    "screenReader": settings.screenReader,
    "autoSave": settings.autoSave,
    "lazyLoading": settings.lazyLoading,
    "offlineMode": settings.offlineMode,
    "keyboardShortcuts": settings.keyboardShortcuts,
    "developerMode": settings.developerMode,
    "betaFeatures": settings.betaFeatures,
  };

  final jsonString = const JsonEncoder.withIndent('  ').convert(data);

  String? outputPath = await FilePicker.platform.saveFile(
    dialogTitle: 'Export Settings',
    fileName: 'insured_settings.json',
  );

  if (outputPath != null) {
    final file = File(outputPath);
    await file.writeAsString(jsonString);
  }
}

// Future<void> exportSettings(SettingsState settings) async {
//   final data = {
//     "themeMode": settings.themeMode,
//     "textSize": settings.textSize,
//     "defaultView": settings.defaultView,
//     "compactMode": settings.compactMode,
//     "enableNotifications": settings.enableNotifications,
//     "emailNotifications": settings.emailNotifications,
//     "renewalReminders": settings.renewalReminders,
//     "language": settings.language,
//     "twoFactorAuth": settings.twoFactorAuth,
//     "activityLogging": settings.activityLogging,
//     "showSensitiveData": settings.showSensitiveData,
//     "highContrast": settings.highContrast,
//     "reduceMotion": settings.reduceMotion,
//     "screenReader": settings.screenReader,
//     "autoSave": settings.autoSave,
//     "lazyLoading": settings.lazyLoading,
//     "offlineMode": settings.offlineMode,
//     "keyboardShortcuts": settings.keyboardShortcuts,
//     "developerMode": settings.developerMode,
//     "betaFeatures": settings.betaFeatures,
//   };

//   final jsonString = const JsonEncoder.withIndent('  ').convert(data);

//   /// WEB
//   if (kIsWeb) {
//     final bytes = utf8.encode(jsonString);
//     final blob = html.Blob([bytes]);

//     final url = html.Url.createObjectUrlFromBlob(blob);

//     final anchor = html.AnchorElement(href: url)
//       ..setAttribute("download", "insured_settings.json")
//       ..click();

//     html.Url.revokeObjectUrl(url);
//     return;
//   }

//   /// DESKTOP / MOBILE
//   String? outputPath = await FilePicker.platform.saveFile(
//     dialogTitle: 'Export Settings',
//     fileName: 'insured_settings.json',
//   );

//   if (outputPath != null) {
//     final file = File(outputPath);
//     await file.writeAsString(jsonString);
//   }
// }

Future<void> exportSettings(SettingsState settings) async {
  final data = {
    "themeMode": settings.themeMode,
    "textSize": settings.textSize,
    "defaultView": settings.defaultView,
    "compactMode": settings.compactMode,
    "enableNotifications": settings.enableNotifications,
    "emailNotifications": settings.emailNotifications,
    "renewalReminders": settings.renewalReminders,
    "language": settings.language,
    "twoFactorAuth": settings.twoFactorAuth,
    "activityLogging": settings.activityLogging,
    "showSensitiveData": settings.showSensitiveData,
    "highContrast": settings.highContrast,
    "reduceMotion": settings.reduceMotion,
    "screenReader": settings.screenReader,
    "autoSave": settings.autoSave,
    "lazyLoading": settings.lazyLoading,
    "offlineMode": settings.offlineMode,
    "keyboardShortcuts": settings.keyboardShortcuts,
    "developerMode": settings.developerMode,
    "betaFeatures": settings.betaFeatures,
  };

  final jsonString = const JsonEncoder.withIndent('  ').convert(data);

  /// WEB – uses direct browser download
  if (kIsWeb) {
    await downloadJsonWeb(jsonString, 'insured_settings.json');
    return;
  }

  /// MOBILE / DESKTOP – uses FilePicker
  String? outputPath = await FilePicker.platform.saveFile(
    dialogTitle: 'Export Settings',
    fileName: 'insured_settings.json',
  );

  if (outputPath != null) {
    final file = File(outputPath);
    await file.writeAsString(jsonString);
  }
}
