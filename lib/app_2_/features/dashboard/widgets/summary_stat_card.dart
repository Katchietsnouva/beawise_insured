import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';

class SummaryStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  // final String? subValue;
  final Map<String, String>? subValues;
  final VoidCallback? onTap;

  const SummaryStatCard({
    super.key,
    required this.title,
    this.subValues,
    required this.value,
    required this.color,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    title,
                    type: CustomTextType.paragraph,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                if (subValues != null)
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: subValues!.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '${entry.key}: ${entry.value}',
                              style: TextStyle(
                                fontSize: Responsive.isMobile(context)
                                    ? 10
                                    : 14,
                                color: color.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                // if (subValue != null) ...[
                //   const SizedBox(height: 4),
                //   Text(
                //     subValue!,
                //     style: TextStyle(
                //       fontSize: Responsive.isMobile(context) ? 10 : 20,
                //       color: color.withOpacity(0.8),
                //       fontWeight: FontWeight.w500,
                //     ),
                //     maxLines: 1,
                //     overflow: TextOverflow.ellipsis,
                //   ),
                // ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
