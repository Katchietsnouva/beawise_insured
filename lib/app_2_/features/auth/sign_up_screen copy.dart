import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:insured/app_2/core/constants/app_colors.dart';
import 'package:insured/app_2/core/constants/app_strings.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/features/onboarding/widgets/three_d_model_viewer.dart';
import 'package:insured/app_2/core/widgets/animated_orbs.dart';
import 'package:insured/app_2/core/widgets/grain_overlay.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final Animation<double> _floatAnim;
  late final AnimationController _shimmerCtrl;

  late final TextEditingController _emailCtrl;
  late final TextEditingController _passwordCtrl;
  late final TextEditingController _confirmPasswordCtrl;

  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
    _confirmPasswordCtrl = TextEditingController();

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12), // ← slow shimmer
    )..repeat();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(
      begin: -5,
      end: 5,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOutSine));
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _floatCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
          if (_isFocused) {
            setState(() => _isFocused = false);
          }
        },
        child: Container(
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
              Positioned(
                top: 16,
                left: 16,
                child: SafeArea(
                  child: IconButton(
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      context.go('/onboarding'); // or '/' if onboarding is root
                    },
                  ),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    // 3D model
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: size.height * (_isFocused ? 0.1 : 0.30),
                      child: Center(
                        child: ThreeDModelViewer(
                          rotationY: 1.0,
                          floatAnim: _floatAnim,
                          isLogin: false, // Adjusted for sign-up
                        ),
                      ),
                    ),
                    // Glass card
                    Expanded(
                      child: Center(
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: Responsive.isMobile(context)
                                  ? double.infinity
                                  : 500,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              child: GlassCard(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Already have an account? ",
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => context.go('/login'),
                                          child: const Text(
                                            "Login",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    // Email field
                                    _buildTextField(
                                      'Email',
                                      Icons.email,
                                      controller: _emailCtrl,
                                    ),
                                    const SizedBox(height: 10),
                                    // Password field
                                    _buildTextField(
                                      'Password',
                                      Icons.lock,
                                      obscureText: true,
                                      controller: _passwordCtrl,
                                    ),
                                    const SizedBox(height: 10),
                                    // Confirm Password field
                                    _buildTextField(
                                      'Confirm Password',
                                      Icons.lock_outline,
                                      obscureText: true,
                                      controller: _confirmPasswordCtrl,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomAdvancedButton(
                                      label: 'Sign Up', // Adjusted label
                                      variant: ButtonVariant.primary,
                                      onPressed: () {
                                        // TODO: validate and create account
                                        if (_passwordCtrl.text ==
                                            _confirmPasswordCtrl.text) {
                                          // Proceed with sign-up logic
                                          context.push('/dashboard');
                                        } else {
                                          // Handle mismatch (e.g., show error)
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Or Continue With',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomAdvancedButton(
                                            height: 14,
                                            label: AppStrings.continueWithApple,
                                            variant: ButtonVariant.apple,
                                            onPressed: () {},
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: CustomAdvancedButton(
                                            iconRight: true,
                                            height: 10,
                                            label: "Google",
                                            variant: ButtonVariant.google,
                                            onPressed: () {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon, {
    bool obscureText = false,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        onTap: () {
          if (Responsive.isMobile(context)) {
            setState(() => _isFocused = true);
          }
        },
        onEditingComplete: () {
          setState(() => _isFocused = false);
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}
