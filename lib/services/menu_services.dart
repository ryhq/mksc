import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mksc/model/detailed_menu.dart';
import 'package:mksc/model/menu.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/services/mksc_urls.dart';

class MenuServices {

  static Future<List<Menu>> getMenu({required String camp, required String day, required String  menuType}) async{
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

  static Future<DetailedMenu> getMenuDetailed(BuildContext context, {required int id}) async{
    try {
      
      final response = await http.get(
        Uri.parse("${MKSCUrls.getMenuDetailed}/$id"),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      debugPrint("\n\n\n👉👉👉👉👉Response URL ${MKSCUrls.getMenuDetailed}/$id");
      debugPrint("\n\n\n👉👉👉👉👉Response status code ${response.statusCode} @ getMenuDetailed");
      // debugPrint("\n\n\n👉👉👉👉👉Response body ${response.body} @ getMenuDetailed");

      if (response.statusCode == 200) {

        final responseBody = response.body;

        final Map<String, dynamic> responseData = json.decode(responseBody);

        DetailedMenu detailedMenu = DetailedMenu.fromJson(responseData);

        return detailedMenu;
        
      } else {
        if(!context.mounted) return DetailedMenu.empty();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred during fetching detailed menu\n${response.statusCode}')),
        );
      }
      
    } catch (e) {
      debugPrint("\n\n\nError Data: $e\n\n\n");
      return DetailedMenu.empty();        
    }
    return DetailedMenu.empty(); 
  }

  static Future<DetailedMenu> getUpdatedMenuDetails(BuildContext context, {required int dishId}) async{
    try {
      
      final response = await http.get(
        Uri.parse("${MKSCUrls.getbydishesurl}/$dishId"),
        headers: {
          'Content-Type': 'application/json',
        },
      );


      debugPrint("\n\n\n👉👉👉👉👉Response uri ${MKSCUrls.getbydishesurl}/$dishId");

      debugPrint("\n\n\nResponse status code ${response.statusCode}");

      // debugPrint("\n\n\n👉👉👉👉👉Response body ${response.body}");

      if (response.statusCode == 200) {

        final responseBody = response.body;

        final Map<String, dynamic> responseData = json.decode(responseBody);

        DetailedMenu detailedMenu = DetailedMenu.fromJson(responseData);

        return detailedMenu;
        
      } else {
        if(!context.mounted) return DetailedMenu.empty();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred during fetching detailed menu\n${response.statusCode}')),
        );
      }
      
    } catch (e) {
      debugPrint("\n\n\nError Data: $e\n\n\n");
      return DetailedMenu.empty();        
    }
    return DetailedMenu.empty(); 
  }
}