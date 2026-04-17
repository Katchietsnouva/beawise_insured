import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_circular_avatar.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';

class CustomSuperCard<T> extends StatefulWidget {
  final T? item;
  final String? name;

  final Widget? avatar;
  final String? title;
  final Widget? titleTrailing;
  final bool titleTrailingEnd;
  final List<Widget>? subtitleRows;
  final List<Widget>? extraRows;

  final List<Widget>? expandedContent;
  final Widget? trailingButton;
  final List<Widget>? expandedButtons;
  final bool expandable;
  final bool isExpanded;

  final ValueChanged<bool>? onExpandedChanged;

  final VoidCallback? onTap;

  final bool isGrid;

  final Color? borderColor;

  final EdgeInsetsGeometry? padding;

  final EdgeInsetsGeometry? contentPadding;
  final List<List<String>>? titleSubRowsPairList;
  final Widget? subtitleRowsTrailing;
  final List<Widget>? subtitleRowsTrailingList;
  final List<List<String>>? subtitleRowsTrailingListPairs;

  final List<List<String>>? subtitleRowsPairList;
  final List<List<String>>? expandedPairs;

  const CustomSuperCard({
    super.key,
    this.item,
    this.name,
    this.avatar,
    this.title,
    this.titleTrailing,
    this.titleTrailingEnd = false,
    this.subtitleRows,
    this.extraRows,
    this.expandedContent,
    this.trailingButton,
    this.expandedButtons,
    this.expandable = false,
    this.isExpanded = false,
    this.onExpandedChanged,
    this.onTap,
    this.isGrid = false,
    this.borderColor,
    this.padding,
    this.contentPadding,
    this.expandedPairs,
    this.titleSubRowsPairList,
    this.subtitleRowsTrailing,
    this.subtitleRowsTrailingList,
    this.subtitleRowsTrailingListPairs,
    this.subtitleRowsPairList,
  });

  @override
  State<CustomSuperCard<T>> createState() => _CustomSuperCardState<T>();
}

class _CustomSuperCardState<T> extends State<CustomSuperCard<T>> {
  // void _handleTap() {
  //   if (widget.onTap != null) widget.onTap!();
  //   print('Inside fiel CustomSuperCard Card tapped');
  // }

  void _handleTap() {
    if (widget.expandable) {
      _toggleExpand();
    }

    // if (widget.onTap != null) widget.onTap!();
  }

