import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:insured/app_2/core/utils/icon_scale_helper.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_circular_avatar.dart';
import 'package:insured/app_2/l10n/app_localizations.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

// ─── DESIGN TOKENS ───────────────────────────────────────────────────────────
abstract class _SidebarTokens {
  // Shared brand
  static const blue = Color(0xFF3B6BFF);
  static const purple = Color(0xFF8E5CCB);
  static const indigo = Color(0xFF6C63FF);

  // Gradient used for active pills, indicator, logo accent
  static const brandGradient = LinearGradient(
    colors: [blue, purple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const brandGradientVertical = LinearGradient(
    colors: [blue, purple],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── DARK ──
  static const darkBg = Color(0xFF0A0F1E);
  static const darkSurface = Color(0xFF0F1629); // sidebar panel
  static const darkBorder = Color(0xFF1A2340);
  static const darkTextPri = Colors.white;
  static const darkTextMuted = Color(0xFF6B7FA8);
  static const darkActiveBg = Color(0x2A3B6BFF); // blue @ 17%
  static const darkHoverBg = Color(0x103B6BFF);

  // ── LIGHT ──
  static const lightBg = Color(0xFFF0F2FF); // cool lavender-white
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightBorder = Color(0xFFDDE2F5);
  static const lightTextPri = Color(0xFF0F1629);
  static const lightTextMuted = Color(0xFF7A85A8);
  static const lightActiveBg = Color(0x1A3B6BFF); // blue @ 10%
  static const lightHoverBg = Color(0x0D3B6BFF);
}

// ─── NAV ITEM MODEL ──────────────────────────────────────────────────────────
class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  const _NavItem(this.icon, this.label, this.route);
}

// ─── SIDEBAR WIDGET ──────────────────────────────────────────────────────────
class Sidebar extends ConsumerStatefulWidget {
  const Sidebar({super.key});
  @override
  ConsumerState<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends ConsumerState<Sidebar>
    with SingleTickerProviderStateMixin {
  bool _isCollapsed = false;

  late final AnimationController _ctrl;
  late final Animation<double> _widthAnim;

  static const double _expanded = 256;
  static const double _collapsed = 64;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
    );
    _widthAnim = Tween<double>(
      begin: _expanded,
      end: _collapsed,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isCollapsed = !_isCollapsed);
    _isCollapsed ? _ctrl.forward() : _ctrl.reverse();
  }

  // ── NAV STRUCTURE ─────────────────────────────────────────────────────────
  List<_NavItem> get _mainItems => [
    const _NavItem(Icons.dashboard_rounded, 'Dashboard', '/dashboard'),
    const _NavItem(Icons.people_alt_rounded, 'Clients', '/clients'),
    const _NavItem(Icons.directions_car_rounded, 'Motor Quote', '/motor/quote'),
    const _NavItem(Icons.request_quote_rounded, 'Quotes', '/quotes'),
    const _NavItem(Icons.policy_rounded, 'Production', '/policies'),
    const _NavItem(Icons.autorenew_rounded, 'Renewals', '/renewals'),
    const _NavItem(Icons.verified_rounded, 'Certificates', '/certificates'),
    const _NavItem(Icons.receipt_long_rounded, 'Statement', '/statement'),
    const _NavItem(
      Icons.fact_check_rounded,
      'DMVIC Check',
      '/dmvic-double-insurance',
    ),
  ];

  List<_NavItem> get _accountItems => [
    const _NavItem(Icons.person_rounded, 'Profile', '/profile'),
    const _NavItem(Icons.settings_rounded, 'Settings', '/settings'),
  ];

  // ── BUILD ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final String pathPrefix = (kIsWeb && kDebugMode) ? '' : 'assets';

    final surface = isDark
        ? _SidebarTokens.darkSurface
        : _SidebarTokens.lightSurface;
    final border = isDark
        ? _SidebarTokens.darkBorder
        : _SidebarTokens.lightBorder;

    return AnimatedBuilder(
      animation: _widthAnim,
      builder: (context, _) {
        return Container(
          width: _widthAnim.value,
          decoration: BoxDecoration(
            color: surface,
            border: Border(right: BorderSide(color: border, width: 1)),
            // Subtle gradient overlay on the sidebar background
            gradient: isDark
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFF0F1629), const Color(0xFF0A0F1E)],
                  )
                : LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, const Color(0xFFF4F0FF)],
                  ),
          ),
          child: Column(
            children: [
              _Header(
                isCollapsed: _isCollapsed,
                isDark: isDark,
                pathPrefix: pathPrefix,
                onToggle: _toggle,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_isCollapsed) _SectionLabel('MAIN', isDark: isDark),
                      for (final item in _mainItems)
                        _MenuItem(
                          item: item,
                          isCollapsed: _isCollapsed,
                          isDark: isDark,
                        ),
                      const SizedBox(height: 4),
                      if (!_isCollapsed)
                        _SectionLabel('ACCOUNT', isDark: isDark),
                      for (final item in _accountItems)
                        _MenuItem(
                          item: item,
                          isCollapsed: _isCollapsed,
                          isDark: isDark,
                        ),
                    ],
                  ),
                ),
              ),
              _Footer(
                isCollapsed: _isCollapsed,
                isDark: isDark,
                pathPrefix: pathPrefix,
                user: user,
                onLogout: () {
                  Future.microtask(
                    () => ref.read(authProvider.notifier).logout(),
                  );
                  context.go('/login');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── HEADER ──────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final bool isCollapsed;
  final bool isDark;
  final String pathPrefix;
  final VoidCallback onToggle;

  const _Header({
    required this.isCollapsed,
    required this.isDark,
    required this.pathPrefix,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final border = isDark
        ? _SidebarTokens.darkBorder
        : _SidebarTokens.lightBorder;
    final mutedColor = isDark
        ? _SidebarTokens.darkTextMuted
        : _SidebarTokens.lightTextMuted;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: border, width: 1)),
      ),
      child: isCollapsed
          ? Center(
              child: _GradientIconButton(
                icon: Icons.chevron_right_rounded,
                onTap: onToggle,
                tooltip: 'Expand',
              ),
            )
          : Row(
              children: [
                const SizedBox(width: 4),
                // ── Logo with gradient underline accent ──
                ShaderMask(
                  shaderCallback: (bounds) =>
                      _SidebarTokens.brandGradient.createShader(bounds),
                  blendMode: BlendMode.srcIn,
                  child: Image(
                    image: AssetImage(
                      '$pathPrefix/images/${isDark ? 'Insured' : 'Insured_black'}.png',
                    ),
                    height: 30,
                    fit: BoxFit.contain,
                    // If ShaderMask on image isn't desired, remove the ShaderMask
                    // and use the Image directly
                  ),
                ),
                const Spacer(),
                _GradientIconButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: onToggle,
                  tooltip: 'Collapse',
                ),
              ],
            ),
    );
  }
}

