import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:mksc/model/item_category.dart';
import 'package:mksc/provider/chicken_house_data_provider.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/utils/validator_utility.dart';
import 'package:mksc/view/chickenHouse/chicken_house_sync_screen.dart';
import 'package:mksc/view/chickenHouse/widgets/chicken_house_data_card.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:mksc/widgets/button.dart';
import 'package:mksc/widgets/log_out_action_button.dart';
import 'package:provider/provider.dart';

class ChickenHouseScreen extends StatefulWidget {
  final String? token;

  final String categoryTitle;

  const ChickenHouseScreen({super.key, this.token, required this.categoryTitle});

  @override
  State<ChickenHouseScreen> createState() => _ChickenHouseScreenState();
}

class _ChickenHouseScreenState extends State<ChickenHouseScreen> {

  TextEditingController dateController = TextEditingController();

  DateTime dateTime = DateTime.now();

  bool isFetchingChickenHouseData = false;

  bool isSyncing = false;

  bool noCategoryLeft = false;

  final List<ItemCategory> chickenHouseCategories = [
    ItemCategory(svgicon: 'assets/icons/chicken_.svg', name: 'Cock'),
    ItemCategory(svgicon: 'assets/icons/hen.svg', name: 'Hen'),
    ItemCategory(svgicon: 'assets/icons/chick.svg', name: 'Chick'),
    ItemCategory(svgicon: 'assets/icons/egg.svg', name: 'Eggs'),
  ];

  ItemCategory? selectedCategory;

