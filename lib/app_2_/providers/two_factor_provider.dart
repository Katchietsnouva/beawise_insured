import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class TwoFactorState {
  final bool isAuthenticatedThisSession;
  TwoFactorState({this.isAuthenticatedThisSession = false});
}

class TwoFactorNotifier extends StateNotifier<TwoFactorState> {
  TwoFactorNotifier() : super(TwoFactorState());

  void setAuthenticated(bool value) {
    state = TwoFactorState(isAuthenticatedThisSession: value);
  }

  void reset() => state = TwoFactorState();
}

final twoFactorProvider =
    StateNotifierProvider<TwoFactorNotifier, TwoFactorState>((ref) {
      return TwoFactorNotifier();
    });
