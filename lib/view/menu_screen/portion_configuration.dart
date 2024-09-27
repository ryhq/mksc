import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mksc/model/detailed_menu.dart';
import 'package:mksc/model/menu.dart';
import 'package:mksc/model/other_dish.dart';
import 'package:mksc/model/portion.dart';
import 'package:mksc/provider/menu_provider.dart';
import 'package:mksc/provider/theme_provider.dart';
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
  bool isFetchDetailedMenu = false;

  TextEditingController paxController = TextEditingController();

  bool isUpdateDetailedMenu = false;

  OtherDish selectedDish = OtherDish.empty();

  final GlobalKey<PopupMenuButtonState<OtherDish>> _popupDishKey = GlobalKey<PopupMenuButtonState<OtherDish>>();
  
  int paxCount = 1;


  @override
  void initState() {
    super.initState();
    fetchDetailedMenu();
  }
  @override
  Widget build(BuildContext context) {

    DetailedMenu detailedMenu = Provider.of<MenuProvider>(context, listen: true).detailedMenu;

    List<Portion> portionList = detailedMenu.portions;

    List<OtherDish> otherDishList = detailedMenu.otherDishesFromSelectedMenu;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: isFetchDetailedMenu ? const ShimmerWidgets(totalShimmers: 4) :
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

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
                          selectedDish = otherDish;
                          paxCount = 1; // Reset pax count
                        });
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
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    "Portions Configurations",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Number of Pax",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: paxController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                        textAlign: TextAlign.right,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (String value) {
                          // Check if the input is a positive integer
                          if (value.isNotEmpty && int.tryParse(value) != null && int.parse(value) >= 0) {
                            if (int.parse(value) <= 9999) {
                              setState(() {
                                updatePax(int.parse(value));
                              });
                            }else{
                              // Clear the input if it is invalid
                              paxController.clear();
                              updatePax(1);
                            }
                          } else {
                            // Clear the input if it is invalid
                            paxController.clear();
                            updatePax(1);
                          }
                        },
                        style: Theme.of(context).textTheme.labelLarge,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide.none),
                          hintText: "123",
                          hintStyle: Theme.of(context).textTheme.labelLarge,
                          hintTextDirection: TextDirection.rtl,
                          suffixIcon: paxController.text.toString().isNotEmpty ? IconButton(
                            onPressed: () {
                              setState(() {
                                paxController.clear();
                                updatePax(1);
                              });
                            },
                            icon: Icon(
                              Icons.cancel,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ) : null,
                        ),
                      ),
                    ),
                  ],
                ),
      
                Card(
                  elevation: 12.0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(28.0)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(21.0)),
                    child: Table(
                      border: TableBorder.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.5,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(1),
                      },
                        
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          children: [
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: Text(
                                    'Product Name',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.surface
                                    )
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Center(
                                child: Padding(
                                  padding:const  EdgeInsets.only(top: 10.0, bottom: 10.0),
                                  child: Text(
                                    'Unit Needed',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.surface
                                    )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    
                        for(int index = 0; index < portionList.length ; index++)...[
                          TableRow(
                            decoration: BoxDecoration(
                              color: index % 2 == 0 ? Theme.of(context).colorScheme.primary.withAlpha(70) : null,
                            ),
                            children: [
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          portionList[index].productName,
                                          style: Theme.of(context).textTheme.bodyMedium
                                        ),
                                        if(portionList[index].extraDetails != null)...[
                                          Text(
                                            "(${portionList[index].extraDetails!})",
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary)
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Center(
                                  child: Padding(
                                    padding:const  EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    child: Text(
                                      portionList[index].multiply == 1 ?
                                      "${(double.parse(portionList[index].unitNeeded) * paxCount).toStringAsFixed(2)} ${portionList[index].unit}" 
                                      :
                                      "${double.parse(portionList[index].unitNeeded).toStringAsFixed(2)} ${portionList[index].unit}",
                                      style: Theme.of(context).textTheme.bodyMedium
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                    
                        
                        // for(var portion in portionList)...[
                        //   TableRow(
                        //     children: [
                        //       TableCell(
                        //         child: Center(
                        //           child: Padding(
                        //             padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        //             child: Column(
                        //               children: [
                        //                 Text(
                        //                   portion.productName,
                        //                   style: Theme.of(context).textTheme.bodyMedium
                        //                 ),
                        //                 if(portion.extraDetails != null)...[
                        //                   Text(
                        //                     "(${portion.extraDetails!})",
                        //                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary)
                        //                   ),
                        //                 ]
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       TableCell(
                        //         child: Center(
                        //           child: Padding(
                        //             padding:const  EdgeInsets.only(top: 10.0, bottom: 10.0),
                        //             child: Text(
                        //               portion.multiply == 1 ?
                        //               "${(double.parse(portion.unitNeeded) * paxCount).toStringAsFixed(2)} ${portion.unit}" 
                        //               :
                        //               "${double.parse(portion.unitNeeded).toStringAsFixed(2)} ${portion.unit}",
                        //               style: Theme.of(context).textTheme.bodyMedium
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ],
                      ],
                    ),
                  ),
                ),
                if (detailedMenu.image.isNotEmpty) ...[
                  const SizedBox(height: 8.0,),

                  Text(
                    "Dish Image",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      elevation: 12.0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(21.0)),
                      ),
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: 300,
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(21.0)),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(21.0)),
                          child: Image.network(
                            width: MediaQuery.of(context).size.width,
                            height: 350,
                            detailedMenu.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
              )
            ]
          ],
        ),
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

  void getUpdatedMenuDetails({required int dishId}) async{
    setState(() {
      isUpdateDetailedMenu = true;
    });
    
    await Provider.of<MenuProvider>(context, listen: false).getUpdatedMenuDetails(context, dishId: dishId);

    setState(() {
      isUpdateDetailedMenu = false;
    });
  }

  void updatePax(int newPax) {
    setState(() {
      paxCount = newPax;
    });
  }
}