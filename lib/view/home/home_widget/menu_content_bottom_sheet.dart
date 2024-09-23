import 'package:flutter/material.dart';
import 'package:mksc/model/camp.dart';
import 'package:mksc/model/menu.dart';
import 'package:mksc/model/menu_type.dart';
import 'package:mksc/provider/camp_provider.dart';
import 'package:mksc/provider/menu_provider.dart';
import 'package:mksc/provider/menu_type_provider.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/view/menu_screen/menu_screen.dart';
import 'package:mksc/widgets/app_circular_progress_indicator.dart';
import 'package:mksc/widgets/button.dart';
import 'package:provider/provider.dart';

class MenuContentBottomSheet extends StatefulWidget {
  const MenuContentBottomSheet({super.key});

  @override
  State<MenuContentBottomSheet> createState() => _MenuContentBottomSheetState();
}

class _MenuContentBottomSheetState extends State<MenuContentBottomSheet> {

  bool isLoadingCamps = false;

  bool isLoadingMenuPerCamp = false;

  bool isLoadingMenu = false;

  String selectedCamp = "";

  String selectedMenuTypePerCamp = "";

  String selectedDay = "";

  String selectedMenu = "";

  Menu realSelectedMenu = Menu.empty();

  List<String> daysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  void initState() {
    super.initState();
    fetchCamps();
  }

