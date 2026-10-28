import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class InfoRowDetails extends StatelessWidget {
  final String label;
  final String value;
  const InfoRowDetails({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.bodyMedium!.copyWith(color: context.grey625)),
          Text(
            value,
            style: context.bodyMedium
          ),
        ],
      ),
    );
  }
}
