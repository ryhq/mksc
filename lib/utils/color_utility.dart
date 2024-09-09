import 'dart:math';
import 'package:flutter/material.dart';

class ColorUtils {
  static Color getRandomColor() {
    // Generate random values for RGB components
    final random = Random();
    var r = random.nextInt(128);
    var g = random.nextInt(128);
    var b = random.nextInt(128);

    // Ensure that the resulting color is not brighter than white
    while (r + g + b > 500) {
      r = random.nextInt(128);
      g = random.nextInt(128);
      b = random.nextInt(128);
    }
    
    return Color.fromARGB(255, r, g, b); // Return random color
  }

  // Method to validate that the color is not brighter than white
  static bool isColorTooLight(Color color) {
    // Calculate the brightness of the color
    int brightness = color.red + color.green + color.blue;
    // Check if the color is not brighter than white (brightness <= 500)
    return brightness <= 500;
  }

  // Method to validate that the color is not too dark
  static bool isColorTooDark(Color color) {
    int brightness = color.red + color.green + color.blue;
    // Check if the color is not too dark (brightness >= 100)
    return brightness >= 100;
  }

  // Method to validate that the color is within an acceptable range
  static bool isColorWithinRange(Color color) {
    int brightness = color.red + color.green + color.blue;
    // Ensure the brightness is neither too high nor too low
    return brightness >= 100 && brightness <= 500;
  }

  static Color calculateSecondaryColor({required Color primaryColor}){
    HSLColor hslColor = HSLColor.fromColor(primaryColor);
    double newHue = (hslColor.hue + 30) % 360;
    HSLColor secondaryHSLColor = hslColor.withHue(newHue);
    Color secondaryColor = secondaryHSLColor.toColor();
    return secondaryColor;
  }
}