  void _toggleExpand() {
    if (widget.onExpandedChanged != null) {
      widget.onExpandedChanged!(!widget.isExpanded);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = !isMobile;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: _handleTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: widget.padding ?? const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                widget.borderColor ??
                Theme.of(context).primaryColor.withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withOpacity(isDarkMode ? 0.1 : 0.4),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  // widget.contentPadding ?? EdgeInsets.all(isMobile ? 2 : 16),
                  widget.contentPadding ??
                  EdgeInsets.all(isMobile ? (widget.isGrid ? 2 : 4) : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.,
                    children: [
                      Opacity(opacity: 0, child: _defaultAvatar()),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (widget.subtitleRowsPairList != null &&
                                    widget
                                        .subtitleRowsPairList!
                                        .isNotEmpty) ...[
                                  // const SizedBox(height: 8),
                                  // ...widget.titleSubRowsPairList!,
                                  ...widget.subtitleRowsPairList!.map(
                                    (pair) => _buildsubtitleRowsPairList(
                                      pair[0],
                                      pair[1],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            if (widget.subtitleRows != null &&
                                widget.subtitleRows!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              ...widget.subtitleRows!,
                            ],
                          ],
                        ),
                      ),
                      Spacer(),
                      if (widget.expandable)
                        // Ink(
                        //   decoration: BoxDecoration(
                        //     color: AppColors.favColour.withOpacity(0.7),
                        //     shape: BoxShape.circle,
                        //   ), child:
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: _toggleExpand,
                          color: AppColors.favColour,
                          icon: AnimatedRotation(
                            turns: widget.isExpanded ? 0.5 : 0.0,
                            duration: const Duration(milliseconds: 250),
                            child: const Icon(
                              Icons.keyboard_arrow_down,
                              size: 40,
                            ),
                          ),
                        ),
                      // ),
                    ],
                  ),
                  if (widget.extraRows != null &&
                      widget.extraRows!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    ...widget.extraRows!,
                  ],
                  if (widget.trailingButton != null &&
                      (widget.isGrid || isMobile)) ...[
                    const SizedBox(height: 12),
                    widget.trailingButton!,
                    const SizedBox(height: 2),
                  ],
                ],
              ),
            ),
            // Expanded content (collapsible)
            if (widget.expandable && widget.isExpanded
            // && widget.expandedContent != null
            )
              Padding(
                padding:
                    widget.contentPadding ??
                    const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: Theme.of(context).dividerColor.withOpacity(0.4),
                      thickness: 0.8,
                    ),
                    if (widget.expandedPairs != null)
                      ...widget.expandedPairs!.map(
                        (pair) => _buildDetailRow(pair[0], pair[1]),
                      ),
                    Divider(
                      color: Theme.of(context).dividerColor.withOpacity(0.4),
                      thickness: 0.8,
                    ),

                    // if (widget.expandedPairs != null)
                    if (widget.expandedContent != null &&
                        widget.expandedContent!.isNotEmpty)
                      ...widget.expandedContent!,

                    if (widget.expandedButtons != null &&
                        widget.expandedButtons!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      if (widget.isGrid || isMobile)
                        Column(
                          children: widget.expandedButtons!
                              .map(
                                (b) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: b,
                                ),
                              )
                              .toList(),
                        )
                      else
                        Row(
                          children: widget.expandedButtons!
                              .map((b) => Expanded(child: b))
                              .toList(),
                        ),
                      SizedBox(height: Responsive.isMobile(context) ? 4 : 10),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final avatar = widget.avatar ?? _defaultAvatar();
    final title = widget.title ?? widget.name ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        avatar,
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (widget.isGrid || Responsive.isMobile(context))
                    Expanded(
                      child: CustomText(
                        title,
                        type: CustomTextType.paragraph,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.normal,
                      ),
                    )
                  else
                    CustomText(
                      title,
                      type: CustomTextType.subHeader,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.normal,
                    ),

                  // if (widget.titleTrailing != null) ...[
                  //   if (widget.titleTrailingEnd) Spacer(),
                  //   const SizedBox(width: 8),
                  //   widget.titleTrailing!,
                  // ],
                  if (widget.titleTrailing != null) ...[
                    // ✅ Only push trailing to far end on desktop OR very short names
                    if (!Responsive.isMobile(context) &&
                        (widget.titleTrailingEnd || title.length <= 6))
                      const Spacer(),

                    const SizedBox(width: 8),

                    // ✅ Constrain trailing so it doesn't over-reserve space
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: Responsive.isMobile(context)
                            ? 140
                            : 160, // tweak as needed
                      ),
                      child: widget.titleTrailing!,
                    ),
                  ],
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                /// helpes me alliht if policy amount  only
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.titleSubRowsPairList != null &&
                            widget.titleSubRowsPairList!.isNotEmpty) ...[
                          // const SizedBox(height: 8),
                          // ...widget.titleSubRowsPairList!,
                          ...widget.titleSubRowsPairList!.map(
                            (pair) =>
                                _buildtitleSubRowsPairList(pair[0], pair[1]),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // // if (widget.subtitleRowsTrailing != null) ...[
                  // //   if (widget.titleTrailingEnd) Spacer(),
                  // //   const SizedBox(width: 8),
                  // //   widget.subtitleRowsTrailing!,
                  // // ],
                  // if (widget.subtitleRowsTrailing != null ||
                  //     (widget.subtitleRowsTrailingList?.isNotEmpty ??
                  //         false)) ...[
                  //   if (widget.titleTrailingEnd) Spacer(),
                  //   const SizedBox(width: 8),

                  //   if (widget.subtitleRowsTrailingList != null &&
                  //       widget.subtitleRowsTrailingList!.isNotEmpty)
                  //     Column(
                  //       crossAxisAlignment:
                  //           CrossAxisAlignment.end, // Aligns text to the right
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: widget.subtitleRowsTrailingList!,
                  //     )
                  //   else if (widget.subtitleRowsTrailing != null)
                  //     widget.subtitleRowsTrailing!,
                  // ],
                  if (widget.subtitleRowsTrailingListPairs != null &&
                      widget.subtitleRowsTrailingListPairs!.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: widget.subtitleRowsTrailingListPairs!
                          .map(
                            (pair) => _buildTrailingPairRow(pair[0], pair[1]),
                          )
                          .toList(),
                    ),
                  ] else if (widget.subtitleRowsTrailingList != null &&
                      widget.subtitleRowsTrailingList!.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: widget.subtitleRowsTrailingList!,
                    ),
                  ] else if (widget.subtitleRowsTrailing != null) ...[
                    const SizedBox(width: 8),
                    widget
                        .subtitleRowsTrailing!, // already a widget, no Flexible needed
                  ],

                  // if (widget.subtitleRowsTrailingListPairs != null &&
                  //     widget.subtitleRowsTrailingListPairs!.isNotEmpty) ...[
                  //   if (widget.titleTrailingEnd) const Spacer(),
                  //   const SizedBox(width: 8),
                  //   Expanded(
                  //     // ← Flexible prevents overflow
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.end,
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: widget.subtitleRowsTrailingListPairs!
                  //           .map(
                  //             (pair) => _buildTrailingPairRow(pair[0], pair[1]),
                  //           )
                  //           .toList(),
                  //     ),
                  //   ),
                  // ] else if (widget.subtitleRowsTrailingList != null &&
                  //     widget.subtitleRowsTrailingList!.isNotEmpty) ...[
                  //   if (widget.titleTrailingEnd) const Spacer(),
                  //   const SizedBox(width: 8),
                  //   Flexible(
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.end,
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: widget.subtitleRowsTrailingList!,
                  //     ),
                  //   ),
                  // ] else if (widget.subtitleRowsTrailing != null) ...[
                  //   if (widget.titleTrailingEnd) const Spacer(),
                  //   const SizedBox(width: 8),
                  //   Flexible(
                  //     child: SingleChildScrollView(
                  //       scrollDirection: Axis.horizontal,
                  //       child: widget.subtitleRowsTrailing!,
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ],
          ),
        ),
        if (!widget.isGrid &&
            !Responsive.isMobile(context) &&
            widget.trailingButton != null)
          widget.trailingButton!,
      ],
    );
  }

  Widget _defaultAvatar() {
    return CustomCircularAvatar(user: widget.name);
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Opacity(
              opacity: 0.8,
              child: CustomText(
                label,
                type: CustomTextType.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: CustomText(
                value,
                type: CustomTextType.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildtitleSubRowsPairList(String label, String value) {
    return Row(
      children: [
        // if (!Responsive.isMobile(context))
        if (!Responsive.isMobile(context) && !widget.isGrid)
          if (label.trim().isNotEmpty) ...[
            // Flexible( flex: 2,child:
            Opacity(
              opacity: 0.6,
              child: CustomText(
                '$label:',
                type: CustomTextType.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // ),
            ),
            const SizedBox(width: 8),
          ],
        // Flexible( flex: 3, child:
        Flexible(
          child: CustomText(
            value,
            type: CustomTextType.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // ),
      ],
    );
  }

  Widget _buildsubtitleRowsPairList_(String label, String value) {
    return Row(
      children: [
        if (!Responsive.isMobile(context) && !widget.isGrid)
          if (label.trim().isNotEmpty) ...[
            Opacity(
              opacity: 0.6,
              child: CustomText(
                '$label:',
                type: CustomTextType.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // ),
            ),
            const SizedBox(width: 8),
          ],
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: CustomText(
            value,
            type: CustomTextType.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // ),
      ],
    );
  }

  Widget _buildsubtitleRowsPairList(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!Responsive.isMobile(context) && !widget.isGrid)
          if (label.trim().isNotEmpty) ...[
            Opacity(
              opacity: 0.6,
              child: CustomText(
                '$label:',
                type: CustomTextType.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
          ],
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: CustomText(
              value,
              type: CustomTextType.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrailingPairRow(String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool isMobileOrGrid = Responsive.isMobile(context) || widget.isGrid;
    final double? labelWidth = isMobileOrGrid ? 80 : null;
    final charCount = 14;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (!Responsive.isMobile(context) && !widget.isGrid)
        //   if (label.trim().isNotEmpty) ...[
        if (label.trim().isNotEmpty) ...[
          // ConstrainedBox(
          //   constraints: BoxConstraints(
          //     maxWidth: isMobileOrGrid ? 80 : double.infinity,
          //   ),
          SizedBox(
            width: labelWidth,
            child: Opacity(
              opacity: 0.6,
              child: CustomText(
                // Truncate label on mobile/grid to ~6 chars + "..."
                isMobileOrGrid && label.length > charCount
                    ? '${label.substring(0, charCount)}...'
                    : label,
                type: CustomTextType.caption,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                color: isDarkMode
                    ? AppColors.favColour
                    : AppColors.favColourDark!,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],

        Flexible(
          child: CustomText(
            value,
            type: CustomTextType.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            color: isDarkMode ? AppColors.favColour : AppColors.favColourDark!,
          ),
        ),
      ],
    );
  }

  Widget _buildTrailingPairRow_(String label, String value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool isMobileOrGrid = Responsive.isMobile(context) || widget.isGrid;
    final double? labelWidth = isMobileOrGrid
        ? 80
        : null; // fixed width for alignment

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (label.trim().isNotEmpty) ...[
            SizedBox(
              width: labelWidth,

              child: Opacity(
                opacity: 0.6,
                child: CustomText(
                  isMobileOrGrid && label.length > 6
                      ? '${label.substring(0, 6)}...'
                      : label,
                  type: CustomTextType.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  color: isDarkMode
                      ? AppColors.favColour
                      : AppColors.favColourDark!,
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: CustomText(
              value,
              type: CustomTextType.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: isDarkMode
                  ? AppColors.favColour
                  : AppColors.favColourDark!,
            ),
          ),
        ],
      ),
    );
  }
}
