import 'package:flutter/material.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';

InputDecoration inputDecorationDef(
  IconData? icon,
  String label,
  Color color,
  BuildContext ctx,
) {
  return InputDecoration(
    contentPadding: const EdgeInsets.only(
      bottom: 8,
      top: 8,
      left: 15,
      right: 15,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1),
      borderRadius: const BorderRadius.all(Radius.circular(35)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1),
      borderRadius: const BorderRadius.all(Radius.circular(35)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1),
      borderRadius: const BorderRadius.all(Radius.circular(35)),
    ),
    suffixIcon: icon != null
        ? Icon(icon, color: color, size: 30, weight: 30)
        : null,
    label: Text(label, style: ctx.bodySmall),
  );
}
