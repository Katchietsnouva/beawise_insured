import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/animated_orbs.dart';
import 'package:insured/app_2/core/widgets/custom_text_Field.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastS.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastT.dart';
import 'package:insured/app_2/core/widgets/glass_card_auth.dart';
import 'package:insured/app_2/core/widgets/grain_overlay.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  late final AnimationController _shimmerCtrl;
  late final TextEditingController _emailCtrl;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final size = MediaQuery.sizeOf(context);

    return Theme(
      data: AppTheme.darkTheme,

      child: Scaffold(
        body: Container(
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [Color(0xFF0D1F1C), Color(0xFF0F3D3E), Color(0xFF145A32)],
          //   ),
          // ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.nice_grad_1,
                AppColors.nice_grad_3,
                AppColors.nice_grad_2,
              ],
            ),
          ),
          child: Stack(
            children: [
              AnimatedOrbs(
                glowColor: AppColors.animatedOrbsGlow,
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
                              'Forgot Password',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Enter your email address and we\'ll send you a code to reset your password.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: 24),
                            CustomTextField(
                              isRequired: true,
                              hint: 'Email',
                              hintLabel: 'yourname@gmail.com',
                              icon: Icons.email,
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 24),
                            CustomAdvancedButton(
                              label: _isSubmitting
                                  ? 'Sending...'
                                  : 'Send Reset Code',
                              variant: ButtonVariant.primary,
                              // loading: _isSubmitting || authState.isLoading,
                              loading: _isSubmitting,
                              onPressed: () async {
                                if (_emailCtrl.text.trim().isEmpty) {
                                  FuturisticToastT.show(
                                    context: context,
                                    message: 'Email is required',
                                    icon: Icons.warning,
                                    alignment: Alignment.topCenter,
                                  );
                                  return;
                                }

                                setState(() => _isSubmitting = true);
                                final success = await ref
                                    .read(authProvider.notifier)
                                    .requestPasswordReset(
                                      _emailCtrl.text.trim(),
                                    );

                                if (!mounted) {
                                  setState(() => _isSubmitting = false);
                                  return;
                                }

                                if (success) {
                                  FuturisticToastS.show(
                                    context: context,
                                    message: 'Reset code sent to your email',
                                    icon: Icons.check_circle,
                                    iconColor: Colors.greenAccent,
                                    alignment: Alignment.topCenter,
                                  );
                                  context.push(
                                    '/reset-password',
                                    extra: _emailCtrl.text.trim(),
                                  );
                                } else {
                                  final errorState = ref.read(authProvider);
                                  FuturisticToastT.show(
                                    context: context,
                                    message:
                                        // errorState.error ??
                                        // errorState. ??
                                        'Failed to send reset code',
                                    errors: errorState.errorData,
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
                                'Back to Login',
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
}
