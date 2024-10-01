import 'package:flutter/material.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/provider/vegetable_provider.dart';
import 'package:mksc/utils/validator_utility.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/button.dart';
import 'package:provider/provider.dart';

class VegetableCardBottomSheet extends StatefulWidget {
  final Vegetable vegetableData;

  final String token;

  final String date;

  final bool? editCard;

  const VegetableCardBottomSheet(
      {super.key,
      required this.vegetableData,
      required this.token,
      required this.date,
      this.editCard = false});

  @override
  State<VegetableCardBottomSheet> createState() =>
      _VegetableCardBottomSheetState();
}

class _VegetableCardBottomSheetState extends State<VegetableCardBottomSheet> {
  TextEditingController editingController = TextEditingController();

  String selectedUnit = "Kg";

  List<String> units = [
    // Weight units
    "Kg",
    "gram",
    "ton",
    "pound",
    "ounce",

    // Volume units (for liquids or grains)
    "liter",
    "milliliter",
    "gallon",
    "pint",
    "quart",
    "barrel",
    "bushel",

    // Countable units (for individual items or livestock)
    "units",
    "pieces",
    "heads", // for livestock like cattle, goats, sheep
    "dozen",
    "bunch",
    "tray", // for eggs, seedlings

    // Area units (for land measurement, yield per area)
    "acre",
    "hectare",
    "square meter",
    "square foot",

    // Other units specific to certain crops or products
    "bale", // for hay, cotton
    "crate", // for fruits or vegetables
    "sack", // for potatoes, onions
    "carton", // for fruits like apples, oranges
    "bundle", // for tied crops like sugarcane, wheat
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.editCard!
        ? editingController.text = widget.vegetableData.number!
        : null;
    widget.editCard! ? selectedUnit = widget.vegetableData.unit! : null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Text(
                  widget.editCard!
                      ? "Edit ${widget.vegetableData.name} data"
                      : "Add ${widget.vegetableData.name} data",
                  style: Theme.of(context).textTheme.headlineSmall,
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
                          selectedUnit.isEmpty
                              ? "Select Unit"
                              : "Selected Unit",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(selectedUnit.isEmpty ? "" : selectedUnit,
                                style: selectedUnit.isEmpty
                                    ? Theme.of(context).textTheme.labelMedium
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontStyle: FontStyle.italic)),
                            PopupMenuButton<String>(
                              onSelected: (String unit) {
                                setState(() {
                                  selectedUnit = unit;
                                });
                              },
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).colorScheme.primary,
                                size: Provider.of<ThemeProvider>(context,
                                            listen: false)
                                        .fontSize +
                                    7,
                              ),
                              itemBuilder: (context) {
                                return units.map((unit) {
                                  return PopupMenuItem<String>(
                                    value: unit,
                                    child: Text(
                                      unit,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
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
                  ),
                ),
                const SizedBox(
                  height: 21,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: AppTextFormField(
                    hintText: "####",
                    iconData: widget.editCard! ? Icons.edit : Icons.add,
                    obscureText: false,
                    textInputType: const TextInputType.numberWithOptions(
                        decimal: false, signed: true),
                    textEditingController: editingController,
                    onChanged: (value) {
                      setState(() {
                        editingController.text = value;
                      });
                    },
                    validator: (value) => ValidatorUtility.validateRequiredField(
                        value,
                        "${widget.vegetableData.name} quantity is required."),
                  ),
                ),
                const SizedBox(
                  height: 21,
                ),
                if (selectedUnit.isNotEmpty ||
                    editingController.text.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Button(
                      title: "Clear",
                      danger: true,
                      onTap: () {
                        setState(() {
                          selectedUnit = "";
                          editingController.clear();
                        });
                      },
                    ),
                  )
                ],
                const SizedBox(
                  height: 21,
                ),
                if (selectedUnit.isNotEmpty &&
                    editingController.text.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Button(
                      title: widget.editCard! ? "Update" : "Save",
                      danger: false,
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          widget.editCard!
                              ? await Provider.of<VegetableProvider>(context,
                                      listen: false)
                                  .editVegetableData(
                                  context,
                                  token: widget.token,
                                  number: editingController.text,
                                  unit: selectedUnit,
                                  date: widget.date,
                                  id: widget.vegetableData.tempId!,
                                )
                              : await Provider.of<VegetableProvider>(context,
                                      listen: false)
                                  .saveVegetableData(context,
                                      token: widget.token,
                                      number: editingController.text,
                                      unit: selectedUnit,
                                      date: widget.date,
                                      item: widget.vegetableData.name);

                          setState(() {
                            selectedUnit = "";
                            editingController.clear();
                          });

                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
