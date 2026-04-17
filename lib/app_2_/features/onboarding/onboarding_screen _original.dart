import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:insured/app_2/core/constants/app_strings.dart';
import 'package:insured/app_2/core/utils/haptic_helper.dart';
import 'package:insured/app_2/features/onboarding/onboarding_page_model.dart';
import 'package:insured/app_2/features/onboarding/widgets/three_d_model_viewer.dart';
import 'package:insured/app_2/core/widgets/animated_orbs.dart';
import 'package:insured/app_2/core/widgets/grain_overlay.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/page_dots.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _floatCtrl;
  late final Animation<double> _floatAnim;
  late final AnimationController _glowCtrl;
  late final AnimationController _shimmerCtrl; // ← renamed

  double _pageOffset = 0.0;
  double _rotationY = 0.0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12), // ← slow shimmer
    )..repeat(); // ← infinite loop

    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _pageOffset = _pageController.page ?? 0.0;
          _rotationY = _pageOffset * (pi / 6); // 30° per page
        });
      });

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOutSine));

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatCtrl.dispose();
    _glowCtrl.dispose();
    _shimmerCtrl.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    HapticHelper.light();
    setState(() => _currentPage = page);
  }

  void _onContinue() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // Last page -> go to login
      context.push('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final currentPageData = onboardingPages[_currentPage];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: currentPageData.bgGradient,
          ),
        ),
        child: Stack(
          children: [
            // Background orbs & grain
            AnimatedOrbs(
              glowColor: currentPageData.glowColor,
              shimmerCtrl: _shimmerCtrl,
            ),
            const GrainOverlay(),

            // PageView content
            SafeArea(
              child: Column(
                children: [
                  // 3D model area
                  SizedBox(
                    height: size.height * 0.5,
                    child: Center(
                      child: ThreeDModelViewer(
                        rotationY: _rotationY,
                        floatAnim: _floatAnim,
                      ),
                    ),
                  ),

                  // Text + buttons
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: onboardingPages.length,
                      onPageChanged: _onPageChanged,
                      itemBuilder: (ctx, i) => _buildPageContent(i),
                    ),
                  ),
                ],
              ),
            ),

            // Page dots
            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom + 80,
              left: 0,
              right: 0,
              child: PageDots(
                count: onboardingPages.length,
                current: _currentPage,
                activeColor: currentPageData.glowColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(int index) {
    final page = onboardingPages[index];
    final isLast = index == onboardingPages.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ).animate().fadeIn().slideY(begin: 0.1, end: 0),
          const SizedBox(height: 12),
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1, end: 0),
          const SizedBox(height: 40),
          CustomAdvancedButton(
            label: isLast ? 'Get Started' : AppStrings.continueWithPhone,
            variant: ButtonVariant.primary,
            onPressed: _onContinue,
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 16),
          CustomAdvancedButton(
            label: AppStrings.continueWithApple,
            variant: ButtonVariant.apple,
            onPressed: () => HapticHelper.medium(),
          ).animate().fadeIn(delay: 280.ms).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 24),
          Text(
            'By continuing, you agree to our Terms and Privacy Policy',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}