  final TextEditingController dataController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool savingClicked = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      dateController.text = DateTime.now().toString().split(' ')[0];
    });

    if (widget.token  == null) {
      fetchChickenHouseDataFromLocal(context, date: dateController.text);
    } else {
      syncData();
      fetchChickenHouseData(context, token: widget.token!, date: dateController.text);
    }
  }

  @override
  Widget build(BuildContext context) {

    List<ChickenHouseData> chickenHouseDataList = Provider.of<ChickenHouseDataProvider>(context, listen: true).chickenHouseDataList;
    List<ChickenHouseData> chickenHouseDataLocalList = Provider.of<ChickenHouseDataProvider>(context, listen: true).chickenHouseDataLocalList;

    // Check if all categories are disabled
    noCategoryLeft = chickenHouseCategories.every((category) => chickenHouseDataList.any((data) => data.item == category.name));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  isSyncing ? null : Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(21.0),
                    child: Icon(
                      CupertinoIcons.back,
                      color: Colors.white,
                      size: Provider.of<ThemeProvider>(context).fontSize + 7,
                    ),
                  ),
                ),
              );
            },
          ),
          title: Text(
            widget.categoryTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          actions: [

            if(widget.token != null && chickenHouseDataLocalList.isNotEmpty)...[
              isSyncing ? SizedBox(
                width: Provider.of<ThemeProvider>(context).fontSize + 7,
                height: Provider.of<ThemeProvider>(context).fontSize + 7,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                ),
              ) :
              IconButton(
                onPressed: () async {
                  syncData();
                }, 
                icon: Icon(
                  Icons.sync,
                  color:Colors.white,
                  size: Provider.of<ThemeProvider>(context).fontSize + 7,
                )
              )
            ],

            if(widget.token != null)...[
              LogOutActionButton(categoryTitle: widget.categoryTitle)
            ],
          ],
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: AbsorbPointer(
          absorbing: isSyncing,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  // Colors.blue[100]!,
                  Colors.grey[50]!,
                  Colors.white,
                  Colors.grey[50]!,
                  // Colors.blue[100]!,
                ],
              ),
            ),
            child: Stack(
              children: [

                Align(
                  alignment: Alignment.center,
                  child: Opacity(
                    opacity: isSyncing ? 1.0 : 0.0,
                    child: const ChickenHouseSyncScreen()
                  ),
                ),

                Opacity(
                  opacity: isSyncing ? 0.1 : 1.0,
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
                          const SizedBox(
                            height: 21,
                          ),
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
                          const SizedBox(
                            height: 21,
                          ),
                          Text(
                            "Please select Category",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.13,
                              child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
                                  crossAxisSpacing: MediaQuery.of(context).orientation == Orientation.portrait ? 10.0 : 5.0,
                                  mainAxisSpacing: MediaQuery.of(context).orientation == Orientation.portrait ? 10.0 : 5.0,
                                  childAspectRatio: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 8) : MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 2),
                                ),
                                itemCount: chickenHouseCategories.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final category = chickenHouseCategories[index];
                                  // Check if the category name exists in chickenHouseDataList
                                  final isDisabled =  chickenHouseDataLocalList.any((data) => data.item == category.name) || chickenHouseDataList.any((data) => data.item == category.name);
                            
                                  final isSelected = selectedCategory == category;
                            
                                  return GestureDetector(
                                    onTap: isDisabled ? null : () {
                                      setState(() {
                                        if (selectedCategory != null &&
                                            selectedCategory == category) {
                                          selectedCategory = null;
                                        } else {
                                          selectedCategory = category;
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isDisabled ? Colors.grey : Theme.of(context).colorScheme.primary,
                                          width: isDisabled ? 1.0 : isSelected ? 2.0 : 0.5
                                        ),
                                        borderRadius: isDisabled ? BorderRadius.circular(32.0) : BorderRadius.circular(8.0), color: Theme.of(context).colorScheme.secondary
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(right: 18.0),
                                              child: SvgPicture.asset(
                                                chickenHouseCategories[index].svgicon,
                                                height: 20,
                                                width: 20,
                                                color: isDisabled ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                                              ),
                                            ),
                                            const SizedBox(height: 18.0),
                                            Text(
                                              category.name,
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(decoration: isDisabled ? TextDecoration.lineThrough : null),
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
                          const SizedBox(
                            height: 21,
                          ),
                          if (!noCategoryLeft) ...[
                            if (selectedCategory != null) ...[
                              AbsorbPointer(
                                absorbing: savingClicked,
                                child: Opacity(
                                  opacity: savingClicked ? 0.3 : 1.0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Enter Data for ${widget.categoryTitle} - ${selectedCategory!.name}",
                                        style: Theme.of(context).textTheme.bodyLarge,
                                      ),
                                      const SizedBox(
                                        height: 21,
                                      ),
                                      Form(
                                        key: _formKey,
                                        child: AppTextFormField(
                                          hintText: "123",
                                          iconData: Icons.numbers,
                                          obscureText: false,
                                          textInputType: TextInputType.number,
                                          textEditingController: dataController,
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
                                          validator: (value) => ValidatorUtility.validateRequiredField(value, "Integer Quantity for ${selectedCategory!.name} is required"),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 21,
                                      ),
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
                                          savingClicked ? const BallPulseIndicator() : Button(
                                            title: "Save",
                                            onTap: () async {
                                              if (_formKey.currentState!.validate()) {
                                                setState(() {
                                                  savingClicked = true;
                                                });
                                                widget.token == null ? 
                                                await Provider.of<ChickenHouseDataProvider>(context, listen: false).saveChickenHouseDataToLocal(
                                                  context,
                                                  item: selectedCategory!.name,
                                                  number: int.parse(dataController.text),
                                                  date: dateController.text
                                                )
                                                :
                                                await Provider.of<ChickenHouseDataProvider>(context, listen: false).saveChickenHouseData(
                                                  context,
                                                  item: selectedCategory!.name,
                                                  number: int.parse(dataController.text),
                                                  token: widget.token!,
                                                  date: dateController.text
                                                );
                                                setState(() {
                                                  _formKey.currentState!.reset();
                                                  dataController.clear();
                                                  savingClicked = false;
                                                  selectedCategory = null;
                                                });
                                              }
                                            },
                                            danger: false,
                                            vibrate: false,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 21,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ],
                          Text(
                            dateController.text == DateTime.now().toString().split(' ')[0] ? "Today's Data" : "Chicken House Data on ${dateController.text}",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: 21,
                          ),
                          isFetchingChickenHouseData ? const BallPulseIndicator() : 
                          chickenHouseDataList.isEmpty ? 
                          SizedBox(
                            height: chickenHouseDataLocalList.isEmpty ? MediaQuery.of(context).size.height * 0.5 : MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Sorry, no chicken house data available on ${dateController.text}",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (!context.mounted) return;
                                      widget.token == null ? 
                                      fetchChickenHouseDataFromLocal(
                                        context, 
                                        date: dateController.text
                                      )
                                      :
                                      fetchChickenHouseData(
                                        context, 
                                        token: widget.token!,
                                        date: dateController.text
                                      );
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
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: chickenHouseDataList.length,
                            itemBuilder: (BuildContext context, int index) {
                              var chickenHouseData = chickenHouseDataList[index];
                              return widget.token == null ?
                                ChickenHouseDataCard(
                                  chickenHouseData: chickenHouseData,
                                  date: dateController.text,
                                  isLocalData: false,
                                ) : 
                                ChickenHouseDataCard(
                                  chickenHouseData: chickenHouseData,
                                  date: dateController.text,
                                  token: widget.token!,
                                  isLocalData: false,
                                );
                            },
                          ),
                            
                          if(chickenHouseDataLocalList.isNotEmpty)...[
                            
                            Text(
                              dateController.text == DateTime.now().toString().split(' ')[0] ? "Today's Data, \nOffline data" : "Chicken House Data on ${dateController.text}, \nOffline data",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(
                              height: 21,
                            ),
                            ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: chickenHouseDataLocalList.length,
                              itemBuilder: (BuildContext context, int index) {
                                var chickenHouseData = chickenHouseDataLocalList[index];
                                return widget.token == null ?
                                ChickenHouseDataCard(
                                  chickenHouseData: chickenHouseData,
                                  date: dateController.text,
                                  isLocalData: true,
                                ) : 
                                ChickenHouseDataCard(
                                  chickenHouseData: chickenHouseData,
                                  date: dateController.text,
                                  token: widget.token!,
                                  isLocalData: true,
                                );
                              },
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  Future<void> fetchChickenHouseData(
    BuildContext context, {
    required String token,
    required String date,
  }) async {
    setState(() {
      isFetchingChickenHouseData = true;
    });
    await Provider.of<ChickenHouseDataProvider>(context, listen: false).fetchChickenHouseData(context, token: token, date: date).then((_){
      setState(() {
        isFetchingChickenHouseData = false;
      });
    });
    await Future.delayed(const Duration(milliseconds: 700));
  }

  void fetchChickenHouseDataFromLocal(
    BuildContext context, 
    {
      required String date,
    }
  ) async {
    setState(() {
      isFetchingChickenHouseData = true;
    });
    await Provider.of<ChickenHouseDataProvider>(context, listen: false).fetchChickenHouseDataFromLocal(context, date: date).then((_){
      setState(() {
        isFetchingChickenHouseData = false;
      });
    });
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dateTime = pickedDate;
        dateController.text = pickedDate.toString().split(' ')[0];
      });
      if (!context.mounted) {
        return;
      }
      if (widget.token == null) {
        Provider.of<ChickenHouseDataProvider>(context, listen: false).clearChickenHouseDataList();
        fetchChickenHouseDataFromLocal(context, date: dateController.text); 
      } else {
        fetchChickenHouseData(context, token: widget.token!, date: dateController.text);
      }
    }
  }

  void syncData() async {
    int data = Provider.of<ChickenHouseDataProvider>(context, listen: false).chickenHouseLocalDataStatus;
    if (data == 0) {
      return;
    }
    setState(() {
      isSyncing = true;
    });

    debugPrint("\n👉 Syncing state  : \t$isSyncing");
    await Provider.of<ChickenHouseDataProvider>(
      context, 
      listen: false
    ).uploadData(context, token: widget.token!,);
    setState(() {
      isSyncing = false;
    });
    if (!context.mounted) return;
    await fetchChickenHouseData(context, token: widget.token!, date: dateController.text);
    debugPrint("\n👉 Syncing state  : \t$isSyncing");
  }
}
