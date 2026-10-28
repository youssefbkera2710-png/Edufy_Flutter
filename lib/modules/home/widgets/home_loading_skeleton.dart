import 'package:edufy/core/shared/widgets/skeltion/app_shimmer.dart';
import 'package:edufy/core/shared/widgets/skeltion/skeleton_box.dart';
import 'package:flutter/material.dart';
class HomeLoadingSkeleton extends StatelessWidget {
  const HomeLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            const SkeletonBox(
              height: 220,
              radius: 0,
            ),

            const SizedBox(height: 20),

            /// Stat cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: SkeletonBox(
                      height: 120,
                      radius: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SkeletonBox(
                      height: 120,
                      radius: 24,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Section title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SkeletonBox(
                width: 180,
                height: 24,
                radius: 12,
              ),
            ),

            const SizedBox(height: 16),

            /// Academic performance
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SkeletonBox(
                height: 220,
                radius: 24,
              ),
            ),

            const SizedBox(height: 24),

            /// Exams title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SkeletonBox(
                width: 160,
                height: 24,
                radius: 12,
              ),
            ),

            const SizedBox(height: 16),

            /// Exams list
            ...List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: SkeletonBox(
                  height: 110,
                  radius: 20,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}