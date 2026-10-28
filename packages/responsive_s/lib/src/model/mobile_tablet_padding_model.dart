class SwitcherPadding {
  SwitcherPadding({
    required this.mobilePadding,
    required this.tabletPadding,
  });

  PaddingModel mobilePadding;
  PaddingModel tabletPadding;
}

class PaddingModel {
  PaddingModel({
    this.top = 0,
    this.right = 0,
    this.left = 0,
    this.bottom = 0,
  });

  final double right;
  final double left;
  final double top;
  final double bottom;
}
