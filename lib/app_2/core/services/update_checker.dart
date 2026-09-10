import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:insured/app_2/app_router.dart';
import 'package:insured/app_2/core/constants/url_cosntants.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// One entry in the changelog history.
class VersionEntry {
  final String version;
  final DateTime? date;
  final List<String> changes;
  const VersionEntry({required this.version, this.date, required this.changes});
}

/// Parsed contents of version.json plus the derived update state.
class UpdateInfo {
  final String latestVersion;
  final String currentVersion;
  final DateTime? releaseDate;
  final String? downloadUrl;
  final bool forceUpdate;
  final String message;
  final List<String> changes;
  final List<VersionEntry> history;

  const UpdateInfo({
    required this.latestVersion,
    required this.currentVersion,
    this.releaseDate,
    this.downloadUrl,
    this.forceUpdate = false,
    this.message = 'A new version of the app is available.',
    this.changes = const [],
    this.history = const [],
  });

  bool get isUpdateAvailable =>
      UpdateChecker.isNewer(latestVersion, currentVersion);

  String get target => downloadUrl ?? InscloudUrls.installationPage;

  /// How many days the newest version has been out (i.e. how long the
  /// installed app has been outdated). Null when there's no release date.
  int? get daysOutdated {
    if (releaseDate == null || !isUpdateAvailable) return null;
    final days = DateTime.now().difference(releaseDate!).inDays;
    return days < 0 ? 0 : days;
  }
}

/// Fetches version.json once and exposes it to the UI (Settings screen, etc.).
final updateInfoProvider = FutureProvider<UpdateInfo?>((ref) {
  return UpdateChecker.fetch();
});

/// Dev-only, persisted toggle for showing the update popup on the web build.
/// Defaults to false; only surfaced in Settings for [UpdateChecker.devEmail].
class ShowOnWebNotifier extends StateNotifier<bool> {
  ShowOnWebNotifier() : super(false) {
    _load();
  }
  static const String key = 'dev_show_update_on_web';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(key) ?? false;
  }

  Future<void> set(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}

final showUpdateOnWebProvider = StateNotifierProvider<ShowOnWebNotifier, bool>(
  (ref) => ShowOnWebNotifier(),
);

class UpdateChecker {
  static final String versionUrl = '${InscloudUrls.baseUrl}/version.json';

  /// The only account allowed to enable the update popup on web.
  static const String devEmail = 'philipaswa01@gmail.com';

