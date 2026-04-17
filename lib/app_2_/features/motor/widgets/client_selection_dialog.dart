import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
// import 'package:insured/app_2/core/widgets/custom_text_field.dart';
// import 'package:insured/app_2/core/widgets/insured_button.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/providers/client_pagination_provider.dart';

class ClientSelectionDialog extends ConsumerStatefulWidget {
  const ClientSelectionDialog({super.key});

  @override
  ConsumerState<ClientSelectionDialog> createState() =>
      _ClientSelectionDialogState();
}

class _ClientSelectionDialogState extends ConsumerState<ClientSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    // Initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(clientsPaginationProvider.notifier).fetchPage(1);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(clientsPaginationProvider.notifier).setSearchQuery(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(clientsPaginationProvider);
    final notifier = ref.read(clientsPaginationProvider.notifier);
    final filteredClients = notifier.getFilteredClients();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: GlassCard(
        child: Container(
          width: 600,
          constraints: const BoxConstraints(maxHeight: 700),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Client',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Search field
              CustomTextField(
                hint: 'Search clients...',
                icon: Icons.search,
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 16),
              // Pagination controls (simplified)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Page ${state.currentPage} of ${state.lastPage}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_left,
                          color: Colors.white70,
                        ),
                        onPressed: state.currentPage > 1
                            ? () => notifier.previousPage()
                            : null,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                          color: Colors.white70,
                        ),
                        onPressed: state.currentPage < state.lastPage
                            ? () => notifier.nextPage()
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Client list
              Expanded(
                child: state.isLoading && filteredClients.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : filteredClients.isEmpty
                    ? const Center(
                        child: Text(
                          'No clients found',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredClients.length,
                        separatorBuilder: (_, __) =>
                            const Divider(color: Colors.white10),
                        itemBuilder: (ctx, i) {
                          final client = filteredClients[i];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange.withOpacity(0.2),
                              child: Text(client.name[0].toUpperCase()),
                            ),
                            title: Text(
                              client.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              client.email,
                              style: const TextStyle(color: Colors.white70),
                            ),
                            onTap: () => Navigator.pop(context, client),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
