import 'package:flutter/material.dart';
import 'package:mksc/model/theme_color.dart';
import 'package:mksc/services/theme_services.dart';
import 'package:mksc/utilities/color_utility.dart';
import 'package:mksc/utilities/screen_size_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {

  double _fontSize = 14.0;
  
  String _fontFamily = "georgia";

  Color _primaryColor = const Color(0xff5A1E03);

  String _dateFormat = "yyyy-MM-dd";

  bool _hourFormat24 = true;

  ThemeData _themeData = _lightMode;

  static final ThemeData _darkMode = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: Color(0xffFAE5C4),
      onPrimary: Colors.black,
      secondary: Color(0xff03dac6),
      onSecondary: Colors.black,
      error: Color(0xffcf6679),
      onError: Colors.black,
      surface: Colors.black,
      onSurface: Colors.white,
    ),
  );

  static final ThemeData _lightMode = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: Color(0xff5A1E03),
      onPrimary: Colors.white,
      secondary: Color(0xff03dac6),
      onSecondary: Colors.black,
      error: Color(0xffb00020),
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );

  double get fontSize => _fontSize;

  String get fontFamily => _fontFamily;

  Color get primaryColor => _primaryColor;

  String get dateFormat => _dateFormat;

  bool get hourFormat24 => _hourFormat24;

  bool get isDarkMode => _themeData == _darkMode;
  
  ThemeData getThemeData(BuildContext context) => _buildThemeData(context);

  ThemeProvider() {
    _loadPreferences();
  }  
  
  set setThemeData(ThemeData themeData) {
    _themeData = themeData;
    _savePreferences();
    notifyListeners();
  }

  void setFontSize(double size) {
    _fontSize = size;
    _savePreferences();
    notifyListeners();
  }

  void setFontFamily(String fontFamily){
    _fontFamily = fontFamily;
    _savePreferences();
    notifyListeners();
  }

  void setDateFormat(String dateFormat){
    _dateFormat = dateFormat;
    _savePreferences();
    notifyListeners();
  }
  
  void toggleHourFormat24() {
    _hourFormat24 = !_hourFormat24;
    _savePreferences();
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = _themeData == _lightMode ? _darkMode : _lightMode;
    _savePreferences();
    notifyListeners();
  }
  

  void setPrimaryColor(Color color) {
    _primaryColor = color;
    _savePreferences(); // Save the new color to preferences
    notifyListeners();
  }

  Future<void> setPrimaryColorFromNet() async{
    ThemeColor themeColor = await ThemeServices.getAppPrimaryColor();
    setPrimaryColor(themeColor.primaryColor);
    await _savePreferences();
    await _loadPreferences();
  }

  void resetToFactoryDefaults(BuildContext context) {
    _fontSize = 14.0;
    _primaryColor = const Color(0xff5A1E03);
    _fontFamily = 'georgia';
    _dateFormat = "yyyy-MM-dd";
    _hourFormat24 = true;
    _themeData = _lightMode;
    _buildThemeData(context);
    _savePreferences();
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setString('fontFamily', _fontFamily);
    await prefs.setBool('isDarkMode', _themeData == _darkMode);
    await prefs.setInt('primaryColor', _primaryColor.value);
    await prefs.setString('dateFormat', _dateFormat);
    await prefs.setBool('hourFormat24', _hourFormat24);
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble('fontSize') ?? 14.0;
    _fontFamily = prefs.getString('fontFamily') ?? 'georgia';
    bool isDark = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDark ? _darkMode : _lightMode;
    _primaryColor = Color(prefs.getInt('primaryColor') ?? 0xff5A1E03);
    _dateFormat = prefs.getString('dateFormat') ?? 'yyyy-MM-dd';
    _hourFormat24 = prefs.getBool('hourFormat24') ?? true;
    notifyListeners();
  }

  ThemeData _buildThemeData(BuildContext context) {
    final baseTheme = isDarkMode ? _darkMode : _lightMode;
    // final colorScheme = baseTheme.colorScheme;
    final colorScheme = baseTheme.colorScheme.copyWith(
      primary: _primaryColor,
      secondary: ColorUtility.calculateSecondaryColorWithAlpha(primaryColor: _primaryColor, alpha: 90)
    );
    
    double scaleFont(double fontSize) => ScreenSizeUtility.scaleFontSize(
      context, fontSize
    );
    
    return baseTheme.copyWith(
      colorScheme: colorScheme,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: scaleFont(_fontSize + 16.0),
          fontFamily: _fontFamily,
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        displayMedium: TextStyle(
          fontSize: scaleFont(_fontSize + 14.0),
          fontFamily: _fontFamily, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        displaySmall: TextStyle(
          fontSize: scaleFont(_fontSize + 12.0),
          fontFamily: _fontFamily, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        headlineLarge: TextStyle(
          fontSize: scaleFont(_fontSize + 10.0),
          fontFamily: _fontFamily, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        headlineMedium: TextStyle(
          fontSize: scaleFont(_fontSize + 8.0),
          fontFamily: _fontFamily, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.normal,height: 3,
          color: colorScheme.onSurface
        ),
        headlineSmall: TextStyle(
          fontSize: scaleFont(_fontSize + 6.0),
          fontFamily: _fontFamily, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        titleLarge: TextStyle(
          fontSize: scaleFont(_fontSize + 4.0),
          fontFamily: _fontFamily, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurface,
          wordSpacing: 1
        ),
        titleMedium: TextStyle(
          fontSize: scaleFont(_fontSize + 4.0),
          fontFamily: _fontFamily, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurface,
          wordSpacing: 2
        ),
        titleSmall: TextStyle(
          fontSize: scaleFont(_fontSize + 2.0),
          fontFamily: _fontFamily, 
          fontWeight: FontWeight.bold, 
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurface,
          wordSpacing: 3
        ),
        bodyLarge: TextStyle(
          fontSize: scaleFont(_fontSize + 2.0),
          fontFamily: _fontFamily, 
          fontWeight: FontWeight.normal, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        bodyMedium: TextStyle(
          fontSize: scaleFont(_fontSize),
          fontFamily: _fontFamily, 
          fontWeight: FontWeight.normal, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        bodySmall: TextStyle(
          fontSize: scaleFont(_fontSize - 2.0),
          fontFamily: _fontFamily, 
          fontWeight: FontWeight.normal, 
          fontStyle: FontStyle.normal,
          color: colorScheme.onSurface
        ),
        labelLarge: TextStyle(
          fontSize: scaleFont(_fontSize - 2.0),
          fontFamily: _fontFamily, 
          fontWeight: FontWeight.normal, 
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurface,
          wordSpacing: 1
        ),
        labelMedium: TextStyle(
          fontSize: scaleFont(_fontSize - 4.0),
          fontFamily: _fontFamily, 
          fontWeight: FontWeight.normal, 
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurface,
          wordSpacing: 2
        ),
        labelSmall: TextStyle(
          fontSize: scaleFont(_fontSize - 6.0),
          fontFamily: _fontFamily, 
          fontWeight: FontWeight.normal, 
          fontStyle: FontStyle.italic,
          color: colorScheme.onSurface,
          wordSpacing: 3
        ),
      )
    );
  }
}