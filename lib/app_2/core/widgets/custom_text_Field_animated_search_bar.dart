import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onSearchChanged;
  final Duration debounceDuration;
  final String hint;

  // filter dialog content  Return a widget in  AlertDialog.
  final WidgetBuilder? filterDialogBuilder;
  final String filterDialogTitle;
  final VoidCallback? onToggle;

  const AnimatedSearchBar({
    super.key,
    required this.controller,
    this.onSearchChanged,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.hint = 'Search...',
    this.filterDialogBuilder,
    this.filterDialogTitle = 'Filters',
    this.onToggle,
  });

  @override
  State<AnimatedSearchBar> createState() => AnimatedSearchBarState();
}

class AnimatedSearchBarState extends State<AnimatedSearchBar>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  bool _isEmpty = true;
  Timer? _debounce;
  bool get isExpanded => _expanded;

  late final AnimationController _ctrl;
  late final Animation<double> _widthFactor;
  late final Animation<double> _fadeAnim;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _widthFactor = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _fadeAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    );

    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final empty = widget.controller.text.isEmpty;
    if (empty != _isEmpty) setState(() => _isEmpty = empty);

    if (widget.onSearchChanged != null) {
      _debounce?.cancel();
      _debounce = Timer(widget.debounceDuration, () {
        if (mounted) widget.onSearchChanged!(widget.controller.text);
      });
    }
  }

  void expand() {
    if (_expanded) return;
    setState(() => _expanded = true);
    _ctrl.forward();
    widget.onToggle?.call();
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  void collapse() {
    _focusNode.unfocus();
    widget.controller.clear();
    widget.onSearchChanged?.call('');
    _ctrl.reverse().then((_) {
      // if (mounted) setState(() => _expanded = false);
      if (mounted) {
        setState(() => _expanded = false);
        widget.onToggle?.call();
      }
    });
  }

  void _showFilter() {
    if (widget.filterDialogBuilder == null) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.filterDialogTitle),
        content: widget.filterDialogBuilder!(ctx),
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _debounce?.cancel();
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final surface = theme.colorScheme.surface;

    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            // collapsed = just the icon button
            // expanded = full bar
            final expandedWidth = constraints.maxWidth;
            final collapsedWidth = 40.0;
            final currentWidth =
                collapsedWidth +
                (expandedWidth - collapsedWidth) * _widthFactor.value;

            return SizedBox(
              height: 44,
              width: currentWidth,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(22),
                color: theme.brightness == Brightness.dark
                    ? surface.withOpacity(0.25)
                    : surface.withOpacity(0.85),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: _expanded ? null : expand,
                  child: Padding(
                    // padding: const EdgeInsets.symmetric(horizontal: 4),
                    // child: Row(
                    //   mainAxisAlignment: _expanded
                    //       ? MainAxisAlignment.start
                    //       : MainAxisAlignment.center,
                    //   children: [
                    //     IconButton(
                    //       icon: Icon(
                    //         Icons.search,
                    //         color: onSurface.withOpacity(0.7),
                    //         size: 20,
                    //       ),
                    //       onPressed: _expanded ? null : expand,
                    //       splashRadius: 18,
                    //       padding: EdgeInsets.zero,
                    //       constraints: const BoxConstraints(
                    //         minWidth: 32,
                    //         minHeight: 32,
                    //       ),
                    //     ),
                    padding: EdgeInsets.symmetric(
                      horizontal: _expanded ? 4 : 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.search,
                            color: onSurface.withOpacity(0.7),
                            size: 20,
                          ),
                          onPressed: _expanded ? null : expand,
                          splashRadius: 18,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 40,
                            minHeight: 44,
                          ),
                        ),
                        if (_expanded)
                          Expanded(
                            child: FadeTransition(
                              opacity: _fadeAnim,
                              child: TextField(
                                focusNode: _focusNode,
                                controller: widget.controller,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: onSurface,
                                ),
                                decoration: InputDecoration(
                                  hintText: widget.hint,
                                  hintStyle: theme.textTheme.bodySmall
                                      ?.copyWith(
                                        color: onSurface.withOpacity(0.5),
                                      ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onSubmitted: (v) =>
                                    widget.onSearchChanged?.call(v),
                              ),
                            ),
                          ),

                        // ── Trailing: clear OR filter OR close ──
                        if (_expanded) ...[
                          if (!_isEmpty)
                            FadeTransition(
                              opacity: _fadeAnim,
                              child: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: onSurface.withOpacity(0.6),
                                  size: 18,
                                ),
                                onPressed: () {
                                  widget.controller.clear();
                                  widget.onSearchChanged?.call('');
                                  _focusNode.requestFocus();
                                },
                                splashRadius: 16,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                              ),
                            ),
                          if (widget.filterDialogBuilder != null)
                            FadeTransition(
                              opacity: _fadeAnim,
                              child: IconButton(
                                icon: Icon(
                                  Icons.filter_list,
                                  color: onSurface.withOpacity(0.7),
                                  size: 20,
                                ),
                                onPressed: _showFilter,
                                splashRadius: 16,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 28,
                                  minHeight: 28,
                                ),
                              ),
                            ),
                          FadeTransition(
                            opacity: _fadeAnim,
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: onSurface.withOpacity(0.5),
                                size: 18,
                              ),
                              onPressed: collapse,
                              splashRadius: 16,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 28,
                                minHeight: 28,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
