import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/menu.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/view/menu_screen/portion_configuration.dart';
import 'package:mksc/view/menu_screen/recipe_part.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  final Menu menu;
  const MenuScreen({super.key, required this.menu});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint("\n\n\nMenu id ${widget.menu.id}");
    debugPrint("\n\n\nMenu menuName ${widget.menu.menuName}");
    debugPrint("\n\n\nMenu camp ${widget.menu.camp}");
    return Scaffold(
      body: DefaultTabController(
        length: 2, 
        child: Scaffold(
          appBar: AppBar(
            leading: Builder(
              builder: (context) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Icon(
                      CupertinoIcons.back,
                      color: Colors.white,
                      size: Provider.of<ThemeProvider>(context).fontSize + 7,
                    ),
                  ),
                );
              },
            ),
            title: Text(
              "${widget.menu.camp}\n${widget.menu.menuName}",
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
              ],
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.primary
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              
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
              RecipePart(menu: widget.menu)
            ]
          ),
        )
      ),
    );
  }
}