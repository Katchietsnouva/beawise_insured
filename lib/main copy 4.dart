// import 'package:flutter/material.dart';
// import 'core/theme/app_theme.dart';
// import 'features/onboarding/screens/welcome_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'AI Plant Doctor',
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.darkTheme,
//       home: const WelcomeScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(const PlantDoctorApp());
}

class PlantDoctorApp extends StatelessWidget {
  const PlantDoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Plant Doctor',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
        fontFamily: 'sans-serif', // Use GoogleFonts in a real project
      ),
      home: const WelcomeScreen(),
    );
  }
}

// --- REUSABLE UI COMPONENTS ---

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double opacity;
  final double blur;

  const GlassContainer({
    super.key,
    required this.child,
    this.opacity = 0.1,
    this.blur = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Deep Green Organic Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F291E),
                  Color(0xFF1E4D36),
                  Color(0xFF09140F),
                ],
              ),
            ),
          ),
          // Subtle glow orb
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.greenAccent.withOpacity(0.1),
              ),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

// --- SCREEN 1: WELCOME ---

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const Spacer(),
            // Placeholder for the 3D Plant Image
            const Icon(Icons.eco, size: 200, color: Colors.greenAccent),
            const SizedBox(height: 40),
            const Text(
              "Welcome",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Scan plants, spot issues, and\nget instant care tips.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: const Text(
                "Continue with Phone",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.apple, color: Colors.white),
              label: const Text(
                "Continue with Apple",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "By pressing continue, you agree to our Terms and Policy",
              style: TextStyle(fontSize: 10, color: Colors.white38),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// --- SCREEN 2: SIGN UP WITH MOCK LOGIN ---

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);

    // MOCK LOGIN LOGIC
    await Future.delayed(const Duration(seconds: 2));

    if (_emailController.text == "admin" && _passController.text == "1234") {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FeatureScreen()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Try: admin / 1234")));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(height: 20),
              const Text(
                "Join AI Plant Doctor",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Create an account to unlock features.",
                style: TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 40),
              _buildGlassField(Icons.person_outline, "Name", null),
              const SizedBox(height: 15),
              _buildGlassField(Icons.email_outlined, "Email", _emailController),
              const SizedBox(height: 15),
              _buildGlassField(
                Icons.lock_outline,
                "Password",
                _passController,
                obscure: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("Continue"),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  "Or log in with",
                  style: TextStyle(color: Colors.white38),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _socialButton(Icons.g_mobiledata),
                  _socialButton(Icons.apple),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassField(
    IconData icon,
    String hint,
    TextEditingController? controller, {
    bool obscure = false,
  }) {
    return GlassContainer(
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon) {
    return GlassContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        child: Icon(icon, size: 30),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);

    // MOCK LOGIN LOGIC (same as before)
    await Future.delayed(const Duration(seconds: 2));

    if (_emailController.text == "admin" && _passController.text == "1234") {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FeatureScreen()),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Try: admin / 1234")));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(height: 20),
              const Text(
                "Login to AI Plant Doctor",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Enter your credentials to access features.",
                style: TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 40),
              _buildGlassField(Icons.email_outlined, "Email", _emailController),
              const SizedBox(height: 15),
              _buildGlassField(
                Icons.lock_outline,
                "Password",
                _passController,
                obscure: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text("Login"),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpScreen()),
                  ),
                  child: const Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  "Or log in with",
                  style: TextStyle(color: Colors.white38),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _socialButton(Icons.g_mobiledata),
                  _socialButton(Icons.apple),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassField(
    IconData icon,
    String hint,
    TextEditingController? controller, {
    bool obscure = false,
  }) {
    return GlassContainer(
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.white70),
          hintText: hint,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon) {
    return GlassContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        child: Icon(icon, size: 30),
      ),
    );
  }
}

// --- SCREEN 3: FEATURE OVERVIEW ---

class FeatureScreen extends StatelessWidget {
  const FeatureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome to AI\nPlant Doctor",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _featureCard(
                    "Instant diagnosis",
                    Icons.search,
                    Colors.transparent,
                  ),
                  _featureCard(
                    "Smart reminders",
                    Icons.water_drop,
                    Colors.green,
                  ),
                  _featureCard(
                    "Actionable plans",
                    Icons.assignment,
                    Colors.transparent,
                  ),
                  _featureCard(
                    "Track Growth",
                    Icons.show_chart,
                    Colors.transparent,
                  ),
                ],
              ),
            ),
            const GlassContainer(
              child: ListTile(
                leading: Icon(Icons.shield, color: Colors.greenAccent),
                title: Text("Instant Solutions"),
                subtitle: Text("Find easy care tips and remedies."),
                trailing: Icon(Icons.check_circle, color: Colors.greenAccent),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureCard(String title, IconData icon, Color bgColor) {
    return GlassContainer(
      opacity: bgColor == Colors.green ? 0.3 : 0.1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.greenAccent),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
