import 'package:flutter/material.dart';
import 'package:mksc/model/laundry_data.dart';
import 'package:mksc/utils/validator_utility.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/custom_alert.dart';

class LaundryDataCard extends StatefulWidget {
  const LaundryDataCard({super.key, required this.laundryData, required this.date, required this.token});

  final LaundryData laundryData;
  final String date;
  final String token;

  @override
  State<LaundryDataCard> createState() => _LaundryDataCardState();
}

class _LaundryDataCardState extends State<LaundryDataCard> {
  TextEditingController editingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          editingController.text = widget.laundryData.circle.toString();
        });
        CustomAlert.showAlertWidget(
          context, 
          title: "Edit", 
          content: Form(
            key: _formKey,
            child: AppTextFormField(
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
              validator: (value) => ValidatorUtility.validateRequiredField(value, "${widget.laundryData.circle} quantity is required."),
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
                  // await Provider.of<ChickenHouseDataProvider>(context, listen: false).editChickenHouseData(
                  //   context, 
                  //   item: widget.chickenHouseData.item, 
                  //   number: int.parse(editingController.text), 
                  //   token: widget.token, 
                  //   id: widget.chickenHouseData.id
                  // );
                }
              },
            ),
          ]
        );
      },
      child: Card(
        elevation: 3,
        color: Theme.of(context).colorScheme.surface,
        shape: const RoundedRectangleBorder(
          borderRadius:  BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(42.0),
            topLeft: Radius.circular(21.0),
            topRight: Radius.circular(0.0),
          ),
        ),
        child: ListTile(
          tileColor: Colors.transparent,
          title: Text(
            "${widget.laundryData.kg} Kg",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "${widget.laundryData.machineType} with ${widget.laundryData.circle} circles",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          trailing: Text(
            widget.laundryData.day,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}