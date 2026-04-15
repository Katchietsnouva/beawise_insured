import 'package:flutter/material.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';

class TabItem {
  final String label;
  final IconData? icon;
  final int index;

  const TabItem({required this.label, required this.index, this.icon});
}

class CustomSuperTabSwitcher extends StatelessWidget {
  final List<TabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  // Optional overrides
  final EdgeInsets? padding;
  final double? verticalItemPadding;

  const CustomSuperTabSwitcher({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.padding,
    this.verticalItemPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Mint accent — same token used across MotorSave + Dashboard
    final Color activeColor = isDark
        ? const Color(0xFF00FFB2)
        : Colors.green[800]!;

    final Color activeBg = isDark
        ? const Color(0xFF00FFB2).withOpacity(0.18)
        : Colors.green[800]!.withOpacity(0.12);

    final double vPad =
        verticalItemPadding ?? (Responsive.isMobile(context) ? 6 : 8);

    return Container(
      padding:
          padding ??
          EdgeInsets.symmetric(
            vertical: Responsive.isMobile(context) ? 4 : 4,
            horizontal: 4,
          ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
        ),
      ),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = selectedIndex == tab.index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabSelected(tab.index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: vPad),
                decoration: BoxDecoration(
                  color: isSelected ? activeBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (tab.icon != null) ...[
                      Icon(
                        tab.icon,
                        size: 18,
                        color: isSelected
                            ? activeColor
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.55),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Flexible(
                      child: CustomText(
                        tab.label,
                        type: CustomTextType.paragraph,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: isSelected
                            ? FontWeight.w400
                            : FontWeight.w300,
                        color: isSelected
                            ? activeColor
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}




  // _buildClientTabs() {
  //   return CustomSuperTabSwitcher(
  //     selectedIndex: _clientMode,
  //     tabs: const [
  //       TabItem(label: 'Existing Client', index: 0),
  //       TabItem(label: 'New Client', index: 1),
  //     ],
  //     onTabSelected: (index) {
  //       setState(() {
  //         _clientMode = index;
  //         if (index == 1) {
  //           _selectedClient = null;
  //           _clearClientControllers();
  //         }
  //       });
  //       final motorCache = ref.read(motorSaveCacheProvider);
  //       motorCache.put('clientMode', index.toString());
  //       if (index == 1) motorCache.remove('selectedClientData');
  //     },
  //   );
  // }




    // CustomSuperTabSwitcher(
    //   selectedIndex: _selectedTabIndex,
    //   tabs: const [
    //     TabItem(label: 'Renewals Due', icon: Icons.history, index: 0),
    //     TabItem(label: 'Certificates', icon: Icons.description, index: 2),
    //   ],
    //   onTabSelected: (index) => setState(() => _selectedTabIndex = index),
    // );