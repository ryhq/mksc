import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/laundry_data.dart';
import 'package:mksc/model/laundry_machine.dart';
import 'package:mksc/provider/laundry_machine_provider.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/view/laundry/widgets/laundry_data_card.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:provider/provider.dart';

class LaundryScreen extends StatefulWidget {

  final String token;

  final String categoryTitle;

  final String camp;

  const LaundryScreen({super.key, required this.token, required this.categoryTitle, required this.camp});

  @override
  State<LaundryScreen> createState() => _LaundryScreenState();
}

class _LaundryScreenState extends State<LaundryScreen> {

  TextEditingController dateController = TextEditingController();

  DateTime dateTime = DateTime.now();

  bool isFetchLaundryMachines = false;

  bool isFetchingLaundryData = false;

  LaundryMachine? selectedLaundryMachine;

  bool noLaundryMachineLeft = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      dateController.text = DateTime.now().toString().split(' ')[0];
    });

    fetchLaundryMachines();
    fetchLaundryDataByDate(context, token: widget.token, date: dateController.text);
  }

  @override
  Widget build(BuildContext context) {
    List<LaundryMachine> laundryMachineList = Provider.of<LaundryMachineProvider>(context).laundryMachineList;
    List<LaundryData> laundryDataList = Provider.of<LaundryMachineProvider>(context).laundryDataList;

    noLaundryMachineLeft = laundryMachineList.every((machine) =>
      laundryDataList.any((data) => data.machineType == machine.machineType)  
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                    size: Provider.of<ThemeProvider>(context).fontSize + 7,
                  ),
                ),
              );
            },
          ),
          title: Text(
            widget.categoryTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[100]!,
                Colors.grey[50]!,
                Colors.white,
                Colors.grey[50]!,
                Colors.blue[100]!,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Filter by date",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  
                  const SizedBox(height: 21,),
                  
                  GestureDetector(
                    onTap: () => _selectDateTime(context),
                    child: AbsorbPointer(
                      child: AppTextFormField(
                        hintText: "yyyy-mm-dd", 
                        iconData: Icons.date_range, 
                        obscureText: false, 
                        textInputType: TextInputType.number,
                        textEditingController: dateController,
                      ),
                    ),
                  ),
            
                  const SizedBox(height: 21,),
                  
                  Text(
                    "Please select laundry machine at ${widget.camp}.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.13,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4, 
                          crossAxisSpacing: MediaQuery.of(context).orientation == Orientation.portrait ? 10.0 : 5.0,
                          mainAxisSpacing: MediaQuery.of(context).orientation == Orientation.portrait ? 10.0 : 5.0, 
                          childAspectRatio : MediaQuery.of(context).orientation == Orientation.portrait ? 
                              MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 8) : 
                              MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 2),
                        ),
                        itemCount: laundryMachineList.length,
                        itemBuilder: (BuildContext context, int index) {

                          final laundryMachine = laundryMachineList[index];
                          
                          final isDisabled = laundryDataList.any((data) => data.machineType == laundryMachine.machineType);

                          final isSelected = selectedLaundryMachine == laundryMachine;
                          
                          return GestureDetector(
                            onTap: isDisabled ? null : () {
                              setState(() {
                                if(selectedLaundryMachine != null && selectedLaundryMachine == laundryMachine){
                                  selectedLaundryMachine = null;
                                }else {
                                  selectedLaundryMachine = laundryMachine;
                                }
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isDisabled ? Colors.grey : Theme.of(context).colorScheme.primary, 
                                  width: isDisabled ? 1.0 : isSelected ? 2.0 : 0.5
                                ),
                                borderRadius: isDisabled ? BorderRadius.circular(32.0) : BorderRadius.circular(8.0),
                                color: Theme.of(context).colorScheme.secondary
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 18.0),
                                      child: Icon(
                                        Icons.local_laundry_service_outlined,
                                        color: isDisabled ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                                      )
                                    ),
                                    const SizedBox(height: 18.0),
                                    Text(
                                      laundryMachine.machineType,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        decoration: isDisabled ? TextDecoration.lineThrough : null
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 21,),

                  if(!noLaundryMachineLeft)...[
                    if(selectedLaundryMachine != null)...[

                    ]
                  ],
            
                  Text(
                    dateController.text == DateTime.now().toString().split(' ')[0] ? "Today's Laundry Data"
                    : "Laundry Data on ${dateController.text}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 21,),

                  isFetchingLaundryData ? const BallPulseIndicator() :

                  laundryDataList.isEmpty ? 

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Sorry, no laundry data available on ${dateController.text}",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                        ),
                        IconButton(
                          onPressed: () {
                            if(!context.mounted) return;
                            fetchLaundryDataByDate(context, token: widget.token, date: dateController.text);
                          }, 
                          icon: Icon(
                            Icons.refresh,
                            size: Provider.of<ThemeProvider>(context).fontSize + 21,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        )
                      ],
                    ),
                  )

                  :

                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: laundryDataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var laundryData = laundryDataList[index];
                      return LaundryDataCard(
                        laundryData: laundryData, 
                        date: dateController.text,
                        token: widget.token,
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dateTime = pickedDate;
        dateController.text = pickedDate.toString().split(' ')[0];
      });
      if(!context.mounted) return;
      fetchLaundryDataByDate(context, token: widget.token, date: dateController.text);
    }
  }

  void fetchLaundryMachines() async{
    setState(() {
      isFetchLaundryMachines = true;
    });
    await Provider.of<LaundryMachineProvider>(context, listen: false).fetchLaundryMachines(camp: widget.camp);
    setState(() {
      isFetchLaundryMachines = false;
    });
  }

  void fetchLaundryDataByDate(
    BuildContext context, 
    {
      required String token, 
      required String date,
    }
  ) async{
    setState(() {
      isFetchingLaundryData = true;
    });
    await Provider.of<LaundryMachineProvider>(context, listen: false).getLaundryDataByDate(camp: widget.camp, date: date);
    setState(() {
      isFetchingLaundryData = false;
    });
  }
}