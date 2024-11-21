import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mksc/model/detailed_menu.dart';
import 'package:mksc/model/portion.dart';
import 'package:mksc/provider/menu_provider.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class PortionSection extends StatefulWidget {
  const PortionSection({super.key});

  @override
  State<PortionSection> createState() => _PortionSectionState();
}

class _PortionSectionState extends State<PortionSection> {
  TextEditingController paxController = TextEditingController();
  int paxCount = 1;
  @override
  Widget build(BuildContext context) {
    DetailedMenu detailedMenu = Provider.of<MenuProvider>(context, listen: true).detailedMenu;
    List<Portion> portionList = detailedMenu.portions;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "Portions Configurations",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Number of Pax",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Flexible(
                flex: 3,
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
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: Provider.of<ThemeProvider>(context).fontSize + 14
                  ),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide.none
                    ),
                    hintText: "123",
                    hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: 'Mono',
                      color: Colors.grey[400],
                      fontSize: Provider.of<ThemeProvider>(context).fontSize + 14
                    ),
                    hintTextDirection: TextDirection.rtl,
                  ),
                ),
              ),
            ],
          ),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  void updatePax(int newPax) {
    setState(() {
      paxCount = newPax;
    });
  }
}