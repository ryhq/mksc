import 'package:flutter/material.dart';
import 'package:mksc/provider/chicken_house_data_provider.dart';
import 'package:mksc/utils/validator_utility.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:mksc/widgets/button.dart';
import 'package:provider/provider.dart';

class AddChickenHouseData extends StatefulWidget {
  final String categoryTitle;
  final String item;
  final String token;
  final String date;
  const AddChickenHouseData({super.key, required this.categoryTitle, required this.item, required this.token, required this.date});

  @override
  State<AddChickenHouseData> createState() => _AddChickenHouseDataState();
}

class _AddChickenHouseDataState extends State<AddChickenHouseData> {
  final TextEditingController dataController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool savingClicked = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Data for ${widget.categoryTitle} - ${widget.item}",
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
                validator: (value) => ValidatorUtility.validateRequiredField(value, "Integer Quantity for ${widget.item} is required"),
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
                      await Provider.of<ChickenHouseDataProvider>(context, listen: false).saveChickenHouseData(
                        context, 
                        item: widget.item, 
                        number: int.parse(dataController.text), 
                        token: widget.token, 
                        date: widget.date
                      );
                      setState(() {
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
        ),
      ],
    );
  }
}