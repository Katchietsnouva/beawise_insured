niiice bro this is so perfect s o i want us to capita;ose nase pm tjese 2 super ideas. draw inspiratio from the following code bro:


import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart'; // Add to pubspec.yaml: model_viewer_plus: ^latest

void main() {
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
return const MaterialApp(
debugShowCheckedModeBanner: false,
home: OnboardingScreen(),
);
}
}

class OnboardingScreen extends StatefulWidget {
const OnboardingScreen({super.key});

@override
State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
with TickerProviderStateMixin {
final PageController _pageController = PageController();
late AnimationController _floatController;
double _rotation = 0.0;

@override
void initState() {
super.initState();
_floatController = AnimationController(
vsync: this,
duration: const Duration(seconds: 4),
)..repeat(reverse: true);
_pageController.addListener(() {
setState(() {
_rotation =
(_pageController.page ?? 0) * -30.0; // Rotate left on swipe left
});
});
}

@override
void dispose() {
_floatController.dispose();
_pageController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
body: Stack(
fit: StackFit.expand,
children: [
// Background gradient
Container(
decoration: const BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topCenter,
end: Alignment.bottomCenter,
colors: [
  Color(0xFF0D1F1C),
  Color(0xFF0F3D3E),
  Color(0xFF145A32),
],
),
),
),
// Subtle noise overlay (simulated with semi-transparent white for now; can add texture image)
Container(color: Colors.white.withOpacity(0.02)),
// PageView for content
PageView(
controller: _pageController,
children: const [
OnboardingPageContent(
title: 'Welcome',
subtitle:
    'Scan plants, spot issues, and get instant care tips.',
),
OnboardingPageContent(
title: 'Discover Plants',
subtitle:
    'Explore a world of greenery with advanced AI scanning.',
),
OnboardingPageContent(
title: 'Care Tips',
subtitle:
    'Receive personalized advice to keep your plants thriving.',
),
],
),
// Fixed 3D model with rotation and floating
Positioned(
top: 100,
left: 0,
right: 0,
child: Center(
child: Stack(
alignment: Alignment.center,
children: [
  // Radial glow behind model
  Container(
    width: 300,
    height: 300,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [
          const Color(0xFF00FFB2).withOpacity(0.2),
          Colors.transparent,
        ],
      ),
    ),
  ),
  AnimatedBuilder(
    animation: _floatController,
    builder: (context, child) {
      return Transform.translate(
        offset: Offset(
          0,
          10 * sin(_floatController.value * 2 * pi),
        ),
        child: child,
      );
    },
    child: SizedBox(
      width: 300,
      height: 300,
      child: ModelViewer(
        backgroundColor: Colors.transparent,
        src:
            // 'https://modelviewer.dev/shared-assets/models/NeilArmstrong.glb', // Replace with Monstera GLB, e.g., download from https://sketchfab.com/3d-models/monstera-plant-33af1f66afed48719fed468036f2a083 and host
            // 'https://sketchfab.com/3d-models/monstera-plant-33af1f66afed48719fed468036f2a083',
            // 'assets/3d/monstera_plant.glb',
            'assets/3d/padlock_closed.glb',
        // 'assets/3d/Astronaut.glb',
        alt:
            'To simulate the strenght of Insured security, we use a 3D padlock model as a subtle background element.',
        autoRotate: true,
        rotationPerSecond: '100.5',
        cameraControls: false,
        // disableZoom: true,
        // orientation: '0deg ${_rotation}deg 0deg',
        ar: false,
        exposure: 1.2,
        shadowIntensity: 1.0,
      ),
    ),
  ),
],
),
),
),
],
),
);
}
}

