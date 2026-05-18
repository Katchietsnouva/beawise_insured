import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const _App());

class _App extends StatefulWidget {
  const _App();
  @override
  State<_App> createState() => _AppState();
}

class _AppState extends State<_App> {
  ThemeMode _mode = ThemeMode.dark;
  void _toggle() => setState(
    () => _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _mode,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      // home: DownloadScreen(onToggleTheme: _toggle, themeMode: _mode),
      home: DownloadScreen(),
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  return ThemeData(
    brightness: brightness,
    scaffoldBackgroundColor: dark
        ? const Color(0xFF0D1F1C)
        : const Color(0xFFF0FAF7),
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: dark ? const Color(0xFF00FFB2) : const Color(0xFF00A572),
      onPrimary: const Color(0xFF0D1F1C),
      secondary: dark ? const Color(0xFF00CC8E) : const Color(0xFF008A5E),
      onSecondary: Colors.white,
      error: Colors.redAccent,
      onError: Colors.white,
      surface: dark ? const Color(0xFF132620) : const Color(0xFFE4F4EE),
      onSurface: dark ? const Color(0xFFF0FAF7) : const Color(0xFF0D2520),
    ),
    fontFamily: 'SF Pro Display',
    useMaterial3: true,
  );
}

final localColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: const Color(0xFF00FFB2),
  onPrimary: const Color(0xFF0D1F1C),
  secondary: const Color(0xFF00CC8E),
  onSecondary: Colors.white,
  error: Colors.redAccent,
  onError: Colors.white,
  surface: const Color(0xFF132620),
  onSurface: const Color(0xFFF0FAF7),
);

