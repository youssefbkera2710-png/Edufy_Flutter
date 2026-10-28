import 'package:flutter/material.dart';
import 'package:responsive_s/src/custom_default_size.dart';
import 'package:responsive_s/src/enums/enums.dart';
import 'package:responsive_s/src/model/frame_model.dart';

class FrameProvider extends InheritedWidget {
  const FrameProvider({
    super.key,
    required super.child,
    required this.frame,
    required this.defaultSizes,
    this.calculateStrategy = CalculateStrategy.onlyWidth,
  });

  final Frame frame;
  final CustomDefaultSize defaultSizes;
  final CalculateStrategy calculateStrategy;

  static FrameProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FrameProvider>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget != this;
}
