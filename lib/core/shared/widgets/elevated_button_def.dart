import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';
import 'package:edufy/core/shared/extensions/context_extension.dart';

class ElevatedButtonDef extends StatelessWidget {
  const ElevatedButtonDef({
    super.key,
    required this.press,
    required this.text,
    this.padding,
  });
  final String text;
  final void Function() press;
  final double? padding;
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Padding(
        padding: EdgeInsets.all(padding ?? 0),
        child: ElevatedButton(
          onPressed: press,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(sizer.w(10)),
            backgroundColor: context.primary,
            maximumSize: Size(MediaQuery.sizeOf(context).width, sizer.h(40)),
            minimumSize: Size(MediaQuery.sizeOf(context).width, sizer.h(40)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sizer.radius(10)),
            ),
          ),
          child: Text(text, style: context.bodyMedium),
        ),
      ),
    );
  }
}
