import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insured/app_2/core/constants/app_colors.dart';
import 'package:insured/app_2/core/services/memory_cache.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/utils/error_parser.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/animated_orbs.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastS.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastT.dart';
import 'package:insured/app_2/core/widgets/glass_card.dart';
import 'package:insured/app_2/core/widgets/grain_overlay.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? email; // passed from previous screen
  const ResetPasswordScreen({super.key, this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen>
    with TickerProviderStateMixin {
  late final AnimationController _shimmerCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _tokenCtrl;
  late final TextEditingController _passwordCtrl;
  late final TextEditingController _confirmPasswordCtrl;
  bool _isSubmitting = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.email ?? '');
    _tokenCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _confirmPasswordCtrl = TextEditingController();

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _emailCtrl.dispose();
    _tokenCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Theme(
      data: AppTheme.darkTheme,

      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D1F1C), Color(0xFF0F3D3E), Color(0xFF145A32)],
            ),
          ),
          child: Stack(
            children: [
              AnimatedOrbs(
                glowColor: AppColors.mint,
                shimmerCtrl: _shimmerCtrl,
              ),
              const GrainOverlay(),
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: Responsive.isMobile(context)
                            ? double.infinity
                            : 500,
                      ),
                      child: GlassCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Enter the code sent to your email and your new password.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 24),
                            CustomTextField(
                              isRequired: true,
                              hint: 'Email',
                              icon: Icons.email,
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              enabled: widget.email == null,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              isRequired: true,
                              hint: 'Reset Code (from email)',
                              icon: Icons.vpn_key,
                              controller: _tokenCtrl,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              isRequired: true,
                              hint: 'New Password',
                              icon: Icons.lock,
                              obscureText: _obscurePassword,
                              controller: _passwordCtrl,
                              // suffixIcon: IconButton(
                              //   icon: Icon(
                              //     _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              //     color: Colors.white70,
                              //   ),
                              //   onPressed: () {
                              //     setState(() => _obscurePassword = !_obscurePassword);
                              //   },
                              // ),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              isRequired: true,
                              hint: 'Confirm New Password',
                              icon: Icons.lock_outline,
                              obscureText: _obscureConfirm,
                              controller: _confirmPasswordCtrl,
                              // suffixIcon: IconButton(
                              //   icon: Icon(
                              //     _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                              //     color: Colors.white70,
                              //   ),
                              //   onPressed: () {
                              //     setState(() => _obscureConfirm = !_obscureConfirm);
                              //   },
                              // ),
                            ),
                            const SizedBox(height: 24),
                            CustomAdvancedButton(
                              label: _isSubmitting
                                  ? 'Resetting...'
                                  : 'Reset Password',
                              variant: ButtonVariant.primary,
                              loading: _isSubmitting || authState.isLoading,
                              onPressed: () async {
                                // Validation
                                if (_emailCtrl.text.trim().isEmpty) {
                                  _showError('Email is required');
                                  return;
                                }
                                if (_tokenCtrl.text.trim().isEmpty) {
                                  _showError('Reset code is required');
                                  return;
                                }
                                if (_passwordCtrl.text.isEmpty) {
                                  _showError('Password is required');
                                  return;
                                }
                                if (_passwordCtrl.text !=
                                    _confirmPasswordCtrl.text) {
                                  _showError('Passwords do not match');
                                  return;
                                }
                                if (_passwordCtrl.text.length < 8) {
                                  _showError(
                                    'Password must be at least 8 characters',
                                  );
                                  return;
                                }

                                setState(() => _isSubmitting = true);
                                final success = await ref
                                    .read(authProvider.notifier)
                                    .confirmPasswordReset(
                                      email: _emailCtrl.text.trim(),
                                      token: _tokenCtrl.text.trim(),
                                      password: _passwordCtrl.text,
                                      passwordConfirmation:
                                          _confirmPasswordCtrl.text,
                                    );

                                if (!mounted) {
                                  setState(() => _isSubmitting = false);
                                  return;
                                }

                                if (success) {
                                  final loginCache = ref.read(
                                    loginCacheProvider,
                                  );
                                  loginCache.put(
                                    'rememberedEmail',
                                    _emailCtrl.text.trim(),
                                  );

                                  FuturisticToastS.show(
                                    context: context,
                                    message:
                                        'Password reset successful! Please login.',
                                    icon: Icons.check_circle,
                                    iconColor: Colors.greenAccent,
                                    alignment: Alignment.topCenter,
                                  );
                                  // Navigate to login after a short delay
                                  Future.delayed(
                                    const Duration(seconds: 2),
                                    () {
                                      // if (mounted) context.go('/login');
                                      if (mounted)
                                        context.go(
                                          '/login',
                                          extra: _emailCtrl.text.trim(),
                                        );
                                    },
                                  );
                                } else {
                                  // // final errorState = ref.read(authProvider);
                                  // // FuturisticToastT.show(
                                  // //   context: context,
                                  // //   message:
                                  // //       errorState.error ??
                                  // //       'Password reset failed',
                                  // //   errors: errorState.errorData,
                                  // //   icon: Icons.error,
                                  // //   iconColor: Colors.redAccent,
                                  // //   alignment: Alignment.topCenter,
                                  // // );

                                  // final errorState = ref.read(authProvider);

                                  // Map<String, dynamic>? errorMap;
                                  // String displayMessage =
                                  //     errorState.error ?? 'Password reset failed';

                                  // if (errorState.errorData != null &&
                                  //     errorState.errorData
                                  //         is Map<String, dynamic>) {
                                  //   final decoded =
                                  //       errorState.errorData
                                  //           as Map<String, dynamic>;
                                  //   displayMessage =
                                  //       decoded['message'] ?? displayMessage;

                                  //   // Extract the actual field errors (e.g., {"password": [...]})
                                  //   if (decoded['errors'] is Map) {
                                  //     errorMap = (decoded['errors'] as Map).map(
                                  //       (key, value) => MapEntry(
                                  //         key.toString(),
                                  //         value is List
                                  //             ? List<String>.from(value)
                                  //             : [value.toString()],
                                  //       ),
                                  //     );
                                  //   }
                                  // }

                                  // FuturisticToastT.show(
                                  //   context: context,
                                  //   message: displayMessage,
                                  //   errors:
                                  //       errorMap, // ✅ only the field errors, not the whole response
                                  //   icon: Icons.error,
                                  //   iconColor: Colors.redAccent,
                                  //   alignment: Alignment.topCenter,
                                  // );
                                  final errorState = ref.read(authProvider);

                                  final parsed = ErrorParser.fromDynamic(
                                    errorState.errorData ?? errorState.error,
                                  );

                                  FuturisticToastT.show(
                                    context: context,
                                    message: parsed.message,
                                    errors: parsed
                                        .errors, // ✅ only the field errors, not the whole response
                                    icon: Icons.error,
                                    iconColor: Colors.redAccent,
                                    alignment: Alignment.topCenter,
                                  );
                                }
                                setState(() => _isSubmitting = false);
                              },
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text(
                                'Back',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                    size: 40,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    FuturisticToastT.show(
      context: context,
      message: message,
      icon: Icons.warning,
      iconColor: Colors.orangeAccent,
      alignment: Alignment.topCenter,
    );
  }
}
