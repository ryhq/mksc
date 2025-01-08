import 'package:flutter/material.dart';
import 'package:mksc/model/chicken_house_product.dart';
import 'package:mksc/providers/chicken_house_provider.dart';
import 'package:mksc/providers/theme_provider.dart';
import 'package:mksc/utilities/validator_utility.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:mksc/widgets/button.dart';
import 'package:provider/provider.dart';

class ChickenHouseDataEntry extends StatefulWidget {
  final ChickenHouseProduct chickenHouseProduct;
  final String categoryTitle;
  final String date;
  final VoidCallback onSaving; 
  final VoidCallback onSavingDone; 
  const ChickenHouseDataEntry({
    super.key, 
    required this.chickenHouseProduct, 
    required this.categoryTitle, 
    required this.onSaving, 
    required this.onSavingDone, 
    required this.date
  });

  @override
  State<ChickenHouseDataEntry> createState() => _ChickenHouseDataEntryState();
}

class _ChickenHouseDataEntryState extends State<ChickenHouseDataEntry> {
  TextEditingController dataController = TextEditingController();
  bool savingClicked = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 42,),
        Text(
          "Enter Data for ${widget.categoryTitle} - ${widget.chickenHouseProduct.name}",
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
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[400],
              fontSize: Provider.of<ThemeProvider>(context).fontSize + 14
            ),

            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: Provider.of<ThemeProvider>(context).fontSize + 14
            ),
            onChanged: (value) {
              // Check if the input is a positive integer
              if (value.isNotEmpty && int.tryParse(value) != null && int.parse(value) > 0) {
                if (int.parse(value) <= 99999999) {
                  setState(() {
                    dataController.text = value;
                  });
                }else{
                  // Clear the input if it is invalid
                  dataController.clear();
                }
              } else {
                // Clear the input if it is invalid
                dataController.clear();
              }
            },
            validator: (value) => ValidatorUtility.validateRequiredField(value, "Integer Quantity for ${widget.chickenHouseProduct.name} is required"),
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
              danger: true,
              vibrate: false,
              onTap: () {
                setState(() {
                  _formKey.currentState!.reset();
                  dataController.clear();
                });
                widget.onSavingDone();
              },
            ),
            savingClicked ? const BallPulseIndicator() : Button(
              title: "Save",
              danger: false,
              vibrate: false,
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    savingClicked = true;
                  });
                  widget.onSaving();
                  await Provider.of<ChickenHouseProvider>(context, listen: false).saveChickenHouse(
                    context: context,
                    item: widget.chickenHouseProduct.name, 
                    number: int.parse(dataController.text), 
                    date: widget.date,
                    title: widget.categoryTitle
                  );
                  setState(() {
                    _formKey.currentState!.reset();
                    dataController.clear();
                    savingClicked = false;
                  });
                  widget.onSavingDone();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 21,),
      ],
    );
  }
}