import 'package:flutter/material.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/widgets/custom_dropdown.dart';

class BodyTypeDropdown extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;
  final MemoryCacheService cache;

  const BodyTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.cache,
  });

  static const Map<String, List<String>> _bodyTypes = {
    'Private / Personal': [
      'Saloon',
      'Hatchback',
      'Station Wagon',
      'Sedan',
      'Coupe',
      'Convertible',
      'SUV',
      'Multi-Purpose Vehicle',
      'Crossover',
    ],
    'Commercial': [
      'Pick-up (Single Cab)',
      'Pick-up (Double Cab)',
      'Panel Van',
      'Box Van/Body',
      'Flatbed/Platform',
      'Lorry/Truck (Rigid)',
      'Truck Tractor (Prime Mover/Articulated)',
      'Tanker',
      'Refrigerated Van/Truck (Reefer)',
      'Tipper',
      'Curtain Sider',
      'Low Bed/Low Loader',
      'Cattle/Livestock Truck',
    ],
    'PSV (Public Service Vehicle)': [
      'Matatu (14-seater / Nissan)',
      'Minibus',
      'Bus',
      'Coach',
    ],
    'Motorcycles / Tricycles': [
      'Motorcycle (Boda Boda)',
      'Motor Tricycle (Tuk Tuk)',
      'Scooter',
    ],
    'Special / Other': [
      'Ambulance',
      'Fire Tender',
      'Mobile Crane',
      'Excavator/Earthmoving',
      'Forklift',
      'Trailer',
      'Caravan',
      'Hearse',
      'Armored Vehicle',
      'Agricultural Tractor',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hint: 'Body Type',
      hintLabel: 'Select Body Type',
      icon: Icons.directions_car_filled_rounded,
      value: value,
      groupedItems: _bodyTypes,
      cacheKey: 'body_type',
      cache: cache,
      isRequired: true,
      validator: (value) =>
          value == null || value.isEmpty ? 'Please select a body type' : null,
      onChanged: onChanged,
    );
  }
}