class OnboardingPageContent extends StatelessWidget {
final String title;
final String subtitle;

const OnboardingPageContent({
super.key,
required this.title,
required this.subtitle,
});

@override
Widget build(BuildContext context) {
return SafeArea(
child: Column(
mainAxisAlignment: MainAxisAlignment.end,
children: [
const SizedBox(height: 400), // Space for the fixed 3D model
// Glass card
Padding(
padding: const EdgeInsets.symmetric(horizontal: 32.0),
child: ClipRRect(
borderRadius: BorderRadius.circular(32),
child: BackdropFilter(
filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
child: Container(
  padding: const EdgeInsets.all(24),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.1),
    border: Border.all(color: Colors.white.withOpacity(0.2)),
    borderRadius: BorderRadius.circular(32),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        spreadRadius: 5,
      ),
    ],
  ),
  child: Column(
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 8),
      Text(
        subtitle,
        style: TextStyle(
          fontSize: 18,
          color: Colors.white.withOpacity(0.8),
        ),
        textAlign: TextAlign.center,
      ),
    ],
  ),
),
),
),
),
const SizedBox(height: 32),
// Primary button: Continue with Phone
Padding(
padding: const EdgeInsets.symmetric(horizontal: 32.0),
child: GlassButton(
text: 'Continue with Phone',
gradient: const LinearGradient(
colors: [Color(0xFF145A32), Color(0xFF00F0FF)],
),
onPressed: () {
// TODO: Handle continue with phone
HapticFeedback.lightImpact();
},
),
),
const SizedBox(height: 16),
// Secondary button: Continue with Apple
Padding(
padding: const EdgeInsets.symmetric(horizontal: 32.0),
child: GlassButton(
text: 'Continue with Apple',
icon: const Icon(Icons.apple, color: Colors.white),
gradient: LinearGradient(
colors: [
  Colors.white.withOpacity(0.1),
  Colors.white.withOpacity(0.05),
],
),
onPressed: () {
// TODO: Handle continue with Apple
HapticFeedback.lightImpact();
},
),
),
const SizedBox(height: 16),
// Terms text
Text(
'By pressing on Continue with... you agree to our Terms of Service and Privacy Policy',
style: TextStyle(
fontSize: 12,
color: Colors.white.withOpacity(0.6),
),
textAlign: TextAlign.center,
),
const SizedBox(height: 32),
],
),
);
}
}

class GlassButton extends StatefulWidget {
final String text;
final LinearGradient gradient;
final VoidCallback onPressed;
final Icon? icon;

const GlassButton({
super.key,
required this.text,
required this.gradient,
required this.onPressed,
this.icon,
});

@override
State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
with SingleTickerProviderStateMixin {
late AnimationController _scaleController;
late Animation<double> _scaleAnimation;

@override
void initState() {
super.initState();
_scaleController = AnimationController(
vsync: this,
duration: const Duration(milliseconds: 200),
);
_scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
);
}

@override
void dispose() {
_scaleController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return GestureDetector(
onTapDown: (_) {
_scaleController.forward();
},
onTapUp: (_) {
_scaleController.reverse();
widget.onPressed();
},
onTapCancel: () {
_scaleController.reverse();
},
child: ScaleTransition(
scale: _scaleAnimation,
child: ClipRRect(
borderRadius: BorderRadius.circular(28),
child: BackdropFilter(
filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
child: Container(
padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
decoration: BoxDecoration(
gradient: widget.gradient,
border: Border.all(color: Colors.white.withOpacity(0.2)),
borderRadius: BorderRadius.circular(28),
boxShadow: [
  BoxShadow(
    color: const Color(0xFF00FFB2).withOpacity(0.1),
    blurRadius: 10,
    spreadRadius: 2,
  ),
],
),
child: Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
  if (widget.icon != null) ...[
    widget.icon!,
    const SizedBox(width: 8),
  ],
  Text(
    widget.text,
    style: const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
  ),
],
),
),
),
),
),
);
}
}



import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

import 'package:model_viewer_plus/model_viewer_plus.dart';

void main() {
runApp(const GlassPlantApp());
}

class GlassPlantApp extends StatelessWidget {
const GlassPlantApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
theme: ThemeData(brightness: Brightness.dark),
home: const GlassOnboardingScreen(),
);
}
}

class GlassOnboardingScreen extends StatefulWidget {
const GlassOnboardingScreen({super.key});

@override
State<GlassOnboardingScreen> createState() => _GlassOnboardingScreenState();
}

