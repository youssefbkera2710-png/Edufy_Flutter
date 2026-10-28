import 'dart:ui';

class Frame {
  const Frame({
    required this.desktopFrame,
    required this.tabletPortraitFrame,
    required this.mobilePortraitFrame,
    this.tabletLandscapeFrame,
    this.mobileLandscapeFrame,
    this.tvFrame,
    this.screenWatchFrame,
    this.unresolvedBoundariesFrame,
  });

  final Size desktopFrame;
  final Size? tabletLandscapeFrame;
  final Size tabletPortraitFrame;
  final Size? mobileLandscapeFrame;
  final Size mobilePortraitFrame;
  final Size? tvFrame;
  final Size? screenWatchFrame;
  final Size? unresolvedBoundariesFrame;
}
