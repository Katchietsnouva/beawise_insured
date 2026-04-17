import 'package:flutter/material.dart';

class CustomSpinner extends StatelessWidget {
  final double width;
  final double height;
  final double strokeWidth;
  final Color? color;

  const CustomSpinner({
    Key? key,
    this.width = 16,
    this.height = 16,
    this.strokeWidth = 2,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