// ─── SECTION LABEL ───────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  final bool isDark;
  const _SectionLabel(this.text, {required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 18, 14, 6),
      child: Text(
        text,
        style: TextStyle(
          color: isDark
              ? _SidebarTokens.darkTextMuted
              : _SidebarTokens.lightTextMuted,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.6,
        ),
      ),
    );
  }
}

// ─── MENU ITEM ───────────────────────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final _NavItem item;
  final bool isCollapsed;
  final bool isDark;

  const _MenuItem({
    required this.item,
    required this.isCollapsed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isActive = location.startsWith(item.route);

    final activeBg = isDark
        ? _SidebarTokens.darkActiveBg
        : _SidebarTokens.lightActiveBg;
    final hoverBg = isDark
        ? _SidebarTokens.darkHoverBg
        : _SidebarTokens.lightHoverBg;
    final textPri = isDark
        ? _SidebarTokens.darkTextPri
        : _SidebarTokens.lightTextPri;
    final textMuted = isDark
        ? _SidebarTokens.darkTextMuted
        : _SidebarTokens.lightTextMuted;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Tooltip(
        message: isCollapsed ? item.label : '',
        preferBelow: false,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => context.go(item.route),
            splashColor: _SidebarTokens.blue.withOpacity(0.12),
            highlightColor: _SidebarTokens.blue.withOpacity(0.06),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? 0 : 10,
                vertical: isCollapsed ? 12 : 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isActive ? activeBg : Colors.transparent,
                border: Border.all(
                  color: isActive
                      ? _SidebarTokens.blue.withOpacity(isDark ? 0.35 : 0.25)
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: isCollapsed
                  ? _CollapsedItem(isActive: isActive)
                  : _ExpandedItem(
                      item: item,
                      isActive: isActive,
                      textPri: textPri,
                      textMuted: textMuted,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _CollapsedItem({required bool isActive}) {
    return Center(
      child: isActive
          ? ShaderMask(
              shaderCallback: (b) =>
                  _SidebarTokens.brandGradient.createShader(b),
              blendMode: BlendMode.srcIn,
              child: Icon(item.icon, size: 22, color: Colors.white),
            )
          : Icon(
              item.icon,
              size: 22,
              color: isDark
                  ? _SidebarTokens.darkTextMuted
                  : _SidebarTokens.lightTextMuted,
            ),
    );
  }

  Widget _ExpandedItem({
    required _NavItem item,
    required bool isActive,
    required Color textPri,
    required Color textMuted,
  }) {
    return Row(
      children: [
        // ── Gradient indicator bar ──────────────────────────────────────
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 3,
          height: isActive ? 20 : 0,
          margin: EdgeInsets.only(right: isActive ? 10 : 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: _SidebarTokens.brandGradientVertical,
            boxShadow: [
              BoxShadow(
                color: _SidebarTokens.blue.withOpacity(0.5),
                blurRadius: 8,
              ),
            ],
          ),
        ),

        // ── Icon: gradient when active, muted when not ─────────────────
        isActive
            ? ShaderMask(
                shaderCallback: (b) =>
                    _SidebarTokens.brandGradient.createShader(b),
                blendMode: BlendMode.srcIn,
                child: Icon(item.icon, size: 20, color: Colors.white),
              )
            : Icon(item.icon, size: 20, color: textMuted),

        const SizedBox(width: 12),

        // ── Label ──────────────────────────────────────────────────────
        Expanded(
          child: Text(
            item.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isActive ? textPri : textMuted,
              fontSize: 13.5,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              letterSpacing: 0.1,
            ),
          ),
        ),

        // ── Active dot ─────────────────────────────────────────────────
        if (isActive)
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(right: 2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [_SidebarTokens.blue, _SidebarTokens.purple],
              ),
            ),
          ),
      ],
    );
  }
}

