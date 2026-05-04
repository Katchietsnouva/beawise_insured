import 'package:flutter/material.dart';

class SpeedDialAction {
  final String heroTag;
  final IconData icon;
  final String? tooltip;
  final VoidCallback onPressed;

  const SpeedDialAction({
    required this.heroTag,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });
}

class SpeedDialFAB extends StatefulWidget {
  final List<SpeedDialAction> actions;
  final IconData openIcon;
  final IconData closeIcon;
  final bool isLight;

  /// Optional external control — pass a key to call open/close from outside
  const SpeedDialFAB({
    super.key,
    required this.actions,
    this.openIcon = Icons.menu,
    this.closeIcon = Icons.close,
    required this.isLight,
  });

  @override
  State<SpeedDialFAB> createState() => SpeedDialFABState();
}

class SpeedDialFABState extends State<SpeedDialFAB>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late final AnimationController _ctrl;
  late final Animation<double> _expandAnim;
  late final Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _rotateAnim = Tween<double>(
      begin: 0,
      end: 0.625,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void toggle() {
    setState(() => _open = !_open);
    _open ? _ctrl.forward() : _ctrl.reverse();
  }

  void close() {
    if (_open) toggle();
  }

  void open() {
    if (!_open) toggle();
  }

  Color get _fabBg =>
      Theme.of(context).primaryColor.withOpacity(widget.isLight ? 1 : 0.25);

  Color get _fabFg => Theme.of(context).colorScheme.onSurface;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // ── Action buttons (appear above main FAB) ──
        ...widget.actions
            .asMap()
            .entries
            .map((entry) {
              final i = entry.key;
              final action = entry.value;

              // Stagger each button slightly
              final staggered = Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: _expandAnim,
                  curve: Interval(
                    i / widget.actions.length,
                    1.0,
                    curve: Curves.easeOut,
                  ),
                ),
              );

              return AnimatedBuilder(
                animation: staggered,
                builder: (ctx, _) {
                  return Opacity(
                    opacity: staggered.value.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - staggered.value)),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FloatingActionButton(
                          heroTag: action.heroTag,
                          onPressed: action.onPressed,
                          elevation: widget.isLight ? 16 : 20,
                          backgroundColor: _fabBg,
                          tooltip: action.tooltip,
                          child: Icon(action.icon, size: 28, color: _fabFg),
                        ),
                      ),
                    ),
                  );
                },
              );
            })
            .toList()
            .reversed
            .toList(), // reverse so first action is closest to main FAB
        // ── Main toggle FAB ──
        FloatingActionButton(
          heroTag: "speed_dial_main",
          onPressed: toggle,
          elevation: widget.isLight ? 16 : 20,
          backgroundColor: _fabBg,
          child: RotationTransition(
            turns: _rotateAnim,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                _open ? widget.closeIcon : widget.openIcon,
                key: ValueKey(_open),
                size: 32,
                color: _fabFg,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
