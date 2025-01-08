import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/providers/internet_connection_provider.dart';
import 'package:mksc/providers/theme_provider.dart';
import 'package:mksc/providers/vegetable_provider.dart';
import 'package:mksc/utilities/color_utility.dart';
import 'package:mksc/utilities/validator_utility.dart';
import 'package:mksc/views/vegetables/widgets/vegetable_image_section.dart';
import 'package:mksc/widgets/app_animated_switcher.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:provider/provider.dart';

class VegetableCard extends StatefulWidget {
  const VegetableCard({
    super.key,
    required this.vegetableData, required this.date, required this.title,
  });

  final Vegetable vegetableData;
  final String date;
  final String title;
  @override
  State<VegetableCard> createState() => _VegetableCardState();
}

class _VegetableCardState extends State<VegetableCard> {  
  
  TextEditingController editingController = TextEditingController();
  
  final FocusNode _focusNode = FocusNode();

  bool savingState = false;

  bool editMode = false;
  
  bool addMode = false;

  String selectedUnit = "";

  final _formKey = GlobalKey<FormState>();


  List<String> units = [
    "Kg",         // Kilogram
    "g",          // Gram
    "ltr",        // Liter
    "unit",       // Unit (for items like pieces)
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
    bool internetConnection = Provider.of<InternetConnectionProvider>(context).isConnected;
    bool isFocused = _focusNode.hasFocus;
    return AbsorbPointer(
      absorbing: savingState,
      child: Focus(
        focusNode: _focusNode,
        child: GestureDetector(
          onTap: () {
            if (isFocused) {
              _focusNode.unfocus();
              setState(() {
                addMode = false;
                editMode = false;
              });
            }else{
              _focusNode.requestFocus();
            }
          },
          child: Card(
            elevation: 3,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(21.0))),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(21.0),
              child: Slidable(
                enabled: !editMode,
                key: ValueKey(widget.vegetableData.id),
                startActionPane: !widget.vegetableData.isLocal ? null : 
                ActionPane(
                  motion: const StretchMotion(), 
                  children: <Widget>[
                    SlidableAction(
                      onPressed: (context) async{
                        if (!internetConnection) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "No internet", 
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white
                                ),
                              ),
                              backgroundColor: Colors.red,
                            )
                          );
                          return;
                        }

                        setState(() {
                          savingState = true;
                        });

                        await Provider.of<VegetableProvider>(context, listen: false).uploadSingleLocalData(
                          context: context, 
                          title: widget.title, 
                          localData: widget.vegetableData
                        ).then(
                          (_){
                            setState(() {
                              savingState = false;
                            });
                          }
                        );
                      },
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Colors.orange,
                      icon: Icons.upload,
                      label: 'Upload ${widget.vegetableData.name} data',
                    )
                  ]
                ),
                endActionPane: !widget.vegetableData.isLocal ? null : 
                ActionPane(
                  motion: const StretchMotion(), 
                  children: <Widget>[
                    SlidableAction(
                      onPressed: (context) => _deleteVegetableData(context),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Colors.red,
                      icon: CupertinoIcons.delete,
                      label: 'Delete ${widget.vegetableData.name} data',
                    )
                  ]
                ),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 150.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21.0),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        // Theme.of(context).colorScheme.surface,
                        // Colors.white,
                        // Colors.grey[50]!,
                        ColorUtility.calculateSecondaryColorWithAlpha(primaryColor: Theme.of(context).colorScheme.primary, alpha: 90),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: editMode ?
                        (
                          (isFocused && !editMode) ? 0.3 : 
                          (isFocused && !editMode) ? 0.7 :
                          1
                        ) : (
                          (isFocused && !addMode) ? 0.3 : 
                          (isFocused && !addMode) ? 0.7 :
                          1
                        ),
                        child: Opacity(
                          opacity: savingState ? 0.5 : 1.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                
                              // Image Section
                
                              VegetableImageSection(vegetable: widget.vegetableData),
                
                              // Detail Section
                                            
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

                                    AppAnimatedSwitcher(
                                      show: widget.vegetableData.isLocal,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(
                                                Radius.circular(21),
                                              ),
                                              border: Border.all(color: Colors.orange),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                              child: Text(
                                                "Local",
                                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                  color: Colors.orange
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 21,),
                                          if(widget.vegetableData.isConflict)...[
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(21),
                                                ),
                                                border: Border.all(color: Colors.red),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                                child: Text(
                                                  "Conflict",
                                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                    color: Colors.red
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 10,),
                                                      
                                    if(widget.vegetableData.number!.isNotEmpty)...[
                                      
                                      if((editMode && isFocused))...[
                                                            
                                        Form(
                                          key: _formKey,
                                          child: TextFormField(
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
                                                    if (selectedUnit == units[index]) {
                                                      selectedUnit = "";
                                                    } else {
                                                      selectedUnit = units[index];
                                                    }
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
                                      ]else...[
                                        Text(
                                          "${widget.vegetableData.number!} ${widget.vegetableData.unit!}",
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ]
                                    ]else...[
                                      if((addMode && isFocused))...[
                                        Form(
                                          key: _formKey,
                                          child: TextFormField(
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
                                                    if (selectedUnit == units[index]) {
                                                      selectedUnit = "";
                                                    } else {
                                                      selectedUnit = units[index];
                                                    }
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
                                      ]
                                    ]
                                  ],
                                ),
                              ),
                            ],
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
                            color: Colors.transparent,
                            child: (widget.vegetableData.number!.isEmpty) ? 
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: addMode ? ElevatedButton(
                                onPressed: () async{
                                  if (_formKey.currentState!.validate() && selectedUnit.isNotEmpty) {
                                    setState(() {
                                      savingState = true;
                                    });
                                    
                                    await Provider.of<VegetableProvider>(context, listen: false).saveVegetableData(
                                      context : context, 
                                      title: widget.title,
                                      number: editingController.text, 
                                      unit: selectedUnit, 
                                      date: widget.date, 
                                      item: widget.vegetableData.name
                                    );
                                    
                                    setState(() {
                                      savingState = false;
                                      addMode = false;
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Be sure to select unit and input valid data for ${widget.vegetableData.name}'),
                                        backgroundColor: Theme.of(context).colorScheme.error
                                      ),
                                    );
                                  }
                                }, 
                                child: Text(
                                  "Save",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                                )
                              ) 
                              :
                              IconButton(
                                tooltip: 'Add ${widget.vegetableData.name} data',
                                onPressed: () {
                                  setState(() {
                                    editingController.text = widget.vegetableData.number!;
                                    addMode = !addMode;
                                  });
                                }, 
                                icon: Icon(
                                  addMode ? Icons.save : Icons.add_circle_outline_outlined,
                                  color: addMode ? Colors.green : Theme.of(context).colorScheme.primary,
                                  size: Provider.of<ThemeProvider>(context).fontSize + 21,
                                )
                              )
                            )
                            :
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: editMode ? ElevatedButton(
                                onPressed: () async{
                                  if (_formKey.currentState!.validate() && selectedUnit.isNotEmpty) {
                                    setState(() {
                                      savingState = true;
                                    });
                                    await Provider.of<VegetableProvider>(context, listen: false).editVegetableData(
                                      context: context, 
                                      title: widget.title,
                                      vegetable: widget.vegetableData,
                                      number: editingController.text, 
                                      unit: selectedUnit, 
                                      date: widget.date, 
                                    );
                                    if (context.mounted) {
                                      setState(() {
                                        savingState = false;
                                        editMode = false;
                                      });
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Be sure to select unit and input valid data for ${widget.vegetableData.name}'),
                                        backgroundColor: Theme.of(context).colorScheme.error
                                      ),
                                    );
                                  }
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
                            ) 
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _deleteVegetableData(BuildContext context) {
    
    Provider.of<VegetableProvider>(context, listen: false).deleteVegetableData(
      context: context,
      title: widget.title,
      vegetable: widget.vegetableData,
      date: widget.date
    );
    
  }
}