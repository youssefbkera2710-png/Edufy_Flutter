import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart' show Sizer;

import 'font_families.dart';
import 'font_size.dart';

class CustomTextTheme {
  CustomTextTheme({required this.sizer});

  final Sizer sizer;



  TextStyle bodyExtraLarge() => TextStyle(
    fontFamily: FontFamilies.cairo,
    fontWeight: FontWeight.w700,
    fontSize: sizer.fontSize(FontSize.textLarge),
  );
  TextStyle bodyLarge() => TextStyle(
    fontFamily: FontFamilies.cairo,
    fontWeight: FontWeight.w500,
    fontSize: sizer.fontSize(FontSize.textLarge),
  );

  TextStyle bodyRegular() => TextStyle(
    fontFamily: FontFamilies.cairo,
    fontWeight: FontWeight.w400,
    fontSize: sizer.fontSize(FontSize.textRegular),
  );
  TextStyle bodyRegularbold() => TextStyle(
    fontFamily: FontFamilies.cairo,
    fontWeight: FontWeight.w700,
    fontSize: sizer.fontSize(FontSize.textRegular),
  );
  TextStyle bodyMediumBold() => TextStyle(
    fontFamily: FontFamilies.cairo,
    fontWeight: FontWeight.w600,
    fontSize: sizer.fontSize(FontSize.textMedium),
  );
  TextStyle bodyMediumThin() => TextStyle(
    fontFamily: FontFamilies.cairo,
    fontWeight: FontWeight.w500,
    fontSize: sizer.fontSize(FontSize.textMedium),
  );
  TextStyle bodyMedium() => TextStyle(
    fontFamily: FontFamilies.cairo,
    fontWeight: FontWeight.w400,
    fontSize: sizer.fontSize(FontSize.textMedium),
  );

  TextStyle bodySmall() => TextStyle(
    fontFamily: FontFamilies.cairo,
    fontWeight: FontWeight.w400,
    fontSize: sizer.fontSize(FontSize.textSmall),
  );
  TextStyle bodyTiny() => TextStyle(
    fontFamily: FontFamilies.cairo,
    fontWeight: FontWeight.w400,
    fontSize: sizer.fontSize(FontSize.textTiny),
  );
  TextStyle bodyExtraTiny() => TextStyle(
    fontFamily: FontFamilies.cairo,
    fontWeight: FontWeight.w400,
    fontSize: sizer.fontSize(FontSize.textExtraTiny),
  );
}
