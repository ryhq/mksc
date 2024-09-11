import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mksc/model/population_data.dart';
import 'package:mksc/provider/data_provider.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/view/data_categorization/widget/add_data_to_category.dart';
import 'package:mksc/view/data_categorization/widget/population_data_widget.dart';
import 'package:mksc/view/data_categorization/widget/today_uploaded_data.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:mksc/widgets/card_category.dart';
import 'package:provider/provider.dart';

class DataCategorization extends StatefulWidget {
  final String categoryTitle;
  const DataCategorization({super.key, required this.categoryTitle});

  @override
  State<DataCategorization> createState() => _DataCategorizationState();
}

class _DataCategorizationState extends State<DataCategorization> with SingleTickerProviderStateMixin{
  TabController? _tabController;

  TextEditingController dateController = TextEditingController();
  DateTime dateTime = DateTime.now();
  
  List<PopulationData> populationData = [];
  List<String> selectedCategories = [];

  bool _isLoading = true;
  bool _isLoadingTodayData = true;

  List<PopulationData> get filteredPopulationData {
    if (selectedCategories.isEmpty) {
      return populationData; 
    } else {
      return populationData.where((data) => selectedCategories.contains(data.item)).toList();
    }
  }

  void onCategorySelected(String category) {
    setState(() {
      if (selectedCategories.contains(category)) {
        selectedCategories.remove(category);
      } else {
        selectedCategories.add(category);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPopulationData();
    fetchTodayData();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = Provider.of<DataProvider>(context).categories.reversed.toList();
    int totalFilteredPopulationData = Provider.of<DataProvider>(context).filteredPopulationData(selectedCategories).length;
    int totalFilteredData = Provider.of<DataProvider>(context).filteredData(selectedCategories).length;
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
                    color: Theme.of(context).colorScheme.primary,
                    size: Provider.of<ThemeProvider>(context).fontSize + 7,
                  ),
                ),
              );
            },
          ),
          title: Text(
            widget.categoryTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          centerTitle: true,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
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

                Text(
                  "Please select Category",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 21,),
                _isLoading ? const BallPulseIndicator() :

                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    controller: ScrollController(),
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final category =  categories[index];
                      return CardCategory(
                        title: category,
                        iconData: Icons.egg,
                        isSelected: selectedCategories.contains(category),
                        onCategorySelected: onCategorySelected,
                      );
                    },
                  ),
                ),

                // SizedBox(
                //   height: 48,
                //   child: GridView.builder(
                //     physics: const BouncingScrollPhysics(),
                //     scrollDirection: Axis.horizontal,
                //     controller: ScrollController(),
                //     shrinkWrap: true,
                //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount:  1, //MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3, // For landscape mode, show 4 items per row,
                //       mainAxisSpacing: 5.0,
                //       crossAxisSpacing: 5.0,
                //       childAspectRatio: 3.0
                //     ),
                //     itemCount: categories.length,
                //     itemBuilder: (BuildContext context, int index) {
                //       final category =  categories[index];
                //       return CardCategory(
                //         title: category,
                //         iconData: Icons.egg,
                //         isSelected: selectedCategories.contains(category),
                //         onCategorySelected: onCategorySelected,
                //       );
                //     },
                //   ),
                // ),
                const SizedBox(height: 21,),

                AddDataToCategory(selectedCategories: selectedCategories, categoryTitle: widget.categoryTitle),

                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(text: 'Today\'s Data ($totalFilteredData)'),
                    Tab(text: 'Population Data ($totalFilteredPopulationData)'),
                  ]
                ),
                SizedBox(
                  height: 450,
                  child: TabBarView(
                    controller: _tabController,
                    children: <Widget>[
                      TodayUploadedData(selectedCategories: selectedCategories, isLoadingTodayData: _isLoadingTodayData,),
                      PopulationDataWidget(selectedCategories: selectedCategories,),
                    ]
                  ),
                ),
                // const SizedBox(height: 21,),

                // TodayUploadedData(selectedCategories: selectedCategories,),

                
                // const SizedBox(height: 21,),

                // _isLoading ? const Center(child: BallPulseIndicator(),) : 

                // PopulationDataWidget(selectedCategories: selectedCategories,),
              ],
            ),
          ),
        ),
      )
    );
  }

  Future<void> fetchPopulationData()async{
    await Provider.of<DataProvider>(context, listen: false).fetchPopulationData(context);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> fetchTodayData()async{
    await Provider.of<DataProvider>(context, listen: false).fetchTodayData(context);
    setState(() {
      _isLoadingTodayData = false;
    });
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        dateTime = pickedDate;
        dateController.text = pickedDate.toString().split(' ')[0];
      });
    }
  }
}