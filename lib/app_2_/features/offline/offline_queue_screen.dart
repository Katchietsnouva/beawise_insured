import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/data/models/offline_action_model.dart';
import 'package:insured/app_2/features/clients/add_client_screen.dart'; // import the modal
import 'package:insured/app_2/providers/offline_queue_provider.dart';

class OfflineQueueScreen extends ConsumerStatefulWidget {
  const OfflineQueueScreen({super.key});

  @override
  ConsumerState<OfflineQueueScreen> createState() => _OfflineQueueScreenState();
}

class _OfflineQueueScreenState extends ConsumerState<OfflineQueueScreen> {
  @override
  void initState() {
    super.initState();
    // This triggers a fresh fetch from SharedPreferences immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(offlineActionsProvider);
    });
  }

  Future<void> _editAction(OfflineAction action) async {
    // final result = await showModalBottomSheet<bool>(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   builder: (_) => AddClientModal(initialData: action.data),
    // );
    // We need the data from the modal, not just 'true'
    final result = await showModalBottomSheet<(bool, Map<String, dynamic>)>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // Pass a flag to the modal so it knows it should RETURN the data
      builder: (_) => AddClientModal(initialData: action.data),
    );
    // if (result == true) {
    if (result != null) {
      final (success, data) = result;

      // If modal returned true (client created), we should remove the action.
      // But if user just edited and saved while offline, we need to update the stored data.
      // For simplicity, we'll refresh the list.

      // Update the action with new data
      final notifier = ref.read(offlineQueueNotifierProvider.notifier);

      await notifier.updateActionData(
        action.id,
        // result as Map<String, dynamic>,
        data,
      );
      ref.refresh(offlineActionsProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final actionsAsync = ref.watch(offlineActionsProvider);
    final notifier = ref.read(offlineQueueNotifierProvider.notifier);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Offline Queue'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.cloud_upload),
      //       onPressed: () => notifier.processAll(),
      //       tooltip: 'Upload all',
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.delete_sweep),
      //       onPressed: () => notifier.clear(),
      //       tooltip: 'Clear all',
      //     ),
      //   ],
      // ),
      appBar: AppBar(
        // title: const Text('Offline Queue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(offlineActionsProvider);
            },
            tooltip: 'Refresh list',
          ),
          IconButton(
            icon: const Icon(Icons.cloud_upload),
            onPressed: () => notifier.processAll(context),
            tooltip: 'Upload all',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () async {
              await ref.read(offlineQueueNotifierProvider.notifier).clear();

              ref.invalidate(offlineActionsProvider);

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Queue cleared')));
            },
            tooltip: 'Clear all',
          ),
        ],
      ),
      body: actionsAsync.when(
        data: (actions) {
          if (actions.isEmpty) {
            return const Center(child: Text('No pending offline actions'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: actions.length,
            itemBuilder: (ctx, i) {
              final action = actions[i];
              final status = action.status;
              final isPending = status == OfflineActionStatus.pending;
              final isError = status == OfflineActionStatus.error;
              final isSending = status == OfflineActionStatus.sending;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isError
                        ? Colors.red
                        : (isPending ? Colors.orange : Colors.green),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: isError
                                ? Colors.red.withOpacity(0.2)
                                : (isPending
                                      ? Colors.orange.withOpacity(0.2)
                                      : Colors.green.withOpacity(0.2)),
                            child: Text(
                              action.data['name']?[0] ?? '?',
                              style: TextStyle(
                                color: isError
                                    ? Colors.red
                                    : (isPending
                                          ? Colors.orange
                                          : Colors.green),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  action.data['name'] ?? 'Unknown',
                                  type: CustomTextType.subHeader,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                CustomText(
                                  action.data['email'] ?? '',
                                  type: CustomTextType.paragraph,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                CustomText(
                                  action.data['phone'] ?? '',
                                  type: CustomTextType.caption,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (isPending || isError)
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editAction(action),
                                  tooltip: 'Edit',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cloud_upload),
                                  onPressed: () => notifier.processAction(
                                    action.id,
                                    context,
                                  ),
                                  tooltip: 'Upload',
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (isError && action.errorMessage != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            action.errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isError
                                  ? Colors.red.withOpacity(0.2)
                                  : (isPending
                                        ? Colors.orange.withOpacity(0.2)
                                        : Colors.green.withOpacity(0.2)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _statusText(status),
                              style: TextStyle(
                                color: isError
                                    ? Colors.red
                                    : (isPending
                                          ? Colors.orange
                                          : Colors.green),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  String _statusText(OfflineActionStatus status) {
    switch (status) {
      case OfflineActionStatus.pending:
        return 'Pending';
      case OfflineActionStatus.sending:
        return 'Uploading...';
      case OfflineActionStatus.success:
        return 'Success';
      case OfflineActionStatus.error:
        return 'Error';
    }
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
// import 'package:insured/app_2/data/models/offline_action.dart';
// import 'package:insured/app_2/providers/offline_queue_provider.dart';

// class OfflineQueueScreen extends ConsumerStatefulWidget {
//   const OfflineQueueScreen({super.key});

//   @override
//   ConsumerState<OfflineQueueScreen> createState() => _OfflineQueueScreenState();
// }

// class _OfflineQueueScreenState extends ConsumerState<OfflineQueueScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final actionsAsync = ref.watch(offlineActionsProvider);
//     final notifier = ref.read(offlineQueueNotifierProvider.notifier);

//     return Scaffold(
//       appBar: AppBar(
//         // title: const Text('Offline Queue'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.cloud_upload),
//             onPressed: () => notifier.processAll(),
//             tooltip: 'Upload all',
//           ),
//           IconButton(
//             icon: const Icon(Icons.delete_sweep),
//             onPressed: () => notifier.clear(),
//             tooltip: 'Clear all',
//           ),
//         ],
//       ),
//       body: actionsAsync.when(
//         data: (actions) {
//           if (actions.isEmpty) {
//             return const Center(child: Text('No pending offline actions'));
//           }
//           return ListView.builder(
//             itemCount: actions.length,
//             itemBuilder: (ctx, i) {
//               final action = actions[i];
//               return Card(
//                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Create Client: ${action.data['name']}',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text('Status: ${_statusText(action.status)}'),
//                             if (action.errorMessage != null)
//                               Text(
//                                 'Error: ${action.errorMessage}',
//                                 style: const TextStyle(
//                                   color: Colors.red,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                       if (action.status == OfflineActionStatus.pending)
//                         IconButton(
//                           icon: const Icon(Icons.cloud_upload),
//                           onPressed: () => {
//                             notifier.processAction(action.id),
//                             print("Btn pressed"),
//                           },
//                         ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, stack) => Center(child: Text('Error: $err')),
//       ),
//     );
//   }

//   String _statusText(OfflineActionStatus status) {
//     switch (status) {
//       case OfflineActionStatus.pending:
//         return 'Pending';
//       case OfflineActionStatus.sending:
//         return 'Uploading...';
//       case OfflineActionStatus.success:
//         return 'Success';
//       case OfflineActionStatus.error:
//         return 'Error';
//     }
//   }
// }
 