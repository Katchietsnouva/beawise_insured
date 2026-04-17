import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insured/app_2/core/theme/app_theme.dart';
import 'package:insured/app_2/core/widgets/custom_otp.dart';
import 'package:insured/app_2/core/widgets/custom_text.dart';
import 'package:insured/app_2/core/widgets/futuristic_toastT.dart';
import 'package:insured/app_2/core/widgets/glass_card_auth.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/animated_orbs.dart';
import 'package:insured/app_2/core/widgets/grain_overlay.dart';

import 'package:insured/app_2/core/widgets/response_display.dart';
import 'package:insured/app_2/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen>
    with TickerProviderStateMixin {
  bool _isVerifying = false;
  final TextEditingController _otpController = TextEditingController();
  late final AnimationController _shimmerCtrl;

  @override
  void initState() {
    super.initState();

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
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
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: GlassCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            'Verify OTP',
                            type: CustomTextType.header,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 8),
                          Opacity(
                            opacity: 0.7,
                            child: CustomText(
                              'Enter the 6-digit code sent to  ',
                              // textAlign: TextAlign.center,
                              type: CustomTextType.paragraph,
                              color: Colors.white,
                            ),
                          ),
                          CustomText(
                            '${authState.pendingEmail ?? 'your email'}',
                            // textAlign: TextAlign.center,
                            type: CustomTextType.subHeader,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 24),
                          // CustomTextField( hint: 'OTP Code', icon: Icons.lock_outline, controller: _otpController, keyboardType: TextInputType.number),
                          OTPInput(
                            length: 6,
                            controller: _otpController,
                            isRequired: true,
                            onCompleted: (otp) {
                              print('Entered OTP: $otp');
                              // Use the OTP value, e.g., submit to API
                            },
                          ),
                          const SizedBox(height: 16),
                          // if (authState.error != null)
                          //   Padding(
                          //     padding: const EdgeInsets.only(bottom: 8),
                          //     child: Text(
                          //       authState.error!,
                          //       style: const TextStyle(color: Colors.redAccent),
                          //     ),
                          //   ),
                          CustomAdvancedButton(
                            label: _isVerifying ? 'Verifying...' : 'Verify',
                            // label: 'Verify',
                            variant: ButtonVariant.primary,
                            loading: _isVerifying,
                            onPressed: _isVerifying
                                ? () {}
                                : () async {
                                    setState(() => _isVerifying = true);
                                    final result = await authNotifier.verifyOtp(
                                      _otpController.text.trim(),
                                    );
                                    print(
                                      'This is the result after logging in via otp success $result',
                                    );

                                    print(
                                      'This is the json fprmat$jsonEncode($result)',
                                    );

                                    print(
                                      'JSON format 2: $jsonEncode($result)',
                                    );

                                    if (!mounted) {
                                      setState(() => _isVerifying = false);
                                      return;
                                    }

                                    if (result.success) {
                                      // FuturisticToastS.show(
                                      //   context: context, message: result.message ?? 'Login successful!',
                                      //   icon: Icons.check_circle, iconColor: Colors.greenAccent, duration: const Duration(seconds: 2),
                                      // );
                                      context.go('/dashboard');
                                    } else {
                                      // Show error toast using errorData
                                      final errorState = ref.read(authProvider);
                                      final errorData = errorState.errorData;
                                      print(
                                        "Printing errorState ${errorState}",
                                      );
                                      print("Printing errorData ${errorData}");

                                      Widget toastContent;
                                      if (errorData != null) {
                                        toastContent = ResponseDisplay.error(
                                          message:
                                              errorData['message'] ??
                                              'OTPP verification failed',
                                          rawData: errorData,
                                        );
                                      } else {
                                        toastContent = ResponseDisplay.error(
                                          message:
                                              errorState.error ??
                                              'Verification failed',
                                          rawData: {},
                                        );
                                      }
                                      setState(() => _isVerifying = false);

                                      String displayMessage =
                                          errorState.error ??
                                          'Verification failed';
                                      Map<String, dynamic>? errorMap;
                                      Map<String, dynamic>?
                                      rawJson; // NEW: To hold the full parsed JSON for copying

                                      if (errorData != null &&
                                          errorData is Map<String, dynamic> &&
                                          errorData.containsKey('error')) {
                                        String errorString = errorData['error']
                                            .toString()
                                            .trim();
                                        if (errorString.startsWith(
                                          'Exception: ',
                                        )) {
                                          errorString = errorString
                                              .substring(11)
                                              .trim(); // Strip "Exception: "
                                        }

                                        try {
                                          final decoded = jsonDecode(
                                            errorString,
                                          );
                                          if (decoded is Map<String, dynamic>) {
                                            displayMessage =
                                                decoded['message'] ??
                                                'OTP verification failed';
                                            rawJson =
                                                decoded; // Store full JSON for copying

                                            if (decoded['errors'] is Map) {
                                              errorMap =
                                                  (decoded['errors'] as Map)
                                                      .map(
                                                        (key, value) =>
                                                            MapEntry(
                                                              key.toString(),
                                                              List<String>.from(
                                                                value ?? [],
                                                              ),
                                                            ),
                                                      );
                                            }
                                          }
                                        } catch (_) {
                                          displayMessage =
                                              errorString; // Fallback if not JSON
                                        }
                                      }

                                      // FuturisticToast.showWidget(
                                      //   context: context,
                                      //   child: toastContent,
                                      //   duration: const Duration(seconds: 5),
                                      //   alignment: Alignment.topCenter,
                                      // );
                                      FuturisticToastT.show(
                                        context: context,
                                        message: displayMessage,
                                        // errors: errorMap,
                                        errors: errorMap ?? rawJson,
                                        icon: Icons.gpp_bad_outlined,
                                        alignment: Alignment.topCenter,
                                        duration: const Duration(seconds: 6),
                                      );
                                    }
                                  },
                          ),
                          const SizedBox(height: 16),
                          CustomAdvancedButton(
                            width: 170,
                            height: 40,
                            label: "Back to Login",
                            variant: ButtonVariant.secondary,
                            onPressed: () {
                              context.pop();
                            },
                            // child: const CustomText(
                            //   'Back to Login',
                            //   type: CustomTextType.paragraph,
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
