import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'dart:ui';

import 'package:intl/intl.dart';

class AcidicDateRangePicker extends StatefulWidget {
  final DateTime initialStart;
  final DateTime initialEnd;
  final void Function(DateTime? start, DateTime? end)? onRangeSelected;
  final void Function()? onCancel;
  final String? labelPrefix;
  final bool compact;
  const AcidicDateRangePicker({
    super.key,
    this.onRangeSelected,
    this.onCancel,
    required this.initialStart,
    required this.initialEnd,
    this.labelPrefix,
    this.compact = false,
  });

  @override
  State<AcidicDateRangePicker> createState() => _AcidicDateRangePickerState();
}

class _AcidicDateRangePickerState extends State<AcidicDateRangePicker> {
  DateTime? _startDate;
  DateTime? _endDate;
  // DateTime _viewingMonth = DateTime(2026, 3);
  DateTime _viewingMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialStart;
    _endDate = widget.initialEnd;
    _viewingMonth =
        _startDate ?? DateTime(DateTime.now().year, DateTime.now().month, 1);
    // DateTime.now();
  }

  void _onDateTapped(DateTime date) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = date;
        _endDate = null;
      } else if (date.isBefore(_startDate!)) {
        _startDate = date;
      } else {
        _endDate = date;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cTheme = Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF00FFB2)
        : Colors.green[900];
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            colors: [cTheme!.withOpacity(0.5), Colors.transparent],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: 700, // Panoramic layout
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF050505).withOpacity(0.85)
                    : const Color.fromARGB(
                        255,
                        255,
                        255,
                        255,
                      ).withOpacity(0.95),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(cTheme),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildMonthGrid(_viewingMonth, cTheme)),
                      Container(
                        width: 1,
                        height: 280,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.2),
                      ),
                      Expanded(
                        child: _buildMonthGrid(
                          DateTime(_viewingMonth.year, _viewingMonth.month + 1),
                          cTheme,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildStatusFooter(cTheme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(cTheme) {
    return Row(
      children: [
        Icon(Icons.calendar_view_month_rounded, color: cTheme, size: 18),
        const SizedBox(width: 10),
        const CustomText("DATE RANGE SELECTOR", type: CustomTextType.paragraph),
        const Spacer(),
        _navBtn(
          Icons.chevron_left,
          () => setState(
            () => _viewingMonth = DateTime(
              _viewingMonth.year,
              _viewingMonth.month - 1,
            ),
          ),
        ),
        const SizedBox(width: 10),
        _navBtn(
          Icons.chevron_right,
          () => setState(
            () => _viewingMonth = DateTime(
              _viewingMonth.year,
              _viewingMonth.month + 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthGrid(DateTime month, cTheme) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final firstDayOffset = DateTime(month.year, month.month, 1).weekday % 7;
    final monthLabel = DateFormat('MMMM yyyy').format(month).toUpperCase();

    return Column(
      children: [
        CustomText(monthLabel, type: CustomTextType.paragraph),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: daysInMonth + firstDayOffset,
          itemBuilder: (context, index) {
            if (index < firstDayOffset) return const SizedBox();
            final day = index - firstDayOffset + 1;
            final date = DateTime(month.year, month.month, day);
            return _buildDayNode(date, cTheme);
          },
        ),
      ],
    );
  }

  Widget _buildDayNode(DateTime date, cTheme) {
    bool isStart = _startDate != null && DateUtils.isSameDay(date, _startDate);
    bool isEnd = _endDate != null && DateUtils.isSameDay(date, _endDate);
    bool inRange =
        _startDate != null &&
        _endDate != null &&
        date.isAfter(_startDate!) &&
        date.isBefore(_endDate!);

    Color textColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.8);
    if (isStart || isEnd)
      textColor = Theme.of(context).colorScheme.surface.withOpacity(1);
    else if (inRange)
      textColor = cTheme;

    return GestureDetector(
      onTap: () => _onDateTapped(date),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: (isStart || isEnd)
              ? cTheme
              : inRange
              ? cTheme.withOpacity(0.15)
              : Colors.transparent,
          border: Border.all(
            color: (isStart || isEnd)
                ? cTheme
                : inRange
                ? cTheme.withOpacity(0.3)
                : Colors.transparent,
          ),
          boxShadow: (isStart || isEnd)
              ? [
                  BoxShadow(
                    color: cTheme.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        alignment: Alignment.center,
        child: Text(
          "${date.day}",
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: (isStart || isEnd)
                ? FontWeight.bold
                : FontWeight.normal,
            // fontFamily: 'Monospace',
          ),
        ),
      ),
    );
  }

  // Widget _buildStatusFooter(cTheme) {
  //   return Row(
  //     children: [
  //       _statusBlock(
  //         "START_DATE",
  //         _startDate != null
  //             ? DateFormat('dd/MM/yy').format(_startDate!)
  //             : "NULL",
  //         cTheme,
  //       ),
  //       const SizedBox(width: 12),
  //       Icon(
  //         Icons.arrow_forward,
  //         color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
  //         size: 14,
  //       ),
  //       const SizedBox(width: 12),
  //       _statusBlock(
  //         "END_DATE",
  //         _endDate != null ? DateFormat('dd/MM/yy').format(_endDate!) : "NULL",
  //         cTheme,
  //       ),
  //       Spacer(),
  //       Wrap(
  //         // mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           CustomAdvancedButton(
  //             customFontSize: 12,
  //             height: 36,
  //             width: 150,
  //             label: "CANCEL",
  //             variant: ButtonVariant.secondary,
  //             onPressed: () {
  //               widget.onCancel?.call();
  //               Navigator.pop(context);
  //             },
  //           ),
  //           const SizedBox(width: 16),
  //           ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: cTheme.withOpacity(0.6),
  //               foregroundColor: Colors.black,
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 24,
  //                 vertical: 12,
  //               ),
  //             ),
  //             // onPressed: () {
  //             //   widget.onRangeSelected?.call(_startDate, _endDate);
  //             //   Navigator.pop(context);
  //             // },
  //             onPressed: _endDate != null
  //                 ? () {
  //                     widget.onRangeSelected?.call(_startDate, _endDate);
  //                     Navigator.pop(context);
  //                   }
  //                 : null,
  //             child: const Text(
  //               "APPLY RANGE",
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildStatusFooter(Color cTheme) {
    final isMobile = Responsive.isMobile(
      context,
    ); // or MediaQuery.of(context).size.width < 600

    if (isMobile) {
      // Mobile layout: two columns, each with two rows
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left column: dates stacked vertically
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _statusBlock(
                  "START_DATE",
                  _startDate != null
                      ? DateFormat('dd/MM/yy').format(_startDate!)
                      : "NULL",
                  cTheme,
                ),
                const SizedBox(height: 12),
                _statusBlock(
                  "END_DATE",
                  _endDate != null
                      ? DateFormat('dd/MM/yy').format(_endDate!)
                      : "NULL",
                  cTheme,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Right column: buttons stacked vertically
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomAdvancedButton(
                  customFontSize: 12,
                  height: 36,
                  width: double.infinity, // fill column width
                  label: "CANCEL",
                  variant: ButtonVariant.secondary,
                  onPressed: () {
                    widget.onCancel?.call();
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cTheme.withOpacity(0.6),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  onPressed: _endDate != null
                      ? () {
                          widget.onRangeSelected?.call(_startDate, _endDate);
                          Navigator.pop(context);
                        }
                      : null,
                  child: const Text(
                    "APPLY RANGE",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // Wide screen layout (original)
      return Row(
        children: [
          _statusBlock(
            "START_DATE",
            _startDate != null
                ? DateFormat('dd/MM/yy').format(_startDate!)
                : "NULL",
            cTheme,
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.arrow_forward,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            size: 14,
          ),
          const SizedBox(width: 12),
          _statusBlock(
            "END_DATE",
            _endDate != null
                ? DateFormat('dd/MM/yy').format(_endDate!)
                : "NULL",
            cTheme,
          ),
          const Spacer(),
          Wrap(
            children: [
              CustomAdvancedButton(
                customFontSize: 12,
                height: 36,
                width: 150,
                label: "CANCEL",
                variant: ButtonVariant.secondary,
                onPressed: () {
                  widget.onCancel?.call();
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cTheme.withOpacity(0.6),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: _endDate != null
                    ? () {
                        widget.onRangeSelected?.call(_startDate, _endDate);
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text(
                  "APPLY RANGE",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _statusBlock(String label, String value, cTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(label, type: CustomTextType.caption),
          Text(
            value,
            style: TextStyle(
              color: cTheme,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              // fontFamily: 'Monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        size: 20,
      ),
    );
  }
}

// HOW TO USE MY MY CUSTOM COMPONENT:

// void _openDateRangePicker() {
//   showGeneralDialog(
//     context: context,
//     barrierDismissible: true,
//     barrierLabel: "DateRange",
//     barrierColor: Colors.black.withOpacity(0.85),
//     transitionDuration: const Duration(milliseconds: 250),
//     pageBuilder: (_, __, ___) {
//       return Center(
// child: AcidicDateRangePicker(
//             onRangeSelected: (start, end) {
//               if (start == null || end == null) return; // OR DO sth

//               setState(() {
//                 _startDate = start;
//                 _endDate = end;
//               });

//               // Update Riverpod provider → triggers new fetch
//               ref.read(certificateProvider.notifier).setDateRange(
//                     start: start.toIso8601String().split('T')[0],
//                     end: end.toIso8601String().split('T')[0],
//                   );
//             },
//             onCancel: () {
//               // OR DO sth
//             },
//           ),
// );
//     },
//     transitionBuilder: (_, animation, __, child) {
//       return Transform.scale(
//         scale: Curves.easeOutBack.transform(animation.value),
//         child: Opacity(opacity: animation.value, child: child),
//       );
//     },
//   );
// }

Widget f = Container(
  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
  decoration: BoxDecoration(
    gradient: LinearGradient(colors: [Colors.green, Colors.transparent]),
    borderRadius: BorderRadius.circular(44),
  ),
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.calendar_month, color: Colors.green, size: 18),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomText(
                "Click to select Date range",
                type: CustomTextType.paragraph,
              ),
              CustomText(
                "palceholder",
                // "RANGE: ${_displayFormat.format(_startDate!)} > ${_displayFormat.format(_endDate!)}",
                type: CustomTextType.paragraph,
                // softWrap: true,
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);
