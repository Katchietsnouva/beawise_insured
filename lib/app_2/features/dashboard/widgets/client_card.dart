// // lib/app_2/features/dashboard/widgets/client_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_circular_avatar.dart';
import 'package:insured/app_2/core/widgets/custom_super_card.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/data/models/list_client_model.dart';
import 'package:insured/app_2/features/clients/add_client_screen.dart';
import 'package:insured/app_2/features/clients/client_details_modal.dart';
import 'package:insured/app_2/features/dashboard/widgets/id_badge.dart';
import 'package:insured/app_2/providers/client_pagination_provider.dart';
import 'package:insured/app_2/providers/client_view_provider.dart';

class ClientCard extends ConsumerStatefulWidget {
  final Client client;
  final ClientViewMode? viewMode;

  const ClientCard({super.key, required this.client, this.viewMode});

  @override
  ConsumerState<ClientCard> createState() => _ClientCardState();
}

class _ClientCardState extends ConsumerState<ClientCard> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final isGrid = widget.viewMode == ClientViewMode.grid;
    // final paginationState = ref.watch(clientsPaginationProvider);
    final client = widget.client;

    return CustomSuperCard<Client>(
      name: client.name,
      title: client.name,
      titleTrailing: IdBadge(id: client.client_no),
      titleSubRowsPairList: [
        ['Email', client.email],
        // ['', client.mobile],
        ['Mobile', client.mobile],
      ],
      subtitleRowsPairList: [],
      // subtitleRows: [
      //   CustomText(client.email, type: CustomTextType.caption),
      //   CustomText(client.mobile, type: CustomTextType.caption),
      // ],
      expandable: true,
      isExpanded: _isExpanded,
      onExpandedChanged: (expanded) {
        setState(() => _isExpanded = expanded);
      },
      trailingButton: CustomAdvancedButton(
        label: 'Contact Client',
        variant: ButtonVariant.secondary,
        height: 40,
        icon: Icon(Icons.description),
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ClientDetailsModal(client: client),
        ),
      ),
      expandedPairs: [
        ['ID Number', (client.idno ?? '')],
        ['Date of Birth', (formatHumanDate(client.dob ?? ''))],
        ['Address', (client.address ?? '')],
      ],
      // onTap: () => context.push('/client/${client.id}', extra: client),
      onTap: () async {
        final shouldRefresh = await context.push(
          '/client/${widget.client.id}',
          extra: widget.client,
        );
        if (shouldRefresh == true && context.mounted) {
          // Optional: refresh list if needed
          // ref.read(clientsPaginationProvider.notifier).refreshAllAndReset();
        }
      },
      expandedButtons: [
        Center(
          child: CustomAdvancedButton(
            width: 600,
            height: 40,
            label: 'Edit',
            icon: Icon(Icons.edit),
            variant: ButtonVariant.primary,
            isDisabled: false,
            onPressed: () async {
              final result =
                  await showModalBottomSheet<(bool, Map<String, dynamic>)>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => AddClientModal(
                      initialData: {
                        'name': client.name,
                        'email': client.email,
                        'phone': client.mobile,
                        'idno': client.idno,
                        'pin': client.pin,
                        'dob': client.dob,
                        // 'client_no': client.client_no,
                        'gender': client.gender,
                        'occupation': client.occupation,
                        'location': client.location,
                        'address': client.address,
                        'postCode': client.postCode,
                        'city': client.city,
                        // 'status': client.status,
                      },
                      clientId: client.id
                          ?.toString(), // bytha pass ID used  for update
                    ),
                  );
              if (result != null && result.$1) {
                // Navigator.pop(context, true);
                // Refresh the clients list after update

                ref
                    .read(clientsPaginationProvider.notifier)
                    .refreshAllAndReset();
                // Optionally force a rebuild to show updated data immediately
                setState(() {});
              }
            },
          ),
        ),
      ],
      isGrid: widget.viewMode == ClientViewMode.grid,
    );
  }
}

class ClientCard_ extends ConsumerWidget {
  final Client client;
  final ClientViewMode? viewMode;

  const ClientCard_({super.key, required this.client, this.viewMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGrid = viewMode == ClientViewMode.grid;
    final paginationState = ref.watch(clientsPaginationProvider);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        // final shouldRefresh = await  context.push('/client/${client.client_no}', extra: client);
        final shouldRefresh = await context.push(
          '/client/${client.id}',
          extra: client,
        );

        if (shouldRefresh == true) {
          // ref.refresh(clientsPaginationProvider);
          ref.read(clientsPaginationProvider.notifier).refreshAllAndReset();
        }
      },
      child: Material(
        elevation: Theme.of(context).brightness == Brightness.light ? 4 : 6,
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        // color: Theme.of(context).primaryColor,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            // border: Border.all(color: Colors.white.withOpacity(0.1)),
            border: Border.all(
              color: const Color(0xFF00FFB2).withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.25 : 0.85,
              ),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CustomCircularAvatar(user: client.name),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isGrid
                            ? Column(
                                children: [
                                  CustomText(
                                    client.name,
                                    type: CustomTextType.subHeader,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  IdBadge(id: client.client_no),
                                ],
                              )
                            : Row(
                                children: [
                                  CustomText(
                                    client.name,
                                    type: CustomTextType.subHeader,
                                  ),
                                  const SizedBox(width: 8),
                                  IdBadge(id: client.client_no),
                                ],
                              ),
                        const SizedBox(height: 4),
                        CustomText(
                          client.email,
                          type: CustomTextType.paragraph,
                          overflow: TextOverflow.ellipsis,
                        ),
                        CustomText(
                          client.mobile,
                          type: CustomTextType.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if ((!Responsive.isMobile(context)) && !isGrid)
                    // if (!Responsive.isMobile(context))
                    _GenerateQuotationButton(client: client),
                ],
              ),
              if ((Responsive.isMobile(context)) || isGrid)
                _GenerateQuotationButton(client: client),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenerateQuotationButton extends StatelessWidget {
  final Client client;

  const _GenerateQuotationButton({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: CustomAdvancedButton(
        // label: 'Generate Quote',
        label: 'View Details',
        variant: ButtonVariant.secondary,
        height: 40,
        icon: Icon(Icons.description),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => ClientDetailsModal(client: client),
          );
        },
      ),
    );
  }
}



// // if (client.status != null) ?
// // StatusBadge(status: client.status!),
// if (client.status != null)
//   StatusBadge(status: client.status!),