
import 'package:edufy/core/shared/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart';

class RowDividerTextDivider extends StatelessWidget {
  String text;
   RowDividerTextDivider({
    super.key,required this.text
  });

  @override
  Widget build(BuildContext context) {
    return  ResponsiveWidget(builder: (sizer)=>Padding(
      padding:  EdgeInsets.only(top: sizer.h(15), bottom: sizer.h(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const DividerDef(),
          Text(
            text,
            style: context.bodySmall,
          ),
          const DividerDef()
        ],
      ),
    ));
  }
}

class DividerDef extends StatelessWidget {
  const DividerDef({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(builder: (sizer)=>Expanded(
      child: Divider(
        height: sizer.h(25),
        color: context.primary,
        thickness: 0.6,
        indent: MediaQuery.sizeOf(context).width / 25,
        endIndent: MediaQuery.sizeOf(context).width / 25,
      ),
    ));
  }
}
