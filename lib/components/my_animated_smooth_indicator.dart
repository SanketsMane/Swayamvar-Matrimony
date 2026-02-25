import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyAnimatedSmoothIndicator extends StatelessWidget {
  const MyAnimatedSmoothIndicator({
    super.key,
    required this.carouselIndex,
    required this.images,
  });

  final int? carouselIndex;
  final List images;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return SizedBox
          .shrink();
    }

    return AnimatedSmoothIndicator(
      effect: ExpandingDotsEffect(
        dotColor: Colors.white.withOpacity(0.8),
        activeDotColor: Colors.white,
        dotHeight: 8,
        dotWidth: 8,
      ),
      activeIndex: (carouselIndex ?? 0)
          .clamp(0, images.length - 1),
      count: images.length,
    );
  }
}
