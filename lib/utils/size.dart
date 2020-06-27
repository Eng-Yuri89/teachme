import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/* class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal =_mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
} */

/// Responsive sizes 
/// iPhone 11 pro
double baseHeight = 812.0;
double baseWidth = 375.0;

/// Returns the height of th scree.
double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

/// Returns the width of th scree.
double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

/// Returns a ratio of the height based on the 
/// size of the device on which the design was made.
double screenAwareHeight(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.height / baseHeight;
}

/// Returns a ratio of the width based on the 
/// size of the device on which the design was made.
double screenAwareWidth(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.width / baseWidth;
}