class _GlassOnboardingScreenState extends State<GlassOnboardingScreen>
with SingleTickerProviderStateMixin {
late PageController _pageController;
double _currentPage = 0.0;
late AnimationController _floatController;

@override
void initState() {
super.initState();
_pageController = PageController()
..addListener(() {
setState(() {
_currentPage = _pageController.page ?? 0;
});
});

_floatController = AnimationController(
duration: const Duration(seconds: 3),
vsync: this,
)..repeat(reverse: true);
}

@override
void dispose() {
_pageController.dispose();
_floatController.dispose();
super.dispose();
}

@override
Widget build(BuildContext context) {
return Scaffold(
body: Stack(
children: [
// 1. Deep Futuristic Background
const BackgroundGradients(),

// 2. Animated 3D Object (The Plant)
Positioned(
top: MediaQuery.of(context).size.height * 0.15,
left: 0,
right: 0,
child: AnimatedBuilder(
animation: _floatController,
builder: (context, child) {
// Combine floating animation with 3D rotation
double floatValue = _floatController.value * 20;
return Transform(
  alignment: Alignment.center,
  transform: Matrix4.identity()
    ..setEntry(3, 2, 0.001) // Perspective
    ..rotateY((_currentPage * 0.5)) // Rotate based on scroll
    ..translate(0.0, floatValue, 0.0),
  child: Center(
    // child: Image.network(
    //   'https://i.imgur.com/8666nIn.png', // Transparent Monstera placeholder
    //   height: 300,
    //   fit: BoxFit.contain,
    // ),
    child: ModelViewer(
      backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
      // src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
      src: 'assets/3d/Astronaut.glb',
      alt: 'A 3D model of an astronaut',
      ar: true,
      autoRotate: true,
      iosSrc:
          'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
      disableZoom: true,
    ),
  ),
);
},
),
),

// 3. Glass Content Layer
PageView(
controller: _pageController,
children: [
_buildPage(
title: "Welcome to\nNature's Future",
subtitle:
    "Scan plants, spot issues, and get\ninstant AI-powered care tips.",
),
_buildPage(
title: "Deep Health\nDiagnostics",
subtitle:
    "Our neural sensors detect pests and\nnutrient deficiencies in seconds.",
),
_buildPage(
title: "Join the\nGreen Verse",
subtitle:
    "Connect with millions of growers\nin the ultimate plant community.",
),
],
),

// 4. Bottom Glass Buttons
Positioned(
bottom: 60,
left: 30,
right: 30,
child: Column(
children: [
_buildGlassButton(
  text: "Continue with Phone",
  isPrimary: true,
  onPressed: () {},
),
const SizedBox(height: 16),
_buildGlassButton(
  text: "Continue with Apple",
  isPrimary: false,
  icon: Icons.apple,
  onPressed: () {},
),
const SizedBox(height: 20),
Text(
  "By pressing continue, you agree to our Terms",
  style: TextStyle(
    color: Colors.white.withOpacity(0.4),
    fontSize: 12,
  ),
),
],
),
),
],
),
);
}

Widget _buildPage({required String title, required String subtitle}) {
return Padding(
padding: const EdgeInsets.symmetric(horizontal: 40),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const SizedBox(height: 250), // Space for the 3D plant
Text(
title,
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 32,
fontWeight: FontWeight.bold,
letterSpacing: -1,
color: Colors.white,
),
),
const SizedBox(height: 16),
Text(
subtitle,
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 16,
height: 1.5,
color: Colors.white.withOpacity(0.7),
),
),
],
),
);
}

Widget _buildGlassButton({
required String text,
required bool isPrimary,
IconData? icon,
required VoidCallback onPressed,
}) {
return ClipRRect(
borderRadius: BorderRadius.circular(20),
child: BackdropFilter(
filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
child: GestureDetector(
onTap: onPressed,
child: Container(
width: double.infinity,
padding: const EdgeInsets.symmetric(vertical: 18),
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: Colors.white.withOpacity(0.2),
width: 1.5,
),
gradient: isPrimary
  ? LinearGradient(
      colors: [
        Colors.tealAccent.withOpacity(0.6),
        Colors.cyanAccent.withOpacity(0.4),
      ],
    )
  : LinearGradient(
      colors: [
        Colors.white.withOpacity(0.1),
        Colors.white.withOpacity(0.05),
      ],
    ),
),
child: Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
if (icon != null) ...[
  Icon(icon, color: Colors.white),
  const SizedBox(width: 10),
],
Text(
  text,
  style: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.w600,
    fontSize: 16,
  ),
),
],
),
),
),
),
);
}
}

