
import 'package:flutter/material.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/provider/vegetable_provider.dart';
import 'package:mksc/utils/validator_utility.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/custom_alert.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

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

  String selectedUnit = "Kg";

  List<String> units = [
    "Kg",
    "gram",
    "units"
  ];

  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
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
                  opacity: isFocused ? 0.3 : 1,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                  
                          // image
                          widget.vegetableData.image.isNotEmpty ?
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              widget.vegetableData.image, 
                              width: 140,
                              height: 140,
                              errorBuilder: (context, error, stackTrace) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                );
                              },
                            ),
                          ) 
                          : 
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.image,
                              size: 50,
                              color: Theme.of(context).colorScheme.primary,
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
                                  Text(
                                    "${widget.vegetableData.number!} ${widget.vegetableData.unit!}",
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ]
                              
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // actions
                if(isFocused)...[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      constraints: const BoxConstraints(minHeight: 150.0),
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if(widget.vegetableData.number!.isEmpty)...[
                              IconButton(
                                tooltip: 'Add ${widget.vegetableData.name} data',
                                onPressed: () {
                                  CustomAlert.showAlertWidget(
                                    context, 
                                    title: "Add ${widget.vegetableData.name} data", 
                                    content: Form(
                                      key: _formKey,
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: Column(
                                          children: [
                                            AppTextFormField(
                                              hintText: "####", 
                                              iconData: Icons.add, 
                                              obscureText: false, 
                                              textInputType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                                              textEditingController: editingController,
                                              onChanged: (value) {
                                                setState(() {
                                                  editingController.text = value;
                                                });
                                              },
                                              validator: (value) => ValidatorUtility.validateRequiredField(value, "${widget.vegetableData.name} quantity is required."),
                                            ),
                                            Card(
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(21.0),
                                                side: BorderSide(
                                                  width: 1.5, 
                                                  color: Theme.of(context).colorScheme.onSurface
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: ListTile(
                                                  title: Text(
                                                    selectedUnit.isEmpty ? "Select Unit" : "Selected Unit",
                                                    style: Theme.of(context).textTheme.bodyMedium,
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        selectedUnit.isEmpty ? "" : selectedUnit,
                                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic)
                                                      ),
                                                      // selectedUnit.isNotEmpty ? const SizedBox() :
                                                      PopupMenuButton<String>(
                                                        onSelected: (String unit) {
                                                          setState(() {
                                                            selectedUnit = unit;
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Theme.of(context).colorScheme.primary,
                                                          size: Provider.of<ThemeProvider>(context, listen: false).fontSize + 7,
                                                        ),
                                                        itemBuilder: (context) {
                                                          return units.map((unit) {
                                                            return PopupMenuItem<String>(
                                                              value: unit,
                                                              child: Text(
                                                                unit,
                                                                style: Theme.of(context).textTheme.bodyMedium,
                                                              ),
                                                            );
                                                          }).toList();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  contentPadding: const EdgeInsets.all(0.0),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ), 
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          'Clear',
                                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.red)
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            editingController.clear();
                                          });
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Cancel',
                                          style: Theme.of(context).textTheme.labelLarge
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Save',
                                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.green)
                                        ),
                                        onPressed: () async{
                                          if (_formKey.currentState!.validate()) {
                                            Navigator.of(context).pop();

                                            await Provider.of<VegetableProvider>(context, listen: false).saveVegetableData(
                                              context, 
                                              token: widget.token, 
                                              number: editingController.text, 
                                              unit: selectedUnit, 
                                              date: widget.date,
                                              item: widget.vegetableData.name
                                            );
                                          }
                                        },
                                      ),
                                    ]
                                  );
                                }, 
                                icon: Icon(
                                  Icons.add_circle,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: Provider.of<ThemeProvider>(context).fontSize + 21,
                                )
                              )
                            ],

                            // Edit
                            
                            if(widget.vegetableData.number!.isNotEmpty)...[
                              IconButton(
                                tooltip: 'Edit ${widget.vegetableData.name} data',
                                onPressed: () {
                                  setState(() {
                                    editingController.text = widget.vegetableData.number!;
                                  });
                                  CustomAlert.showAlertWidget(
                                    context, 
                                    title: "Edit ${widget.vegetableData.name} data", 
                                    content: Form(
                                      key: _formKey,
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: Column(
                                          children: [
                                            AppTextFormField(
                                              hintText: "####", 
                                              iconData: Icons.edit, 
                                              obscureText: false, 
                                              textInputType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                                              textEditingController: editingController,
                                              onChanged: (value) {
                                                setState(() {
                                                  editingController.text = value;
                                                });
                                              },
                                              validator: (value) => ValidatorUtility.validateRequiredField(value, "${widget.vegetableData.name} quantity is required."),
                                            ),
                                            Card(
                                              elevation: 3,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(21.0),
                                                side: BorderSide(
                                                  width: 1.5, 
                                                  color: Theme.of(context).colorScheme.onSurface
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: ListTile(
                                                  title: Text(
                                                    selectedUnit.isEmpty ? "Select Unit" : "Selected Unit",
                                                    style: Theme.of(context).textTheme.bodyMedium,
                                                  ),
                                                  trailing: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        selectedUnit.isEmpty ? "" : selectedUnit,
                                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic)
                                                      ),
                                                      // selectedUnit.isNotEmpty ? const SizedBox() :
                                                      PopupMenuButton<String>(
                                                        onSelected: (String unit) {
                                                          setState(() {
                                                            selectedUnit = unit;
                                                          });
                                                        },
                                                        icon: Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Theme.of(context).colorScheme.primary,
                                                          size: Provider.of<ThemeProvider>(context, listen: false).fontSize + 7,
                                                        ),
                                                        itemBuilder: (context) {
                                                          return units.map((unit) {
                                                            return PopupMenuItem<String>(
                                                              value: unit,
                                                              child: Text(
                                                                unit,
                                                                style: Theme.of(context).textTheme.bodyMedium,
                                                              ),
                                                            );
                                                          }).toList();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  contentPadding: const EdgeInsets.all(0.0),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ), 
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          'Clear',
                                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.red)
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            editingController.clear();
                                          });
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Cancel',
                                          style: Theme.of(context).textTheme.labelLarge
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Save',
                                          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.green)
                                        ),
                                        onPressed: () async{
                                          if (_formKey.currentState!.validate()) {
                                            Navigator.of(context).pop();

                                            await Provider.of<VegetableProvider>(context, listen: false).editVegetableData(
                                              context, 
                                              token: widget.token, 
                                              number: editingController.text, 
                                              unit: selectedUnit, 
                                              id: widget.vegetableData.tempId!,
                                              date: widget.date
                                            );
                                          }
                                        },
                                      ),
                                    ]
                                  );
                                }, 
                                icon: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).colorScheme.error,
                                  size: Provider.of<ThemeProvider>(context).fontSize + 21,
                                )
                              )
                            ]
                          ],
                        ),
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