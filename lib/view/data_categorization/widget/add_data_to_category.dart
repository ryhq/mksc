import 'package:flutter/material.dart';
import 'package:mksc/services/population_data_services.dart';
import 'package:mksc/utils/validator_utility.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:mksc/widgets/button.dart';

class AddDataToCategory extends StatefulWidget {
  final String categoryTitle;
  final List<String> selectedCategories;
  const AddDataToCategory({super.key, required this.selectedCategories, required this.categoryTitle});

  @override
  State<AddDataToCategory> createState() => _AddDataToCategoryState();
}

class _AddDataToCategoryState extends State<AddDataToCategory> {
  final TextEditingController dataController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool savingClicked = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.selectedCategories.length == 1 ? 
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Data for ${widget.categoryTitle} - ${widget.selectedCategories[0]}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 21,),
            Form(
              key: _formKey,
              child: AppTextFormField(
                hintText: "123", 
                iconData: Icons.numbers, 
                obscureText: false, 
                textInputType: TextInputType.number,
                textEditingController: dataController,
                validator: (value) => ValidatorUtility.validateRequiredField(value, "Integer Quantity for ${widget.selectedCategories[0]} is required"),
              ),
            ),
            const SizedBox(height: 21,),
            GridView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3, // For landscape mode, show 4 items per row,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                childAspectRatio: 3.0
              ),
              children: [
                Button(
                  title: "Clear", 
                  onTap: () {
                    setState(() {
                      widget.selectedCategories.clear();
                      _formKey.currentState!.reset();
                      dataController.clear();
                    });
                  },
                  danger: true,
                  vibrate: false,
                ),
                savingClicked ? const BallPulseIndicator() :
                Button(
                  title: "Save", 
                  onTap: () async{
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        savingClicked = true;
                      });
                      await PopulationDataServices.saveData(context, item: widget.selectedCategories[0], number: int.parse(dataController.text));
                      setState(() {
                        widget.selectedCategories.clear();
                        _formKey.currentState!.reset();
                        dataController.clear();
                        savingClicked = false;
                      });
                    }
                  },
                  danger: false,
                  vibrate: false,
                ),
              ],
            ),
            const SizedBox(height: 21,),
          ],
        ) : const SizedBox(),
      ],
    );
  }
}