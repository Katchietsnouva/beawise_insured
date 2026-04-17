import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_card_choice.dart';
import 'package:insured/app_2/core/widgets/custom_checkbox.dart';
import 'package:insured/app_2/core/widgets/custom_dropdown.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/features/motor/widgets/top_card_selection.dart';
import 'package:insured/app_2/providers/motor_provider.dart';

// Import your cache file if it's in a different file
// import 'path_to_your_cache_file.dart';

class MotorFormRightSection extends ConsumerStatefulWidget {
  final String? selectedScope;
  final ValueChanged<String?> onScopeChanged;
  final String? selectedCoverPeriod;
  final ValueChanged<String?> onCoverPeriodChanged;
  final TextEditingController valueController;
  final TextEditingController yearController;
  final String? selectedCoverage;
  final ValueChanged<String?> onCoverageChanged;

  final bool excessProtectorSelected;
  final ValueChanged<bool?> onExcessProtectorChanged;
  final bool politicalViolenceSelected;
  final ValueChanged<bool?> onPoliticalViolenceChanged;

  const MotorFormRightSection({
    super.key,
    required this.selectedScope,
    required this.onScopeChanged,
    required this.selectedCoverPeriod,
    required this.onCoverPeriodChanged,
    required this.valueController,
    required this.yearController,
    required this.selectedCoverage,
    required this.onCoverageChanged,

    required this.excessProtectorSelected,
    required this.onExcessProtectorChanged,
    required this.politicalViolenceSelected,
    required this.onPoliticalViolenceChanged,
  });

  @override
  ConsumerState<MotorFormRightSection> createState() =>
      _MotorFormRightSectionState();
}

class _MotorFormRightSectionState extends ConsumerState<MotorFormRightSection> {
  late final MemoryCacheService _cache;

  @override
  void initState() {
    super.initState();
    _cache = ref.read(motorFormCacheProvider);

    // Auto-restore from cache when the form opens
    _restoreFromCache();

    // Auto-save text fields on every keystroke
    widget.valueController.addListener(_saveVehicleValue);
    widget.yearController.addListener(_saveYear);
  }

