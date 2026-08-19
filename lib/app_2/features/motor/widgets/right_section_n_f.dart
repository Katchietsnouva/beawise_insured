import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_checkbox.dart';
import 'package:insured/app_2/core/widgets/custom_dropdown.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/features/motor/quoter_benefit_providers.dart';
import 'package:insured/app_2/features/motor/widgets/motor_selection_flow.dart';

class MotorFormRightSection extends ConsumerStatefulWidget {
  final String? selectedClass;
  final ValueChanged<String> onClassChanged;
  final String? selectedScope;
  final ValueChanged<String?> onScopeChanged;
  final String? selectedCoverPeriod;
  final ValueChanged<String?> onCoverPeriodChanged;
  final TextEditingController valueController;
  final TextEditingController yearController;
  final String? selectedCoverage;
  final ValueChanged<String?> onCoverageChanged;

  // final bool excessProtectorSelected;
  // final ValueChanged<bool?> onExcessProtectorChanged;
  // final bool politicalViolenceSelected;
  // final ValueChanged<bool?> onPoliticalViolenceChanged;

  final TextEditingController seatsController;
  final TextEditingController tonnageController;

  final String? psvTypeSelected;
  final ValueChanged<String?> onPsvTypeChanged;

  final String? matatuDaysSelected;
  final ValueChanged<String?> onMatatuDaysChanged;

