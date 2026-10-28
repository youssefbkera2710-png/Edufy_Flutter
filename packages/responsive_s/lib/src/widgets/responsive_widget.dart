import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';
import 'package:responsive_s/src/screen_detector.dart';


class ResponsiveWidget extends StatelessWidget {
  const ResponsiveWidget({
    super.key,
    required this.builder,
  });

  final Widget Function(Sizer sizer) builder;

  @override
  Widget build(BuildContext context) {
    final ScreenDetector screenDetector = ScreenDetector(context);
    final sizer = Sizer(
      context,
      frameSize: screenDetector.getFrame(),
      screenType: screenDetector.getScreenType(),
    );
    return builder(sizer);
  }
}
