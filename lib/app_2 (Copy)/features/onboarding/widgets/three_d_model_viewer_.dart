import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ThreeDModelViewer extends StatelessWidget {
  final bool isLogin;

  const ThreeDModelViewer({super.key, this.isLogin = false});

  @override
  Widget build(BuildContext context) {
    final String pathPrefix = kIsWeb && !kDebugMode ? 'assets/' : '';

    return SizedBox.expand(
      child: ModelViewer(
        src: isLogin
            ? '${pathPrefix}assets/models/padlock_opened.glb'
            : '${pathPrefix}assets/models/padlock_closed.glb',
        alt: '3D Padlock',
        shadowIntensity: 1.0,
        autoRotate: true,
        cameraControls: false,
        disableZoom: true,
      ),
    );
  }
}
