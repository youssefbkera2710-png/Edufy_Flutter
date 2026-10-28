import 'package:flutter/material.dart';

Widget iconCircle({required IconData icon, required Color color}) {
  return Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: color.withOpacity(0.12),
      shape: BoxShape.circle,
    ),
    child: Icon(icon, size: 18, color: color),
  );
}
