import 'package:flutter/material.dart';
import 'package:mksc/model/menu_type.dart';
import 'package:mksc/services/menu_type_services.dart';

class MenuTypeProvider with ChangeNotifier {
  
  List<MenuType> _menuTypeList = [];

  List<MenuType> get menuTypeList => _menuTypeList;

  Future<void> fetchMenus(BuildContext context, {required String camp}) async{
    try {
      final List<MenuType> fetchedMenus = await MenuTypeServices.getMenuPerCamp(camp: camp);
      if (fetchedMenus.isNotEmpty) {
        _menuTypeList.clear();
        _menuTypeList = fetchedMenus;
      }
      notifyListeners();
    } catch (e) { 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sorry, unable to fetch Menus for $camp, please try again later or check your network connection'),
          backgroundColor: Colors.red,
        ),
      );
      // Fluttertoast.showToast(
      //   msg: "Sorry, unable to fetch Menus for $camp, please try again later or check your network connection",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16.0,
      // );  
    }
  }
}