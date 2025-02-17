import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/detailed_menu.dart';
import 'package:mksc/model/menu.dart';
import 'package:mksc/model/other_dish.dart';
import 'package:mksc/providers/menu_provider.dart';
import 'package:mksc/providers/theme_provider.dart';
import 'package:mksc/views/menu/menu_video_screen.dart';
import 'package:mksc/views/menu/portion%20widget/dish_image_section.dart';
import 'package:mksc/views/menu/portion_configuration.dart';
import 'package:mksc/views/menu/recipe_part.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  final Menu menu;
  const MenuScreen({super.key, required this.menu});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  bool isFetchDetailedMenu = false;

  @override
  void initState() {
    super.initState();
    fetchDetailedMenu();
  }
  @override
  Widget build(BuildContext context) {

    DetailedMenu detailedMenu = Provider.of<MenuProvider>(context, listen: true).detailedMenu;

    OtherDish selectedDish = Provider.of<MenuProvider>(context, listen: true).selectedDish;

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            leading: Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(21.0),
                      child: Icon(
                        CupertinoIcons.back,
                        color: Colors.white,
                        size: Provider.of<ThemeProvider>(context).fontSize + 7,
                      ),
                    ),
                  ),
                );
              },
            ),
            title: Text(
              selectedDish.dishName.isEmpty ? "Menu" : selectedDish.dishName.toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
            bottom: TabBar(
              indicatorColor: Colors.orange,
              indicatorWeight: 2,
              tabs: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Portion Configurations',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Recipe',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    'Dish Image',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)
                  ),
                ),
              ],
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.primary
          ),
          floatingActionButton: detailedMenu.video.isEmpty ? null : FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VideoScreen(detailedMenu: detailedMenu),));
            },
            tooltip: "Video",
            shape: const OvalBorder(eccentricity: 1, side: BorderSide.none),
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(
              CupertinoIcons.play_rectangle,
              size: 30,
              color: Colors.white,
            ),
          ),
          body: TabBarView(
            children: [
              PortionConfiguration(menu: widget.menu),
              RecipePart(menu: widget.menu),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: DishImageSection(),
              )
            ]
          ),
        )
      ),
    );
  }

  
  void fetchDetailedMenu() async{
    setState(() {
      isFetchDetailedMenu = true;
    });
      
    await Provider.of<MenuProvider>(context, listen: false).fetchDetailedMenu(context, id: widget.menu.id);
    
    setState(() {
      isFetchDetailedMenu = false;
    });
  }
}
