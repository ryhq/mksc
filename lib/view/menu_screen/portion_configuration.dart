import 'package:flutter/material.dart';
import 'package:mksc/model/detailed_menu.dart';
import 'package:mksc/model/menu.dart';
import 'package:mksc/model/other_dish.dart';
import 'package:mksc/provider/menu_provider.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/view/menu_screen/portion%20widget/dish_image_section.dart';
import 'package:mksc/view/menu_screen/portion%20widget/portion_section.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:mksc/widgets/shimmer_widgets.dart';
import 'package:provider/provider.dart';

class PortionConfiguration extends StatefulWidget {
  final Menu menu;

  const PortionConfiguration({super.key, required this.menu,});

  @override
  State<PortionConfiguration> createState() => _PortionConfigurationState();
}

class _PortionConfigurationState extends State<PortionConfiguration> {

  TextEditingController paxController = TextEditingController();

  bool isUpdateDetailedMenu = false;

  bool isFetchDetailedMenu = false;

  final GlobalKey<PopupMenuButtonState<OtherDish>> _popupDishKey = GlobalKey<PopupMenuButtonState<OtherDish>>();
  
  int paxCount = 1;

  @override
  Widget build(BuildContext context) {

    DetailedMenu detailedMenu = Provider.of<MenuProvider>(context, listen: true).detailedMenu;

    List<OtherDish> otherDishList = detailedMenu.otherDishesFromSelectedMenu;

    OtherDish selectedDish = Provider.of<MenuProvider>(context, listen: true).selectedDish;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: 
        detailedMenu.dish.id == 0 ? 
        const ShimmerWidgets(totalShimmers: 4) :
        // isFetchDetailedMenu ?
        // const BallPulseIndicator() :
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                
            const SizedBox(height: 12.0,),

            if(otherDishList.isEmpty)...[
              IconButton(
                onPressed: () {
                  fetchDetailedMenu();
                }, 
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.primary,
                )
              )
            ]else...[
              Text(
                selectedDish.dishName.isEmpty ? "Select a Dish" : "Selected Dish",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
      
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
                        selectedDish.dishName.isEmpty ? "Tap Here" : selectedDish.dishName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: PopupMenuButton<OtherDish>(
                        key: _popupDishKey,
                        onSelected: (OtherDish otherDish) {
                          setState(() {
                            paxCount = 1; // Reset pax count
                          });
                          Provider.of<MenuProvider>(context, listen: false).setSelectedDish(
                            selectedDish: otherDish
                          );
                          getUpdatedMenuDetails(dishId: otherDish.id);
                        },
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).colorScheme.primary,
                          size: Provider.of<ThemeProvider>(context).fontSize + 7,
                        ),
                        itemBuilder: (context) {
                          return otherDishList.map((otherDish) {
                            return PopupMenuItem<OtherDish>(
                              value: otherDish,
                              child: Text(
                                otherDish.dishName,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }).toList();
                        },
                      ),
                      contentPadding: const EdgeInsets.all(0.0),
                      onTap: () {
                        _popupDishKey.currentState?.showButtonMenu();
                      },
                    )
                  ),
                ),
              ),
      
              if(selectedDish.dishName.isNotEmpty)...[  
                
                if(isUpdateDetailedMenu)...[
                  const BallPulseIndicator()
                ]else...[
                  // Table 
                  const SizedBox(height: 8.0,),
        
                  detailedMenu.portions.isEmpty ? const SizedBox() : const PortionSection(),

                  if (detailedMenu.image.isNotEmpty) ...[
                    const SizedBox(height: 8.0,),
                    
                    const DishImageSection()
                  ]else...[
                    const SizedBox(height: 21.0,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Dish Image Unavailable",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8.0,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
                ]
              ]else...[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.hourglass_empty,
                          color: Theme.of(context).colorScheme.error,
                          size: Provider.of<ThemeProvider>(context).fontSize + 84,
                        ),

                        Text(
                          "Please select a dish of your choice",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                    ),
                  ),
                ),
              ]
            ]
          ],
        ),
      ),
    );
  }

  void getUpdatedMenuDetails({required int dishId}) async{
    setState(() {
      isUpdateDetailedMenu = true;
    });
    
    await Provider.of<MenuProvider>(context, listen: false).getUpdatedMenuDetails(context, dishId: dishId);

    setState(() {
      isUpdateDetailedMenu = false;
    });
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