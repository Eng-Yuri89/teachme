import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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