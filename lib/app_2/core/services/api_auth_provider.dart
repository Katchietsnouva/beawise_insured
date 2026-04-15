// // lib/app_2/core/services/api_auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'api_service.dart'; // make sure this import points to your api_service.dart

final apiAuthProvider = StateNotifierProvider<ApiAuthNotifier, AuthApiState>(
  (ref) => ApiAuthNotifier(),
);

class AuthApiState {
  final bool loading;
  final String error;
  const AuthApiState({this.loading = false, this.error = ''});
  AuthApiState copyWith({bool? loading, String? error}) {
    return AuthApiState(
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}

class ApiAuthNotifier extends StateNotifier<AuthApiState> {
  ApiAuthNotifier() : super(const AuthApiState());

  Future<String> getAuthToken() async {
    state = state.copyWith(loading: true, error: '');
    try {
      // ✅ Call the actual API method, not itself
      final token = await ApiService.getAuthToken();
      return token;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_riverpod/legacy.dart';
// import 'package:insured/app_2/core/services/api_service.dart';

// // final apiAuthProvider = StateNotifierProvider<ApiAuthNotifier, AuthApiState>(
// //   (ref) => ApiAuthNotifier(),
// // );

// final apiAuthProvider = StateNotifierProvider<ApiAuthNotifier, AuthApiState>(
//   (ref) => ApiAuthNotifier(ref),
// );

// class AuthApiState {
//   final bool loading;
//   final String error;
//   const AuthApiState({this.loading = false, this.error = ''});
//   AuthApiState copyWith({bool? loading, String? error}) {
//     return AuthApiState(
//       loading: loading ?? this.loading,
//       error: error ?? this.error,
//     );
//   }
// }

// class ApiAuthNotifier extends StateNotifier<AuthApiState> {
//   // ApiAuthNotifier() : super(const AuthApiState());
//   final Ref ref; // <- store it

//   ApiAuthNotifier(this.ref) : super(const AuthApiState());

//   Future<String> getAuthToken() async {
//     state = state.copyWith(loading: true, error: '');
//     try {
//       // final token = await ApiService.getAuthToken(); // your existing service call
//       final token = await ref.read(apiAuthProvider.notifier).getAuthToken();
//       return token;
//     } catch (e) {
//       state = state.copyWith(error: e.toString());
//       rethrow;
//     } finally {
//       state = state.copyWith(loading: false);
//     }
//   }
// }
