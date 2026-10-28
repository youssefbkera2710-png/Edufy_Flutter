// lib/modules/exams/add_exam/widgets/add_exam_loading_overlay.dart
import 'package:flutter/material.dart';

class AddExamLoadingOverlay extends StatelessWidget {
  final bool isLoading;

  const AddExamLoadingOverlay({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withOpacity(0.4),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
