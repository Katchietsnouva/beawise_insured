import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastS.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastT.dart';
import 'package:insured/app_2/data/models/offline_action_model.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:insured/app_2/core/services/offline_queue_service.dart';
import 'package:insured/app_2/providers/client_pagination_provider.dart';
import 'package:insured/app_2/providers/dashboard_provider.dart';

final offlineQueueServiceProvider = Provider<OfflineQueueService>((ref) {
  return OfflineQueueService();
});

final offlineActionsProvider = FutureProvider<List<OfflineAction>>((ref) async {
  final service = ref.watch(offlineQueueServiceProvider);
  return await service.getActions();
});

final offlineQueueNotifierProvider =
    StateNotifierProvider<OfflineQueueNotifier, List<OfflineAction>>((ref) {
      return OfflineQueueNotifier(ref);
    });

class OfflineQueueNotifier extends StateNotifier<List<OfflineAction>> {
  final Ref ref;
  OfflineQueueNotifier(this.ref) : super([]) {
    _load();
  }

  Future<void> _load() async {
    final service = ref.read(offlineQueueServiceProvider);
    state = await service.getActions();
  }

  Future<void> add(OfflineAction action) async {
    final service = ref.read(offlineQueueServiceProvider);
    await service.addAction(action);
    state = await service.getActions();
  }

  Future<void> update(OfflineAction action) async {
    final service = ref.read(offlineQueueServiceProvider);
    await service.updateAction(action);
    // Force the list provider to re-fetch so the UI updates
    ref.invalidate(offlineActionsProvider);
    state = await service.getActions();
  }

  Future<void> remove(String id) async {
    final service = ref.read(offlineQueueServiceProvider);
    await service.removeAction(id);
    ref.invalidate(offlineActionsProvider);
    state = await service.getActions();
  }

  Future<void> clear() async {
    final service = ref.read(offlineQueueServiceProvider);
    await service.clearAll();
    ref.invalidate(offlineActionsProvider);
    state = [];
  }

  // Future<void> processAction(String id) async {
  //   final action = state.firstWhere((a) => a.id == id);
  //   if (action.status == OfflineActionStatus.sending) return;

  //   action.status = OfflineActionStatus.sending;
  //   await update(action);
  //   print("In processAction fxn");
  //   try {
  //     final authState = ref.read(authProvider);
  //     final token = authState.bearerToken;
  //     final user = authState.user;
  //     print(
  //       "THese are the states: authState $authState token $token user $user",
  //     );
  //     if (token == null || user == null) throw Exception('Not authenticated');

  //     if (action.type == OfflineActionType.createClient) {
  //       final _clientData = {'client': action.data};
  //       print("Here is the data to be uploads fo r_clientData $_clientData");
  //       final response = await ApiService.createClient(
  //         clientData: _clientData,
  //         agentCode: user.agentCode,
  //         agentKey: user.agentKey,
  //         token: token,
  //       );
  //       print("This is the response form offlline screnn  ${response}");
  //       if (response['status'] == 'success') {
  //         await remove(id);
  //         FuturisticToastS.show(
  //           context: context,
  //           message: "Successfully Uploaded!",
  //           icon: Icons.error,
  //           alignment: Alignment.topCenter,
  //         );
  //       } else {
  //         throw Exception(response['message'] ?? 'Failed');
  //       }
  //       print("End of processAction ");
  //     } // add other types here
  //   } catch (e) {
  //     FuturisticToastT.show(
  //       context: context,
  //       message: e.toString(),
  //       icon: Icons.error,
  //       alignment: Alignment.topCenter,
  //     );
  //     action.status = OfflineActionStatus.error;
  //     action.errorMessage = e.toString();
  //     action.retryCount++;
  //     await update(action);
  //   }
  // }

  // Future<void> processAction(String id, BuildContext context) async {
  //   // Added context
  //   final action = state.firstWhere((a) => a.id == id);
  //   if (action.status == OfflineActionStatus.sending) return;

  //   action.status = OfflineActionStatus.sending;
  //   await update(action);

  //   try {
  //     final authState = ref.read(authProvider);
  //     final token = authState.bearerToken;
  //     final user = authState.user;

