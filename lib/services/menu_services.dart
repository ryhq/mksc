import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mksc/model/menu.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/services/mksc_urls.dart';

class MenuServices {
  static Future<List<Menu>>  getMenu({required String camp, required String day, required String  menuType}) async{
    final response = await http.get(Uri.parse("${MKSCUrls.getMenurl}/$day/$menuType/$camp"));
    debugPrint("\n\n\n👉👉👉Response status code ${response.statusCode}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<Menu> menus = data.map((menu) => Menu.fromJson(menu)).toList();
      return menus;
    } else {
      return List<Menu>.empty();
    }
  }
}