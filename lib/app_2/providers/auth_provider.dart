// lib/app_2/providers/auth_provider.dart
import 'dart:convert';
import 'package:insured/app_2/app_router.dart';
import 'package:insured/app_2/core/services/notification_service.dart';
import 'package:insured/app_2/providers/certificate_provider.dart';
import 'package:insured/app_2/providers/motor_provider.dart';
import 'package:insured/app_2/providers/renewal_provider.dart';
import 'package:insured/app_2/providers/statement_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider;
import 'package:flutter_riverpod/legacy.dart';
import 'package:insured/app_2/core/services/api_service.dart';
import 'package:insured/app_2/data/models/user_model.dart';
import 'package:insured/app_2/providers/client_provider.dart';
import 'package:insured/app_2/providers/policy_provider.dart';

// const String _kAuthTokenKey = 'auth_token';
const String _kBearerTokenKey = 'bearer_token';
const String _kUserKey = 'auth_user';
const String _kRememberMe = 'remember_me';
const String _kLastRoute = 'last_route';

class AuthState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? errorData;
  final String? pendingEmail;
  final String? bearerToken;
  // final String? authToken;
  final bool isAuthenticated;

  final String? resetEmail;
  final bool resetRequestSent;
  final User? user;
  final bool rememberMe;
  final String? lastRoute;

  @override
  String toString() {
    // authToken: $authToken,
    return '''
      AuthState(
        isLoading: $isLoading,
        isAuthenticated: $isAuthenticated,
        pendingEmail: $pendingEmail,
        bearerToken: $bearerToken,
        error: $error,
        errorData: $errorData,
        user: $user
      )
    ''';
  }

  AuthState({
    this.isLoading = false,
    this.error,
    this.errorData,
    this.pendingEmail,
    this.bearerToken,
    // this.authToken,
    this.isAuthenticated = false,

    this.resetEmail,
    this.resetRequestSent = false,
    this.user,
    this.rememberMe = false,
    this.lastRoute,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    Map<String, dynamic>? errorData,
    String? pendingEmail,
    String? bearerToken,
    // String? authToken,
    bool? isAuthenticated,

    String? resetEmail,
    bool? resetRequestSent,
    User? user,
    bool? rememberMe,
    String? lastRoute,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      errorData: errorData ?? this.errorData,
      pendingEmail: pendingEmail ?? this.pendingEmail,
      bearerToken: bearerToken ?? this.bearerToken,
      // authToken: authToken ?? this.authToken,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,

      resetEmail: resetEmail ?? this.resetEmail,
      resetRequestSent: resetRequestSent ?? this.resetRequestSent,
      user: user ?? this.user,
      rememberMe: rememberMe ?? this.rememberMe,
      lastRoute: lastRoute ?? this.lastRoute,
    );
  }
}

class ApiResult<T> {
  final bool success;
  final String? message;
  final User? data;

  @override
  String toString() {
    return '''
      ApiResult(
        success: $success,
        message: $message,
        data: $data
      )
      ''';
  }

  ApiResult({required this.success, this.message, this.data});
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  // AuthNotifier(this.ref) : super(AuthState());
  AuthNotifier(this.ref)
    : // super(AuthState()) {
      super(AuthState(isLoading: true)) {
    _loadFromStorage();
  }

  void setRememberMe(bool value, {String? route}) {
    state = state.copyWith(rememberMe: value, lastRoute: route);
    _saveToStorage(user: state.user);
  }

  void updateLastRoute(String route) {
    if (state.rememberMe && state.isAuthenticated) {
      state = state.copyWith(lastRoute: route);
      _saveToStorage(user: state.user);
    }
  }

  Future<void> _saveToStorage({User? user}) async {
    final prefs = await SharedPreferences.getInstance();
    // if (token != null) {
    //   await prefs.setString(_kAuthTokenKey, token);
    // }
    if (user != null) {
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_kUserKey, userJson);
    }

    if (state.bearerToken != null) {
      await prefs.setString(_kBearerTokenKey, state.bearerToken!);
    }

