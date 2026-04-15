import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

final issueCertificateResultProvider_ =
    StateNotifierProvider<IssueCertificateController, AsyncValue<void>>(
      (ref) => IssueCertificateController(ref),
    );

final issueCertificateResultProvider =
    StateProvider<AsyncValue<Map<String, dynamic>>?>((ref) => null);

class IssueCertificateController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  IssueCertificateController(this.ref) : super(const AsyncData(null));

  Future<void> issueCertificate(String policyId) async {
    state = const AsyncLoading();

    final authState = ref.read(authProvider);
    final user = authState.user;
    final token = authState.bearerToken;

    if (user == null || token == null) {
      state = AsyncError('User not authenticated', StackTrace.current);
      return;
    }

    try {
      final response = await ApiService.issueCertificate(
        policyId: policyId,
        agentCode: user.agentCode,
        agentKey: user.agentKey,
        token: token,
      );

      if (response['status'] == 'success' || response['status'] == 1) {
        state = const AsyncData(null);
      } else {
        state = AsyncError(
          response['message'] ?? 'Failed to issue certificate',
          StackTrace.current,
        );
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
