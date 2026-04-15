// lib/app_2/core/services/get_auth.dart
import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'package:insured/app_2/core/constants/url_cosntants.dart';

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
      final response = await http.post(
        Uri.parse(InscloudUrls.auth),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'inscloudkey': InscloudUrls.inscloudkey,
          'passkey': InscloudUrls.inscloudpasskey,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        final message = data['message'] ?? 'Auth failed';
        state = state.copyWith(error: 'Authentication error: $message');
        throw Exception(message);
      }

      return data['token'];
    } catch (e) {
      state = state.copyWith(error: 'Failed to authenticate: ${e.toString()}');
      rethrow;
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}




// | React Hook                    | Flutter Riverpod          |
// | ----------------------------- | ------------------------- |
// | useState                      | StateNotifier state       |
// | useCallback                   | method in notifier        |
// | return { loading, error, fn } | provider state + notifier |
// | setLoading                    | state.copyWith            |
// | throw error                   | throw Exception           |



// ✅ 3️⃣ How To Use It (Like Your Hook)

// Inside a ConsumerWidget or ConsumerStatefulWidget:

// final authState = ref.watch(apiAuthProvider);

// await ref.read(apiAuthProvider.notifier).getAuthToken();

// Access:

// authState.loading
// authState.error

// Exactly like:

// loading
// error
// getAuthToken()