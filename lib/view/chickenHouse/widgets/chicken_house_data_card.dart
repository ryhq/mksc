
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:mksc/provider/chicken_house_data_provider.dart';
import 'package:mksc/utils/validator_utility.dart';
import 'package:mksc/widgets/app_circular_progress_indicator.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:provider/provider.dart';

class ChickenHouseDataCard extends StatefulWidget {
  const ChickenHouseDataCard({
    super.key,
    required this.chickenHouseData, required this.date, required this.token,
  });

  final ChickenHouseData chickenHouseData;
  final String date;
  final String token;

  @override
  State<ChickenHouseDataCard> createState() => _ChickenHouseDataCardState();
}

class _ChickenHouseDataCardState extends State<ChickenHouseDataCard> {
  TextEditingController editingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool savingState = false;
  bool ediMode = false;
  
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
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
    return Focus(
      focusNode: _focusNode,
      child: GestureDetector(
        onTap: () {
          if (isFocused) {
            _focusNode.unfocus();
            setState(() {
              ediMode = !ediMode;
              editingController.text = widget.chickenHouseData.number.toString();
            });
          }else{
            _focusNode.requestFocus(); 
          }
        },
        child: AbsorbPointer(
          absorbing: savingState,
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
              leading: isFocused && !savingState ? IconButton(
                onPressed: (){
                  _focusNode.unfocus();
                }, 
                icon: Icon(
                  Icons.cancel,
                  color: Theme.of(context).colorScheme.primary,
                )
              ) : null,
              title: isFocused && !savingState ?
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: editingController,
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
                  validator: (value) => ValidatorUtility.validateRequiredField(value, "${widget.chickenHouseData.item} quantity is required."),
                
                ),
              ) : 
              savingState ? const BallPulseIndicator() :
              Text(
                widget.chickenHouseData.item,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: isFocused && !savingState  ? Text(
                "You are editing ${widget.chickenHouseData.item} data",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
              ) : 
              savingState  ? Text(
                "Saving ${widget.chickenHouseData.item} data ....",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
              ) : null,
              trailing: isFocused && !savingState ?
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    _focusNode.unfocus();
                    setState(() {
                      savingState = true;
                    });
                    await Provider.of<ChickenHouseDataProvider>(context, listen: false).editChickenHouseData(
                      context, 
                      item: widget.chickenHouseData.item, 
                      number: int.parse(editingController.text), 
                      token: widget.token, 
                      id: widget.chickenHouseData.id
                    ).then((_){
                      setState(() {
                        savingState = false;
                      });
                    });
                  }
                }, 
                child: Text(
                  "Update",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
                )
              ) : 
              savingState ? const AppCircularProgressIndicator() :
              Text(
                widget.chickenHouseData.number.toString(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        ),
      ),
    );
  }
}