  @override
  Widget build(BuildContext context) {
    final List<Camp> camps = Provider.of<CampProvider>(context,).campList;
    final List<MenuType> menuTypePerCamp = Provider.of<MenuTypeProvider>(context,).menuTypeList;
    final List<Menu> menus = Provider.of<MenuProvider>(context).menuList;
    return Column(
      children: [

        // Select camp
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 0.2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: ListTile(
                title: Text(
                  selectedCamp.isEmpty ? "Select Camp" : "Selected Camp",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: isLoadingCamps ? const AppCircularProgressIndicator() : 
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedCamp.isEmpty ? "" : selectedCamp,
                      style: selectedCamp.isEmpty ? Theme.of(context).textTheme.labelMedium : Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic)
                    ),
                    selectedCamp.isNotEmpty ? const SizedBox() :
                    PopupMenuButton<Camp>(
                      enabled: selectedCamp.isEmpty,
                      onSelected: (Camp camp) {
                        setState(() {
                          selectedCamp = camp.camp;
                        });
                        fetchMenuTypePerCamp(selectedCamp: selectedCamp);
                      },
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).colorScheme.primary,
                        size: Provider.of<ThemeProvider>(context).fontSize + 7,
                      ),
                      itemBuilder: (context) {
                        return camps.map((camp) {
                          return PopupMenuItem<Camp>(
                            value: camp,
                            child: Text(
                              camp.camp,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
                contentPadding: const EdgeInsets.all(0.0),
              )
            ),
          ),
        ),

        // Select camp

        if(selectedCamp.isNotEmpty)...[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 0.2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: ListTile(
                  title: Text(
                    selectedMenuTypePerCamp.isEmpty ? "Choose Menu Type" : "Choosed Menu Type",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: isLoadingMenuPerCamp ? const AppCircularProgressIndicator() : 
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedMenuTypePerCamp.isEmpty ? "" :
                        selectedMenuTypePerCamp == "1" ? "Break Fast" : 
                        selectedMenuTypePerCamp == "2" ? "Lunch" : 
                        selectedMenuTypePerCamp == "3" ? "Dinner" : 
                        selectedMenuTypePerCamp == "4" ? "Picnic" : "",
                        style: selectedMenuTypePerCamp.isEmpty ? Theme.of(context).textTheme.labelMedium : Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic)
                      ),
                      selectedMenuTypePerCamp.isNotEmpty ? const SizedBox() :
                      PopupMenuButton<MenuType>(
                        onSelected: (MenuType menu) {
                          setState(() {
                            selectedMenuTypePerCamp = menu.type;
                          });
                          debugPrint("👉👉👉 Menu : $selectedMenuTypePerCamp");
                        },
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.primary,
                          size: Provider.of<ThemeProvider>(context).fontSize + 7,
                        ),
                        itemBuilder: (context) {
                          return menuTypePerCamp.map((menu) {
                            return PopupMenuItem<MenuType>(
                              value: menu,
                              child: Text(
                                menu.type == "1" ? "Break Fast" : 
                                menu.type == "2" ? "Lunch" : 
                                menu.type == "3" ? "Dinner" : 
                                menu.type == "4" ? "Picnic" : "",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                  contentPadding: const EdgeInsets.all(0.0),
                )
              ),
            ),
          ),
        ],

        // Select a day

        if(selectedMenuTypePerCamp.isNotEmpty)...[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 0.2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: ListTile(
                  title: Text(
                    selectedDay.isEmpty ? "Select a day" : "Selected a day",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedDay.isEmpty ? "" : selectedDay,
                        style: selectedDay.isEmpty ? Theme.of(context).textTheme.labelMedium : Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic)
                      ),
                      selectedDay.isNotEmpty ? const SizedBox() :
                      PopupMenuButton<String>(
                        onSelected: (String day) {
                          setState(() {
                            selectedDay = day;
                          });
                          fetchMenu(camp: selectedCamp, day: selectedDay, menuType: selectedMenuTypePerCamp);                   
                        },
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.primary,
                          size: Provider.of<ThemeProvider>(context).fontSize + 7,
                        ),
                        itemBuilder: (context) {
                          return daysOfWeek.map((day) {
                            return PopupMenuItem<String>(
                              value: day,
                              child: Text(
                                day,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                  contentPadding: const EdgeInsets.all(0.0),
                )
              ),
            ),
          ),
        ],

        // Select a Menu
        
        if(selectedDay.isNotEmpty)...[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 0.2,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10),
                child: ListTile(
                  title: Text(
                    selectedDay.isEmpty ? "Choose Menu" : "Choosed Menu",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: isLoadingMenu ? const AppCircularProgressIndicator() :
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedMenu.isEmpty ? "" : selectedMenu,
                        style: selectedMenu.isEmpty ? Theme.of(context).textTheme.labelMedium : Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic)
                      ),

                      selectedMenu.isNotEmpty ? const SizedBox() :
                      PopupMenuButton<Menu>(
                        onSelected: (Menu menu) {
                          setState(() {
                            selectedMenu = menu.menuName;
                            realSelectedMenu = menu;
                          });                          
                        },
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.primary,
                          size: Provider.of<ThemeProvider>(context).fontSize + 7,
                        ),
                        itemBuilder: (context) {
                          return menus.map((menu) {
                            return PopupMenuItem<Menu>(
                              value: menu,
                              child: Text(
                                menu.menuName,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                  contentPadding: const EdgeInsets.all(0.0),
                )
              ),
            ),
          ),
        ],

        if(selectedCamp.isNotEmpty || selectedDay.isNotEmpty || selectedMenu.isNotEmpty || selectedMenuTypePerCamp.isNotEmpty)...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Button(
              title: "Clear", 
              danger: true,
              onTap: () {
                setState(() {
                  selectedCamp = "";
                  selectedDay = "";
                  selectedMenuTypePerCamp = "";
                  selectedMenu = "";            
                });
              },
            ),
          )
        ],

        if(selectedCamp.isNotEmpty && selectedDay.isNotEmpty && realSelectedMenu.camp.isNotEmpty && selectedMenuTypePerCamp.isNotEmpty)...[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Button(
              title: "Check Menu", 
              danger: false,
              onTap: () {
                setState(() {
                  selectedCamp = "";
                  selectedDay = "";
                  selectedMenuTypePerCamp = "";
                  selectedMenu = "";            
                });
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => MenuScreen(menu: realSelectedMenu),));
              },
            ),
          )
        ],
        
      ],
    );
  }

  void fetchCamps() async{
    setState(() {
      isLoadingCamps = true;
    });
    await Provider.of<CampProvider>(context, listen: false).fetchCamps();
    setState(() {
      isLoadingCamps = false;
    });
  }

  void fetchMenuTypePerCamp({required String selectedCamp}) async{
    debugPrint("\n\n\n👉👉👉Fetching Menu type for $selectedCamp");
    setState(() {
      isLoadingMenuPerCamp = true;
    });
    await Provider.of<MenuTypeProvider>(context, listen: false).fetchMenus(context, camp: selectedCamp);
    setState(() {
      isLoadingMenuPerCamp = false;
    });
  }

  void fetchMenu({required String camp, required String day, required String  menuType}) async{
    debugPrint("\n\n\n👉👉👉Fetching Menu for $selectedCamp");
    setState(() {
      isLoadingMenu = true;
    });
    await Provider.of<MenuProvider>(context, listen: false).fetchMenus(context, camp: selectedCamp, day: day, menuType: menuType);
    setState(() {
      isLoadingMenu = false;
    });
  }
}