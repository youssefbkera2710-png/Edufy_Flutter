import 'dart:math' show max;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_s/src/constant/frame_constant.dart';
import 'package:responsive_s/src/enums/enums.dart';
import 'package:responsive_s/src/model/mobile_tablet_padding_model.dart';

class Sizer {
  Sizer(
    this.context, {
    required this.frameSize,
    required this.screenType,
  }) {
    screenSize = MediaQuery.of(context).size;
    screenType = _determineScreenType();
  }

  final BuildContext context;
  late ScreenType screenType;
  late Size screenSize;
  final Size frameSize;

  ScreenType _determineScreenType() {
    if (screenSize.width >= FrameConstant.desktopFrame.width) {
      return ScreenType.desktop;
    } else if (screenSize.width >= FrameConstant.tabletPortraitFrame.width) {
      return ScreenType.tabletPortrait;
    } else if (screenSize.width >= FrameConstant.mobilePortraitFrame.width) {
      return ScreenType.mobilePortrait;
    } else {
      return ScreenType.unresolvedBoundaries;
    }
  }

  double _calculateLengthPercentage(
    double frameLength,
    double screenLength,
    double length,
  ) {
    final percentage = length / frameLength;
    return percentage * screenLength;
  }

  ///Calculate  width from value depending on given frames.
  double w(double width) {
    return _calculateLengthPercentage(
      frameSize.width,
      screenSize.width,
      width,
    );
  }

  double ww(double mobileWidth, tabletWidth) {
    return _calculateLengthPercentage(
      frameSize.width,
      screenSize.width,
      isMobile ? mobileWidth : tabletWidth,
    );
  }

  double radius(double value) => _calculateLengthPercentage(
        frameSize.width,
        screenSize.width,
        value,
      );

  ///Calculate height from value depending on given frames.
  double h(double height) {
    return _calculateLengthPercentage(
      frameSize.height,
      screenSize.height,
      height,
    );
  }

  double hh(double mobileHeight, double tabletHeight) {
    return _calculateLengthPercentage(
      frameSize.height,
      screenSize.height,
      isMobile ? mobileHeight : tabletHeight,
    );
  }

