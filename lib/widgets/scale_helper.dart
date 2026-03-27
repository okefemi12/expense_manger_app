// Put this in a utils or config file
import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double textScaleFactor;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    textScaleFactor = _mediaQueryData.textScaleFactor;
  }

  static double scaledFont(double baseFontSize) {
    double shortestSide =
        screenWidth < screenHeight ? screenWidth : screenHeight;
    double scaleFactor = shortestSide / 375;
    scaleFactor = scaleFactor.clamp(0.85, 1.2);
    return baseFontSize * scaleFactor;
  }
}
