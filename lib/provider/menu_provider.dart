import 'package:flutter/material.dart';
import 'package:mksc/model/menu.dart';
import 'package:mksc/services/menu_services.dart';

class MenuProvider with ChangeNotifier {
  
  List<Menu> _menuList = [];

  List<Menu> get menuList => _menuList;

  Future<void> fetchMenus(BuildContext context, {required String camp, required String day, required String  menuType}) async{
    try {
      final List<Menu> fetchedMenus = await MenuServices.getMenu(camp: camp, day: day, menuType: menuType);
      if (fetchedMenus.isNotEmpty) {
        _menuList.clear();
        _menuList = fetchedMenus;
      }
      notifyListeners();
    } catch (e) { 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sorry, unable to fetch Menus for $camp, please try again later or check your network connection'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}