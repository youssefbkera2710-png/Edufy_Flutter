import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';

extension SizeExtension on num {
  double get _widthFactor => kIsWeb
      ? 1440
      : Platform.isAndroid || Platform.isIOS
          ? 375
          : 768;

  double get _heightFactor => kIsWeb
      ? 1024
      : Platform.isAndroid || Platform.isIOS
          ? 812
          : 1024;

  double get w {
    return (this / _widthFactor) *
        WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.width;
  }

  double get h {
    return (this / _heightFactor) *
        WidgetsBinding
            .instance.platformDispatcher.views.first.physicalSize.height;
  }

  double get sp =>
      (this / 375) *
      WidgetsBinding.instance.platformDispatcher.views.first.physicalSize.width;
}
