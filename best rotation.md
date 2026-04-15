// BEST GEMINI:

import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

void main() => runApp(const MaterialApp(home: ModelControlPage()));

class ModelControlPage extends StatefulWidget {
  const ModelControlPage({super.key});

  @override
  State<ModelControlPage> createState() => _ModelControlPageState();
}

class _ModelControlPageState extends State<ModelControlPage> {
  int _rotationAngle = 0; // Use int for cleaner degree management

  void _updateRotation(int step) {
    setState(() {
      _rotationAngle += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("3D Rotate Fix")),
      body: Column(
        children: [
          Expanded(
            child: ModelViewer(
              // The Key is the "secret sauce" - it forces the widget to refresh
              key: ValueKey('model_angle_$_rotationAngle'),
              src: 'assets/3d/Astronaut.glb',
              alt: "Astronaut Model",
              ar: true,
              autoRotate: false, // Must be false for manual control
              cameraControls: true,
              // Format: [Horizontal Angle] [Vertical Angle] [Distance]
              cameraOrbit: '${_rotationAngle}deg 75deg auto',
              backgroundColor: const Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBtn(Icons.rotate_left, -30, "Left"),
                Column(
                  children: [
                    const Text("Current Angle", style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("$_rotationAngle°"),
                  ],
                ),
                _buildBtn(Icons.rotate_right, 30, "Right"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBtn(IconData icon, int degrees, String label) {
    return ElevatedButton.icon(
      onPressed: () => _updateRotation(degrees),
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
    );
  }
}


