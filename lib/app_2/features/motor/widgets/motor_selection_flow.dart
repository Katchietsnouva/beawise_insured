import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/utils/responsive.dart';

class MotorSelectionOption {
  final String value;
  final String title;
  final String? description;
  final String? group;
  final IconData icon;

  const MotorSelectionOption({
    required this.value,
    required this.title,
    this.description,
    this.group,
    required this.icon,
  });
}

enum _SelectionLayout { grid, list }

class MotorSelectionFlow extends StatefulWidget {
  final String? selectedClass;
  final ValueChanged<String> onClassChanged;
  final String? selectedCoverage;
  final ValueChanged<String?> onCoverageChanged;
  final List<MotorSelectionOption> coverageOptions;
  final String? selectedScope;
  final ValueChanged<String?> onScopeChanged;
  final String? selectedCoverPeriod;
  final ValueChanged<String?> onCoverPeriodChanged;
  final String? selectedPsvType;
  final ValueChanged<String?> onPsvTypeChanged;
  final String? selectedMatatuDays;
  final ValueChanged<String?> onMatatuDaysChanged;
  final bool showPsvType;
  final bool showMatatuDays;
  final List<MotorSelectionOption> coverPeriodOptions;
  final bool Function(int step, String value)? shouldAdvance;
  final String? coverageGroup;
  final VoidCallback? onCoverageGroupBack;

  const MotorSelectionFlow({
    super.key,
    required this.selectedClass,
    required this.onClassChanged,
    required this.selectedCoverage,
    required this.onCoverageChanged,
    required this.coverageOptions,
    required this.selectedScope,
    required this.onScopeChanged,
    required this.selectedCoverPeriod,
    required this.onCoverPeriodChanged,
    required this.selectedPsvType,
    required this.onPsvTypeChanged,
    required this.selectedMatatuDays,
    required this.onMatatuDaysChanged,
    required this.showPsvType,
    required this.showMatatuDays,
    required this.coverPeriodOptions,
    this.shouldAdvance,
    this.coverageGroup,
    this.onCoverageGroupBack,
  });

  @override
  State<MotorSelectionFlow> createState() => _MotorSelectionFlowState();
}

