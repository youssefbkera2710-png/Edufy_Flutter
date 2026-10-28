import 'dart:ui';
import 'package:responsive_s/src/model/frame_model.dart';



class FrameConstant {
  ///Stander TV frame
  static const tvFrame = Size(1920, 1080);

  ///Stander Desktop frame
  static const desktopFrame = Size(1024, 720);

  ///Stander portrait Tablet frame
  static const tabletPortraitFrame = Size(768, 1024);

  ///Stander landscape Tablet frame
  static const tabletLandscapeFrame = Size(1024, 768);

  ///Stander portrait Mobile frame
  static const mobilePortraitFrame = Size(480, 1200);

  ///Stander landscape Mobile frame
  static const mobileLandscapeFrame = Size(1200, 480);

  ///Stander watch frame
  static const screenWatchFrame = Size(320, 320);

  ///Stander unresolved boundaries frame
  static const unresolvedBoundariesFrame = Size(200, 200);

  static const Frame frame = Frame(
    desktopFrame: desktopFrame,
    tvFrame: tvFrame,
    tabletPortraitFrame: tabletPortraitFrame,
    tabletLandscapeFrame: tabletLandscapeFrame,
    mobilePortraitFrame: mobilePortraitFrame,
    mobileLandscapeFrame: mobileLandscapeFrame,
    screenWatchFrame: screenWatchFrame,
    unresolvedBoundariesFrame: unresolvedBoundariesFrame,
  );
}
