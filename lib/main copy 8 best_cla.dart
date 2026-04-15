/// ============================================================
///  🌿 FLORA – Futuristic Glassmorphism Onboarding
///  Monolith main.dart – ready to drop into lib/
///  Dependencies needed in pubspec.yaml:
///    flutter_animate: ^4.5.0
///    google_fonts: ^6.2.1
///  Optional for real 3D: model_viewer_plus: ^1.8.0
///
///  The 3D plant is rendered here with a pure-Flutter layered
///  Canvas approach (no external 3D lib needed) so the file
///  compiles with zero extra deps beyond flutter_animate +
///  google_fonts. Swap the _PlantWidget for model_viewer_plus
///  if you have a real GLB file.
/// ============================================================

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

// ─────────────────────────────────────────────
// Entry
// ─────────────────────────────────────────────
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(const FloraApp());
}

// ─────────────────────────────────────────────
// App root
// ─────────────────────────────────────────────
class FloraApp extends StatelessWidget {
  const FloraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D1F1C),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FFB2),
          secondary: Color(0xFF00F0FF),
        ),
      ),
      home: const OnboardingScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// Data model for each page
// ─────────────────────────────────────────────
class _OnboardPage {
  final String title;
  final String subtitle;
  final Color glowColor;
  final List<Color> bgGradient;
  final double plantHue; // HSL hue shift for the plant tint

  const _OnboardPage({
    required this.title,
    required this.subtitle,
    required this.glowColor,
    required this.bgGradient,
    required this.plantHue,
  });
}

const List<_OnboardPage> _pages = [
  _OnboardPage(
    title: 'Welcome',
    subtitle: 'Scan plants, spot issues, and\nget instant care tips.',
    glowColor: Color(0xFF00FFB2),
    bgGradient: [Color(0xFF0D2318), Color(0xFF0F3D2E), Color(0xFF145A32)],
    plantHue: 0,
  ),
  _OnboardPage(
    title: 'Instant Diagnosis',
    subtitle: 'Point your camera at any leaf.\nOur AI tells you what\'s wrong.',
    glowColor: Color(0xFF00F0FF),
    bgGradient: [Color(0xFF0D1F2B), Color(0xFF0F3D50), Color(0xFF0F5A6A)],
    plantHue: 180,
  ),
  _OnboardPage(
    title: 'Smart Reminders',
    subtitle: 'Water, fertilise, repot – Flora\nnever lets you forget.',
    glowColor: Color(0xFFB2FF00),
    bgGradient: [Color(0xFF1A1F0D), Color(0xFF3D4A0F), Color(0xFF5A6814)],
    plantHue: 60,
  ),
];

