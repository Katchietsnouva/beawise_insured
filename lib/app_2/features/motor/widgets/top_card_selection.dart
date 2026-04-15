import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/custom_card_choice.dart';

class VehicleClassSelector extends StatelessWidget {
  final String? selectedKey;
  final ValueChanged<String> onSelect;
  final int columns;

  const VehicleClassSelector({
    super.key,
    required this.selectedKey,
    required this.onSelect,
    this.columns = 2,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCardChoice<String>(
      type: 2,
      columns: columns,
      options: const ['Motor', 'Tuktuk', 'Motorcycle'].map((v) {
        return ButtonCardOption(
          key: v,
          title: v,
          icon: v == 'Motor'
              ? Icons.directions_car
              : v == 'Tuktuk'
              ? Icons.electric_rickshaw
              : Icons.two_wheeler,
        );
      }).toList(),
      selectedKey: selectedKey,
      onSelect: onSelect,
    );
  }
}
