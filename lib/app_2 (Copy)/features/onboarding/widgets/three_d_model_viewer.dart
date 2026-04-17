import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ThreeDModelViewer extends StatelessWidget {
  final double rotationY;
  final Animation<double> floatAnim;
  final bool isLogin;

  const ThreeDModelViewer({
    super.key,
    required this.rotationY,
    required this.floatAnim,
    this.isLogin = false,
  });

  @override
  Widget build(BuildContext context) {
    // Web production builds nest assets under an extra /assets/ folder
    final String pathPrefix = kIsWeb && !kDebugMode ? 'assets/' : '';

    return AnimatedBuilder(
      animation: floatAnim,
      builder: (_, child) {
        return
        // Transform.translate(
        //   offset: Offset(0, floatAnim.value),
        //   child: Transform(
        //     alignment: Alignment.center,
        //     transform: Matrix4.identity()
        //       ..setEntry(3, 2, 0.001)
        //       ..rotateY(rotationY),
        //     // ..rotateY(rotationY),
        //    // child:
        SizedBox(
          // width: 300,
          // height: 300,
          child: ModelViewer(
            src: isLogin
                ? '${pathPrefix}assets/models/padlock_opened.glb'
                : '${pathPrefix}assets/models/padlock_closed.glb',
            alt: '3D Padlock',
            // backgroundColor: const Color.fromARGB(227, 223, 216, 216),
            shadowIntensity: 1.0,

            // autoRotate: false,
            autoRotate: true,
            // disableZoom: true,
            disableZoom: true,
            rotationPerSecond: "25deg",
            cameraControls:
                true, // Gestures like orbit (rotation), pan, or zoom require explicit permissions and can be blocked if cameraControls is false (as in your code).
            // cameraOrbit: "0deg 75deg 2.5m",
            // minCameraOrbit: "-15deg 65deg 2.5m",
            // maxCameraOrbit: "15deg 85deg 2.5m",
            interpolationDecay: 350,
            interactionPrompt: InteractionPrompt.none,
          ),
        );

        //   ),
        // );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:model_viewer_plus/model_viewer_plus.dart';

// class ThreeDModelViewer extends StatelessWidget {
//   final double rotationY; // in radians
//   final Animation<double> floatAnim;
//   final bool isLogin;

//   const ThreeDModelViewer({
//     super.key,
//     required this.rotationY,
//     required this.floatAnim,
//     this.isLogin = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: floatAnim,
//       builder: (_, child) {
//         return Transform.translate(
//           offset: Offset(0, floatAnim.value),
//           child: Transform(
//             alignment: Alignment.center,
//             transform: Matrix4.identity()
//               ..setEntry(3, 2, 0.001) // perspective
//               ..rotateY(rotationY),
//             child: SizedBox(
//               width: 300,
//               height: 300,
//               child: ModelViewer(
//                 // src: 'assets/models/padlock_closed.glb',
//                 src: isLogin
//                     // ? 'assets/models/padlock_opened_2.glb'
//                     ? 'assets/models/padlock_opened.glb'
//                     : 'assets/models/padlock_closed.glb',

//                 alt: '3D Padlock',
//                 autoRotate: false,
//                 cameraControls: false,
//                 disableZoom: true,
//                 backgroundColor: Colors.transparent,
//                 shadowIntensity: 1.0,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
