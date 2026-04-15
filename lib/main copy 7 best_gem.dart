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
                      // disableZoom: true,
                      // disablePan: true,
                      // disableTap: true,
                      // cameraControls:
                      //     false, // 🔥 IMPORTANT That prevents it from capturing drag gestures.
                    ),

                    // child: // Inside the Positioned → AnimatedBuilder → Transform → Center → child:
                    // IgnorePointer(
                    //   // ← Add this wrapper: ignores all pointers (swipes pass through to PageView below)
                    //   child: SizedBox(
                    //     width:
                    //         300, // ← Keep or make responsive if needed (e.g., min(300, MediaQuery.of(context).size.width * 0.5))
                    //     height: 300,
                    //     child: ModelViewer(
                    //       backgroundColor: Colors
                    //           .transparent, // ← Changed to transparent for better layering
                    //       src: 'assets/3d/Astronaut.glb',
                    //       alt: 'A 3D model of an astronaut',
                    //       ar: false, // ← Disable AR (reduces unnecessary gesture handling)
                    //       autoRotate: true,
                    //       iosSrc:
                    //           'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
                    //       disableZoom: true,
                    //       cameraControls:
                    //           false, // ← Add: explicitly disable orbit/pan/zoom gestures
                    //     ),
                    //   ),
                    // ),
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
