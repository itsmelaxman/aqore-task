import 'dart:ui';
import 'package:flutter/material.dart';

class BlurWrap extends StatelessWidget {
  /// Child widget.
  final Widget child;

  /// Border radius.
  final BorderRadius? radius;

  /// Blur intensity.
  final double blur;

  const BlurWrap({super.key, required this.child, this.radius, this.blur = 13});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius ?? .circular(8.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: child,
      ),
    );
  }
}
