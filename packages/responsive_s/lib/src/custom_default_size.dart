
import 'package:responsive_s/src/constant/constant_default_size.dart';

class CustomDefaultSize {
  const CustomDefaultSize({
    this.defaultTvWidth = ConstantDefaultSize.maxDefaultTvWidth,
    this.defaultDesktopWidth = ConstantDefaultSize.maxDefaultDesktopWidth,
    this.defaultTabletWidth = ConstantDefaultSize.maxDefaultTabletWidth,
    this.defaultMobileWidth = ConstantDefaultSize.maxDefaultMobileWidth,
    this.defaultScreenWatchWidth =
        ConstantDefaultSize.maxDefaultScreenWatchWidth,
    this.defaultUnresolvedWidth = ConstantDefaultSize.maxDefaultUnresolvedWidth,
  });

  final double defaultTvWidth;

  ///Default Desktop Size
  final double defaultDesktopWidth;

  ///Default portrait Tablet Size
  final double defaultTabletWidth;

  ///Default portrait Mobile Size
  final double defaultMobileWidth;

  ///Default watch Size
  final double defaultScreenWatchWidth;

  ///Default unresolved boundaries width
  final double defaultUnresolvedWidth;
}
