import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:mksc/providers/chicken_house_provider.dart';
import 'package:mksc/utilities/validator_utility.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:provider/provider.dart';

class ChickenHouseDataCard extends StatefulWidget {
  final ChickenHouseData chickenHouseData;
  final String date;
  final String title;
  const ChickenHouseDataCard({
    super.key, 
    required this.chickenHouseData, 
    required this.date, required this.title
  });

  @override
  State<ChickenHouseDataCard> createState() => _ChickenHouseDataCardState();
}

class _ChickenHouseDataCardState extends State<ChickenHouseDataCard> {
  TextEditingController editingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool editMode = false;
  bool saving = false;
  @override
  Widget build(BuildContext context) {
    final chickenHouseProviderListenFalse = Provider.of<ChickenHouseProvider>(context, listen: false);
    return saving ? const BallPulseIndicator() : Slidable(
      key: editMode ? null : ValueKey(widget.chickenHouseData.id),
      startActionPane: editMode ? null :  ActionPane(
        motion: const StretchMotion(),
        children: <Widget>[
          SlidableAction(
            onPressed: (context) {
              setState(() {
                editMode = true;
                editingController.text = widget.chickenHouseData.number.toString();
              });
            },
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Colors.green,
            icon: Icons.edit,
            label: 'Edit ${widget.chickenHouseData.item}',
          ),
          if(widget.chickenHouseData.isLocal)...[
            SlidableAction(
              onPressed: (context ) async {
                setState(() {
                  saving = true;
                });
                await chickenHouseProviderListenFalse.uploadSingleLocalData(
                  context: context, 
                  title: widget.title, 
                  localData: widget.chickenHouseData
                ).then(
                  (_){
                    setState(() {
                      saving = false;
                    });
                  }
                );
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Colors.orange,
              icon: Icons.upload,
              label: 'Upload ${widget.chickenHouseData.item}',
            )
          ]
        ]
      ),
      endActionPane: widget.chickenHouseData.isLocal ? ( 
        editMode ? null : ActionPane(
          motion: const StretchMotion(),
          children: <Widget>[
            SlidableAction(
              onPressed: (context) {
                chickenHouseProviderListenFalse.deleteChickenHouseLocalData(
                  context: context,
                  chickenHouseData: widget.chickenHouseData,
                  title: widget.date
                );
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              foregroundColor: Colors.red,
              icon: CupertinoIcons.delete,
              label: 'Delete ${widget.chickenHouseData.item}',
            )
          ]
        )
      ) : null,
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
          leading: editMode ? IconButton(
            onPressed: (){
              setState(() {
                editMode = false;
              });
            }, 
            tooltip: 'Cancel',
            icon: Icon(
              Icons.cancel,
              color: Theme.of(context).colorScheme.error,
            )
          ) : null,
          title: editMode ? Form(
            key: _formKey,
            child: TextFormField(
              controller: editingController,
              autofocus: true,
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
              validator: (value) => ValidatorUtility.validateRequiredField(value, "${widget.chickenHouseData.item} quantity is required."),
            ),
          ) 
          :
          Text(
            widget.chickenHouseData.item,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: editMode ? 
          Text(
            "Editing ${widget.chickenHouseData.item}",
            style: Theme.of(context).textTheme.labelSmall,
          ) : (
            widget.chickenHouseData.isLocal ? 
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(21),
                    ),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "Local",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.orange
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 21,),
                if(widget.chickenHouseData.isConflict)...[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(21),
                      ),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        "Conflict",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.red
                        ),
                      ),
                    ),
                  ),
                ]
              ],
            ) : null
          ),
          trailing: editMode ?  
          (
            widget.chickenHouseData.number != int.tryParse(editingController.text) ?
            IconButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    saving = true;
                  });
                  await chickenHouseProviderListenFalse.editChickenHouse(
                    context: context, 
                    chickenHouseData: widget.chickenHouseData, 
                    title: widget.title,
                    number: int.parse(editingController.text)
                  );
                  setState(() {
                    editMode = false;
                    saving = false;
                  });
                }
              }, 
              tooltip: 'Save',
              icon: const Icon(
                Icons.send,
                color:Colors.green,
              )
            ) : null
          )
          :
          Text(
            widget.chickenHouseData.number.toString(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}