  //     if (token == null || user == null) throw Exception('Not authenticated');

  //     if (action.type == OfflineActionType.createClient) {
  //       final _clientData = {'client': action.data};
  //       final response = await ApiService.createClient(
  //         clientData: _clientData,
  //         agentCode: user.agentCode,
  //         agentKey: user.agentKey,
  //         token: token,
  //       );

  //       if (response['status'] == 'success') {
  //         await remove(id);

  //         // CHECK MOUNTED BEFORE USING CONTEXT
  //         if (!context.mounted) return;

  //         FuturisticToastS.show(
  //           context: context,
  //           message: "Successfully Uploaded!",
  //           icon: Icons.check_circle, // Changed from error to check
  //           alignment: Alignment.topCenter,
  //         );
  //       } else {
  //         throw Exception(response['message'] ?? 'Failed');
  //       }
  //     }
  //   } catch (e) {
  //     // CHECK MOUNTED BEFORE USING CONTEXT
  //     if (!context.mounted) return;

  //     FuturisticToastT.show(
  //       context: context,
  //       message: e.toString(),
  //       icon: Icons.error,
  //       alignment: Alignment.topCenter,
  //     );

  //     action.status = OfflineActionStatus.error;
  //     action.errorMessage = e.toString();
  //     action.retryCount++;
  //     await update(action);
  //   }
  // }

  // Inside OfflineQueueNotifier class

  Future<void> processAction(String id, BuildContext context) async {
    final action = state.firstWhere((a) => a.id == id);
    if (action.status == OfflineActionStatus.sending) return;

    action.status = OfflineActionStatus.sending;
    await update(action);

    try {
      final authState = ref.read(authProvider);
      final token = authState.bearerToken;
      final user = authState.user;

      if (token == null || user == null) throw Exception('Not authenticated');

      if (action.type == OfflineActionType.createClient) {
        final _clientData = {'client': action.data};

        final response = await ApiService.createClient(
          clientData: _clientData,
          agentCode: user.agentCode,
          agentKey: user.agentKey,
          token: token,
        );

        if (response['status'] == 'success') {
          // 1. Remove from local state and database
          await remove(id);

          // 2. 🔥 REFRESH THE QUEUE PROVIDER (This removes it from the UI)
          ref.invalidate(offlineActionsProvider);

          // 3. 🔥 REFRESH DASHBOARD & CLIENTS LIST (The global feedback)
          // This ensures the new client shows up in the lists immediately
          ref.read(clientsPaginationProvider.notifier).refreshAllAndReset();
          ref.invalidate(dashboardRecentClientsProvider);

          if (!context.mounted) return;
          FuturisticToastS.show(
            context: context,
            message: "Successfully Uploaded!",
            icon: Icons.check_circle,
            alignment: Alignment.topCenter,
          );
        } else {
          throw Exception(response['message'] ?? 'Failed');
        }
      }
    } catch (e) {
      if (!context.mounted) return;
      FuturisticToastT.show(
        context: context,
        message: e.toString(),
        icon: Icons.error,
        alignment: Alignment.topCenter,
      );

      action.status = OfflineActionStatus.error;
      action.errorMessage = e.toString();
      action.retryCount++;
      await update(action);
    }
  }

  Future<void> updateActionData(String id, Map<String, dynamic> newData) async {
    final action = state.firstWhere((a) => a.id == id);
    final updatedAction = OfflineAction(
      id: action.id,
      type: action.type,
      data: newData,
      createdAt: action.createdAt,
      status: OfflineActionStatus.pending,
      errorMessage: null,
      retryCount: 0,
    );
    await update(updatedAction);
  }

  // Future<void> processAll() async {
  //   final pending = state
  //       .where((a) => a.status == OfflineActionStatus.pending)
  //       .toList();
  //   for (var action in pending) {
  //     await processAction(action.id);
  //   }
  // }

  Future<void> processAll(BuildContext context) async {
    final pending = state
        .where((a) => a.status == OfflineActionStatus.pending)
        .toList();
    for (var action in pending) {
      await processAction(action.id, context);
    }
  }
}