  void _restoreFromCache() {
    // Dropdowns (only restore if parent didn't pass a value)
    if (widget.selectedCoverage == null &&
        _cache.containsKey('motor_coverage')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onCoverageChanged(_cache.get('motor_coverage'));
      });
    }
    if (widget.selectedScope == null && _cache.containsKey('motor_scope')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onScopeChanged(_cache.get('motor_scope'));
      });
    }
    if (widget.selectedCoverPeriod == null &&
        _cache.containsKey('motor_cover_period')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onCoverPeriodChanged(_cache.get('motor_cover_period'));
      });
    }

    // Text fields
    if (_cache.containsKey('motor_vehicle_value')) {
      widget.valueController.text = _cache.get('motor_vehicle_value') ?? '';
    }
    if (_cache.containsKey('motor_year')) {
      widget.yearController.text = _cache.get('motor_year') ?? '';
    }

    if (_cache.containsKey('motor_excess_protector')) {
      final val = _cache.get('motor_excess_protector') == 'true';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onExcessProtectorChanged(val);
      });
    }
    if (_cache.containsKey('motor_political_violence')) {
      final val = _cache.get('motor_political_violence') == 'true';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onPoliticalViolenceChanged(val);
      });
    }
  }

  final bool _excessProtector = false;
  final bool _politicalViolence = false;

  void _saveVehicleValue() {
    _cache.put('motor_vehicle_value', widget.valueController.text);
  }

  void _saveYear() {
    _cache.put('motor_year', widget.yearController.text);
  }

  void _saveExcessProtector() {
    _cache.put('motor_excess_protector', _excessProtector.toString());
  }

  void _savePoliticalViolence() {
    _cache.put('motor_political_violence', _politicalViolence.toString());
  }

  @override
  void dispose() {
    widget.valueController.removeListener(_saveVehicleValue);
    widget.yearController.removeListener(_saveYear);
    super.dispose();
  }

  void _clearQuote() {
    // Safe: schedule after current frame finishes building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // ref.read(motorProvider.notifier).clearQuote();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> yearsList = List.generate(
      (2026 - 2011) + 1,
      (index) => (2026 - index).toString(),
    );

    Widget vehValue = CustomTextField(
      hint: 'Vehicle Value',
      hintLabel: 'e.g., 800000',
      icon: Icons.attach_money,
      controller: widget.valueController,
      keyboardType: TextInputType.number,
      isRequired: true,
      isNumber: true,
      toNumberCommaFormat: true,
      allowDecimal: true,
    );

    // Widget vehYrOfMan = CustomTextField(
    //   hint: 'Year of Manufacture',
    //   hintLabel: 'e.g., 2016',
    //   icon: Icons.calendar_today,
    //   controller: widget.yearController,
    //   keyboardType: TextInputType.number,
    //   isRequired: true,
    // );

    Widget vehYrOfMan = CustomDropdown<String>(
      hint: 'Year of Manufacture',
      icon: Icons.calendar_today,
      // Use the controller text as the current value
      value: yearsList.contains(widget.yearController.text)
          ? widget.yearController.text
          : null,
      items: yearsList
          .map((yr) => DropdownMenuItem(value: yr, child: Text(yr)))
          .toList(),
      onChanged: (val) {
        if (val != null) {
          setState(() {
            widget.yearController.text = val;
          });
          _cache.put('motor_year', val);
        }
      },
      isRequired: true,
    );

    Widget excessProtector = CustomCheckbox(
      // value: _excessProtector
      value: widget.excessProtectorSelected,
      label: 'Excess Protector',
      onChanged: (val) {
        // setState(() => _excessProtector = val ?? false);
        // _saveExcessProtector();
        final newVal = val ?? false;
        widget.onExcessProtectorChanged(newVal);
        _cache.put('motor_excess_protector', newVal.toString());
      },
    );

    Widget politicalViolence = CustomCheckbox(
      // value: _politicalViolence,
      value: widget.politicalViolenceSelected,
      label: 'Political Violence and Terrorism',
      onChanged: (val) {
        // setState(() => _politicalViolence = val ?? false);
        // _savePoliticalViolence();
        final newVal = val ?? false;
        widget.onPoliticalViolenceChanged(newVal);
        _cache.put('motor_political_violence', newVal.toString());
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown<String>(
          hint: 'Cover',
          // hint: 'Coverage',
          icon: Icons.shield,
          value: widget.selectedCoverage,
          items: const [
            'Private',
            'Commercial',
          ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (val) {
            _cache.put('motor_coverage', val);
            widget.onCoverageChanged(val);
            _clearQuote();
            print('YOOOO');
          },
          isRequired: true,
        ),
        const SizedBox(height: 16),
        CustomDropdown<String>(
          hint: 'Scope',
          icon: Icons.public,
          value: widget.selectedScope,
          items: const [
            'TPO',
            'Comprehensive',
          ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (val) {
            _cache.put('motor_scope', val);
            print('YOOOO 2');
            _clearQuote();

            if (val == 'TPO') {
              widget.valueController.clear();
              widget.yearController.clear();

              widget.onExcessProtectorChanged(false);
              widget.onPoliticalViolenceChanged(false);

              _cache.put('motor_vehicle_value', '');
              _cache.put('motor_year', '');
              _cache.put('motor_excess_protector', 'false');
              _cache.put('motor_political_violence', 'false');
            }

            widget.onScopeChanged(val);
          },
          isRequired: true,
        ),
        const SizedBox(height: 16),
        CustomDropdown<String>(
          hint: 'Cover Period',
          icon: Icons.timelapse,
          value: widget.selectedCoverPeriod,
          items: const [
            'annual',
            'tor',
          ].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
          onChanged: (val) {
            _cache.put('motor_cover_period', val);
            widget.onCoverPeriodChanged(val);
            _clearQuote();
          },
          isRequired: true,
        ),
        if (widget.selectedScope == 'Comprehensive') ...[
          const SizedBox(height: 16),
          Responsive.isDesktop(context)
              ? Row(
                  children: [
                    Expanded(child: vehValue),
                    const SizedBox(width: 12),
                    Expanded(child: vehYrOfMan),
                  ],
                )
              : Column(
                  children: [vehValue, const SizedBox(height: 12), vehYrOfMan],
                ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              CustomText('Optional Benefits', type: CustomTextType.paragraph),
              const SizedBox(height: 12),
              Responsive.isDesktop(context)
                  ? Row(
                      children: [
                        Expanded(child: excessProtector),
                        const SizedBox(width: 12),
                        Expanded(child: politicalViolence),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        excessProtector,
                        const SizedBox(height: 12),
                        politicalViolence,
                      ],
                    ),
            ],
          ),
        ],
      ],
    );
  }
}
