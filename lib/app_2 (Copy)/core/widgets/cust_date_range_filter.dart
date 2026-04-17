import 'package:flutter/material.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_ac_range_picker.dart';
import 'package:intl/intl.dart';

class DateRangeFilter extends StatefulWidget {
  final DateTime initialStart;
  final DateTime initialEnd;
  final Function(DateTime start, DateTime end) onRangeSelected;
  final String? labelPrefix;
  final bool compact;

  const DateRangeFilter({
    super.key,
    required this.initialStart,
    required this.initialEnd,
    required this.onRangeSelected,
    this.labelPrefix,
    this.compact = false,
  });

  @override
  State<DateRangeFilter> createState() => _DateRangeFilterState();
}

class _DateRangeFilterState extends State<DateRangeFilter> {
  late DateTime _startDate;
  late DateTime _endDate;
  final DateFormat _displayFormat = DateFormat('dd MMM yyyy');

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStart;
    _endDate = widget.initialEnd;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? const LinearGradient(
                colors: [Color(0xFF00FFB2), Colors.transparent],
              )
            : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month,
              color: !isDarkMode ? Colors.green[900] : Color(0xFF00FFB2),
              size: 16,
            ),
            const SizedBox(width: 8),
            if (!widget.compact && widget.labelPrefix != null)
              CustomText(
                widget.labelPrefix!,
                type: CustomTextType.paragraph,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            if (!widget.compact && widget.labelPrefix != null)
              const SizedBox(width: 8),
            Flexible(
              child: GestureDetector(
                onTap: () => _openDateRangePicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF00FFB2)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CustomText(
                    "${_displayFormat.format(_startDate)} → ${_displayFormat.format(_endDate)}",
                    type: CustomTextType.paragraph,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDateRangePicker(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "DateRange",
      barrierColor: Colors.black.withOpacity(0.85),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return Center(
          child: AcidicDateRangePicker(
            initialStart: _startDate,
            initialEnd: _endDate,
            onRangeSelected: (start, end) {
              if (start != null && end != null) {
                setState(() {
                  _startDate = start;
                  _endDate = end;
                });
                widget.onRangeSelected(start, end);
              }
            },
            onCancel: () {},
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(animation.value),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
    );
  }
}
