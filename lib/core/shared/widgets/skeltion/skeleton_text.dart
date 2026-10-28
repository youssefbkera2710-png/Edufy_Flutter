import 'package:flutter/material.dart';

import 'skeleton_box.dart';

class SkeletonText extends StatelessWidget {
  final double width;

  const SkeletonText({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return SkeletonBox(width: width, height: 14, radius: 8);
  }
}
