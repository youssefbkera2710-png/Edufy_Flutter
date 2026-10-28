part of "package:edufy/core/shared/managers/themes_manager/themes_manager.dart";

class ColorManager extends InheritedWidget {
  ColorManager({super.key, required super.child});

  final DynamicColors dynamicColors = DynamicColors.instance;

  factory ColorManager.of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<ColorManager>(
            aspect: ColorManager,
          )
          as ColorManager);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) =>
      oldWidget != this;
}
