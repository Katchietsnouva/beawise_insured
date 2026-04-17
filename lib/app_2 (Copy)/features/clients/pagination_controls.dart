import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_dropdown.dart';
import 'package:insured/app_2/providers/client_pagination_provider.dart';

class PaginationControls extends ConsumerWidget {
  const PaginationControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(clientsPaginationProvider);
    final notifier = ref.read(clientsPaginationProvider.notifier);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 10 : 20,
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 140,
            child: CustomDropdown<int>(
              // hint: 'Items Per page',
              hint: '',
              icon: Icons.format_list_numbered,
              value: state.perPage,
              items: [5, 10, 20, 50].map((value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  notifier.setPerPage(newValue);
                }
              },
            ),
          ),

          Row(
            children: [
              Text(
                '${state.currentPage} of ${state.lastPage}',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.9),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.9),
                ),
                onPressed: state.currentPage > 1
                    ? () => notifier.previousPage()
                    : null,
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.9),
                ),
                onPressed: state.currentPage < state.lastPage
                    ? () => notifier.nextPage()
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
