import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/constants.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Border? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? gradient;

  const GlassContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 24,
    this.blur = 10,
    this.opacity = 0.08,
    this.border,
    this.padding,
    this.margin,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black).withOpacity(opacity),
              borderRadius: BorderRadius.circular(borderRadius),
              border: border ?? Border.all(color: (isDark ? Colors.white : Colors.black).withOpacity(0.12)),
              gradient: gradient,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
// Sanket
