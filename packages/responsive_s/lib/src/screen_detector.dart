import 'dart:math';

import 'package:flutter/material.dart';
import 'package:responsive_s/src/enums/enums.dart';
import 'package:responsive_s/src/frame_provider/frame_provider.dart';

///detect screen type depending on width ,height and orientation
class ScreenDetector {
  ScreenDetector(this.context);

  final BuildContext context;

  Orientation getDeviceOrientation() => MediaQuery.of(context).orientation;

  ///test all probably screens for all devices including Tv screens ,
  ///smart watch screen
  ScreenType getScreenType() {
    final size = MediaQuery.of(context).size;

    final defaultSizes = FrameProvider.of(context).defaultSizes;
    final bool isLandscape = getDeviceOrientation() == Orientation.landscape;
    final double realWidth;
    final CalculateStrategy calculateStrategy =
        FrameProvider.of(context).calculateStrategy;
    if (calculateStrategy == CalculateStrategy.minWidthAndHeight) {
      realWidth = min(size.width, size.height);
    } else {
      realWidth = size.width;
    }

    ///In case the screen is under the unresolved boundaries
    if (realWidth <= defaultSizes.defaultUnresolvedWidth) {
      return ScreenType.unresolvedBoundaries;
    }

    ///smart watch screen
    if (realWidth >= 0 && realWidth <= defaultSizes.defaultScreenWatchWidth) {
      return ScreenType.smartWatch;
    }

    ///mobile phone screen
    else if (realWidth > defaultSizes.defaultScreenWatchWidth &&
        realWidth <= defaultSizes.defaultMobileWidth) {
      return isLandscape
          ? ScreenType.mobileLandscape
          : ScreenType.mobilePortrait;
    }

    ///tablet screen
    else if (realWidth > defaultSizes.defaultMobileWidth &&
        realWidth <= defaultSizes.defaultTabletWidth) {
      return isLandscape
          ? ScreenType.tabletLandScape
          : ScreenType.tabletPortrait;
    }

    ///desktop screen
    else if (realWidth > defaultSizes.defaultTabletWidth &&
        realWidth <= defaultSizes.defaultDesktopWidth) {
      return ScreenType.desktop;
    }

    ///tv screen
    else {
      return ScreenType.television;
    }
  }

  Size getFrame() {
    final screenType = getScreenType();
    final frameProvider = FrameProvider.of(context);
    switch (screenType) {
      case ScreenType.television:
        return frameProvider.frame.tvFrame ?? frameProvider.frame.desktopFrame;
      case ScreenType.desktop:
        return frameProvider.frame.desktopFrame;
      case ScreenType.tabletPortrait:
        return frameProvider.frame.tabletPortraitFrame;
      case ScreenType.tabletLandScape:
        return frameProvider.frame.tabletLandscapeFrame ??
            frameProvider.frame.tabletPortraitFrame;
      case ScreenType.mobilePortrait:
        return frameProvider.frame.mobilePortraitFrame;
      case ScreenType.mobileLandscape:
        return frameProvider.frame.mobileLandscapeFrame ??
            frameProvider.frame.mobilePortraitFrame;
      case ScreenType.smartWatch:
        return frameProvider.frame.screenWatchFrame ??
            frameProvider.frame.mobilePortraitFrame;
      case ScreenType.unresolvedBoundaries:
        return frameProvider.frame.unresolvedBoundariesFrame ??
            frameProvider.frame.desktopFrame;
    }
  }
}
