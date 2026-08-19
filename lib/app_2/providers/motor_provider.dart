import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/core/utils/formatHumanDate.dart';
import 'package:insured/app_2/data/models/motor_quote_request_model.dart';
import 'package:insured/app_2/data/models/motor_save_model.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

class MotorState {
  final bool isLoading;
  final String? error;
  final MotorQuoteResponse? quoteResponse;
  final MotorSaveResponse? saveResponse;

  MotorState({
    this.isLoading = false,
    this.error,
    this.quoteResponse,
    this.saveResponse,
  });

  MotorState copyWith({
    bool? isLoading,
    String? error,
    MotorQuoteResponse? quoteResponse,
    MotorSaveResponse? saveResponse,
  }) {
    return MotorState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      quoteResponse: quoteResponse ?? this.quoteResponse,
      saveResponse: saveResponse ?? this.saveResponse,
    );
  }
}

class MotorNotifier extends StateNotifier<MotorState> {
  final Ref ref;

  MotorNotifier(this.ref) : super(MotorState());

  Future<MotorQuoteResponse?> getQuote(MotorQuoteRequest request) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authState = ref.read(authProvider);
      final user = authState.user;
      final token = authState.bearerToken;

      if (user == null || token == null) {
        ref.read(authProvider.notifier).logout();
        throw AuthenticationException('User not authenticated');
      }

      final response = await ApiService.getMotorQuote(
        agentCode: user.agentCode,
        agentKey: user.agentKey,
        token: token,
        request: request,
        ref: ref,
      );
      print(
        "This is the motor response (MotorQuoteResponse?> getQuote)  ",
        // "This is the motor response (MotorQuoteResponse?> getQuote) $response",
      );
      prettyPrintJson(response);

      if (response['status'] == 'success') {
        final quoteResponse = MotorQuoteResponse.fromJson(response);
        state = state.copyWith(
          isLoading: false,
          quoteResponse: quoteResponse,
          error: null,
        );

        // const encoder = JsonEncoder.withIndent('  ');
        // print('Motor Quote response:\n${encoder.convert(response)}');
        // prettyPrintJson(quoteResponse.toJson());
        return quoteResponse;
      } else {
        throw Exception(response['message'] ?? 'Failed to get quote');
      }
    } catch (e) {
      if (e is AuthenticationException) {
        // Session is gone — logout() was already triggered and the router
        // redirects to /login. Don't record a state error that would pop a
        // misleading toast.
        state = state.copyWith(isLoading: false, error: null);
        rethrow;
      }
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  Future<MotorSaveResponse?> savePolicy(MotorSaveRequest request) async {
    final encoder = const JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(request.toJson());

    print("THIS IS THE MotorSave Payload  JSON:");
    print(prettyJson);
    state = state.copyWith(isLoading: true, error: null);
    try {
      final authState = ref.read(authProvider);
      final user = authState.user;
      final token = authState.bearerToken;

      if (user == null || token == null) {
        ref.read(authProvider.notifier).logout();
        throw AuthenticationException('User not authenticated');
      }

      final response = await ApiService.saveMotorPolicy(
        agentCode: user.agentCode,
        agentKey: user.agentKey,
        token: token,
        request: request,
        ref: ref,
      );

      debugPrint("📦 SAVE POLICY RESPONSE:");
      debugPrint(response.toString());

      if (response['message'] != null) {
        final saveResponse = MotorSaveResponse.fromJson(response);
        state = state.copyWith(
          isLoading: false,
          saveResponse: saveResponse,
          error: null,
        );
        return saveResponse;
      } else {
        throw Exception(response['message'] ?? 'Failed to save policy');
      }
    } catch (e) {
      if (e is AuthenticationException) {
        // Session is gone — logout() was already triggered and the router
        // redirects to /login. Don't record a state error.
        state = state.copyWith(isLoading: false, error: null);
        rethrow;
      }
      debugPrint("❌ SAVE POLICY ERROR:");
      debugPrint(e.toString());
      debugPrint(state.toString());
      state = state.copyWith(isLoading: false, error: e.toString());
      print("❌ SAVE POLICY ERROR: ${e.toString()} ");
      throw Exception(e.toString());
    }
  }

  void clearQuote() {
    state = state.copyWith(quoteResponse: null);
  }

  void clearSave() {
    state = state.copyWith(saveResponse: null);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final motorProvider = StateNotifierProvider<MotorNotifier, MotorState>((ref) {
  return MotorNotifier(ref);
});
