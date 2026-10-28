import 'package:flutter/cupertino.dart';
import 'package:responsive_s/src/constant/frame_constant.dart';
import 'package:responsive_s/src/custom_default_size.dart';
import 'package:responsive_s/src/enums/enums.dart';
import 'package:responsive_s/src/frame_provider/frame_provider.dart';
import 'package:responsive_s/src/model/frame_model.dart';

class ResponsiveWrapper extends StatelessWidget {
  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.defaultSizes = const CustomDefaultSize(),
    this.frame = FrameConstant.frame,
    this.calculateStrategy = CalculateStrategy.onlyWidth,
  });

  final Widget child;
  final Frame frame;
  final CustomDefaultSize defaultSizes;
  final CalculateStrategy calculateStrategy;

  @override
  Widget build(BuildContext context) {
    return FrameProvider(
      defaultSizes: defaultSizes,
      frame: frame,
      calculateStrategy: calculateStrategy,
      child: child,
    );
  }
}
