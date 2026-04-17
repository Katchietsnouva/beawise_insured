import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/providers/settings_provider.dart';
import 'package:insured/app_2/providers/two_factor_provider.dart';
import 'package:insured/app_2/core/services/biometric_auth_service.dart';

/// Wrap any screen or action that should be protected by 2FA.
class TwoFactorGuard extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onAuthenticated; // optional callback after success

  const TwoFactorGuard({super.key, required this.child, this.onAuthenticated});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final twoFactorState = ref.watch(twoFactorProvider);

    // If 2FA not enabled in settings, or already authenticated this session, show child directly.
    if (!settings.twoFactorAuth || twoFactorState.isAuthenticatedThisSession) {
      return child;
    }

    // Otherwise, we need to authenticate before showing child.
    return FutureBuilder<bool>(
      future: BiometricAuthService.authenticate(
        reason:
            'Two‑factor authentication is enabled. Please verify your identity.',
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == true) {
          // Authentication succeeded
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(twoFactorProvider.notifier).setAuthenticated(true);
            onAuthenticated?.call();
          });
          return child;
        } else {
          // Authentication failed or was cancelled – show a message and maybe a retry button.
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 64,
                    color: Colors.white54,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Authentication required',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Two‑factor authentication is enabled. Please verify your identity.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => ref.refresh(twoFactorProvider),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
