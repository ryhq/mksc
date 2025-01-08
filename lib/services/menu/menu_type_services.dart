import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mksc/model/menu_type.dart';
import 'package:mksc/services/mksc_urls.dart';

class MenuTypeServices {

  static Future<List<MenuType>>  getMenuPerCamp({required String camp}) async{
    final response = await http.get(Uri.parse("${MKSCUrls.getMenuTypeUrl}/$camp"));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<MenuType> menus = data.map((menu) => MenuType.fromJson(menu)).toList();
      return menus;
    } else {
      return List<MenuType>.empty();
    }
  }
}