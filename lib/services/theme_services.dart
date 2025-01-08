import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mksc/model/theme_color.dart';
import 'package:mksc/services/mksc_urls.dart';

class ThemeServices {
  static Future<ThemeColor> getAppPrimaryColor() async {
    
    final response = await http.get(
      Uri.parse(MKSCUrls.getThemeColor),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {

      final responseBody = response.body;

      final Map<String, dynamic> responseData = json.decode(responseBody);

      ThemeColor themeColor = ThemeColor.fromJson(responseData);

      return themeColor;
    } else {
      return ThemeColor.empty();
    }
  }
}