  /// Reads the persisted web-override flag (defaults to false).
  static Future<bool> isShowOnWebEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(ShowOnWebNotifier.key) ?? false;
  }

  /// Downloads and parses version.json. Returns null on any failure.
  static Future<UpdateInfo?> fetch() async {
    try {
      final response = await http.get(
        Uri.parse(versionUrl),
        headers: {'Cache-Control': 'no-cache'},
      );
      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final latestVersion = (data['version'] as String?)?.trim();
      if (latestVersion == null || latestVersion.isEmpty) return null;

      List<String> changesOf(dynamic v) =>
          (v as List?)?.map((e) => e.toString()).toList() ?? const <String>[];

      final history = (data['history'] as List?)
          ?.whereType<Map>()
          .map(
            (e) => VersionEntry(
              version: e['version']?.toString() ?? '',
              date: _parseDate(e['release_date']),
              changes: changesOf(e['changes']),
            ),
          )
          .toList();

      return UpdateInfo(
        latestVersion: latestVersion,
        currentVersion: InscloudUrls.appVersion,
        releaseDate: _parseDate(data['release_date']),
        downloadUrl: data['download_url'] as String?,
        forceUpdate: data['force_update'] == true,
        message:
            data['message'] as String? ??
            'A new version of the app is available.',
        changes: changesOf(data['changes']),
        history: history ?? const [],
      );
    } catch (e) {
      debugPrint('Update check error: $e');
      return null;
    }
  }

  /// Startup check: fetches and, on mobile, shows the popup if outdated.
  static Future<void> check() async {
    // The web build is always served up to date, so the popup is mobile-only
    // unless a dev has enabled it via the persisted toggle in Settings.
    if (kIsWeb && !await isShowOnWebEnabled()) return;

    final info = await fetch();
    if (info == null || !info.isUpdateAvailable) return;

    // Show the dialog from the router's navigator, NOT the app-root context
    // (which sits above MaterialApp and therefore has no Navigator).
    final context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) {
      debugPrint('Update check: no navigator context available yet');
      return;
    }
    // Don't nag on the installation/downloads screen — that's where the
    // "Update" button sends the user, so the popup there is redundant.
    if (_isOnInstallationRoute(context)) return;
    await showUpdateDialog(context, info);
  }

  /// True when the current route is the installation/downloads screen.
  static bool _isOnInstallationRoute(BuildContext context) {
    try {
      final location = GoRouter.of(
        context,
      ).routerDelegate.currentConfiguration.uri.toString();
      return location.contains('/installation');
    } catch (_) {
      return false;
    }
  }

  /// The update dialog, reused by the startup check and the Settings screen.
  static Future<void> showUpdateDialog(BuildContext context, UpdateInfo info) {
    return showDialog(
      context: context,
      barrierDismissible: !info.forceUpdate,
      builder: (context) {
        return PopScope(
          canPop: !info.forceUpdate,
          child: AlertDialog(
            title: const Text('Update available'),
            content: SizedBox(
              width: 340,
              child: ConstrainedBox(
                // Keep the dialog on-screen; let long changelogs scroll.
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(info.message),
                  if (info.daysOutdated != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _outdatedLabel(info.daysOutdated!),
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  if (info.changes.isNotEmpty || info.history.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Theme(
                      // Hide ExpansionTile's default divider lines.
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: const EdgeInsets.only(
                          left: 4,
                          bottom: 8,
                        ),
                        title: const Text(
                          "What's new",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        children: _changelog(info),
                      ),
                    ),
                  ],
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              Row(
                children: [
                  if (!info.forceUpdate) ...[
                    Expanded(
                      child: CustomAdvancedButton(
                        label: 'Later',
                        variant: ButtonVariant.primary,
                        color1: Colors.grey,
                        onPressed: () {
                          Navigator.pop(context);
                          _showLaterConfirm(context);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: CustomAdvancedButton(
                      label: 'Update',
                      variant: ButtonVariant.primary,
                      onPressed: () async {
                        await launchUrl(
                          Uri.parse(info.target),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Follow-up shown after the user dismisses the update: reminds them the
  /// update is still available and where to find it later (Settings screen).
  static Future<void> _showLaterConfirm(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update later?'),
        content: const Text(
          'An update is available. You can install it any time from '
          'Settings → App version.',
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomAdvancedButton(
                  label: 'OK',
                  variant: ButtonVariant.primary,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _outdatedLabel(int days) {
    if (days <= 0) return 'Released today';
    if (days == 1) return 'Your app is 1 day behind';
    return 'Your app is $days days behind';
  }

  // Builds the expander body: grouped per-version history when available,
  // otherwise a flat bullet list of the latest changes.
  static List<Widget> _changelog(UpdateInfo info) {
    Widget bullet(String c) => Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text('•  $c'),
      ),
    );

    if (info.history.isEmpty) {
      return [for (final c in info.changes) bullet(c)];
    }
    return [
      for (final entry in info.history) ...[
        Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 2),
          child: Text(
            entry.date != null
                ? 'v${entry.version}  •  ${_fmtDate(entry.date!)}'
                : 'v${entry.version}',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
        for (final c in entry.changes) bullet(c),
      ],
    ];
  }

  static DateTime? _parseDate(dynamic v) =>
      v is String ? DateTime.tryParse(v) : null;

  static String _fmtDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  static bool isNewer(String latest, String current) {
    // Strip any build metadata (e.g. "1.0.9+2") and parse tolerantly.
    int part(String s) => int.tryParse(s.split('+').first.trim()) ?? 0;
    final latestParts = latest.split('.').map(part).toList();
    final currentParts = current.split('.').map(part).toList();

    final length = latestParts.length > currentParts.length
        ? latestParts.length
        : currentParts.length;

    for (int i = 0; i < length; i++) {
      final latestNumber = i < latestParts.length ? latestParts[i] : 0;
      final currentNumber = i < currentParts.length ? currentParts[i] : 0;
      if (latestNumber > currentNumber) return true;
      if (latestNumber < currentNumber) return false;
    }
    return false;
  }
}
