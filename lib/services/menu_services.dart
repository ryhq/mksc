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

      debugPrint("\n\n\nResponse status code ${response.statusCode}");
      debugPrint("\n\n\n👉👉👉👉👉Response body ${response.body}");

      if (response.statusCode == 200) {

        final responseBody = response.body;

        final Map<String, dynamic> responseData = json.decode(responseBody);

        // final Map<String, dynamic> dish = responseData['dish'];

        // final List<dynamic> portions = responseData['portions'];
        
        // final List<dynamic> otherDishesFromSelectedMenu = responseData['otherDishesFromSelectedMenu'];

        // Dish dishMenu = Dish.fromJson(dish);

        // final List<Portion> portionMenu = portions.map((portion) => Portion.fromJson(portion)).toList();

        // final List<OtherDish> otherDish = otherDishesFromSelectedMenu.map((other) => OtherDish.fromJson(other)).toList();

        DetailedMenu detailedMenu = DetailedMenu.fromJson(responseData);
        
        // debugPrint("\n\n\n Detailed menu dish 👉👉👉👉👉 ${detailedMenu.dish}");
        // debugPrint("\n\n\n Detailed menu image 👉👉👉👉👉 ${detailedMenu.image}");
        // debugPrint("\n\n\n Detailed menu otherDishesFromSelectedMenu 👉👉👉👉👉 ${detailedMenu.otherDishesFromSelectedMenu}");
        // debugPrint("\n\n\n Detailed menu portions 👉👉👉👉👉 ${detailedMenu.portions}");
        // debugPrint("\n\n\n Detailed menu video 👉👉👉👉👉 ${detailedMenu.video}");

        return detailedMenu;
        
      } else {
        if(!context.mounted) return DetailedMenu.empty();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred during fetching detailed menu\n${response.statusCode} ${response.body}')),
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

      debugPrint("\n\n\nResponse status code ${response.statusCode}");
      debugPrint("\n\n\n👉👉👉👉👉Response body ${response.body}");

      if (response.statusCode == 200) {

        final responseBody = response.body;

        final Map<String, dynamic> responseData = json.decode(responseBody);

        DetailedMenu detailedMenu = DetailedMenu.fromJson(responseData);

        return detailedMenu;
        
      } else {
        if(!context.mounted) return DetailedMenu.empty();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred during fetching detailed menu\n${response.statusCode} ${response.body}')),
        );
      }
      
    } catch (e) {
      debugPrint("\n\n\nError Data: $e\n\n\n");
      return DetailedMenu.empty();        
    }
    return DetailedMenu.empty(); 
  }
}