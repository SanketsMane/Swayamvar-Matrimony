// Sanket: True Custom Painted Cut Bottom Navigation Bar (Real Fix - Final Stable)
import 'package:flutter/material.dart';
import '../const/my_theme.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;
  double _lastIndex = 0;

  final List<IconData> icons = [
    Icons.explore_outlined,
    Icons.favorite_border,
    Icons.chat_bubble_outline,
    Icons.person_outline,
  ];

  @override
  void initState() {
    super.initState();
    _lastIndex = widget.currentIndex.toDouble();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _animation = Tween<double>(begin: _lastIndex, end: _lastIndex).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.easeOutCubic),
    );
  }

  @override
  void didUpdateWidget(CustomBottomNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex &&
        _animation != null &&
        _controller != null) {
      _lastIndex = _animation!.value;
      _animation = Tween<double>(
        begin: _lastIndex,
        end: widget.currentIndex.toDouble(),
      ).animate(
        CurvedAnimation(parent: _controller!, curve: Curves.easeOutCubic),
      );
      _controller!.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final itemWidth = width / icons.length;
    final labels = ["मुख्य पान", "शोधा", "चॅट", "प्रोफाइल"];
    const double navbarHeight = 65.0; // Slightly increased for labels
    const double circleSize = 52.0;

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: AnimatedBuilder(
          animation:
              _animation ??
              AlwaysStoppedAnimation(widget.currentIndex.toDouble()),
          builder: (context, child) {
            final currentAnimValue =
                _animation?.value ?? widget.currentIndex.toDouble();
            final notchX = currentAnimValue * itemWidth + itemWidth / 2;

            return SizedBox(
              height: navbarHeight + 20,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  /// ✅ TRUE CARVED NAVBAR SURFACE
                  CustomPaint(
                    size: Size(width, navbarHeight),
                    painter: NotchedNavbarPainter(
                      notchX: notchX,
                      color: MyTheme.white,
                      shadowColor: Colors.black26,
                    ),
                  ),

                  /// ✅ ICON & LABEL LAYER
                  SizedBox(
                    height: navbarHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        icons.length,
                        (index) => GestureDetector(
                          onTap: () => widget.onTap(index),
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox(
                            width: itemWidth,
                            height: navbarHeight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  icons[index],
                                  color:
                                      widget.currentIndex == index
                                          ? Colors
                                              .transparent // Hidden in navbar, visible in bubble
                                          : MyTheme.text_secondary,
                                  size: 22,
                                ),
                                // Sanket: Labels removed — icon-only nav
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// ✅ DOCKED ACTIVE INDICATOR
                  Positioned(
                    left: notchX - (circleSize / 2),
                    bottom: 18,
                    child: Container(
                      height: circleSize,
                      width: circleSize,
                      decoration: BoxDecoration(
                        color: MyTheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: MyTheme.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icons[widget.currentIndex],
                            color: Colors.white,
                            size: 22,
                          ),
                          // Sanket: No label in active bubble — icon only
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ✅ THE REAL FIX PAINTER: Physically Carved Geometry
class NotchedNavbarPainter extends CustomPainter {
  final double notchX;
  final Color color;
  final Color shadowColor;

  NotchedNavbarPainter({
    required this.notchX,
    required this.color,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    const double cornerRadius = 25.0;
    const double notchRadius = 32.0; // Tight hug radius for 28px bubble

    Path path = Path();
    path.moveTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    // Entry transition (Balanced 25px width)
    path.lineTo(notchX - notchRadius - 25, 0);
    path.quadraticBezierTo(notchX - notchRadius, 0, notchX - notchRadius, 15);

    // Carved semicircle (Total depth = 15 entry + 32 radius = 47)
    path.arcToPoint(
      Offset(notchX + notchRadius, 15),
      radius: const Radius.circular(notchRadius),
      clockwise: false,
    );

    // Exit transition
    path.quadraticBezierTo(
      notchX + notchRadius,
      0,
      notchX + notchRadius + 25,
      0,
    );

    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Draw Physical Shadow
    canvas.drawShadow(path, shadowColor, 8, true);

    // Draw Background
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant NotchedNavbarPainter oldDelegate) {
    // Basic null check for hot-reload safety
    return oldDelegate.notchX != notchX;
  }
}
