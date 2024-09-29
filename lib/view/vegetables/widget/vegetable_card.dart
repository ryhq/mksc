
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/provider/vegetable_provider.dart';
import 'package:mksc/utils/validator_utility.dart';
import 'package:mksc/view/vegetables/widget/vegetable_edit_or_add_bottom_sheet.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class VegetableCard extends StatefulWidget {
  const VegetableCard({
    super.key,
    required this.vegetableData, required this.token, required this.date,
  });

  final Vegetable vegetableData;

  final String token;

  final String date;

  @override
  State<VegetableCard> createState() => _VegetableCardState();
}

class _VegetableCardState extends State<VegetableCard> {  
  
  TextEditingController editingController = TextEditingController();
  
  final FocusNode _focusNode = FocusNode();

  bool savingState = false;

  bool editMode = false;

  String selectedUnit = "";

  List<String> units = [
    "Kg",         // Kilogram
    "g",          // Gram
    "ltr",        // Liter
    "unit",       // Unit (for items like pieces)
    "dozen",      // Dozen (12 items)
    "box",        // Box (for boxed items)
    "crate",      // Crate (for large quantities)
    "gallon",     // Gallon
  ];


  @override
  void initState() {
    super.initState();
    widget.vegetableData.unit != null ? selectedUnit = widget.vegetableData.unit! : null;
    // Add listener to the focus node to rebuild when focus changes
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose of the focus node to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFocused = _focusNode.hasFocus;
    return Column(
      children: [
        Focus(
          focusNode: _focusNode,
          child: GestureDetector(
            onTap: () {
              if (isFocused) {
                _focusNode.unfocus();
              }else{
                _focusNode.requestFocus(); 
              }
            },
            child: Stack(
              children: [
                Opacity(
                  opacity: isFocused && !editMode ? 0.3 : isFocused && editMode ? 0.7 : 1,
                  child: Card(
                    elevation: 3,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(21.0))),
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 150.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21.0),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.white,
                            Colors.grey[50]!,
                            Colors.blue[100]!,
                          ],
                        ),
                      ),
                      child: Opacity(
                        opacity: savingState ? 0.5 : 1.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                                          
                            // image
                            widget.vegetableData.image.isNotEmpty ?
                            GestureDetector(
                              onTap: () {
                                debugPrint("\n\n\nTapped as picture...👍👍👍\n\n\n");
                                showDialog(
                                  context: context, 
                                  builder: (context) => Dialog(
                                    elevation: 3.0,
                                    backgroundColor: Colors.transparent,
                                    insetAnimationCurve: Curves.slowMiddle,
                                    insetAnimationDuration: const Duration(milliseconds: 700),
                                    insetPadding: const EdgeInsets.all(21),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(21.0),
                                      child: PhotoView(
                                        minScale: PhotoViewComputedScale.contained,
                                        maxScale: PhotoViewComputedScale.covered * 2,
                                        imageProvider: NetworkImage(widget.vegetableData.image,),
                                        heroAttributes: PhotoViewHeroAttributes(tag: widget.vegetableData.image),
                                        backgroundDecoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.9)
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: widget.vegetableData.image,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    widget.vegetableData.image, 
                                    width: 140,
                                    height: 140,
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        // Image has loaded
                                        return child;
                                      } else {
                                        // Image is still loading
                                        return SizedBox(
                                          width: 140,
                                          height: 140,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: 140,
                                          height: 140,
                                          child: Icon(
                                            Icons.error,
                                            size: 50,
                                            color: Theme.of(context).colorScheme.error,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ) 
                            : 
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 140,
                                height: 140,
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                                          
                            // Details
                                          
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.vegetableData.name,
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                  const SizedBox(height: 10,),
                        
                                  if(widget.vegetableData.number!.isNotEmpty)...[
                                    
                                    if(editMode && isFocused)...[

                                      TextFormField(
                                        controller: editingController,
                                        autofocus: true,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                                        onChanged: (value) {
                                          // Check if the input is a positive integer
                                          if (value.isNotEmpty && int.tryParse(value) != null && int.parse(value) >= 0) {
                                            if (int.parse(value) <= 99999999) {
                                              setState(() {
                                                editingController.text = value;
                                              });
                                            }else{
                                              // Clear the input if it is invalid
                                              editingController.clear();
                                            }
                                          } else {
                                            // Clear the input if it is invalid
                                            editingController.clear();
                                          }
                                        },
                                        validator: (value) => ValidatorUtility.validateRequiredField(value, "${widget.vegetableData.name} quantity is required."),
                                      ),

                                      const SizedBox(height: 10),

                                      SizedBox(
                                        height: 50.0, // Adjust height as needed
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: units.length,
                                          physics: const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedUnit = units[index];
                                                });
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                                                decoration: BoxDecoration(
                                                  color: selectedUnit == units[index] ? 
                                                  Theme.of(context).colorScheme.primary :Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    units[index],
                                                    style: TextStyle(
                                                      color: selectedUnit == units[index] ? Colors.white : Colors.black,
                                                      fontWeight: selectedUnit == units[index] ? FontWeight.bold : FontWeight.normal,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      
                                      // Radio buttons for unit selection
                                      // SingleChildScrollView(
                                      //   child: Column(
                                      //     children: units.map((unit) {
                                      //       return RadioListTile<String>(
                                      //         title: Text(unit),
                                      //         value: unit,
                                      //         groupValue: selectedUnit,
                                      //         onChanged: (String? value) {
                                      //           setState(() {
                                      //             selectedUnit = value!;
                                      //           });
                                      //         },
                                      //       );
                                      //     }).toList(),
                                      //   ),
                                      // ),
                                    ]else...[
                                      Text(
                                        "${widget.vegetableData.number!} ${widget.vegetableData.unit!}",
                                        style: Theme.of(context).textTheme.titleMedium,
                                      ),
                                    ]
                                  ]
                                
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: savingState ? 1.0 : 0.0,
                    child: const Center(
                      child: BallPulseIndicator(),
                    ),
                  ),
                ),

                // actions
                if(isFocused && !savingState)...[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      constraints: const BoxConstraints(
                        // minHeight: 150.0
                      ),
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (widget.vegetableData.number!.isEmpty) ?
                          IconButton(
                            tooltip: 'Add ${widget.vegetableData.name} data',
                            onPressed: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                context: context, 
                                builder: (BuildContext context) {
                                  return VegetableEditOrAddBottomSheet(
                                    edit: false,
                                    vegetable: widget.vegetableData,
                                  );
                                },
                              );
                            }, 
                            icon: Icon(
                              Icons.add_circle,
                              color: Theme.of(context).colorScheme.primary,
                              size: Provider.of<ThemeProvider>(context).fontSize + 21,
                            )
                          )
                          
                          :
                        
                          /// Edit
                          
                          editMode ? ElevatedButton(
                            onPressed: () async{
                              setState(() {
                                savingState = true;
                              });
                              await Provider.of<VegetableProvider>(context, listen: false).editVegetableData(
                                context, 
                                token: widget.token, 
                                number: editingController.text, 
                                unit: selectedUnit, 
                                date: widget.date, 
                                id: widget.vegetableData.tempId!
                              );
                              setState(() {
                                savingState = false;
                                editMode = false;
                              });
                            }, 
                            child: Text(
                              "Update",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                            )
                          ) 
                          :
                          IconButton(
                            tooltip: 'Edit ${widget.vegetableData.name} data',
                            onPressed: () {
                              setState(() {
                                editingController.text = widget.vegetableData.number!;
                                editMode = !editMode;
                              });
                            }, 
                            icon: Icon(
                              editMode ? Icons.save : Icons.edit,
                              color: editMode ? Colors.green : Theme.of(context).colorScheme.error,
                              size: Provider.of<ThemeProvider>(context).fontSize + 21,
                            )
                          )
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ],
    );
  }
}