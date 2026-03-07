import 'package:flutter/material.dart';
import '../core/constants.dart';

class PulseFAB extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;

  const PulseFAB({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
  }) : super(key: key);

  @override
  State<PulseFAB> createState() => _PulseFABState();
}

class _PulseFABState extends State<PulseFAB> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer Pulse circles
            _buildPulseCircle(context, 1.0, 0.0),
            _buildPulseCircle(context, 0.8, 0.2),
            _buildPulseCircle(context, 0.6, 0.4),
            
            // The FAB itself
            FloatingActionButton(
              onPressed: widget.onPressed,
              tooltip: widget.tooltip,
              elevation: 8,
              backgroundColor: Colors.transparent,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x66D9475C), // Keep const for fixed color
                      blurRadius: 15,
                      offset: const Offset(0, 5), // Keep const for fixed offset
                    ),
                  ],
                ),
                child: Icon(widget.icon, color: Colors.white, size: 30),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPulseCircle(BuildContext context, double scaleStart, double delayOffset) {
    // Calculate pulsed scale and opacity
    double progress = (_controller.value + delayOffset) % 1.0;
    double scale = 1.0 + (progress * 0.8);
    double opacity = (1.0 - progress) * 0.4;

    return Transform.scale(
      scale: scale,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary(context).withValues(alpha: opacity),
        ),
      ),
    );
  }
}
// Sanket
