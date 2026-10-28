import 'package:flutter/material.dart';

class ResponsiveFillFont extends StatelessWidget {
  const ResponsiveFillFont({
    super.key,
    required this.text,
    required this.fillSize,
    this.textStyle,
  });

  final String text;
  final Size fillSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fillSize.width,
      height: fillSize.height,
      child: FittedBox(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }
}
