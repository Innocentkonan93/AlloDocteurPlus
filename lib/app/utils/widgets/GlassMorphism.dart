import 'dart:ui';

import 'package:flutter/material.dart';

class GlassMorphism extends StatelessWidget {
  const GlassMorphism({
    Key? key,
    required this.opacity,
    required this.blur,
    required this.child,
  }) : super(key: key);
  final double opacity;
  final double blur;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          decoration: BoxDecoration(
            color: Colors.blue.shade50.withOpacity(opacity),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            
          ),
          child: child,
        ),
      ),
    );
  }
}