class BackgroundGradients extends StatelessWidget {
const BackgroundGradients({super.key});

@override
Widget build(BuildContext context) {
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
src: 'assets/3d/padlock_closed.glb',
alt:
'To simulate the strenght of Insured security, we use a 3D padlock model as a subtle background element.',
ar: true,
autoRotate: true,
iosSrc:
'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
disableZoom: true,
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







these are the isnpirations of how the 3d and the before login merge to form a futuristic webstie bro. i love how the user swipes and the 3d moves in th e2 block code, and how the ui backgraoudn colour changes including in th e page indicator dots when  the user swipes thoguht the 3rd block. i want somethign futireigstic liek that in the code we are going to buidl.  we are gonna buidl a proje t called Insured, usign the padclcojk still as the 3d obj on the background. we are going to have 3 pages in the onboarding, and the user can swipe through them, and as they swipe the 3d model will rotate and move a bit, and the background colour will change. we are going to have a glassmorphism card in the middle with some text and a button to continue with phone or apple. we are going to use the model_viewer_plus package to display the 3d model, and we are going to use some animations to make it look more futuristic. for the nboarding part, we sall that the text for eg,:


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


but instead onf the:

label: isLast ? 'Get Started' : 'Continue with Phone',

label: 'Continue with Apple',


etc buttons appearin on oll the onboarding sections,. it will appear onf the last onboarding section, then we proceed to the next page which is the login page, where we have the 3d model in the background and a glassmorphism card in the middle with the login form. we can also have some animations on the login page to make it look more futuristic. for example, we can have the 3d model slowly rotating in the background, and we can have some particles or light effects around the card. we can also have some hover effects on the buttons to make them more interactive. overall, we want to create a seamless transition from the onboarding to the login page, while keeping the futuristic aesthetic consistent throughout.


note. that i love how the 3d object interacts wtih the user swipes of the code blcok taht has:

title: "Join the\nGreen Verse",
block. that how teh onborrding sectionn shall look like bro. now for the login screen, we can have the 3d object above the 

signup login sect kjst liek the

subtitle:
    'Scan plants, spot issues, and get instant care tips.',

    section is.


    nte, i love the futristic codlor of all the buttons, actally we can make a componet that can halndle allthe versions of the buttons we ave above bro though modifyaoble variable that i can pass ot dispaly. yes bro. so the project we are goin to buidln is called insured.

    we shall build it for both mobile and large screens so let s halndle all screen sized bro deep in your mind. 


past the onboarding and the login stuff, we shall have the folloig for the Insured app:


---

### Project: Client & Quote Management Dashboard (Desktop Version)

---

#### Overview:

Build a secure, clean, and modern web-based dashboard application for managing clients and quotes. The app should be intuitive and responsive with a focus on usability and quick access to important data and actions.

---

#### Key Features & UI Components:

1. **Sidebar Navigation (Left Panel):**

* Vertical sidebar fixed on the left side with the app logo/name ("Secured") on top.
* Menu Items with icons and labels:

* Dashboard (highlighted as active)
* Clients
* Quotes
* Production
* Statement
* Renewals
* User Profile section at the bottom showing user name ("Philip Aswa"), email, and a Logout button.
* Sidebar background should be dark, with active menu highlight in orange.

2. **Main Dashboard Area (Right Panel):**

* **Header:**

* Title: "Dashboard"
* Subtitle: "Manage your clients and quotes"
* A prominent button on the right: `+ New Client`

* **Summary Cards Row (4 Cards):**

* Total Clients (blue): show number count
* Total Quotes (orange): show number count
* Accepted Quotes (green): show number count
* Pending Quotes (purple): show number count
* Each card should have a subtle colored square icon and large number count.

* **Quick Action Panels (below summary cards):**

* Left box: `Add New Client` with a user icon, text "Scan ID to auto-fill details"
* Right box: `View All Quotes` with a document icon, text "Manage and track quotes"
* These are clickable action buttons/panels with dashed border outlines.

* **Recent Clients Section (main content area):**

* Title: "Recent Clients"
* Search bar on the top right for filtering clients.
* If no clients exist:

* Display a placeholder icon and text: "No clients yet"
* Below it, small text: "Add your first client to get started"
* A button below: `+ Add Client`
* 
* 
* Below, a horizontal list (or grid) of client cards showing three clients:

John Kamau (Active)

Initials icon: "JK"

Status badge: green "active"

Client details:

ID: 32456789

Email: john.kamau@gmail.com

Phone: +254 712 345 678

Button: Generate Quote (with document icon, outlined in yellow)

Mary Wanjiku (Active)

Initials icon: "MW"

Status badge: green "active"

Client details:

ID: 28765432

Email: mary.wanjiku@yahoo.com

Phone: +254 723 456 789

Button: Generate Quote

Peter Ochieng (Pending)

Initials icon: "PO"

Status badge: orange "pending"

Client details:

ID: 31234567

Email: peter.ochieng@outlook.com

Phone: +254 734 567 890

Button: Generate Quote
* The section should support dynamic listing once clients are added.

---

#### Style & Behavior Notes:

* Clean, modern UI with consistent padding and spacing.
* Use distinct colors for different metrics (blue, orange, green, purple).
* Use smooth hover states for buttons and clickable cards.
* Sidebar and header remain fixed on scroll.
* Responsive layout optimized for desktop screens.
* Icons used next to key text for clarity.
* Input fields should have subtle borders and placeholder text for search.

---

#### Additional Details:

* User authentication is implied (showing user info and logout).
* Data counts (clients, quotes) should update dynamically.
* The app should support adding clients manually or via ID scan (integrate scanning if feasible).
* Quotes management linked from dashboard and separate section in sidebar.
* Data persistence (likely a backend API to fetch and update clients and quotes).

---

Would you like me to draft a more technical spec for the developer (like suggested tech stack, API design, or component structure)? This brief should help them understand the look and flow you want from the desktop version of the app.




Absolutely! Here’s a thoughtful outline for how the **mobile version** of this desktop dashboard app should look and behave, keeping usability and screen size constraints in mind:

---

### Mobile Version Design Hints for Client & Quote Management App

---

#### 1. **Simplified & Collapsible Sidebar → Hamburger Menu**

* Replace the left sidebar with a **hamburger menu icon** at the top left.
* When tapped, it slides in/out the full navigation menu (Dashboard, Clients, Quotes, etc.).
* The user profile and logout button can appear inside this slide-out menu at the bottom.

---

#### 2. **Top Header Bar**

* Compact top header showing:

* Page title (e.g., "Dashboard")
* Hamburger menu icon (left)
* **New Client** button or "+" icon on the right (prominent and easy to tap).

---

#### 3. **Summary Cards**

* Show summary cards stacked **vertically** or in a **2x2 grid** for space efficiency:

* Total Clients
* Total Quotes
* Accepted Quotes
* Pending Quotes
* Cards remain visually distinct with their colors but sized smaller and tappable if you want to drill down.

---

#### 4. **Quick Action Buttons**

* Place the **Add New Client** and **View All Quotes** actions as large, full-width buttons stacked vertically.
* These should be thumb-friendly, with clear icons and text.

---

#### 5. **Recent Clients Section**

* Display a **search bar** at the top for filtering clients.
* Show recent clients as a **scrollable vertical list**, each item tappable to view details.
* If no clients:

* Show the “No clients yet” message with a smaller icon.
* Large, thumb-friendly **Add Client** button below the message.

---

#### 6. **General UI/UX Considerations**

* Use larger tap targets (buttons, cards) for easy finger navigation.
* Keep font sizes legible but compact to maximize screen real estate.
* Avoid horizontal scrolling; content should fit well within screen width.
* Sticky top bar with hamburger menu and page title for easy navigation.
* Smooth animations for menu slide-in/out and button presses.
* Minimize clutter—show only the most critical info on initial view; other details can be revealed by tapping or navigating deeper.

---

### Summary: Mobile UX Priorities

* **Minimalism & clarity** over dense data display.
* Easy navigation via hamburger menu.
* Vertical stacking and scrolling.
* Thumb-friendly buttons and inputs.
* Maintain color-coding and branding consistency.
* Keep all main desktop features accessible but optimized for smaller screens.

---

If you want, I can sketch a wireframe or describe the exact layout flow for mobile screens as well!



lets store aou r mck data for the clients and the quotes in a json file that we can read from and write to. this way we can simulate a backend without actually building one. we can have a `data.json` file.



to guid use in all the structure , we shall statrt witl a project structer 

here are some of the sugestions to make your life easire. i want u to now make your combined one so tha we now htave the futusitrsc applicaiton fr all screens as a mega project adneasirr to work on :

suggestion 1:
insured/                          # Project root
├── android/
├── ios/
├── assets/
│   ├── images/                   # PNGs, SVGs, etc.
│   ├── fonts/                    # Custom fonts
│   ├── models/                   # 3D models (.obj, .glb) for the rotating cube
│   └── ...
├── lib/
│   ├── core/                      # Shared across features
│   │   ├── constants/
│   │   │   ├── app_colors.dart    # Deep gradient colors, glass tints
│   │   │   ├── app_strings.dart   # Onboarding texts, button labels
│   │   │   └── app_dimensions.dart
│   │   ├── themes/
│   │   │   ├── app_theme.dart      # Global theme data (dark, glass)
│   │   │   └── text_styles.dart    # Reusable text styles
│   │   ├── utils/
│   │   │   ├── haptic_helper.dart  # Haptic feedback wrapper
│   │   │   └── animation_curves.dart # Custom curves for 3D rotation
│   │   └── widgets/                # Truly global widgets
│   │       ├── glass_button.dart   # The primary/secondary glass button
│   │       ├── glass_card.dart     # Base glassmorphism container
│   │       └── gradient_background.dart # Background with blur+noise
│   ├── features/
│   │   ├── onboarding/              # Onboarding feature module
│   │   │   ├── presentation/
│   │   │   │   ├── pages/
│   │   │   │   │   └── onboarding_page.dart   # Main PageView screen
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── futuristic_cube.dart   # 3D cube with rotation animation
│   │   │   │   │   ├── page_content.dart      # Title+subtitle per page
│   │   │   │   │   └── bottom_glass_panel.dart # The frosted panel with buttons
│   │   │   │   └── controllers/
│   │   │   │       └── onboarding_controller.dart # Manages page index, rotation
│   │   │   ├── domain/               # Business logic (if any)
│   │   │   └── data/                  # Local data for onboarding pages
│   │   │       └── onboarding_data.dart # List of page contents
│   │   └── insured/                   # Main app feature (after onboarding)
│   │       ├── presentation/
│   │       ├── domain/
│   │       └── data/
│   ├── app/                           # App-level setup
│   │   ├── routes/
│   │   │   └── app_router.dart        # GoRouter / Navigator 2.0 setup
│   │   └── dependency_injection/
│   │       └── injector.dart           # GetIt / Riverpod providers
│   └── main.dart                       # Entry point
├── pubspec.yaml
└── ...


sugegstion 2:

├── assets/
│   ├── models/                # 3D objects (.glb, .obj) e.g., shield.glb, vault.glb
│   ├── images/                # Glass textures and noise overlays
│   └── fonts/                 # Premium typography (e.g., SF Pro or Inter)
├── lib/
│   ├── main.dart              # Entry point & Theme initialization
│   ├── app.dart               # Main MaterialApp wrapper & Routing
│   │
│   ├── core/                  # The "Global" stuff (Reused across the whole app)
│   │   ├── constants/         # App strings and API endpoints
│   │   ├── theme/             # The "Glassmorphism" design system
│   │   │   ├── colors.dart    # Those deep emerald/navy gradients
│   │   │   └── glass_style.dart # Reusable BackdropFilter configs
│   │   ├── widgets/           # Global UI components
│   │   │   ├── glass_button.dart
│   │   │   └── glass_card.dart
│   │   └── utils/             # Haptics, animations, and math helpers
│   │
│   ├── features/              # Modular logic per screen/flow
│   │   ├── onboarding/        # <--- Your Reusable Glass Flow
│   │   │   ├── data/          # Onboarding content models
│   │   │   ├── logic/         # Animation & Page controllers
│   │   │   └── ui/            
│   │   │       ├── onboarding_screen.dart
│   │   │       └── widgets/   # 3D Character viewport & Step indicators
│   │   │
│   │   ├── auth/              # Login / Apple Sign-in logic
│   │   │   ├── ui/
│   │   │   └── logic/
│   │   │
│   │   └── dashboard/         # The main "Insured" interface
│   │       ├── ui/
│   │       └── models/
│   │
│   ├── services/              # External integrations
│   │   ├── storage_service.dart # Saving "First-time user" flags
│   │   └── model_loader.dart    # Logic to fetch 3D characters
│   │
└── pubspec.yaml               # Dependencies (flutter_gl, simple_animations, etc.)


suggestion 3:
insured/
├── android/                  # Android native code
├── ios/                      # iOS native code
├── assets/                   # Static assets like images, fonts, 3D models (e.g., GLB files for plants or insurance icons)
│   ├── images/               # 2D images (e.g., logos, backgrounds)
│   ├── models/               # 3D models (e.g., plant.glb for onboarding)
│   └── fonts/                # Custom fonts if needed
├── lib/                      # Main Dart code
│   ├── main.dart             # Entry point of the app
│   ├── src/                  # Source code organized modularly
│   │   ├── core/             # Core shared modules (reusable across features)
│   │   │   ├── constants/    # App-wide constants (e.g., colors.dart, strings.dart)
│   │   │   │   ├── colors.dart
│   │   │   │   └── strings.dart
│   │   │   ├── themes/       # App themes (light/dark modes, glassmorphism styles)
│   │   │   │   └── app_theme.dart
│   │   │   ├── utils/        # Utility functions (e.g., animations, haptics)
│   │   │   │   ├── animation_utils.dart
│   │   │   │   └── haptic_utils.dart
│   │   │   └── widgets/      # Core reusable widgets (e.g., glass_button.dart)
│   │   │       └── glass_button.dart  # Reusable glassmorphism button from onboarding
│   │   ├── features/         # Feature modules (modular, each can be a separate package if scaled)
│   │   │   ├── onboarding/   # Onboarding feature (reused/adapted from plant app, with 3 pages)
│   │   │   │   ├── screens/  # Screens for onboarding flow
│   │   │   │   │   └── onboarding_screen.dart  # Main PageView-based screen with 3 pages
│   │   │   │   ├── widgets/  # Feature-specific widgets
│   │   │   │   │   ├── onboarding_page_content.dart  # Content for each page (title, subtitle)
│   │   │   │   │   └── three_d_model_viewer.dart     # 3D model with rotation and floating animation
│   │   │   │   └── onboarding_provider.dart          # State management (e.g., Provider or Riverpod for page control)
│   │   │   ├── home/         # Home/dashboard feature for insured app (post-onboarding)
│   │   │   │   ├── screens/
│   │   │   │   │   └── home_screen.dart  # Main home screen (e.g., insurance policies overview)
│   │   │   │   └── widgets/  # Home-specific widgets (e.g., policy_card.dart)
│   │   │   ├── profile/      # User profile feature
│   │   │   │   ├── screens/
│   │   │   │   │   └── profile_screen.dart
│   │   │   │   └── widgets/  # Profile widgets
│   │   │   └── auth/         # Authentication feature (login/signup, integrated with onboarding)
│   │   │       ├── screens/
│   │   │       │   └── auth_screen.dart  # Handles phone/Apple sign-in from onboarding
│   │   │       └── auth_provider.dart    # Auth state management
│   │   └── app_router.dart   # App navigation (e.g., using GoRouter or AutoRoute for modular routing)
│   └── l10n/                 # Localization if needed (for multi-language support)
├── pubspec.yaml              # Dependencies (e.g., model_viewer_plus, flutter_cube)
└── README.md                 # Project documentation


suggestion 4:
├── android/
├── ios/
├── web/
├── lib/
│   ├── main.dart                          # Entry point
│   │
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart            # All color constants
│   │   │   ├── app_text_styles.dart       # GoogleFonts text styles
│   │   │   └── app_theme.dart             # ThemeData config
│   │   ├── constants/
│   │   │   ├── app_strings.dart           # All string literals
│   │   │   └── app_sizes.dart             # Spacing / radius constants
│   │   ├── utils/
│   │   │   ├── responsive.dart            # Screen size breakpoints helper
│   │   │   └── extensions.dart            # Dart extensions
│   │   └── router/
│   │       └── app_router.dart            # Named routes / GoRouter config
│   │
│   ├── data/
│   │   ├── local/
│   │   │   └── data.json                  # Mock backend (clients + quotes)
│   │   ├── models/
│   │   │   ├── client_model.dart
│   │   │   └── quote_model.dart
│   │   └── repositories/
│   │       ├── client_repository.dart     # Read/write clients from data.json
│   │       └── quote_repository.dart      # Read/write quotes from data.json
│   │
│   ├── widgets/                           # 🔁 SHARED / REUSABLE COMPONENTS
│   │   ├── insured_button.dart            # ← THE button component (all variants)
│   │   ├── glass_card.dart                # Reusable glassmorphism card
│   │   ├── animated_orbs.dart             # Background orbs (reused from onboarding)
│   │   ├── grain_overlay.dart             # Grain texture painter
│   │   ├── page_dots.dart                 # Onboarding dot indicators
│   │   ├── status_badge.dart              # Active / Pending / etc.
│   │   ├── client_card.dart               # Client list card
│   │   └── summary_stat_card.dart         # Dashboard metric card
│   │
│   ├── features/
│   │   ├── onboarding/
│   │   │   ├── onboarding_screen.dart     # ♻️ Reused from Flora / renamed
│   │   │   ├── onboarding_page_model.dart # Data model per page
│   │   │   └── widgets/
│   │   │       ├── plant_widget.dart      # CustomPainter 3D plant
│   │   │       └── plant_section.dart     # Float + rotate wrapper
│   │   │
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   └── widgets/
│   │   │       └── auth_glass_form.dart   # Glass-styled input fields
│   │   │
│   │   ├── dashboard/
│   │   │   ├── dashboard_screen.dart      # Responsive shell (picks layout)
│   │   │   ├── dashboard_mobile.dart      # Mobile layout
│   │   │   ├── dashboard_desktop.dart     # Desktop/tablet layout
│   │   │   └── widgets/
│   │   │       ├── sidebar.dart           # Desktop fixed left nav
│   │   │       ├── hamburger_drawer.dart  # Mobile slide-out nav
│   │   │       ├── top_header.dart        # Page title + action button
│   │   │       └── quick_actions_row.dart # Add Client / View Quotes panels
│   │   │
│   │   ├── clients/
│   │   │   ├── clients_screen.dart
│   │   │   ├── client_detail_screen.dart
│   │   │   └── widgets/
│   │   │       └── clients_list.dart
│   │   │
│   │   ├── quotes/
│   │   │   ├── quotes_screen.dart
│   │   │   ├── quote_detail_screen.dart
│   │   │   └── widgets/
│   │   │       └── quotes_list.dart
│   │   │
│   │   ├── renewals/
│   │   │   └── renewals_screen.dart
│   │   │
│   │   ├── production/
│   │   │   └── production_screen.dart
│   │   │
│   │   └── statement/
│   │       └── statement_screen.dart
│   │
│   └── providers/                         # State management (Riverpod / Provider)
│       ├── client_provider.dart
│       ├── quote_provider.dart
│       └── auth_provider.dart
│
├── assets/
│   ├── data/
│   │   └── data.json                      # Symlinked / copied from lib/data/local/
│   ├── images/
│   │   └── logo.png
│   └── models/                            # Optional GLB for 3D plant
│       └── plant.glb
│
└── pubspec.yaml



nwo make ur own comobiend prompt and lets make u feel inspired by the pres login stage havign teh 3 onboarding screns  with 3d , then the choice to continue with phone on the last screen then the login adn sign up page appears with the 3d obje ct above then we mock teh login htbe the main project structrue bro. be professional. be intellignent . be fresh. be inspired. be robust minded. be so intellignet on ths. thinkk liek a hundred professional senor codders. 