import 'package:flutter/material.dart';
import 'package:mksc/model/detailed_menu.dart';
import 'package:mksc/model/menu.dart';
import 'package:mksc/model/other_dish.dart';
import 'package:mksc/services/menu_services.dart';

class MenuProvider with ChangeNotifier {
  
  List<Menu> _menuList = [];

  DetailedMenu _detailedMenu = DetailedMenu.empty();

  OtherDish _selectedDish = OtherDish.empty();

  OtherDish get selectedDish => _selectedDish;

  DetailedMenu  get detailedMenu => _detailedMenu;

  List<Menu> get menuList => _menuList;

  Future<void> fetchMenus(BuildContext context, {required String camp, required String day, required String  menuType}) async{
    try {

      final List<Menu> fetchedMenus = await MenuServices.getMenu(camp: camp, day: day, menuType: menuType);
      if (fetchedMenus.isNotEmpty) {
        _menuList.clear();
        _menuList = fetchedMenus;
        _detailedMenu = DetailedMenu.empty();
        _selectedDish = OtherDish.empty();
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

  Future<void> fetchDetailedMenu(BuildContext context, {required int id}) async{
    try {
      final DetailedMenu fetchedMenu = await MenuServices.getMenuDetailed(context, id: id);
      _detailedMenu = fetchedMenu;

      if (_selectedDish.dishName.isEmpty) {
        _selectedDish = detailedMenu.otherDishesFromSelectedMenu[0];
      }

      debugPrint("\n\n\n 👉👉👉👉 Detailed MENU : ${_detailedMenu.dish.id}");
      debugPrint("\n\n\nSelected Dish default to : 👉👉👉👉 : ${_selectedDish.dishName} id ${_selectedDish.id} ");
      notifyListeners();
    } catch (e) { 
      if(!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sorry, unable to fetch Detailed Menu, please try again later or check your network connection'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> getUpdatedMenuDetails(BuildContext context, {required int dishId}) async{
    try {
      final DetailedMenu fetchedMenu = await MenuServices.getUpdatedMenuDetails(context, dishId: dishId);
      _detailedMenu = fetchedMenu;
      notifyListeners();
    } catch (e) { 
      if(!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sorry, unable to fetch Detailed Menu, please try again later or check your network connection'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> setSelectedDish({required OtherDish selectedDish}) async{
    debugPrint("\n\n\n👉👉👉👉Set selected dish fron ${_selectedDish.dishName} to ${selectedDish.dishName}");
    _selectedDish = selectedDish;
    debugPrint("\n\n\n👉👉👉👉Selected dish is ${_selectedDish.dishName}");
    notifyListeners();
  }
}