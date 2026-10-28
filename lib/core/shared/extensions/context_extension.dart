import 'package:flutter/material.dart';
import 'package:responsive_s/responsive_s.dart' show Sizer;

import '../managers/themes_manager/themes_manager.dart';

extension ContextExtension on BuildContext {
  Sizer? get sizer => null;
  DynamicColors get dynamicColors => ColorManager.of(this).dynamicColors;

  Color get background => dynamicColors.background;
  Color get primary => dynamicColors.primary;
  Color get orange => dynamicColors.orange;
  Color get cyan => dynamicColors.cyan;
  Color get secondry => dynamicColors.secondary;
  Color get green => dynamicColors.green;
  Color get darkblue => dynamicColors.darkblue;
  Color get lightblue => dynamicColors.lightblue;
  Color get lightwhite => dynamicColors.lightwhite;
  Color get primaryColorMode => Theme.of(this).primaryColor;
  Color get primaryDarkMode => Theme.of(this).primaryColorDark;
  Color get primaryLightMode => Theme.of(this).primaryColorLight;
  Color get backgroundColortheme => Theme.of(this).scaffoldBackgroundColor;
  Color get onBackgroundColor => Theme.of(this).colorScheme.onBackground;

  Color get red500 => dynamicColors.red500;
  Color get red500Custom => dynamicColors.red500Custom;
  Color get red50 => dynamicColors.red50;

  Color get grey900 => dynamicColors.grey900;
  Color get grey750 => dynamicColors.grey750;
  Color get gray700 => dynamicColors.gray700;
  Color get grey625 => dynamicColors.grey625;
  Color get grey350 => dynamicColors.grey350;
  Color get grey150 => dynamicColors.grey150;
  Color get grey50 => dynamicColors.grey50;

  Color get blue950 => dynamicColors.blue950;
  Color get blue900 => dynamicColors.blue900;
  Color get blue800 => dynamicColors.blue800;

  Color get yellow => dynamicColors.yellow;
  Color get yellow50 => dynamicColors.yellow50;

  Color get success500 => dynamicColors.success500;
  Color get success700 => dynamicColors.success700;
  Color get error600 => dynamicColors.error600;
  Color get warning400 => dynamicColors.warning400;

  Color get black2 => dynamicColors.black2;
  Color get white => dynamicColors.white;

  TextStyle? get bodyLarge => Theme.of(this).textTheme.titleMedium;

  TextStyle? get bodyExtraLarge => Theme.of(this).textTheme.titleLarge;

  TextStyle? get bodyRegular => Theme.of(this).textTheme.titleSmall;

  TextStyle? get bodyTiny => Theme.of(this).textTheme.bodySmall;

  TextStyle? get bodySmall => Theme.of(this).textTheme.bodyMedium;

  TextStyle? get bodyMedium => Theme.of(this).textTheme.bodyLarge;

  TextStyle? get extraLargeBody => Theme.of(this).textTheme.headlineLarge;
}
