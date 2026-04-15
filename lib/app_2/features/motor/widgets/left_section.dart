import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/features/motor/widgets/top_card_selection.dart';

class MotorFormLeftSection extends ConsumerStatefulWidget {
  final String? selectedClass;
  final ValueChanged<String> onClassSelected;

  const MotorFormLeftSection({
    super.key,
    required this.selectedClass,
    required this.onClassSelected,
  });

  @override
  ConsumerState<MotorFormLeftSection> createState() =>
      _MotorFormLeftSectionState();
}

class _MotorFormLeftSectionState extends ConsumerState<MotorFormLeftSection> {
  late final MemoryCacheService _cache;

  @override
  void initState() {
    super.initState();
    _cache = ref.read(motorFormCacheProvider);

    _restoreFromCache();
  }

  void _restoreFromCache() {
    if (widget.selectedClass == null && _cache.containsKey('motor_class')) {
      final cachedClass = _cache.get('motor_class') as String?;
      if (cachedClass != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onClassSelected(cachedClass);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const CustomText(
        //   "Select the vehicle class",
        //   type: CustomTextType.subHeader,
        // ),
        const SizedBox(height: 20),
        VehicleClassSelector(
          selectedKey: widget.selectedClass,
          onSelect: (value) {
            _cache.put('motor_class', value);
            widget.onClassSelected(value);
          },
          columns: 3,
        ),
      ],
    );
  }
}