    if (state.rememberMe) {
      await prefs.setBool(_kRememberMe, true);
      if (state.lastRoute != null) {
        await prefs.setString(_kLastRoute, state.lastRoute!);
      }
    } else {
      await prefs.remove(_kRememberMe);
      await prefs.remove(_kLastRoute);
    }
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString(_kAuthTokenKey);
    // final token = prefs.getString(_kUserKey);
    final userJson = prefs.getString(_kUserKey);
    final bearerToken = prefs.getString(_kBearerTokenKey);
    final rememberMe = prefs.getBool(_kRememberMe) ?? false;
    final lastRoute = prefs.getString(_kLastRoute);
    // state = state.copyWith(rememberMe: rememberMe, lastRoute: lastRoute);

    String? agentKey;
    User? user;

    if (userJson != null) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(userJson);
        // user = User.fromJson(jsonDecode(userJson));

        agentKey = userMap['agent_key'];
        print('🔑 agent_key: $agentKey');

        // Optional: parse into User object if you want
        user = User.fromJson(userMap);
      } catch (e) {
        print('Error decoding user JSON user from storage: $e');
      }
    } else {
      print('No user data found in storage');
    }

    print('🔐 Loading from storage: agentKey=$agentKey, userJson=$userJson');
    // print(
    //   '🔐 Loading from storage: agentKey=$agentKey, userJson=${jsonEncode(jsonDecode(userJson!))}',
    // );

    if (userJson != null) {
      print(
        '🔐 Loading from storage: agentKey=$agentKey, userJson=${jsonEncode(jsonDecode(userJson))}',
      );
    }
    print('🔐 Loading from storage: agentKey=$agentKey, userJson=$userJson');

    // if (agentKey != null) {
    if (agentKey != null || bearerToken != null) {
      state = state.copyWith(
        // authToken: token,
        bearerToken: bearerToken,
        isAuthenticated: true,
        user: user,
        isLoading: false,
        pendingEmail: null,
        error: null,
        errorData: null,
        rememberMe: rememberMe,
        lastRoute: lastRoute,
      );
      print(
        '🔓 State updated after load: isAuthenticated=true, user=${user?.company}',
      );
    } else {
      print('🔒 No token found');
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _clearStorage() async {
    final prefs = await SharedPreferences.getInstance();

    // await prefs.remove(_kUserKey);
    // await prefs.remove(_kBearerTokenKey);
    await prefs.clear();
  }

  void setLoginData(String email, String bearerToken) {
    state = state.copyWith(pendingEmail: email, bearerToken: bearerToken);
  }

  Future<bool> register(Map<String, dynamic> data) async {
    final stopwatch = Stopwatch()..start();

    state = state.copyWith(isLoading: true, error: null, errorData: null);
    try {
      final token = await ApiService.getAuthToken();
      final response = await ApiService.register(data, token);
      stopwatch.stop();
      print(response);

      // ref .read(notificationProvider.notifier)
      NotificationService.addLog(
        endpoint: 'registeration',
        status: 'success',
        durationMs: stopwatch.elapsedMilliseconds,
        message: 'Registration successful for ${data['email']}',
      );

      state = state.copyWith(isLoading: false, pendingEmail: data['email']);
      return true;
    } catch (e) {
      stopwatch.stop();
      // ref .read(notificationProvider.notifier)
      NotificationService.addLog(
        endpoint: 'registeration',
        status: 'error',
        durationMs: stopwatch.elapsedMilliseconds,
        message: e.toString(),
      );

      Map<String, dynamic>? errorData;
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      try {
        final decoded = jsonDecode(errorMessage);
        if (decoded is Map<String, dynamic>) {
          errorData = decoded;
          errorMessage = decoded['message'] ?? 'Registration failed';
        }
      } catch (_) {}
      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
        errorData: errorData,
      );
      return false;
    }
  }

  // Future<bool> verifyOtp(String otp) async {
  Future<ApiResult<User>> verifyOtp(String otp) async {
    if (state.pendingEmail == null || state.bearerToken == null) {
      final error = 'Missing email or authentication token';

      state = state.copyWith(error: error, errorData: {'message': error});
      // return false;
      return ApiResult(success: false, message: error);
    }
    final stopwatch = Stopwatch()..start();

    state = state.copyWith(isLoading: true, error: null, errorData: null);
    try {
      final response = await ApiService.verifyOtp(
        state.pendingEmail!,
        otp,
        state.bearerToken!,
      );
      stopwatch.stop();
      // ref .read(notificationProvider.notifier)
      NotificationService.addLog(
        endpoint: 'Otp verification',
        status: 'success',
        durationMs: stopwatch.elapsedMilliseconds,
        message: 'Otp verification successful  ',
      );

      print(
        "Here is the response of the verify otp fxn in lib/app_2/providers/auth_provider.dart: $response",
      );

      if (response['status'] == 'success') {
        // final finalToken = response['token'] ?? response['access_token'];
        final userData = response['user'];
        print('lib/app_2/providers/auth_provider.dart $userData');
        User? user;
        if (userData != null) {
          user = User.fromJson(userData);
        }

        await _saveToStorage(user: user);
        // await _saveToStorage(token: finalToken, user: user);

        state = state.copyWith(
          isLoading: false,
          // authToken: finalToken,
          isAuthenticated: true,
          pendingEmail: null,
          user: user,
        );
        print("AUTH STATE AFTER OTP:");
        print(state);
        print("User obj:");
        print(user?.toJson());

        // return true;
        // return true,state;
        return ApiResult(
          success: true,
          message: response['message'],
          data: user,
        );
      } else {
        final errorMessage = response['message'] ?? 'OTP verification failed';

        state = state.copyWith(
          isLoading: false,
          error: errorMessage,
          errorData: response,
        );
        // return false;
        return ApiResult(success: false, message: errorMessage);
      }
    } catch (e) {
      final errorMessage = e.toString();
      stopwatch.stop();
      // ref .read(notificationProvider.notifier)
      NotificationService.addLog(
        endpoint: 'Otp verification',
        status: 'error',
        durationMs: stopwatch.elapsedMilliseconds,
        message: errorMessage,
      );

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
        errorData: {'error': errorMessage},
      );

      return ApiResult(success: false, message: errorMessage);
    }
  }

  //   ApiResult.success(data)
  // ApiResult.error(message)
  // ApiResult.loading()

  Future<bool> requestPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, error: null, errorData: null);
    try {
      final response = await ApiService.requestPasswordReset(email);
      print('requestPasswordReset response: $response');

      if (response.status == 'success') {
        state = state.copyWith(
          isLoading: false,
          resetEmail: email,
          resetRequestSent: true,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Password reset request failed',
          errorData: {'message': response.message},
        );
        return false;
      }
    } catch (e) {
      String errorString = e.toString();
      Map<String, dynamic>? errorData;
      String displayMessage = errorString;

      // Try to parse JSON error from exception
      if (errorString.startsWith('Exception: ')) {
        errorString = errorString.substring(11);
      }
      try {
        final decoded = jsonDecode(errorString);
        if (decoded is Map<String, dynamic>) {
          displayMessage = decoded['message'] ?? 'Request failed';
          errorData = decoded;
        }
      } catch (_) {}

      state = state.copyWith(
        isLoading: false,
        error: displayMessage,
        errorData: errorData,
      );
      return false;
    }
  }

  Future<bool> confirmPasswordReset({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = state.copyWith(isLoading: true, error: null, errorData: null);
    try {
      final response = await ApiService.confirmPasswordReset(
        email: email,
        token: token,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      print('confirmPasswordReset response: $response');

      if (response.status == 'success') {
        state = state.copyWith(isLoading: false, resetRequestSent: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message ?? 'Password reset failed',
          errorData: response.errors ?? {'message': response.message},
        );
        return false;
      }
    } catch (e) {
      String errorString = e.toString();
      Map<String, dynamic>? errorData;
      String displayMessage = errorString;

      if (errorString.startsWith('Exception: ')) {
        errorString = errorString.substring(11);
      }
      try {
        final decoded = jsonDecode(errorString);
        if (decoded is Map<String, dynamic>) {
          displayMessage = decoded['message'] ?? 'Confirmation failed';
          errorData = decoded;
        }
      } catch (_) {}

      state = state.copyWith(
        isLoading: false,
        error: displayMessage,
        errorData: errorData,
      );
      return false;
    }
  }

  // void logout() async {
  Future<void> logout() async {
    await _clearStorage();
    // ref.invalidate(policiesProvider);
    Future.microtask(() {
      ref.invalidate(clientsProvider);
      ref.invalidate(policyProvider);
      ref.invalidate(motorProvider);
      ref.invalidate(certificateProvider);
      ref.invalidate(renewalProvider);
      ref.invalidate(statementProvider);
      ref.invalidate(appRouterProvider); //it creates the circular dep
      state = AuthState();
    });
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