  ///Calculate padding from value depending on given frames.
  EdgeInsets padding({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(
        left: _calculateLengthPercentage(
          frameSize.width,
          screenSize.width,
          left,
        ),
        right: _calculateLengthPercentage(
          frameSize.width,
          screenSize.width,
          right,
        ),
        top: _calculateLengthPercentage(
          frameSize.height,
          screenSize.height,
          top,
        ),
        bottom: _calculateLengthPercentage(
          frameSize.height,
          screenSize.height,
          bottom,
        ),
      );

  ///Calculate padding from value depending on given frames.
  EdgeInsets paddingSwitcherMobileTablet({
    required SwitcherPadding paddingModel,
  }) =>
      EdgeInsets.only(
        left: _calculateLengthPercentage(
          frameSize.width,
          screenSize.width,
          isMobile
              ? paddingModel.mobilePadding.left
              : paddingModel.tabletPadding.left,
        ),
        right: _calculateLengthPercentage(
          frameSize.width,
          screenSize.width,
          isMobile
              ? paddingModel.mobilePadding.right
              : paddingModel.tabletPadding.right,
        ),
        top: _calculateLengthPercentage(
          frameSize.height,
          screenSize.height,
          isMobile
              ? paddingModel.mobilePadding.top
              : paddingModel.tabletPadding.top,
        ),
        bottom: _calculateLengthPercentage(
          frameSize.height,
          screenSize.height,
          isMobile
              ? paddingModel.mobilePadding.bottom
              : paddingModel.tabletPadding.bottom,
        ),
      );

  ///Calculate padding from value depending on given frames.
  ///And assign it to all values.
  EdgeInsets paddingAll([
    double all = 0,
  ]) =>
      EdgeInsets.only(
        left: _calculateLengthPercentage(
          frameSize.width,
          screenSize.width,
          all,
        ),
        right: _calculateLengthPercentage(
          frameSize.width,
          screenSize.width,
          all,
        ),
        top: _calculateLengthPercentage(
          frameSize.height,
          screenSize.height,
          all,
        ),
        bottom: _calculateLengthPercentage(
          frameSize.height,
          screenSize.height,
          all,
        ),
      );

  EdgeInsets paddingSymmetric({
    double horizontal = 0,
    double vertical = 0,
  }) =>
      EdgeInsets.only(
        left: _calculateLengthPercentage(
          frameSize.width,
          screenSize.width,
          horizontal,
        ),
        right: _calculateLengthPercentage(
          frameSize.width,
          screenSize.width,
          horizontal,
        ),
        top: _calculateLengthPercentage(
          frameSize.height,
          screenSize.height,
          vertical,
        ),
        bottom: _calculateLengthPercentage(
          frameSize.height,
          screenSize.height,
          vertical,
        ),
      );

  BorderRadius circularRadius(double value) => BorderRadius.circular(
        _calculateLengthPercentage(
          frameSize.width,
          screenSize.width,
          value,
        ),
      );

  bool get isDesktop => screenType == ScreenType.desktop;

  bool get isTablet =>
      screenType == ScreenType.tabletPortrait ||
      screenType == ScreenType.tabletLandScape;

  bool get isMobile =>
      screenType == ScreenType.mobilePortrait ||
      screenType == ScreenType.mobileLandscape;

  bool get isWatch => screenType == ScreenType.smartWatch;

  bool get isTv => screenType == ScreenType.television;

  ///Calculate width in percentage from screen width.
  double ws([double factor = 1]) => MediaQuery.of(context).size.width * factor;

  ///Calculate height in percentage from screen height.
  double hs([double factor = 1]) => MediaQuery.of(context).size.height * factor;

  // Calculate padding based on width and height percentages
  EdgeInsets paddingS({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(
        left: ws(left),
        right: ws(right),
        top: hs(top),
        bottom: hs(bottom),
      );

  // device height
  double get height => MediaQuery.of(context).size.height;

  // device width
  double get width => MediaQuery.of(context).size.width;

  ///Return responsive value depending on given screen size.
  T responsiveValue<T>({
    required T defaultValue,
    T? tabletPortrait,
    T? tabletLandscape,
    T? desktop,
    T? smartWatch,
    T? tv,
    T? mobilePortrait,
    T? mobileLandscape,
  }) {
    switch (screenType) {
      case ScreenType.mobilePortrait:
        return mobilePortrait ?? defaultValue;
      case ScreenType.mobileLandscape:
        return mobileLandscape ?? mobilePortrait ?? defaultValue;
      case ScreenType.tabletPortrait:
        return tabletPortrait ?? defaultValue;
      case ScreenType.tabletLandScape:
        return tabletLandscape ?? tabletPortrait ?? defaultValue;
      case ScreenType.desktop:
        return desktop ?? defaultValue;
      case ScreenType.smartWatch:
        return smartWatch ?? mobilePortrait ?? defaultValue;
      case ScreenType.television:
        return tv ?? desktop ?? defaultValue;
      case ScreenType.unresolvedBoundaries:
        return defaultValue;
    }
  }

  ///Return responsive font size depending on given font size.
  double fontSize(
    double fontSize, {
    double? maximumScale,
    double? minimumScale,
  }) {
    return _getFixedSize(
      fontSize,
      maximumScale: maximumScale,
      minimumScale: minimumScale,
    );
  }

  BorderRadius circularBorderRadius(
    double radius, {
    double? maximumScale,
    double? minimumScale,
  }) =>
      BorderRadius.circular(_getFixedSize(
        radius,
        minimumScale: minimumScale,
        maximumScale: maximumScale,
      ));

  double _getFixedSize(
    double size, {
    double? maximumScale,
    double? minimumScale,
  }) {
    final heightFactor = frameSize.height / screenSize.height;
    final widthFactor = frameSize.width / screenSize.width;
    final scale = max(heightFactor, widthFactor);
    if (maximumScale == null && minimumScale == null) {
      return size / scale;
    } else if (scale > maximumScale!) {
      return size / maximumScale;
    } else if (scale < minimumScale!) {
      return size / minimumScale;
    } else {
      return size / scale;
    }
  }

  Orientation get deviceOrientation => MediaQuery.of(context).orientation;

  bool get isPortrait => deviceOrientation == Orientation.portrait;
}