class _MotorSelectionFlowState extends State<MotorSelectionFlow> {
  late int _activeStep = widget.selectedClass == null ? 0 : 1;
  _SelectionLayout _layout = _SelectionLayout.grid;
  bool _layoutInitialized = false;
  int get _offset => widget.selectedClass == null ? 0 : 1;
  int _logicalStep(int step) => step - _offset;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_layoutInitialized) {
      _layout = Responsive.isMobile(context)
          ? _SelectionLayout.list
          : _SelectionLayout.grid;
      _layoutInitialized = true;
    }
  }

  @override
  void didUpdateWidget(covariant MotorSelectionFlow oldWidget) {
    super.didUpdateWidget(oldWidget);
    final maxStep = _lastStep;
    if (_activeStep > maxStep) _activeStep = maxStep;
    if (oldWidget.selectedClass == null && widget.selectedClass != null) {
      _activeStep = 1;
    }
  }

  int get _lastStep => (widget.showPsvType ? 3 : 2) + _offset;

  bool _isComplete(int step) {
    if (step == 0 && widget.selectedClass == null) return false;
    if (step == 0) return widget.selectedClass != null;
    step = _logicalStep(step);
    switch (step) {
      case 0:
        return widget.selectedCoverage != null;
      case 1:
        return widget.selectedScope != null;
      case 2:
        return widget.showPsvType
            ? widget.selectedPsvType != null
            : widget.showMatatuDays
            ? widget.selectedMatatuDays != null
            : widget.selectedCoverPeriod != null;
      case 3:
        return widget.showPsvType &&
            (widget.showMatatuDays
                ? widget.selectedMatatuDays != null
                : widget.selectedCoverPeriod != null);
      default:
        return false;
    }
  }

  String _valueForStep(int step) {
    if (step == 0) return widget.selectedClass ?? '';
    step = _logicalStep(step);
    switch (step) {
      case 0:
        return widget.selectedCoverage ?? '';
      case 1:
        return widget.selectedScope ?? '';
      case 2:
        return widget.showPsvType
            ? widget.selectedPsvType ?? ''
            : widget.showMatatuDays
            ? _matatuLabel(widget.selectedMatatuDays)
            : _periodLabel(widget.selectedCoverPeriod);
      case 3:
        return widget.showMatatuDays
            ? _matatuLabel(widget.selectedMatatuDays)
            : _periodLabel(widget.selectedCoverPeriod);
      default:
        return '';
    }
  }

  String _matatuLabel(String? value) => value == null
      ? ''
      : value == 'annual'
      ? 'Annual'
      : '$value days';

  String _periodLabel(String? value) => value == 'tor'
      ? 'TOR (Time on risk)'
      : value == 'annual'
      ? 'Annual'
      : value ?? '';

  List<MotorSelectionOption> get _scopeOptions => const [
    MotorSelectionOption(
      value: 'TPO',
      title: 'Third Party Only',
      description: 'Essential legal cover for other road users.',
      icon: Icons.shield_outlined,
    ),
    MotorSelectionOption(
      value: 'Comprehensive',
      title: 'Comprehensive',
      description: 'Protect your vehicle and other road users.',
      icon: Icons.verified_user_outlined,
    ),
  ];

  List<MotorSelectionOption> get _psvOptions => const [
    MotorSelectionOption(value: 'Taxi', title: 'Taxi', icon: Icons.local_taxi),
    MotorSelectionOption(
      value: 'Uber',
      title: 'Uber',
      icon: Icons.electric_car,
    ),
    MotorSelectionOption(
      value: 'Private Hire',
      title: 'Private Hire',
      icon: Icons.directions_car_filled,
    ),
    MotorSelectionOption(
      value: 'Chauffeur Driven',
      title: 'Chauffeur Driven',
      icon: Icons.airline_seat_recline_extra,
    ),
    MotorSelectionOption(
      value: 'Matatu',
      title: 'Matatu',
      icon: Icons.directions_bus,
    ),
  ];

  List<MotorSelectionOption> get _matatuOptions => const [
    MotorSelectionOption(value: '7', title: '7 days', icon: Icons.today),
    MotorSelectionOption(value: '14', title: '14 days', icon: Icons.date_range),
    MotorSelectionOption(value: '30', title: '30 days', icon: Icons.event),
    MotorSelectionOption(
      value: 'annual',
      title: 'Annual',
      icon: Icons.calendar_month,
    ),
  ];

  List<MotorSelectionOption> get _classOptions => const [
    MotorSelectionOption(
      value: 'Motor',
      title: 'Motor',
      description: 'Cars and commercial vehicles',
      icon: Icons.directions_car,
    ),
    MotorSelectionOption(
      value: 'Tuktuk',
      title: 'Tuktuk',
      description: 'Three-wheel vehicle',
      icon: Icons.electric_rickshaw,
    ),
    MotorSelectionOption(
      value: 'Motorcycle',
      title: 'Motorcycle',
      description: 'Two-wheel vehicle',
      icon: Icons.two_wheeler,
    ),
  ];

  void _select(int step, String value) {
    if (step == 0) {
      widget.onClassChanged(value);
      setState(() => _activeStep = 1);
      return;
    }
    step = _logicalStep(step);
    switch (step) {
      case 0:
        widget.onCoverageChanged(value);
        break;
      case 1:
        widget.onScopeChanged(value);
        break;
      case 2:
        if (widget.showPsvType) {
          widget.onPsvTypeChanged(value);
        } else if (widget.showMatatuDays) {
          widget.onMatatuDaysChanged(value);
        } else {
          widget.onCoverPeriodChanged(value);
        }
        break;
      case 3:
        if (widget.showMatatuDays) {
          widget.onMatatuDaysChanged(value);
        } else {
          widget.onCoverPeriodChanged(value);
        }
        break;
    }
    if (widget.shouldAdvance != null && !widget.shouldAdvance!(step, value)) {
      return;
    }
    setState(() => _activeStep = (_activeStep + 1).clamp(0, _lastStep));
  }

  List<MotorSelectionOption> _optionsForStep(int step) {
    if (step == 0) return _classOptions;
    step = _logicalStep(step);
    switch (step) {
      case 0:
        return widget.coverageOptions;
      case 1:
        return _scopeOptions;
      case 2:
        return widget.showPsvType
            ? _psvOptions
            : widget.showMatatuDays
            ? _matatuOptions
            : widget.coverPeriodOptions;
      case 3:
        return widget.showMatatuDays
            ? _matatuOptions
            : widget.coverPeriodOptions;
      default:
        return const [];
    }
  }

  String _titleForStep(int step) {
    if (step == 0) return 'What are you insuring?';
    step = _logicalStep(step);
    switch (step) {
      case 0:
        return 'What are you covering?';
      case 1:
        return 'Choose your protection';
      case 2:
        return widget.showPsvType
            ? 'What type of PSV is it?'
            : widget.showMatatuDays
            ? 'How long do you need cover?'
            : 'Choose the cover period';
      case 3:
        return widget.showMatatuDays
            ? 'Choose the Matatu period'
            : 'Choose the cover period';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = _optionsForStep(_activeStep);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.favColour : AppColors.favColourDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.route_rounded, color: accent, size: 19),
            const SizedBox(width: 8),
            Text(
              'Quote setup',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const Spacer(),
            Text(
              '${_activeStep + 1} / ${_lastStep + 1}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: accent,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              tooltip: _layout == _SelectionLayout.grid
                  ? 'Use list layout'
                  : 'Use grid layout',
              visualDensity: VisualDensity.compact,
              onPressed: () => setState(() {
                _layout = _layout == _SelectionLayout.grid
                    ? _SelectionLayout.list
                    : _SelectionLayout.grid;
              }),
              icon: Icon(
                _layout == _SelectionLayout.grid
                    ? Icons.view_list_rounded
                    : Icons.grid_view_rounded,
                color: accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildHistory(accent),
        const SizedBox(height: 18),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _buildStep(
            context,
            options,
            accent,
            key: ValueKey(_activeStep),
          ),
        ),
      ],
    );
  }

  Widget _buildHistory(Color accent) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (widget.coverageGroup != null) ...[
            _buildCoverageBreadcrumb(accent),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 17,
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
          ...List.generate(_lastStep + 1, (step) {
            final complete = _isComplete(step);
            final active = step == _activeStep;
            return Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: complete || step <= _activeStep
                      ? () => setState(() => _activeStep = step)
                      : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? accent.withValues(alpha: 0.16)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: active ? accent : Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          complete
                              ? Icons.check_rounded
                              : Icons.circle_outlined,
                          size: 15,
                          color: complete || active
                              ? accent
                              : Theme.of(context).hintColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          complete ? _valueForStep(step) : '${step + 1}',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                if (step < _lastStep)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 17,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCoverageBreadcrumb(Color accent) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: widget.onCoverageGroupBack,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: accent.withValues(alpha: 0.65)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_rounded, size: 15, color: accent),
            const SizedBox(width: 6),
            Text(
              'All cover types',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: accent,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    List<MotorSelectionOption> options,
    Color accent, {
    required Key key,
  }) {
    final selected = _activeStep == 0
        ? widget.selectedClass
        : switch (_logicalStep(_activeStep)) {
            0 => widget.selectedCoverage,
            1 => widget.selectedScope,
            2 =>
              widget.showPsvType
                  ? widget.selectedPsvType
                  : widget.showMatatuDays
                  ? widget.selectedMatatuDays
                  : widget.selectedCoverPeriod,
            3 =>
              widget.showMatatuDays
                  ? widget.selectedMatatuDays
                  : widget.selectedCoverPeriod,
            _ => null,
          };
    final columns = Responsive.isMobile(context)
        ? 2
        : Responsive.isTablet(context)
        ? 3
        : options.length >= 5
        ? 5
        : 4;

    return Container(
      key: key,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _titleForStep(_activeStep),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 5),
          Text(
            'Select one option to continue',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
          ),
          const SizedBox(height: 16),
          _buildOptionSections(options, selected, accent, columns),
        ],
      ),
    );
  }

  Widget _buildOptionSections(
    List<MotorSelectionOption> options,
    String? selected,
    Color accent,
    int columns,
  ) {
    final hasGroups = options.any((option) => option.group != null);
    final groups = <String, List<MotorSelectionOption>>{};
    for (final option in options) {
      groups.putIfAbsent(option.group ?? '', () => []).add(option);
    }

    final sections = hasGroups ? groups.entries : {'': options}.entries;
    return Column(
      children: sections.map((entry) {
        final label = entry.key;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label.isNotEmpty) ...[
              Row(
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Divider(color: accent.withValues(alpha: 0.2)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            _layout == _SelectionLayout.grid
                ? MasonryGridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: columns,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    itemCount: entry.value.length,
                    itemBuilder: (context, index) {
                      final option = entry.value[index];
                      return _SelectionCard(
                        option: option,
                        selected: selected == option.value,
                        accent: accent,
                        onTap: () => _select(_activeStep, option.value),
                        dense: true,
                      );
                    },
                  )
                : Column(
                    children: entry.value
                        .map(
                          (option) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _SelectionCard(
                              option: option,
                              selected: selected == option.value,
                              accent: accent,
                              onTap: () => _select(_activeStep, option.value),
                            ),
                          ),
                        )
                        .toList(),
                  ),
            if (label.isNotEmpty) const SizedBox(height: 14),
          ],
        );
      }).toList(),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final MotorSelectionOption option;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;
  final bool dense;

  const _SelectionCard({
    required this.option,
    required this.selected,
    required this.accent,
    required this.onTap,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: option.title,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.all(dense ? 10 : 13),
          decoration: BoxDecoration(
            color: selected
                ? accent.withValues(alpha: 0.14)
                : Theme.of(context).colorScheme.surface.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? accent : Theme.of(context).dividerColor,
              width: selected ? 1.8 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: dense ? 32 : 38,
                height: dense ? 32 : 38,
                decoration: BoxDecoration(
                  color: selected
                      ? accent.withValues(alpha: 0.2)
                      : Theme.of(context).dividerColor.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  option.icon,
                  size: dense ? 17 : 20,
                  color: selected
                      ? accent
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: dense ? 34 : null,
                      child: Text(
                        option.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (option.description != null) ...[
                      const SizedBox(height: 3),
                      SizedBox(
                        height: dense ? 30 : null,
                        child: Text(
                          option.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Theme.of(context).hintColor),
                        ),
                      ),
                    ] else if (dense)
                      const SizedBox(height: 33),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_circle_rounded, color: accent, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