  const MotorFormRightSection({
    super.key,
    required this.selectedClass,
    required this.onClassChanged,
    required this.selectedScope,
    required this.onScopeChanged,
    required this.selectedCoverPeriod,
    required this.onCoverPeriodChanged,
    required this.valueController,
    required this.yearController,
    required this.selectedCoverage,
    required this.onCoverageChanged,

    // required this.excessProtectorSelected,
    // required this.onExcessProtectorChanged,
    // required this.politicalViolenceSelected,
    // required this.onPoliticalViolenceChanged,
    required this.seatsController,
    required this.tonnageController,

    required this.psvTypeSelected,
    required this.onPsvTypeChanged,

    required this.matatuDaysSelected,
    required this.onMatatuDaysChanged,
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
  }

  // final bool _excessProtector = false;
  // final bool _politicalViolence = false;

  @override
  void dispose() {
    // widget.valueController.removeListener(_saveVehicleValue);
    super.dispose();
  }

  void _clearConditionalFields() {
    widget.seatsController.clear();
    widget.tonnageController.clear();
    _cache.put('motor_seats', '');
    _cache.put('motor_tonnage', '');
  }

  void _restoreFromCache() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.selectedCoverage == null) {
        final value = _cache.get('motor_coverage') as String?;
        if (value != null && value.isNotEmpty) widget.onCoverageChanged(value);
      }
      if (widget.selectedScope == null) {
        final value = _cache.get('motor_scope') as String?;
        if (value != null && value.isNotEmpty) widget.onScopeChanged(value);
      }
      if (widget.selectedCoverPeriod == null) {
        final value = _cache.get('motor_cover_period') as String?;
        if (value != null && value.isNotEmpty) {
          widget.onCoverPeriodChanged(value);
        }
      }
      if (widget.psvTypeSelected == null) {
        final value = _cache.get('motor_psv_type') as String?;
        if (value != null && value.isNotEmpty) widget.onPsvTypeChanged(value);
      }
      if (widget.matatuDaysSelected == null) {
        final value = _cache.get('motor_matatu_days') as String?;
        if (value != null && value.isNotEmpty) {
          widget.onMatatuDaysChanged(value);
        }
      }
    });
  }

  List<MotorSelectionOption> _coverageOptions(bool isMotor, bool isTuktuk) {
    if (isMotor) {
      return const [
        MotorSelectionOption(
          value: 'Private',
          title: 'Private vehicle',
          description: 'Personal use',
          group: 'Private',
          icon: Icons.directions_car,
        ),
        MotorSelectionOption(
          value: 'Commercial Own Goods',
          title: 'Own goods',
          description: 'Commercial vehicle',
          group: 'Commercial',
          icon: Icons.local_shipping,
        ),
        MotorSelectionOption(
          value: 'Commercial General Cartage',
          title: 'General cartage',
          description: 'Commercial vehicle',
          group: 'Commercial',
          icon: Icons.fire_truck,
        ),
        MotorSelectionOption(
          value: 'Commercial Institutional Vehicles',
          title: 'Institutional',
          description: 'Vehicles for institutions',
          group: 'Commercial',
          icon: Icons.business,
        ),
        MotorSelectionOption(
          value: 'Commercial Primemover',
          title: 'Prime mover',
          description: 'Heavy commercial use',
          group: 'Commercial',
          icon: Icons.agriculture,
        ),
        MotorSelectionOption(
          value: 'PSV chauffeur driven',
          title: 'PSV',
          description: 'Passenger service vehicle',
          group: 'PSV',
          icon: Icons.local_taxi,
        ),
      ];
    }
    return isTuktuk
        ? const [
            MotorSelectionOption(
              value: 'Commercial',
              title: 'Commercial',
              description: 'Business use',
              group: 'Commercial',
              icon: Icons.local_shipping,
            ),
            MotorSelectionOption(
              value: 'PSV',
              title: 'PSV',
              description: 'Passenger service vehicle',
              group: 'PSV',
              icon: Icons.directions_bus,
            ),
          ]
        : const [
            MotorSelectionOption(
              value: 'Private',
              title: 'Private vehicle',
              description: 'Personal use',
              group: 'Private',
              icon: Icons.two_wheeler,
            ),
            MotorSelectionOption(
              value: 'PSV',
              title: 'PSV',
              description: 'Passenger service vehicle',
              group: 'PSV',
              icon: Icons.directions_bus,
            ),
          ];
  }

  @override
  Widget build(BuildContext context) {
    // final List<String> yearsList = List.generate(
    //   (2026 - 2006) + 1,
    //   (index) => (2026 - index).toString(),
    // );
    final int currentYear = DateTime.now().year;
    final List<String> yearsList = List.generate(
      21,
      (index) => (currentYear - index).toString(),
    );
    // print(yearsList);

    // final bool isCommercial = widget.selectedCoverage == 'Commercial';
    final bool isCommercial =
        widget.selectedCoverage?.toLowerCase().contains('commercial') ?? false;
    final bool isCommercialInst =
        widget.selectedCoverage?.toLowerCase().contains('institutional') ??
        false;

    final bool isPSV =
        widget.selectedCoverage?.toUpperCase().contains('PSV') ?? false;
    final bool isMotor = widget.selectedClass?.toLowerCase() == 'motor';
    final bool isTuktuk = widget.selectedClass?.toLowerCase() == 'tuktuk';
    final bool isMotorcycle =
        widget.selectedClass?.toLowerCase() == 'motorcycle';

    final bool isComprehensive =
        widget.selectedScope?.toLowerCase() == 'comprehensive';

    final bool isPrivate = widget.selectedCoverage?.toLowerCase() == 'private';

    final bool isPsvUberExact =
        widget.selectedCoverage == 'PSV chauffeur driven';

    // final bool isMatatu = isPSV && widget.psvTypeSelected == 'Matatu';

    // ✅ Detect ANY commercial under motor
    final bool isAnyCommercialMotor =
        isMotor &&
        (widget.selectedCoverage?.toLowerCase().contains('commercial') ??
            false);

    final bool removeTor =
        isTuktuk ||
        (isMotor && isPrivate && isComprehensive) ||
        (isMotor && isPsvUberExact && isComprehensive) ||
        // isMotorcyclePsv ||
        // isMotorcyclePrivateComprehensive ||
        (isMotorcycle &&
            isPrivate) || // motorcycle private (any scope) → annual only
        (isMotorcycle &&
            isPSV &&
            isComprehensive) || // motorcycle PSV comprehensive → annual only
        // isMotorcyclePsv is removed — motorcycle PSV + TPO now gets TOR
        isAnyCommercialMotor;

    final List<MotorSelectionOption> coverPeriodItems =
        // (isPSV || isTuktuk)
        // (isTuktuk || /(isPSV && !isPsvUber && !isMotorcycle) || isPrimeMover || isCommercialInst)
        removeTor
        ? [
            const MotorSelectionOption(
              value: 'annual',
              title: 'Annual',
              icon: Icons.calendar_month,
            ),
          ]
        // : ['annual', 'tor'];
        : [
            const MotorSelectionOption(
              value: 'annual',
              title: 'Annual',
              icon: Icons.calendar_month,
            ),
            const MotorSelectionOption(
              value: 'tor',
              title: 'TOR (Time on risk)',
              description: 'Time on risk cover',
              icon: Icons.timelapse,
            ),
          ];

    Widget vehValue = CustomTextField(
      hint: 'Vehicle Value',
      hintLabel: 'e.g., 800000',
      cache: _cache,
      cacheKey: 'motor_vehicle_value',
      // icon: Icons.attach_money,
      icon: Icons.payments,
      controller: widget.valueController,
      keyboardType: TextInputType.number,
      isRequired: true,
      isNumber: true,
      toNumberCommaFormat: true,
      allowDecimal: true,
    );

    Widget vehYrOfMan = CustomDropdown<String>(
      hint: 'Year of Manufacture',
      hintLabel: 'Select Year of Manufacture',
      icon: Icons.calendar_today,
      cache: _cache,
      cacheKey: 'motor_year',
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
        }
      },
      isRequired: true,
    );

    Widget seatsField = CustomTextField(
      hint: 'Number of Passengers',
      hintLabel: 'e.g., 14',
      icon: Icons.airline_seat_recline_normal,
      controller: widget.seatsController,
      cache: _cache,
      cacheKey: 'motor_seats',
      keyboardType: TextInputType.number,
      isRequired: true,
      isNumber: true,
      toNumberCommaFormat: true,
    );

    Widget tonnageField = CustomTextField(
      hint: 'Tonnage',
      hintLabel: 'Select Tonnage e.g., 3.5',
      icon: Icons.local_shipping,
      controller: widget.tonnageController,
      cache: _cache,
      cacheKey: 'motor_tonnage',
      keyboardType: TextInputType.number,
      isRequired: true,
      isNumber: true,
      allowDecimal: true,
      toNumberCommaFormat: true,
    );

    Widget excessProtector = CustomCheckbox(
      // value: _excessProtector
      // value: widget.excessProtectorSelected,
      value: ref.watch(excessProtectorProvider),
      label: 'Excess Protector',
      cacheKey: 'motor_excess_protector',
      cache: _cache,
      onChanged: (val) {
        // widget.onExcessProtectorChanged(val);
        ref.read(excessProtectorProvider.notifier).state = val;
      },
    );

    Widget politicalViolence = CustomCheckbox(
      // value: _politicalViolence,
      // value: widget.politicalViolenceSelected,
      value: ref.watch(politicalViolenceProvider),
      label: 'Political Violence and Terrorism',
      cacheKey: 'motor_political_violence',
      cache: _cache,
      onChanged: (val) {
        // widget.onPoliticalViolenceChanged(val);
        ref.read(politicalViolenceProvider.notifier).state = val;
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MotorSelectionFlow(
          selectedClass: widget.selectedClass,
          onClassChanged: widget.onClassChanged,
          selectedCoverage: widget.selectedCoverage,
          coverageOptions: _coverageOptions(isMotor, isTuktuk),
          onCoverageChanged: (val) {
            if (val != null) _cache.put('motor_coverage', val);
            _clearConditionalFields();
            if (val?.toUpperCase() != 'PSV') {
              widget.onPsvTypeChanged(null);
              widget.onMatatuDaysChanged(null);
              _cache.put('motor_psv_type', '');
              _cache.put('motor_matatu_days', '');
            }
            if (val == 'Private') {
              widget.tonnageController.clear();
              _cache.put('motor_tonnage', '');
              widget.valueController.clear();
              _cache.put('motor_vehicle_value', '');
            }
            widget.onCoverageChanged(val);
          },
          selectedScope: widget.selectedScope,
          onScopeChanged: (val) {
            if (val != null) _cache.put('motor_scope', val);
            if (val == 'TPO') {
              widget.valueController.clear();
              widget.yearController.clear();
              _cache.put('motor_vehicle_value', '');
              _cache.put('motor_year', '');
              _cache.put('motor_excess_protector', 'false');
              _cache.put('motor_political_violence', 'false');
            }
            widget.onScopeChanged(val);
          },
          selectedCoverPeriod: widget.selectedCoverPeriod,
          onCoverPeriodChanged: (val) {
            if (val != null) _cache.put('motor_cover_period', val);
            widget.onCoverPeriodChanged(val);
          },
          selectedPsvType: widget.psvTypeSelected,
          onPsvTypeChanged: (val) {
            if (val != null) _cache.put('motor_psv_type', val);
            if (widget.psvTypeSelected == 'Matatu' && val != 'Matatu') {
              widget.onMatatuDaysChanged(null);
              _cache.put('motor_matatu_days', '');
            }
            if (val == 'Matatu' && widget.psvTypeSelected != 'Matatu') {
              widget.onCoverPeriodChanged(null);
              _cache.put('motor_cover_period', '');
            }
            widget.onPsvTypeChanged(val);
          },
          selectedMatatuDays: widget.matatuDaysSelected,
          onMatatuDaysChanged: (val) {
            if (val != null) _cache.put('motor_matatu_days', val);
            widget.onMatatuDaysChanged(val);
          },

          // PSV type cards are intentionally disabled to match the original flow.
          // showPsvType: isMotor && isPSV,
          // showMatatuDays: isMatatu,
          showPsvType: false,
          showMatatuDays: false,
          coverPeriodOptions: coverPeriodItems.cast<MotorSelectionOption>(),
        ),

        const SizedBox(height: 16),
        if (isCommercial) ...[
          Responsive.isDesktopOrWider(context)
              ? Row(
                  children: [
                    // if (!isTuktuk) ...[
                    if (isCommercialInst) ...[
                      Expanded(child: seatsField),
                      const SizedBox(width: 12),
                    ],
                    // if (!isCommercialInst) Expanded(child: tonnageField),
                    if (!isCommercialInst && !isTuktuk && !isMotorcycle)
                      Expanded(child: tonnageField),
                  ],
                )
              : Column(
                  children: [
                    // if (!isTuktuk) seatsField,
                    if (isCommercialInst) seatsField,
                    if (isCommercialInst) const SizedBox(height: 12),
                    // if (!isCommercialInst) tonnageField,
                    if (!isCommercialInst && !isTuktuk && !isMotorcycle)
                      tonnageField,
                  ],
                ),
          if (!isTuktuk && !isMotorcycle) const SizedBox(height: 16),
        ],

        if (isPSV) ...[
          seatsField,
          const SizedBox(height: 16),
          // psvTypeDropdown,
          // const SizedBox(height: 16),
        ],

        if (widget.selectedScope == 'Comprehensive') ...[
          const SizedBox(height: 16),
          Responsive.isDesktopOrWider(context)
              ? Row(
                  children: [
                    Expanded(child: vehValue),
                    const SizedBox(width: 12),
                    Expanded(child: vehYrOfMan),
                  ],
                )
              : Column(
                  children: [
                    vehValue,
                    const SizedBox(height: 12),
                    if (!isTuktuk) ...[vehYrOfMan],
                  ],
                ),
          const SizedBox(height: 12),
          if (!isTuktuk && !isMotorcycle) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText('Optional Benefits', type: CustomTextType.paragraph),
                const SizedBox(height: 12),
                !Responsive.isMobile(context)
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
      ],
    );
  }
}