// ─────────────────────────────────────────────
// Main onboarding screen
// ─────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();

  // Tracks fractional page scroll (0.0 … n-1) for smooth interpolation
  double _pageOffset = 0.0;

  // Float animation for the 3-D plant
  late final AnimationController _floatCtrl;
  late final Animation<double> _floatAnim;

  // Shimmer / light sweep animation
  late final AnimationController _shimmerCtrl;

  // Radial glow pulse
  late final AnimationController _glowCtrl;

  // Per-page rotate angle (accumulated)
  double _plantRotationY = 0.0; // radians
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() => _pageOffset = _pageController.page ?? 0.0);
    });

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOutSine));

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _glowCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatCtrl.dispose();
    _shimmerCtrl.dispose();
    _glowCtrl.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────
  Color _lerpColor(Color a, Color b, double t) => Color.lerp(a, b, t)!;

  Color get _currentGlow {
    final base = _pages[_currentPage].glowColor;
    if (_currentPage < _pages.length - 1) {
      final next = _pages[_currentPage + 1].glowColor;
      final frac = _pageOffset - _currentPage;
      return _lerpColor(base, next, frac.clamp(0, 1));
    }
    return base;
  }

  List<Color> get _currentBg {
    final base = _pages[_currentPage].bgGradient;
    if (_currentPage < _pages.length - 1) {
      final next = _pages[_currentPage + 1].bgGradient;
      final frac = (_pageOffset - _currentPage).clamp(0.0, 1.0);
      return List.generate(3, (i) => _lerpColor(base[i], next[i], frac));
    }
    return base;
  }

  void _onPageChanged(int page) {
    HapticFeedback.lightImpact();
    setState(() {
      // Accumulate 30° per page turn
      _plantRotationY += (page > _currentPage ? 1 : -1) * (math.pi / 6);
      _currentPage = page;
    });
  }

  void _goNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _showFinal();
    }
  }

  void _showFinal() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Text(
            '🌿 Welcome to Flora!',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 26,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bg = _currentBg;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: bg,
          ),
        ),
        child: Stack(
          children: [
            // ── Animated blurry orbs ───────────────
            _AnimatedOrbs(glowColor: _currentGlow, shimmerCtrl: _shimmerCtrl),

            // ── Noise grain overlay ────────────────
            const _GrainOverlay(),

            // ── PageView content ───────────────────
            SafeArea(
              child: Column(
                children: [
                  // ── 3-D plant area (top 55%) ───────
                  SizedBox(
                    height: size.height * 0.52,
                    child: _PlantSection(
                      floatAnim: _floatAnim,
                      glowCtrl: _glowCtrl,
                      glowColor: _currentGlow,
                      rotationY: _plantRotationY,
                      pageOffset: _pageOffset,
                    ),
                  ),

                  // ── Text + buttons (PageView) ──────
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _pages.length,
                      onPageChanged: _onPageChanged,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (ctx, i) => _PageContent(
                        page: _pages[i],
                        isLast: i == _pages.length - 1,
                        onNext: _goNext,
                        onApple: () => HapticFeedback.mediumImpact(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Page indicator dots ────────────────
            Positioned(
              bottom: MediaQuery.paddingOf(context).bottom + 80,
              left: 0,
              right: 0,
              child: _PageDots(
                count: _pages.length,
                current: _currentPage,
                activeColor: _currentGlow,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Animated blurry orbs background
// ─────────────────────────────────────────────
class _AnimatedOrbs extends StatelessWidget {
  final Color glowColor;
  final AnimationController shimmerCtrl;

  const _AnimatedOrbs({required this.glowColor, required this.shimmerCtrl});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AnimatedBuilder(
      animation: shimmerCtrl,
      builder: (_, __) {
        final t = shimmerCtrl.value;
        return Stack(
          children: [
            // Primary glow orb
            Positioned(
              top: size.height * 0.05 + math.sin(t * 2 * math.pi) * 20,
              left: size.width * 0.1 + math.cos(t * 2 * math.pi) * 15,
              child: _Orb(
                size: size.width * 0.85,
                color: glowColor.withOpacity(0.18),
                blur: 80,
              ),
            ),
            // Secondary accent orb
            Positioned(
              top: size.height * 0.3 + math.cos(t * 2 * math.pi) * 25,
              right: -size.width * 0.2,
              child: _Orb(
                size: size.width * 0.7,
                color: const Color(0xFF00F0FF).withOpacity(0.10),
                blur: 60,
              ),
            ),
            // Bottom ambient
            Positioned(
              bottom: -size.height * 0.05,
              left: size.width * 0.1,
              child: _Orb(
                size: size.width * 0.8,
                color: Colors.black.withOpacity(0.35),
                blur: 50,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  final double blur;

  const _Orb({required this.size, required this.color, required this.blur});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: color, blurRadius: blur, spreadRadius: blur * 0.3),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Grain overlay using CustomPainter
// ─────────────────────────────────────────────
class _GrainOverlay extends StatelessWidget {
  const _GrainOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: CustomPaint(painter: _GrainPainter()));
  }
}

class _GrainPainter extends CustomPainter {
  final _rng = math.Random(42);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.025);
    for (int i = 0; i < 2000; i++) {
      canvas.drawCircle(
        Offset(_rng.nextDouble() * size.width, _rng.nextDouble() * size.height),
        _rng.nextDouble() * 1.2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─────────────────────────────────────────────
// Plant section with 3-D perspective rotation
// ─────────────────────────────────────────────
class _PlantSection extends StatelessWidget {
  final Animation<double> floatAnim;
  final AnimationController glowCtrl;
  final Color glowColor;
  final double rotationY;
  final double pageOffset;

  const _PlantSection({
    required this.floatAnim,
    required this.glowCtrl,
    required this.glowColor,
    required this.rotationY,
    required this.pageOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Radial glow behind plant
        AnimatedBuilder(
          animation: glowCtrl,
          builder: (_, __) {
            final pulse = 0.85 + glowCtrl.value * 0.15;
            return Container(
              width: 260 * pulse,
              height: 260 * pulse,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    glowColor.withOpacity(0.22 * pulse),
                    Colors.transparent,
                  ],
                ),
              ),
            );
          },
        ),

        // Plant with float + Y-axis perspective rotation
        AnimatedBuilder(
          animation: floatAnim,
          builder: (_, child) {
            return Transform.translate(
              offset: Offset(0, floatAnim.value),
              child: child,
            );
          },
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: rotationY),
            duration: const Duration(milliseconds: 550),
            curve: Curves.easeInOutCubic,
            builder: (_, angle, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001) // perspective
                  ..rotateY(angle),
                child: child,
              );
            },
            child: const _PlantWidget(size: 260),
          ),
        ),

        // Soft drop shadow / ground reflection
        Positioned(
          bottom: 12,
          child: Container(
            width: 140,
            height: 18,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.45),
                  blurRadius: 24,
                  spreadRadius: 6,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Pure-Flutter 2.5D plant (no external 3D lib)
// Replace with model_viewer_plus for real GLB
// ─────────────────────────────────────────────
class _PlantWidget extends StatelessWidget {
  final double size;
  const _PlantWidget({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _PlantPainter()),
    );
  }
}

class _PlantPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // ── Pot body ────────────────────────────────
    final potGrad = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [const Color(0xFFD4CFC8), const Color(0xFFB0A89E)],
    );
    final potRect = Rect.fromCenter(
      center: Offset(cx, cy + 50),
      width: 90,
      height: 70,
    );
    final potRRect = RRect.fromRectAndCorners(
      potRect,
      topLeft: const Radius.circular(8),
      topRight: const Radius.circular(8),
      bottomLeft: const Radius.circular(20),
      bottomRight: const Radius.circular(20),
    );
    canvas.drawRRect(potRRect, Paint()..shader = potGrad.createShader(potRect));

    // Pot rim
    final rimPaint = Paint()
      ..color = const Color(0xFFE0DAD2)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + 15), width: 96, height: 18),
        const Radius.circular(9),
      ),
      rimPaint,
    );

    // Pot base ring
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(cx, cy + 82), width: 80, height: 12),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF3E2B1E),
    );

    // Highlight on pot
    final hlPaint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - 18, cy + 30), width: 20, height: 40),
      hlPaint,
    );

    // ── Stem ────────────────────────────────────
    final stemPaint = Paint()
      ..color = const Color(0xFF2D6A2D)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final stemPath = Path()
      ..moveTo(cx, cy + 14)
      ..cubicTo(cx - 10, cy - 20, cx + 10, cy - 50, cx, cy - 80);
    canvas.drawPath(stemPath, stemPaint);

    // ── Leaves ──────────────────────────────────
    _drawLeaf(
      canvas,
      cx,
      cy,
      pivotX: cx - 5,
      pivotY: cy - 45,
      angle: -0.9,
      scaleX: 1.0,
      scaleY: 1.0,
      baseColor: const Color(0xFF2E8B37),
      highlightColor: const Color(0xFF7FD964),
    );

    _drawLeaf(
      canvas,
      cx,
      cy,
      pivotX: cx + 5,
      pivotY: cy - 60,
      angle: 0.7,
      scaleX: -1.0,
      scaleY: 1.0,
      baseColor: const Color(0xFF3DA847),
      highlightColor: const Color(0xFF9FE87A),
    );

    _drawLeaf(
      canvas,
      cx,
      cy,
      pivotX: cx,
      pivotY: cy - 80,
      angle: -0.15,
      scaleX: 1.0,
      scaleY: 1.0,
      baseColor: const Color(0xFF1E7232),
      highlightColor: const Color(0xFF56C95F),
    );
  }

  void _drawLeaf(
    Canvas canvas,
    double cx,
    double cy, {
    required double pivotX,
    required double pivotY,
    required double angle,
    required double scaleX,
    required double scaleY,
    required Color baseColor,
    required Color highlightColor,
  }) {
    canvas.save();
    canvas.translate(pivotX, pivotY);
    canvas.rotate(angle);
    canvas.scale(scaleX, scaleY);

    // Leaf shape – monstera style with slits
    final path = Path()
      ..moveTo(0, 0)
      ..cubicTo(-55, -10, -70, -55, -30, -95)
      ..cubicTo(-10, -115, 20, -115, 35, -90)
      ..cubicTo(65, -50, 50, -5, 0, 0)
      ..close();

    // Slit 1
    final slit1 = Path()
      ..moveTo(-38, -60)
      ..lineTo(-55, -42)
      ..lineTo(-45, -38)
      ..lineTo(-28, -56)
      ..close();

    // Slit 2
    final slit2 = Path()
      ..moveTo(10, -80)
      ..lineTo(28, -65)
      ..lineTo(22, -60)
      ..lineTo(4, -75)
      ..close();

    // Gradient fill
    final grad = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [highlightColor, baseColor],
    );
    final bounds = path.getBounds();
    canvas.drawPath(path, Paint()..shader = grad.createShader(bounds));

    // Punch slits (simulate holes by drawing in bg color)
    // Use a semi-transparent very dark paint
    final slitPaint = Paint()..color = Colors.black.withOpacity(0.45);
    canvas.drawPath(slit1, slitPaint);
    canvas.drawPath(slit2, slitPaint);

    // Midrib vein
    final veinPaint = Paint()
      ..color = Colors.white.withOpacity(0.22)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final vein = Path()
      ..moveTo(0, 0)
      ..cubicTo(-10, -40, -15, -70, -5, -95);
    canvas.drawPath(vein, veinPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─────────────────────────────────────────────
// Per-page text + button content
// ─────────────────────────────────────────────
class _PageContent extends StatelessWidget {
  final _OnboardPage page;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onApple;

  const _PageContent({
    required this.page,
    required this.isLast,
    required this.onNext,
    required this.onApple,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Title
          Text(
                page.title,
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 34,
                  color: Colors.white,
                  height: 1.1,
                ),
              )
              .animate()
              .fadeIn(duration: 400.ms, curve: Curves.easeOut)
              .slideY(
                begin: 0.15,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOut,
              ),

          const SizedBox(height: 14),

          // Subtitle
          Text(
                page.subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.65),
                  height: 1.55,
                ),
              )
              .animate()
              .fadeIn(delay: 80.ms, duration: 400.ms)
              .slideY(begin: 0.15, end: 0, delay: 80.ms, duration: 400.ms),

          const SizedBox(height: 36),

          // Primary glass button
          _GlassButton(
                label: isLast ? 'Get Started' : 'Continue with Phone',
                isPrimary: true,
                onTap: onNext,
              )
              .animate()
              .fadeIn(delay: 150.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0, delay: 150.ms, duration: 400.ms),

          const SizedBox(height: 14),

          // Apple button
          _GlassButton(
                label: 'Continue with Apple',
                isPrimary: false,
                showApple: true,
                onTap: onApple,
              )
              .animate()
              .fadeIn(delay: 220.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0, delay: 220.ms, duration: 400.ms),

          const SizedBox(height: 20),

          // Legal text
          Text(
            'By pressing "Continue with…" you agree to our',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 11,
              color: Colors.white.withOpacity(0.35),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegalLink('Terms of service'),
              Text(
                ' and ',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.35),
                ),
              ),
              _LegalLink('privacy policy'),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegalLink extends StatelessWidget {
  final String text;
  const _LegalLink(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.dmSans(
        fontSize: 11,
        color: Colors.white.withOpacity(0.70),
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
        decorationColor: Colors.white.withOpacity(0.40),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Glass button with press animation
// ─────────────────────────────────────────────
class _GlassButton extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final bool showApple;
  final VoidCallback onTap;

  const _GlassButton({
    required this.label,
    required this.isPrimary,
    this.showApple = false,
    required this.onTap,
  });

  @override
  State<_GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<_GlassButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: widget.isPrimary
            ? _PrimaryButton(label: widget.label)
            : _SecondaryButton(
                label: widget.label,
                showApple: widget.showApple,
              ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  const _PrimaryButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFFFFF), Color(0xFFEEEEEE)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.12),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final bool showApple;
  const _SecondaryButton({required this.label, required this.showApple});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white.withOpacity(0.10),
            border: Border.all(color: Colors.white.withOpacity(0.22)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showApple) ...[
                const Icon(Icons.apple, color: Colors.white, size: 22),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Page indicator dots
// ─────────────────────────────────────────────
class _PageDots extends StatelessWidget {
  final int count;
  final int current;
  final Color activeColor;

  const _PageDots({
    required this.count,
    required this.current,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: active ? activeColor : Colors.white.withOpacity(0.25),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: activeColor.withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}
