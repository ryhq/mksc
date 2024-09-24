import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:mksc/model/item_category.dart';
import 'package:mksc/provider/chicken_house_data_provider.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/view/chickenHouse/widgets/add_chicken_house_data.dart.dart';
import 'package:mksc/view/chickenHouse/widgets/chicken_house_data_card.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:provider/provider.dart';

class ChickenHouseScreen extends StatefulWidget {

  final String token;

  final String categoryTitle;


  const ChickenHouseScreen({super.key, required this.token, required this.categoryTitle});

  @override
  State<ChickenHouseScreen> createState() => _ChickenHouseScreenState();
}

class _ChickenHouseScreenState extends State<ChickenHouseScreen> {

  TextEditingController dateController = TextEditingController();

  DateTime dateTime = DateTime.now();

  bool isFetchingChickenHouseData = false;

  bool noCategoryLeft = false;

  final List<ItemCategory> chickenHouseCategories = [
    ItemCategory(svgicon: 'assets/icons/chicken_.svg', name: 'Cock'),
    ItemCategory(svgicon: 'assets/icons/hen.svg', name: 'Hen'),
    ItemCategory(svgicon: 'assets/icons/chick.svg', name: 'Chick'),
    ItemCategory(svgicon: 'assets/icons/egg.svg', name: 'Eggs'),
  ];

  ItemCategory? selectedCategory;

  @override
  void initState() {
    super.initState();
    setState(() {
      dateController.text = DateTime.now().toString().split(' ')[0];
    });
    fetchChickenHouseData(context, token: widget.token, date: dateController.text);
  }

  void fetchChickenHouseData(
    BuildContext context, 
    {
      required String token, 
      required String date,
    }
  ) async{
    setState(() {
      isFetchingChickenHouseData = true;
    });
    await Provider.of<ChickenHouseDataProvider>(context, listen: false).fetchChickenHouseData(context, token: token, date: date);
    setState(() {
      isFetchingChickenHouseData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<ChickenHouseData> chickenHouseDataList =  Provider.of<ChickenHouseDataProvider>(context, listen: true).chickenHouseDataList;
    
    // Check if all categories are disabled
    noCategoryLeft = chickenHouseCategories.every((category) => 
      chickenHouseDataList.any((data) => data.item == category.name)
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
            padding: const EdgeInsets.all(8.0),
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
            
                  if(!noCategoryLeft)...[
                    Text(
                      "Please select Category",
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
                          itemCount: chickenHouseCategories.length,
                          itemBuilder: (BuildContext context, int index) {

                            final category = chickenHouseCategories[index];
    
                            // Check if the category name exists in chickenHouseDataList
                            final isDisabled = chickenHouseDataList.any((data) => data.item == category.name);

                            final isSelected = selectedCategory == category;
                            
                            return GestureDetector(
                              onTap: isDisabled ? null : () {
                                setState(() {
                                  if(selectedCategory != null && selectedCategory == category){
                                    selectedCategory = null;
                                  }else {
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

                    if(selectedCategory != null)...[

                      AddChickenHouseData(
                        item: selectedCategory!.name, 
                        categoryTitle: widget.categoryTitle,
                        date: dateController.text,
                        token: widget.token,
                      ),
                    
                    ],
                  ],
            
                  Text(
                    dateController.text == DateTime.now().toString().split(' ')[0] ? "Today's Data"
                    : "Chicken House Data on ${dateController.text}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 21,),

                  isFetchingChickenHouseData ? const BallPulseIndicator() :
                  
                  chickenHouseDataList.isEmpty ? 

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
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
                            if(!context.mounted) return;
                            fetchChickenHouseData(context, token: widget.token, date: dateController.text);
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
                    itemCount: chickenHouseDataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var chickenHouseData = chickenHouseDataList[index];
                      return ChickenHouseDataCard(
                        chickenHouseData: chickenHouseData, 
                        date: dateController.text,
                        token: widget.token,
                      );
                    },
                  ),
            
                ],
              ),
            ),
          ),
        ),
      )
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
      fetchChickenHouseData(context, token: widget.token, date: dateController.text);
    }
  }
}