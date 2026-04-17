import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:insured/app_2/core/constants/app_strings.dart';
import 'package:insured/app_2/core/utils/haptic_helper.dart';
import 'package:insured/app_2/core/utils/responsive.dart';
import 'package:insured/app_2/features/onboarding/onboarding_page_model.dart';
import 'package:insured/app_2/features/onboarding/widgets/three_d_model_viewer.dart';
import 'package:insured/app_2/core/widgets/animated_orbs.dart';
import 'package:insured/app_2/core/widgets/grain_overlay.dart';
import 'package:insured/app_2/core/widgets/custom_advanced_button.dart';
import 'package:insured/app_2/core/widgets/page_dots.dart';
import 'package:go_router/go_router.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

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

    // _pageController = PageController()
    _pageController = PageController(initialPage: 0)
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(0); // ← force reset to first page on mount
    });

    _currentPage = 0;
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   _pageController.jumpToPage(0);
  //   _currentPage = 0;
  // }

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
            BackgroundGradients(),
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
                    height: size.height * 0.3,
                    child: Center(
                      // child: BackgroundGradients(),
                      // ThreeDModelViewer(
                      //   rotationY: _rotationY,
                      //   floatAnim: _floatAnim,
                      // ),
                    ),
                  ),

                  // Text + buttons
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: Responsive.isMobile(context)
                              ? double.infinity
                              : 500,
                        ),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: onboardingPages.length,
                          onPageChanged: _onPageChanged,
                          itemBuilder: (ctx, i) => _buildPageContent(i),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page dots
            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom + 30,
              left: 0,
              right: 0,
              child: PageDots(
                count: onboardingPages.length,
                current: _currentPage,
                activeColor: currentPageData.glowColor,
                onDotTapped: (index) {
                  HapticHelper.light();
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOutCubic,
                  );
                },
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
              fontSize: 32,
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
          const SizedBox(height: 30),
          isLast
              ? Column(
                  children: [
                    CustomAdvancedButton(
                          height: 44,
                          label: isLast
                              ? 'Get Started'
                              : AppStrings.continueWithPhone,
                          variant: ButtonVariant.secondary,
                          onPressed: _onContinue,
                        )
                        .animate()
                        .fadeIn(delay: 200.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 16),
                    // CustomAdvancedButton(
                    //       label: AppStrings.continueWithApple,
                    //       variant: ButtonVariant.apple,
                    //       onPressed: () => HapticHelper.medium(),
                    //     )
                    //     .animate()
                    //     .fadeIn(delay: 280.ms)
                    //     .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 18),
                    Text(
                      'By continuing, you agree to our Terms and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    if (!Responsive.isMobile(context)) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // GO TO PREVIOUS
                          if (_currentPage > 0)
                            CustomAdvancedButton(
                                  height: 40,
                                  width:
                                      _currentPage == onboardingPages.length - 1
                                      ? double.infinity
                                      : 200,
                                  label: 'PREVIOUS',
                                  variant: ButtonVariant.secondary,
                                  // icon: Icons.keyboard_double_arrow_left_sharp,
                                  icon: Icon(
                                    Icons.keyboard_double_arrow_left_sharp,
                                  ),

                                  onPressed: () {
                                    _pageController.previousPage(
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.easeInOutCubic,
                                    );
                                  },
                                )
                                .animate()
                                .fadeIn(delay: 150.ms)
                                .slideY(begin: 0.2, end: 0),

                          if (_currentPage > 0) const SizedBox(width: 16),

                          // GO TO NEXT
                          CustomAdvancedButton(
                                height: 40,
                                // width: 200,
                                width:
                                    _currentPage == onboardingPages.length - 1
                                    ? double.infinity
                                    : 200,
                                label:
                                    _currentPage == onboardingPages.length - 1
                                    ? 'GET STARTED'
                                    : 'NEXT',
                                iconRight: true,
                                variant: ButtonVariant.primary,
                                icon: Icon(
                                  Icons.keyboard_double_arrow_right_sharp,
                                ),
                                onPressed: _onContinue,
                              )
                              .animate()
                              .fadeIn(delay: 200.ms)
                              .slideY(begin: 0.2, end: 0),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        return Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: page.glowColor,
                              size: 60,
                              shadows: [
                                Shadow(
                                  color: page.glowColor.withOpacity(0.8),
                                  blurRadius: 15,
                                ),
                              ],
                            )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .fadeIn(
                              duration: 800.ms,
                              begin: 0.1,
                              curve: Curves.easeIn,
                              delay: (i * 400).ms,
                            )
                            .then(delay: 400.ms)
                            .fadeOut(duration: 800.ms);
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                          Responsive.isMobile(context)
                              ? 'JUST SWIPE'
                              : 'JUST TAP THE NEXT BUTTON',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .fadeIn(duration: 1.seconds),
                  ],
                ),
        ],
      ),
    );
  }
}

class BackgroundGradients extends StatelessWidget {
  const BackgroundGradients({super.key});

  @override
  Widget build(BuildContext context) {
    final String pathPrefix = kIsWeb && !kDebugMode ? 'assets/' : '';

    return Stack(
      children: [
        Container(color: const Color(0xFF0D1F1C)), // Base Dark Green
        Positioned(
          top: -100,
          right: -50,
          child: _GlowCircle(
            color: Colors.tealAccent.withOpacity(0.2),
            size: 400,
          ),
        ),
        Positioned(
          bottom: -50,
          left: -50,
          child: _GlowCircle(
            color: Colors.cyanAccent.withOpacity(0.15),
            size: 350,
          ),
        ),
        // Subtle Noise Overlay simulation
        Opacity(
          opacity: 0.3,

          // child: Image.network(
          //   'https://www.transparenttextures.com/patterns/asfalt-dark.png',
          //   repeat: ImageRepeat.repeat,
          //   height: double.infinity,
          //   width: double.infinity,
          // ),
          child: ModelViewer(
            backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
            // src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
            // src: 'assets/3d/Astronaut.glb',
            // src: 'assets/3d/padlock_closed.glb',
            src: '${pathPrefix}assets/3d/padlock_closed.glb',
            alt:
                'To simulate the strenght of Insured security, we use a 3D padlock model as a subtle background element.',
            ar: false,
            autoRotate: true,
            iosSrc:
                'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
            disableZoom: false,
            cameraControls:
                true, // Gestures like orbit (rotation), pan, or zoom require explicit permissions and can be blocked if cameraControls is false (as in your code).
          ),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final Color color;
  final double size;
  const _GlowCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}
