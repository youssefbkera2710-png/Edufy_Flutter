import 'package:edufy/core/shared/widgets/skeltion/app_shimmer.dart';
import 'package:edufy/core/shared/widgets/skeltion/skeleton_box.dart';
import 'package:flutter/material.dart';


class AppSkeletonList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const AppSkeletonList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 120,
  });

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SkeletonBox(
              height: itemHeight,
              radius: 20,
            ),
          );
        },
      ),
    );
  }
}