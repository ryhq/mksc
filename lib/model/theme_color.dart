import 'package:flutter/material.dart';

class ThemeColor {
  final Color primaryColor; 
  final Color secondaryColor;

  ThemeColor({
    required this.primaryColor, 
    required this.secondaryColor
  }); 

  factory ThemeColor.fromJson(Map<String, dynamic> json){
    return ThemeColor(
      primaryColor: _hexToColor(json['primaryColor']),
      secondaryColor: _hexToColor(json['secondaryColor']),
    );
  }

  ThemeColor copyWith({
    Color? primaryColor,
    Color? secondaryColor,
  }) {
    return ThemeColor(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primaryColor': _colorToHex(primaryColor),
      'secondaryColor': _colorToHex(secondaryColor),
    };
  }

  static ThemeColor empty() {
    return ThemeColor(
      primaryColor: const Color.fromARGB(255, 0, 0, 0), // Default to black
      secondaryColor: const Color.fromARGB(255, 255, 255, 255), // Default to white
    );
  }

  // Helper method to convert hex string to Color
  static Color _hexToColor(String hex) {
    try {
      final hexCode = hex.replaceAll('#', '');
      if (hexCode.length == 6 || hexCode.length == 8) {
        return Color(int.parse('FF$hexCode', radix: 16));
      } else {
        throw const FormatException('Invalid hex color format');
      }
    } catch (e) {
      // Log the error and provide a default fallback color
      debugPrint('Error parsing hex color: $hex. Error: $e');
      return Colors.black; // Default fallback color
    }
  }

  // Helper method to convert Color to hex string
  static String _colorToHex(Color color) {
    try {
      final hexValue = color.value.toRadixString(16).toUpperCase();
      if (hexValue.length == 8) {
        return '#${hexValue.substring(2)}'; // Skip the alpha channel
      } else {
        throw const FormatException('Invalid Color object');
      }
    } catch (e) {
      // Log the error and provide a default fallback value
      debugPrint('Error converting color to hex: $color. Error: $e');
      return '#000000'; // Default fallback hex string
    }
  }

}