import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class OnboardingDots extends StatelessWidget {
  final int dotsCount;
  final int position;

  const OnboardingDots({
    super.key,
    required this.dotsCount,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      dotsCount: dotsCount,
      position: position.toDouble(),
      decorator: DotsDecorator(
        activeColor: Colors.black,
        size: const Size.square(8.0),
        activeSize: const Size(16.0, 8.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }
}
