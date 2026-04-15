// import 'package:flutter/material.dart';
// import 'package:model_viewer_plus/model_viewer_plus.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Model Viewer')),
//         body: const ModelViewer(
//           backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
//           src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
//           alt: 'A 3D model of an astronaut',
//           ar: true,
//           autoRotate: true,
//           iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
//           disableZoom: true,
//         ),
//       ),
//     );
//   }
// }

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
                            'assets/3d/monstera_plant.glb',
                        // 'assets/3d/padlock_closed.glb',
                        // 'assets/3d/Astronaut.glb',
                        alt: '3D model of an Astronaut',
                        autoRotate: false,
                        cameraControls: false,
                        disableZoom: true,
                        orientation: '0deg ${_rotation}deg 0deg',
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