class DownloadScreen extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final ThemeMode? themeMode;

  const DownloadScreen({super.key, this.onToggleTheme, this.themeMode});

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  OverlayEntry? _toastEntry;

  void _showToast(String message) {
    _toastEntry?.remove();
    _toastEntry = OverlayEntry(builder: (_) => _Toast(message: message));
    Overlay.of(context).insert(_toastEntry!);
    Future.delayed(const Duration(milliseconds: 2400), () {
      _toastEntry?.remove();
      _toastEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final cs = Theme.of(context).colorScheme;
    final cs = localColorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      data: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF00FFB2),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FFB2),
          secondary: Color(0xFF00F0FF),
        ),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _TopBar(
                      dark: dark,
                      onToggle: widget.onToggleTheme,
                      themeMode: widget.themeMode,
                    ),
                    const SizedBox(height: 56),
                    _HeroSection(cs: cs),
                    const SizedBox(height: 48),
                    _SectionLabel('Choose your platform'),
                    const SizedBox(height: 16),
                    _PlatformsGrid(cs: cs, onDownload: _showToast),
                    const SizedBox(height: 48),
                    _StatsRow(cs: cs),
                    const SizedBox(height: 48),
                    _SectionLabel('Installation guides'),
                    const SizedBox(height: 16),
                    _InstallGuides(cs: cs, onCopy: _showToast),
                    const SizedBox(height: 48),
                    _SectionLabel('System requirements'),
                    const SizedBox(height: 16),
                    _CompatBar(cs: cs),
                    const SizedBox(height: 60),
                    _Footer(cs: cs),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final bool dark;
  final VoidCallback? onToggle;
  final ThemeMode? themeMode;
  const _TopBar({
    required this.dark,
    required this.onToggle,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.shield_rounded, size: 18, color: cs.onPrimary),
        ),
        const SizedBox(width: 10),
        Text(
          'Insured',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: cs.primary.withOpacity(.6)),
          ),
          child: Text(
            'v1.0',
            style: TextStyle(
              fontSize: 11,
              color: cs.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Spacer(),
        // Theme toggle
        Opacity(
          opacity: 0.005,
          child: GestureDetector(
            onTap: onToggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: cs.surface.withOpacity(.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: cs.onSurface.withOpacity(.12)),
              ),
              child: Row(
                children: [
                  Icon(
                    dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    size: 14,
                    color: cs.onSurface.withOpacity(.7),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    dark ? 'Light mode' : 'Dark mode',
                    style: TextStyle(
                      fontSize: 13,
                      color: cs.onSurface.withOpacity(.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  final ColorScheme cs;
  const _HeroSection({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pulse tag
        _PulseTag(cs: cs),
        const SizedBox(height: 24),
        Text.rich(
          TextSpan(
            text: 'Insurance management,\n',
            style: TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w700,
              height: 1.1,
              letterSpacing: -2,
              color: cs.onSurface,
            ),
            children: [
              TextSpan(
                text: 'everywhere you work',
                style: TextStyle(color: cs.primary),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),
        Text(
          'Download Insured for your device and manage policies,\ncertificates, renewals and clients — offline or online.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            color: cs.onSurface.withOpacity(.6),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurface.withOpacity(.35),
              ),
            ),
            _dot(cs),
            Text(
              'Released May 2026',
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurface.withOpacity(.35),
              ),
            ),
            _dot(cs),
            // Text(
            //   'Forever for agents',
            //   style: TextStyle(
            //     fontSize: 13,
            //     color: cs.onSurface.withOpacity(.35),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _dot(ColorScheme cs) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: cs.onSurface.withOpacity(.3),
        shape: BoxShape.circle,
      ),
    ),
  );
}

class _PulseTag extends StatefulWidget {
  final ColorScheme cs;
  const _PulseTag({required this.cs});
  @override
  State<_PulseTag> createState() => _PulseTagState();
}

class _PulseTagState extends State<_PulseTag>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = widget.cs;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.primary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => Opacity(
              opacity: _anim.value,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'NOW AVAILABLE ON ALL PLATFORMS',
            style: TextStyle(
              fontSize: 11,
              color: cs.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: .8,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlatformsGrid extends StatelessWidget {
  final ColorScheme cs;
  final void Function(String) onDownload;
  const _PlatformsGrid({required this.cs, required this.onDownload});

  @override
  Widget build(BuildContext context) {
    final platforms = [
      _PlatformData(
        'Android',
        'Play Store or direct APK\nAndroid 8.0+',
        Icons.android_rounded,
        'Google Play / APK',
        'Android APK',
        false,
        null,
        '/downloads/v1.0.0-armeabi-v7a-release.apk',
        // 'https://github.com/Katchietsnouva/beawise_insured/blob/main/web/downloads/v1.0.0-arm64-v8a-release.apk',
      ),
      _PlatformData(
        'iOS / iPadOS',
        'iPhone & iPad\niOS 15 or later',
        Icons.phone_iphone_rounded,
        'App Store',
        'iOS App Store',
        false,
        null,
        'https://apps.apple.com/app/...insured-insurance-agent-app/id6441871234',
        // 'https://apps.apple.com/app/...insured-insurance-agent-app/id6441871234',
      ),
      _PlatformData(
        'Windows',
        'Windows 10 / 11 (64-bit)',
        Icons.desktop_windows_rounded,
        'Download .exe',
        'Windows 2.4.1 .exe',
        false,
        null,
        '/downloads/insured-windows-setup.exe',
      ),
      _PlatformData(
        'macOS',
        'Apple Silicon & Intel\nmacOS 12 Monterey or later',
        Icons.laptop_mac_rounded,
        'Download .dmg',
        'macOS 2.4.1 .dmg',
        false,
        null,
        '/downloads/insured-macos.dmg',
      ),

      _PlatformData(
        'Linux',
        'Ubuntu · Mint · Debian\nAMD64 / ARM64',
        Icons.terminal_rounded,
        'Download .deb / .AppImage',
        'Linux 2.4.1 .deb',
        false,
        null,
        '/downloads/insured-linux-amd64.deb',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth > 800
            ? 5
            : constraints.maxWidth > 500
            ? 3
            : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: .72,
          ),
          itemCount: platforms.length,
          itemBuilder: (_, i) =>
              _PlatformCard(data: platforms[i], cs: cs, onDownload: onDownload),
        );
      },
    );
  }
}

class _PlatformData {
  final String name, subtitle, btnLabel, toastMsg;
  final IconData icon;
  final bool featured;
  final String? badge;
  final String downloadUrl;
  const _PlatformData(
    this.name,
    this.subtitle,
    this.icon,
    this.btnLabel,
    this.toastMsg,
    this.featured,
    this.badge,
    this.downloadUrl,
  );
}

class _PlatformCard extends StatefulWidget {
  final _PlatformData data;
  final ColorScheme cs;
  final void Function(String) onDownload;
  const _PlatformCard({
    super.key,
    required this.data,
    required this.cs,
    required this.onDownload,
  });
  @override
  State<_PlatformCard> createState() => _PlatformCardState();
}

class _PlatformCardState extends State<_PlatformCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = widget.cs;
    final d = widget.data;
    final active = _hovered || d.featured;

    Widget _archOption(
      BuildContext context,
      String title,
      String subtitle,
      String url,
      ColorScheme cs,
    ) {
      return InkWell(
        onTap: () => Navigator.pop(context, url),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.primary.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.memory, color: cs.primary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: cs.primary, size: 16),
            ],
          ),
        ),
      );
    }

    Future<String?> _showAndroidArchDialog(BuildContext context) async {
      final cs = widget.cs;
      return showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: cs.surface,
          title: Text(
            'Choose your processor',
            style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _archOption(
                ctx,
                'ARM64 (64‑bit)',
                'Most modern phones (2020+)',
                '/downloads/v1.0.0-arm64-v8a-release.apk',
                cs,
              ),
              const SizedBox(height: 12),
              _archOption(
                ctx,
                'ARMv7 (32‑bit)',
                'Older devices (pre‑2020)',
                '/downloads/v1.0.0-armeabi-v7a-release.apk',
                cs,
              ),
              const SizedBox(height: 12),
              _archOption(
                ctx,
                'x86_64 (64‑bit)',
                'Emulators / very rare phones',
                '/downloads/v1.0.0-x86_64-release.apk',
                cs,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: TextStyle(color: cs.onSurface.withOpacity(0.7)),
              ),
            ),
          ],
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: active
              ? cs.primary.withOpacity(.08)
              : cs.surface.withOpacity(.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: active ? cs.primary : cs.onSurface.withOpacity(.1),
            width: d.featured ? 1.5 : 1,
          ),
        ),
        transform: _hovered
            ? (Matrix4.identity()..translate(0.0, -3.0))
            : Matrix4.identity(),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (d.featured) ...[
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Popular',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(d.icon, size: 22, color: cs.primary),
              ),
              const SizedBox(height: 12),
              Text(
                d.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                d.subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withOpacity(.55),
                  height: 1.4,
                ),
              ),
              const Spacer(),
              GestureDetector(
                // // onTap: () =>
                // // widget.onDownload('Downloading Insured for ${d.name}...'),
                // onTap: () async {
                //   // final Uri url = Uri.parse(d.downloadUrl);
                //   final Uri url = Uri.base.resolve(d.downloadUrl);
                //   if (await canLaunchUrl(url)) {
                //     widget.onDownload('Starting download...');
                //     await launchUrl(url, mode: LaunchMode.externalApplication);
                //   } else {
                //     widget.onDownload('Could not launch download link.');
                //   }
                // },
                onTap: () async {
                  // For Android, show a selection dialog with the three APK options
                  if (d.name == 'Android') {
                    final selectedUrl = await _showAndroidArchDialog(context);
                    if (selectedUrl != null) {
                      final Uri url = Uri.base.resolve(selectedUrl);
                      if (await canLaunchUrl(url)) {
                        widget.onDownload('Starting download...');
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        widget.onDownload('Could not launch download link.');
                      }
                    }
                    return;
                  }

                  // For other platforms, use the single downloadUrl as before
                  final Uri url = Uri.base.resolve(d.downloadUrl);
                  if (await canLaunchUrl(url)) {
                    widget.onDownload('Starting download...');
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    widget.onDownload('Could not launch download link.');
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: active ? cs.primary : cs.onSurface.withOpacity(.06),
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                      color: active
                          ? cs.primary
                          : cs.onSurface.withOpacity(.12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.download_rounded,
                        size: 14,
                        color: active ? cs.onPrimary : cs.onSurface,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          d.btnLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: active ? cs.onPrimary : cs.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Stats ────────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final ColorScheme cs;
  const _StatsRow({required this.cs});

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('5', 'Platforms'),
      ('98%', 'Uptime'),
      ('2K+', 'Agents'),
      ('0', 'Vendor lock-in'),
    ];
    return Row(
      children: stats
          .map(
            (s) => Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: cs.surface.withOpacity(.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.onSurface.withOpacity(.08)),
                ),
                child: Column(
                  children: [
                    Text(
                      s.$1,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      s.$2,
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withOpacity(.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

// ─── Install guides ───────────────────────────────────────────────────────────
class _InstallGuides extends StatelessWidget {
  final ColorScheme cs;
  final void Function(String) onCopy;
  const _InstallGuides({required this.cs, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth > 700 ? 2 : 1;
        final steps = _steps(cs, onCopy);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: cols == 2 ? 1.55 : 2.4,
          ),
          itemCount: steps.length,
          itemBuilder: (_, i) => steps[i],
        );
      },
    );
  }

  List<Widget> _steps(ColorScheme cs, void Function(String) onCopy) => [
    _StepCard(
      num: '1',
      title: 'macOS install',
      os: 'Apple Silicon & Intel',
      cs: cs,
      body:
          'Open the downloaded .dmg, drag Insured to Applications. On first open, right-click → Open if macOS shows a security prompt.',
    ),
    _StepCard(
      num: '2',
      title: 'Windows install',
      os: 'Windows 10 / 11 x64',
      cs: cs,
      body:
          'Run the .exe installer as Administrator. Follow the setup wizard — Insured installs to Program Files and adds a desktop shortcut.',
    ),
    _StepCard(
      num: '3',
      title: 'Ubuntu / Mint install',
      os: 'Debian-based · AMD64',
      cs: cs,
      body: 'Install via terminal:',
      commands: [
        'sudo dpkg -i Insured-2.4.1-amd64.deb',
        'chmod +x Insured.AppImage && ./Insured.AppImage',
      ],
      onCopy: onCopy,
    ),
    _StepCard(
      num: '4',
      title: 'Android sideload',
      os: 'If not using Play Store',
      cs: cs,
      body:
          'Enable "Install unknown apps" in Settings → Security. Download the APK and tap it to install. Play Store install needs no extra steps.',
    ),
    _StepCard(
      num: '5',
      title: 'iOS / iPadOS',
      os: 'App Store or TestFlight',
      cs: cs,
      body:
          'Open the App Store on your iPhone or iPad, search Insured, and tap Get. Sign in with your agent credentials — no configuration needed.',
    ),
    _StepCard(
      num: '6',
      title: 'First login',
      os: 'All platforms',
      cs: cs,
      body:
          'Open Insured and enter your agent email and password. The app syncs your portfolio automatically and works fully offline.',
    ),
  ];
}

class _StepCard extends StatelessWidget {
  final String num, title, os, body;
  final ColorScheme cs;
  final List<String>? commands;
  final void Function(String)? onCopy;

  const _StepCard({
    required this.num,
    required this.title,
    required this.os,
    required this.body,
    required this.cs,
    this.commands,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cs.surface.withOpacity(.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.onSurface.withOpacity(.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: cs.primary.withOpacity(.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: cs.primary),
                ),
                child: Center(
                  child: Text(
                    num,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      os,
                      style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurface.withOpacity(.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: TextStyle(
              fontSize: 13,
              color: cs.onSurface.withOpacity(.6),
              height: 1.6,
            ),
          ),
          if (commands != null) ...[
            const SizedBox(height: 8),
            ...commands!.map(
              (cmd) => _CodeBlock(cmd: cmd, cs: cs, onCopy: onCopy),
            ),
          ],
        ],
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String cmd;
  final ColorScheme cs;
  final void Function(String)? onCopy;
  const _CodeBlock({required this.cmd, required this.cs, this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: cs.onSurface.withOpacity(.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.onSurface.withOpacity(.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              cmd,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: cs.primary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: cmd));
              onCopy?.call('Copied to clipboard!');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: cs.surface.withOpacity(.5),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: cs.onSurface.withOpacity(.1)),
              ),
              child: Text(
                'copy',
                style: TextStyle(
                  fontSize: 10,
                  color: cs.onSurface.withOpacity(.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Compat bar ───────────────────────────────────────────────────────────────
class _CompatBar extends StatelessWidget {
  final ColorScheme cs;
  const _CompatBar({required this.cs});

  @override
  Widget build(BuildContext context) {
    final items = [
      'macOS 12+',
      'Windows 10/11 (64-bit)',
      'Ubuntu 20.04+ / Mint 20+',
      'Android 8.0+',
      'iOS 15+',
      '4 GB RAM minimum',
      '200 MB disk space',
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: cs.surface.withOpacity(.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.onSurface.withOpacity(.08)),
      ),
      child: Wrap(
        spacing: 24,
        runSpacing: 12,
        children: items
            .map(
              (item) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item,
                    style: TextStyle(
                      fontSize: 13,
                      color: cs.onSurface.withOpacity(.6),
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final ColorScheme cs;
  const _Footer({required this.cs});

  @override
  Widget build(BuildContext context) {
    final links = [
      'Privacy Policy',
      'Terms of Use',
      'Support',
      'Release Notes',
      // 'GitHub',
    ];
    return Column(
      children: [
        Divider(color: cs.onSurface.withOpacity(.08)),
        const SizedBox(height: 20),
        Wrap(
          spacing: 24,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: links
              .map(
                (l) => GestureDetector(
                  onTap: () {},
                  child: Text(
                    l,
                    style: TextStyle(
                      fontSize: 13,
                      color: cs.onSurface.withOpacity(.45),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 14),
        Text(
          '© 2026 InsCloud ',
          style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(.3)),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(.35),
      ),
    );
  }
}

class _Toast extends StatefulWidget {
  final String message;
  const _Toast({required this.message});
  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    _slide = Tween<double>(
      begin: 60,
      end: 0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Positioned(
      bottom: 28,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _slide,
        builder: (_, child) =>
            Transform.translate(offset: Offset(0, _slide.value), child: child),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              widget.message,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: cs.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
