import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/utils/validator_utility.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/button.dart';
import 'package:provider/provider.dart';

class VegetableEditOrAddBottomSheet extends StatefulWidget {
  final Vegetable vegetable;
  final bool edit;
  const VegetableEditOrAddBottomSheet({super.key, required this.vegetable, required this.edit});

  @override
  State<VegetableEditOrAddBottomSheet> createState() => _VegetableEditOrAddBottomSheetState();
}

class _VegetableEditOrAddBottomSheetState extends State<VegetableEditOrAddBottomSheet> {

  String selectedUnit = "Kg";

  List<String> units = [
    "Kg",
    "gram",
    "units"
  ];

  final GlobalKey<PopupMenuButtonState<String>> _selectUnitKey = GlobalKey<PopupMenuButtonState<String>>();

  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(218, 242, 250, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                widget.edit ?  "Edit ${widget.vegetable.name}." : "Add ${widget.vegetable.name}.",
                style: Theme.of(context).textTheme.headlineMedium
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
                        selectedUnit.isEmpty ? "Select Unit" : "Selected Unit",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedUnit.isEmpty ? "" : selectedUnit,
                            style: selectedUnit.isEmpty ? Theme.of(context).textTheme.labelMedium : Theme.of(context).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic)
                          ),
                          // selectedUnit.isNotEmpty ? const SizedBox() :
                          PopupMenuButton<String>(
                            key: _selectUnitKey,
                            enabled: selectedUnit.isEmpty,
                            onSelected: (String unit) {
                              setState(() {
                                selectedUnit = unit;
                              });
                            },
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: Theme.of(context).colorScheme.primary,
                              size: Provider.of<ThemeProvider>(context).fontSize + 7,
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
                      onTap: () {
                        _selectUnitKey.currentState?.showButtonMenu();
                      },
                    )
                  ),
                ),
              ),
              AppTextFormField(
                hintText: "####", 
                iconData: Icons.add, 
                obscureText: false, 
                textInputType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                textEditingController: editingController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
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
                validator: (value) => ValidatorUtility.validateRequiredField(value, "${widget.vegetable.name} quantity is required."),
              ),
              if(selectedUnit.isNotEmpty)...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Button(
                    title: "Save", 
                    danger: false,
                    onTap: () {
                      setState(() {
                        selectedUnit = "";          
                      });
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}