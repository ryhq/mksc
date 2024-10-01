import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mksc/model/laundry_data.dart';
import 'package:mksc/provider/laundry_machine_provider.dart';
import 'package:mksc/utils/validator_utility.dart';
import 'package:mksc/widgets/app_circular_progress_indicator.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:provider/provider.dart';

class LaundryDataCard extends StatefulWidget {
  const LaundryDataCard({super.key, required this.laundryData, required this.date, required this.token, required this.camp});

  final LaundryData laundryData;
  final String date;
  final String token;
  final String camp;

  @override
  State<LaundryDataCard> createState() => _LaundryDataCardState();
}

class _LaundryDataCardState extends State<LaundryDataCard> {
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
          } else{
            _focusNode.requestFocus(); 
          }
          if(!savingState){
            setState(() {
              ediMode = !ediMode;
              editingController.text = widget.laundryData.circle.toString();
            });
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
                    if (value.isNotEmpty && int.tryParse(value) != null && int.parse(value) > 0) {
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
                  validator: (value) => ValidatorUtility.validateRequiredField(value, "${widget.laundryData.machineType} circles are required."),
                
                ),
              ) :
              savingState ? const BallPulseIndicator() :
              Text(
                "${widget.laundryData.kg} Kg",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),

              subtitle: isFocused && !savingState  ? Text(
                "You are editing ${widget.laundryData.machineType} data",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
              ) : 
              savingState  ? Text(
                "Saving ${widget.laundryData.machineType} data ....",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
              ) :
              Text(
                widget.laundryData.machineType,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
              ),


              trailing: isFocused && !savingState ?
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    _focusNode.unfocus();
                    setState(() {
                      savingState = true;
                    });
                    await Provider.of<LaundryMachineProvider>(context, listen: false).editLaundryDataByDate(
                      context,
                      camp: widget.camp,
                      circle: editingController.text,
                      machineType: widget.laundryData.machineType, 
                      token: widget.token, 
                      id: widget.laundryData.id
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
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: Text(
                        widget.laundryData.circle,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ),
                    WidgetSpan(
                      child: Text(
                        int.parse(widget.laundryData.circle) ==  1 ?
                        " circle" : " circles",
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ),
                  ]
                )
              )
            ),
          ),
        ),
      ),
    );
  }
}