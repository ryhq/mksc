import 'package:flutter/material.dart';

class ScreenSizeUtility {
  static double scaleFontSize(BuildContext context, double fontSize) {
    double screenWidth = MediaQuery.of(context).size.width;

    double baseWidth = 375; // Reference width (e.g., iPhone 11 Pro)
    return fontSize + (screenWidth / baseWidth);
  }

  static double scaleImageSize(BuildContext context, double imageSize) {
    double screenWidth = MediaQuery.of(context).size.width;
    double baseWidth = 375; // Reference width (e.g., iPhone 11 Pro)
    return imageSize * (screenWidth / baseWidth);
  }
}
