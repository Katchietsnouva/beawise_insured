import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/theme/custom_text_styles.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';

class ButtonCardOption<T> {
  final T key;
  final String title;
  final String? description;
  final IconData? icon;
  ButtonCardOption({
    required this.key,
    required this.title,
    this.description,
    this.icon,
  });
}

class CustomCardChoice<T> extends StatelessWidget {
  final List<ButtonCardOption<T>> options;
  final T? selectedKey;
  final Function(T) onSelect;
  final int columns;
  final Function(T)? onViewMore;
  final int type;

  const CustomCardChoice({
    super.key,
    required this.options,
    required this.selectedKey,
    required this.onSelect,
    this.columns = 2,
    this.onViewMore,
    this.type = 1,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: type == 2 ? 1.0 : 1.1,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        final isSelected = selectedKey == option.key;
        return _CardItem(
          option: option,
          isSelected: isSelected,
          onTap: () => onSelect(option.key),
          onViewMore: onViewMore != null ? () => onViewMore!(option.key) : null,
          type: type,
        );
      },
    );
  }
}

class _CardItem extends StatefulWidget {
  final ButtonCardOption option;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onViewMore;
  final int type;

  const _CardItem({
    required this.option,
    required this.isSelected,
    required this.onTap,
    this.onViewMore,
    this.type = 1,
  });

  @override
  State<_CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<_CardItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = AppColors.favColourDark;
    // final surfaceColor = isDark
    //     ? _CardTokens.darkSurface
    //     : _CardTokens.lightSurface;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Material(
          elevation: widget.isSelected ? 1 : (_isHovered ? 1 : 1),
          borderRadius: BorderRadius.circular(20),

          child: AnimatedScale(
            scale: widget.isSelected ? 1.02 : (_isHovered ? 1.05 : 1.0),
            duration: const Duration(milliseconds: 200),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: widget.isSelected
                    ? accentColor.withOpacity(isDark ? 0.15 : 0.1)
                    // : surfaceColor.withOpacity(0.9),
                    : Theme.of(context).colorScheme.surface.withOpacity(0.2),
                border: Border.all(
                  color: widget.isSelected
                      ? accentColor.withOpacity(0.8)
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.1),
                  width: 2,
                ),
                boxShadow: [
                  if (widget.isSelected)
                    BoxShadow(
                      color: accentColor.withOpacity(0.25),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: widget.type == 2
                        ? _buildCenteredLayout(accentColor, isDark)
                        : _buildHorizontalLayout(accentColor, isDark),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildHorizontalLayout() {
  Widget _buildHorizontalLayout(Color accentColor, bool isDark) {
    final iconColor = widget.isSelected
        ? accentColor
        : (isDark ? Colors.white70 : Colors.black54);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (widget.option.icon != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // color: widget.isSelected
                  //     ? Colors.greenAccent.withOpacity(0.2)
                  //     : Colors.white.withOpacity(0.1),
                  color: widget.isSelected
                      ? accentColor.withOpacity(0.2)
                      : (isDark
                            ? Colors.white10
                            : Colors.black.withOpacity(0.05)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.option.icon,
                  size: 20,
                  color:
                      // widget.isSelected
                      //     ? Colors.greenAccent
                      //     : Colors.white70,
                      iconColor,
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomText(
                widget.option.title,
                type: CustomTextType.paragraph,
              ),
            ),
          ],
        ),
        const Spacer(),
        _buildBottomRow(),
      ],
    );
  }

  // Widget _buildCenteredLayout() {
  Widget _buildCenteredLayout(Color accentColor, bool isDark) {
    final isMobile = (Responsive.isMobile(context));
    final iconColor = widget.isSelected
        ? (isDark ? Colors.white : accentColor)
        : Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isMobile) _buildCardLable(),
        Expanded(
          child: Center(
            child: widget.option.icon != null
                ? Container(
                    padding: EdgeInsets.all((isMobile) ? 2 : 20),
                    decoration: BoxDecoration(
                      // color: widget.isSelected
                      //     ? Colors.greenAccent.withOpacity(0.4)
                      //     : Colors.greenAccent.withOpacity(0.2),
                      color: widget.isSelected
                          ? accentColor.withOpacity(0.25)
                          : accentColor.withOpacity(0.12),

                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.option.icon,
                      size: 54,
                      color:
                          // widget.isSelected
                          //     ? Theme.of(context).brightness == Brightness.dark
                          //           ? Colors.green[900]
                          //           : Colors.green
                          //     : Theme.of(context).colorScheme.onSurface,
                          iconColor,
                    ),
                  )
                : const SizedBox(),
          ),
        ),
        if (!isMobile) _buildCardLable(),
        // const SizedBox(height: 12),
        _buildBottomRow(),
      ],
    );
  }

  Widget _buildCardLable() {
    return Text(
      widget.option.title,

      // style: TextStyle(
      //   color: Colors.white,
      //   fontWeight: FontWeight.bold,
      //   fontSize: Responsive.isMobile(context) ? 8 : 16,
      // ),
      style: CustomTextStyles.style(
        context,
        type: CustomTextType.caption,
        fontSize: Responsive.isMobile(context) ? 10 : 16,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildBottomRow() {
    final isMobile = (Responsive.isMobile(context));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (widget.onViewMore != null)
          TextButton(
            onPressed: widget.onViewMore,
            style: TextButton.styleFrom(
              foregroundColor: Colors.blueAccent,
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              "View Benefits",
              style: TextStyle(
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        if (widget.isSelected)
          Icon(
            Icons.check_circle,
            color: AppColors.favColour,
            size: isMobile ? 16 : 24,
          ),
      ],
    );
  }
}
