import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_checkbox.dart';
import 'package:insured/app_2/core/widgets/custom_dropdown.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/features/motor/quoter_benefit_providers.dart';

class MotorFormRightSection extends ConsumerStatefulWidget {
  final String? selectedClass;
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
    // _restoreFromCache();
  }

  // final bool _excessProtector = false;
  // final bool _politicalViolence = false;

  @override
  void dispose() {
    // widget.valueController.removeListener(_saveVehicleValue);
    super.dispose();
  }

  void _clearConditionalFields() {
    // seatsController.clear();
    // tonnageController.clear();
    _cache.put('motor_seats', '');
    _cache.put('motor_tonnage', '');
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
    final bool isCommercialInst_ =
        widget.selectedCoverage?.trim().toLowerCase() ==
        'commercial institutional vehicles';
    final bool isCommercialInst =
        widget.selectedCoverage?.toLowerCase().contains('institutional') ??
        false;
    final bool isPrimeMover =
        widget.selectedCoverage?.toLowerCase().contains('primemover') ?? false;

    final bool isPSV =
        widget.selectedCoverage?.toUpperCase().contains('PSV') ?? false;
    final bool isPsvUber = widget.selectedCoverage == 'PSV chauffeur driven';
    final bool isMotor = widget.selectedClass?.toLowerCase() == 'motor';
    final bool isTuktuk = widget.selectedClass?.toLowerCase() == 'tuktuk';
    final bool isMotorcycle =
        widget.selectedClass?.toLowerCase() == 'motorcycle';

    final List<String> coverItems = isMotor
        ? [
            'Private',
            // 'Commercial',
            'PSV Uber',
            'Commercial Own Goods',
            'Commercial General Cartage',
            'Commercial Institutional Vehicles',
            'Commercial Primemover',
          ]
        : isTuktuk
        ? ['Commercial', 'PSV']
        : ['Private', 'PSV'];

    final Map<String, List<dynamic>> groupedCoverItems = {};
    if (isMotor) {
      groupedCoverItems['Ungrouped'] = ['Private'];
      groupedCoverItems['Commercial'] = [
        ['Commercial Own Goods', 'Own Goods'], // Value vs Label
        ['Commercial General Cartage', 'General Cartage'],
        ['Commercial Institutional Vehicles', 'Institutional Vehicles'],
        ['Commercial Primemover', 'Primemover'],
      ];
      // groupedCoverItems['Ungrouped_2'] = ['PSV Uber,'];
      // groupedCoverItems['Ungrouped_2'] = ['PSV Uber,'];
      groupedCoverItems['Ungrouped_2'] = [
        ['PSV chauffeur driven', 'PSV Uber'],
      ];
    } else if (isTuktuk) {
      groupedCoverItems['Ungrouped'] = ['Commercial', 'PSV'];
    } else {
      groupedCoverItems['Ungrouped'] = ['Private', 'PSV'];
    }
    // // Build grouped dropdown items
    // List<DropdownMenuItem<String>> buildCoverItems() {
    //   final items = <DropdownMenuItem<String>>[];

    final bool isComprehensive =
        widget.selectedScope?.toLowerCase() == 'comprehensive';

    final bool isPrivate = widget.selectedCoverage?.toLowerCase() == 'private';

    final bool isPsvUberExact =
        widget.selectedCoverage == 'PSV chauffeur driven';

    final bool isMotorcyclePsv = isMotorcycle && isPSV;

    final bool isMotorcyclePrivateComprehensive =
        isMotorcycle && isPrivate && isComprehensive;

    // ✅ Detect ANY commercial under motor
    final bool isAnyCommercialMotor =
        isMotor &&
        (widget.selectedCoverage?.toLowerCase().contains('commercial') ??
            false);

    final bool removeTor =
        isTuktuk ||
        (isMotor && isPrivate && isComprehensive) ||
        (isMotor && isPsvUberExact && isComprehensive) ||
        isMotorcyclePsv ||
        isMotorcyclePrivateComprehensive ||
        isAnyCommercialMotor;

    final List<dynamic> coverPeriodItems =
        // (isPSV || isTuktuk)
        // (isTuktuk || /(isPSV && !isPsvUber && !isMotorcycle) || isPrimeMover || isCommercialInst)
        removeTor
        ? [
            ['annual', 'Annual'],
          ]
        // : ['annual', 'tor'];
        : [
            ['annual', 'Annual'],
            ['tor', 'TOR (Time on risk)'],
          ];
    final List<String> psvTypes = [
      'Taxi',
      'Uber',
      'Private Hire',
      'Chauffeur Driven',
      'Matatu',
    ];
    final bool isMatatu = isPSV && widget.psvTypeSelected == 'Matatu';
    final List<String> matatuDaysDropdownItems = ['7', '14', '30', 'annual'];

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
        ref.read(excessProtectorProvider.notifier).state = val ?? false;
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
        ref.read(politicalViolenceProvider.notifier).state = val ?? false;
      },
    );

    Widget psvTypeDropdown = CustomDropdown<String>(
      hint: 'PSV Type',
      hintLabel: 'Select PSV Type',
      cacheKey: 'motor_psv_type',
      cache: _cache,
      icon: Icons.directions_bus,
      value: psvTypes.contains(widget.psvTypeSelected)
          ? widget.psvTypeSelected
          : null,
      items: psvTypes
          .map((t) => DropdownMenuItem(value: t, child: Text(t)))
          .toList(),
      // onChanged: (val) => widget.onPsvTypeChanged(val),
      onChanged: (val) {
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
      isRequired: true,
    );

    Widget matatuDaysDropdown = CustomDropdown<String>(
      hint: 'Days',
      hintLabel: 'Select Matatu Days',
      cacheKey: 'motor_matatu_days',
      cache: _cache,
      icon: Icons.date_range,
      value: matatuDaysDropdownItems.contains(widget.matatuDaysSelected)
          ? widget.matatuDaysSelected
          : null,
      items: matatuDaysDropdownItems
          .map(
            (d) => DropdownMenuItem(
              value: d,
              child: Text(d == 'annual' ? 'Annual' : '$d days'),
            ),
          )
          .toList(),
      onChanged: (val) => widget.onMatatuDaysChanged(val),
      isRequired: true,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDropdown<String>(
          // hint: 'Coverage',
          hintLabel: 'Select Cover',
          hint: 'Cover',
          cacheKey: 'motor_coverage',
          cache: _cache,
          icon: Icons.shield,

          // // value: widget.selectedCoverage,
          // // value: coverItems.contains(widget.selectedCoverage)
          // value: coverItems.contains(widget.selectedCoverage)
          //     ? widget.selectedCoverage
          //     : null,
          value:
              groupedCoverItems.values
                  .expand((list) => getFlatValuesCustomDropdown(list))
                  .toList()
                  .contains(widget.selectedCoverage)
              ? widget.selectedCoverage
              : null,

          // items:
          //     // const [ 'Private', 'Commercial', 'PSV',]
          //     coverItems
          //         .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          //         .toList(),
          groupedItems: groupedCoverItems,
          onChanged: (val) {
            // _clearConditionalFields();
            _cache.put('motor_seats', '');
            _cache.put('motor_tonnage', '');

            if (val?.toUpperCase() != 'PSV') {
              widget.onPsvTypeChanged(null);
              widget.onMatatuDaysChanged(null);

              _cache.put('motor_psv_type', '');
              _cache.put('motor_matatu_days', '');
            }
            if (val?.toUpperCase() == 'PSV' &&
                widget.selectedCoverPeriod == 'tor') {
              widget.onCoverPeriodChanged(null);
              _cache.put('motor_cover_period', null);
            }

            if (val == 'Private') {
              widget.tonnageController.clear();
              // _cache.put('motor_tonnage', '');
              widget.valueController.clear();
              // _cache.put('motor_vehicle_value', '');
            }
            widget.onCoverageChanged(val);
          },
          isRequired: true,
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

        CustomDropdown<String>(
          hint: 'Scope',
          hintLabel: 'Select Scope',
          cacheKey: 'motor_scope',
          cache: _cache,
          icon: Icons.public,
          value: widget.selectedScope,

          // // items: const [
          // //   'TPO',
          // //   'Comprehensive',
          // // ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          items:
              const [
                    ['TPO', 'TPO (Third Party Only)'],
                    ['Comprehensive', 'Comprehensive'],
                  ]
                  .map(
                    (pair) => DropdownMenuItem<String>(
                      value: pair[0],
                      child: Text(pair[1]),
                    ),
                  )
                  .toList(),

          onChanged: (val) {
            if (val == 'TPO') {
              widget.valueController.clear();
              widget.yearController.clear();

              // widget.onExcessProtectorChanged(false);
              // widget.onPoliticalViolenceChanged(false);

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

        if (!isMatatu) ...[
          CustomDropdown<String>(
            hint: 'Cover Period',
            hintLabel: 'Select Cover Period',
            cacheKey: 'motor_cover_period',
            cache: _cache,
            icon: Icons.timelapse,
            // // value: coverPeriodItems.contains(widget.selectedCoverPeriod)
            // //     ? widget.selectedCoverPeriod
            // //     : null,
            // // // items:
            // // // // const ['annual','tor',]
            // // // coverPeriodItems
            // // //     .map((p) => DropdownMenuItem(value: p, child: Text(p)))
            // // //     .toList(),

            // value:
            //   coverPeriodItems.values
            //       .expand((list) => getFlatValuesCustomDropdown(list))
            //       .toList()
            //       .contains(widget.selectedCoverPeriod)
            //   ? widget.selectedCoverPeriod
            //   : null,
            value:
                getFlatValuesCustomDropdown(
                  coverPeriodItems,
                ).contains(widget.selectedCoverPeriod)
                ? widget.selectedCoverPeriod
                : null,

            groupedItems: {'Ungrouped': coverPeriodItems},
            onChanged: (val) {
              widget.onCoverPeriodChanged(val);
            },
            isRequired: true,
          ),
          // const SizedBox(height: 16),
        ] else ...[
          matatuDaysDropdown,
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