// ─── FOOTER ──────────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  final bool isCollapsed;
  final bool isDark;
  final String pathPrefix;
  final dynamic user;
  final VoidCallback onLogout;

  const _Footer({
    required this.isCollapsed,
    required this.isDark,
    required this.pathPrefix,
    required this.user,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final border = isDark
        ? _SidebarTokens.darkBorder
        : _SidebarTokens.lightBorder;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: border, width: 1)),
        // Subtle purple glow at bottom of sidebar
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            _SidebarTokens.purple.withOpacity(isDark ? 0.06 : 0.04),
          ],
        ),
      ),
      child: isCollapsed
          ? Column(
              children: [
                if (user != null) CustomCircularAvatar(user: user.name),
                const SizedBox(height: 8),
                _GradientIconButton(
                  icon: Icons.logout_rounded,
                  onTap: onLogout,
                  tooltip: 'Log out',
                ),
              ],
            )
          : Row(
              children: [
                Image(
                  image: AssetImage('$pathPrefix/images/inscloud.png'),
                  width: 80,
                  fit: BoxFit.contain,
                ),
                const Spacer(),
                _GradientIconButton(
                  icon: Icons.logout_rounded,
                  onTap: onLogout,
                  tooltip: 'Log out',
                ),
              ],
            ),
    );
  }
}

// ─── GRADIENT ICON BUTTON ────────────────────────────────────────────────────
class _GradientIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const _GradientIconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  State<_GradientIconButton> createState() => _GradientIconButtonState();
}

class _GradientIconButtonState extends State<_GradientIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: _hovered ? _SidebarTokens.brandGradient : null,
              color: _hovered ? null : Colors.transparent,
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: _hovered
                  ? Colors.white
                  : (Theme.of(context).brightness == Brightness.dark
                        ? _SidebarTokens.darkTextMuted
                        : _SidebarTokens.lightTextMuted),
            ),
          ),
        ),
      ),
    );
  }
}
