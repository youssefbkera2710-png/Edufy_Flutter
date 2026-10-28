import 'package:edufy/core/shared/managers/themes_manager/text_theme_manager/font_families.dart';
import 'package:flutter/material.dart';
import 'text_theme_manager/custom_text_theme.dart';

part 'colors_manager/colors_manager.dart';
part 'colors_manager/dynamic_colors.dart';

class ThemesManager {
  static ThemeData lightTheme(CustomTextTheme customTheme) {
    final colors = DynamicColors.instance; // ألوانك الحالية

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.grey[100],
      appBarTheme: AppBarTheme(backgroundColor: Color(0xFFFFF4DD)),
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        secondary: colors.secondary,
      ),
      fontFamily: FontFamilies.cairo,
      textTheme: getTextTheme(customTheme, colors),
    );
  }

  static ThemeData darkTheme(CustomTextTheme customTheme) {
    final colors = DynamicColors.instance;

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(backgroundColor: Colors.grey[900]),
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        secondary: colors.secondary,
      ),
      fontFamily: FontFamilies.cairo,
      textTheme: getTextTheme(customTheme, colors),
    );
  }

  static TextTheme getTextTheme(
    CustomTextTheme customTheme,
    DynamicColors colors,
  ) => TextTheme(
    titleLarge: customTheme.bodyExtraLarge(),
    titleMedium: customTheme.bodyLarge(),
    titleSmall: customTheme.bodyRegular(),
    bodyLarge: customTheme.bodyMedium(),
    bodyMedium: customTheme.bodySmall(),
    bodySmall: customTheme.bodyTiny(),
    headlineLarge: customTheme.bodyLarge(),
  );
}
