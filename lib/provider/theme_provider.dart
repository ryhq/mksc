import 'package:flutter/material.dart';
import 'package:mksc/model/theme_color.dart';
import 'package:mksc/services/theme_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = _lightMode; 

  double _fontSize = 14.0;

  Color primaryColor = const Color(0xff569CEA);

  // Getter for the current theme data
  ThemeData get themeData => _buildThemeData();

  // Getter to check if the current theme is dark mode
  bool get isDarkMode => _themeData == _darkMode;
  
  // Getter for the current font size
  double get fontSize => _fontSize;

  bool _isLoading = true;
  
  bool get isLoading => _isLoading;

  // Setter for theme data which also notifies listeners about the change
  set setThemeData(ThemeData themeData) {
    _themeData = themeData;
    _savePreferences();
    notifyListeners(); // Notify listeners to rebuild widgets that depend on this provider
  }

  // Method to toggle between dark mode and light mode
  void toggleTheme() {
    _themeData = _themeData == _lightMode ? _darkMode : _lightMode;
    _savePreferences();
    notifyListeners();
  } 

  // Method to set a new font size
  void setFontSize(double size) {
    _fontSize = size;
    _savePreferences();
    notifyListeners();
  }
  

  void setPrimaryColor(Color color) {
    primaryColor = color;
    // _buildThemeData();
    _savePreferences(); // Save the new color to preferences
    _buildThemeData();
    notifyListeners();
  }

  ThemeProvider() {
    _loadPreferences();
  }

  Future<void> setPrimaryColorFromNet() async{
    ThemeColor themeColor = await ThemeServices.getAppPrimaryColor();
    String primaryColor = themeColor.primaryColor.replaceAll("#", "");
    if(primaryColor.length == 6) {
      primaryColor = 'FF$primaryColor';
      try {
        setPrimaryColor(Color(int.parse(primaryColor, radix: 16)));
      } catch (e) {
        debugPrint("\n\n\n👉👉👉👉👉Invalid color value from network");
      }
    }
    await _savePreferences();
    await _loadPreferences();
    debugPrint("\n\n\n👉👉👉👉👉Primary Color set : ${primaryColor.toUpperCase()}");
  }

  void resetToFactoryDefaults() {

    // Reset to default values
    _fontSize = 14.0;
    primaryColor = const Color(0xff3C7DBF);
    _themeData = _lightMode;

    _buildThemeData();
    // Save the default values to preferences
    _savePreferences();

    // Notify listeners to rebuild widgets that depend on this provider
    notifyListeners();
  }

  ThemeData _buildThemeData() {
    final baseTheme = isDarkMode ? _darkMode : _lightMode;
    // final colorScheme = baseTheme.colorScheme;
    final colorScheme = baseTheme.colorScheme.copyWith(
      primary: primaryColor,
    );
    return baseTheme.copyWith(
      colorScheme: colorScheme,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: _fontSize + 16.0, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        displayMedium: TextStyle(
          fontSize: _fontSize + 14.0, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        displaySmall: TextStyle(
          fontSize: _fontSize + 12.0, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        headlineLarge: TextStyle(
          fontSize: _fontSize + 10.0, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        headlineMedium: TextStyle(
          fontSize: _fontSize + 8.0, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.normal,height: 3,
          color: colorScheme.onSurface
        ),
        headlineSmall: TextStyle(
          fontSize: _fontSize + 6.0, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        titleLarge: TextStyle(
          fontSize: _fontSize + 4.0, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurface,
          wordSpacing: 1
        ),
        titleMedium: TextStyle(
          fontSize: _fontSize + 4.0, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurface,
          wordSpacing: 2
        ),
        titleSmall: TextStyle(
          fontSize: _fontSize + 2.0, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurface,
          wordSpacing: 3
        ),
        bodyLarge: TextStyle(
          fontSize: _fontSize + 2.0, 
          fontWeight: FontWeight.normal, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        bodyMedium: TextStyle(
          fontSize: _fontSize, 
          fontWeight: FontWeight.normal, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        bodySmall: TextStyle(
          fontSize: _fontSize - 2.0, 
          fontWeight: FontWeight.normal, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        labelLarge: TextStyle(
          fontSize: _fontSize - 2.0, 
          fontWeight: FontWeight.normal, 
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurface,
          wordSpacing: 1
        ),
        labelMedium: TextStyle(
          fontSize: _fontSize - 4.0, 
          fontWeight: FontWeight.normal, 
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurface,
          wordSpacing: 2
        ),
        labelSmall: TextStyle(
          fontSize: _fontSize - 6.0, 
          fontWeight: FontWeight.normal, 
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurface,
          wordSpacing: 3
        ),
      )
    );
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setBool('isDarkMode', _themeData == _darkMode);
    await prefs.setInt('primaryColor', primaryColor.value);
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble('fontSize') ?? 14.0;
    bool isDark = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDark ? _darkMode : _lightMode;
    primaryColor = Color(prefs.getInt('primaryColor') ?? primaryColor.value);
    _isLoading = false;
    notifyListeners();
  }


  // Define dark mode theme data
  static final ThemeData _darkMode = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: Color(0xff569CEA),
      onPrimary: Colors.black,
      secondary: Color.fromARGB(87, 255, 255, 255),
      onSecondary: Colors.black,
      error: Color(0xffcf6679),
      onError: Colors.black,
      surface: Colors.black,
      onSurface: Colors.white,
    ),
  );

  // Define light mode theme data
  static final ThemeData _lightMode = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: Color(0xff569CEA),
      onPrimary: Colors.white,
      secondary: Color.fromARGB(87, 255, 255, 255),
      onSecondary: Colors.black,
      error: Color(0xffb00020),
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );
}
