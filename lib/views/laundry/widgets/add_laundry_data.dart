import 'package:flutter/material.dart';
import 'package:mksc/providers/laundry_machine_provider.dart';
import 'package:mksc/utilities/validator_utility.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:mksc/widgets/button.dart';
import 'package:provider/provider.dart';

class AddLaundryData extends StatefulWidget {
  final String categoryTitle;
  final String camp;
  final String machineType;
  final String token;
  final String date;
  const AddLaundryData({super.key, required this.categoryTitle,  required this.token, required this.date, required this.camp, required this.machineType});

  @override
  State<AddLaundryData> createState() => _AddLaundryDataState();
}

class _AddLaundryDataState extends State<AddLaundryData> {
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
              "Enter Data for ${widget.categoryTitle} - ${widget.machineType}",
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
                validator: (value) => ValidatorUtility.validateRequiredField(value, "Integer Quantity for ${widget.machineType} circle is required"),
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
                      await Provider.of<LaundryMachineProvider>(context, listen: false).saveLaundryDataByDate(
                        context, 
                        camp: widget.camp, 
                        circle: dataController.text, 
                        token: widget.token, 
                        machineType: widget.machineType, 
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