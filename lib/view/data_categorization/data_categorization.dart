import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/data.dart';
import 'package:mksc/model/population_data.dart';
import 'package:mksc/model/token.dart';
import 'package:mksc/provider/data_provider.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/view/data_categorization/data_report_page.dart';
import 'package:mksc/view/data_categorization/widget/add_data_to_category.dart';
import 'package:mksc/view/data_categorization/widget/population_data_widget.dart';
import 'package:mksc/view/data_categorization/widget/today_uploaded_data.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:mksc/widgets/card_category.dart';
import 'package:provider/provider.dart';

class DataCategorization extends StatefulWidget {
  final String categoryTitle;
  final String token;
  const DataCategorization({super.key, required this.categoryTitle, required this.token});

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
    setState(() {
      dateController.text = DateTime.now().toString().split(' ')[0];
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = Provider.of<DataProvider>(context).categories.reversed.toList();
    List<PopulationData> filteredPopulationData = Provider.of<DataProvider>(context).filteredPopulationData(selectedCategories);
    List<Data> filteredTodayData =  Provider.of<DataProvider>(context).filteredData(selectedCategories);
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
          actions: [
            filteredPopulationData.isEmpty && filteredTodayData.isEmpty ? const SizedBox() :
            IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => DataReportPage(
                  populationDataList: filteredPopulationData.reversed.toList(),
                  dataList: filteredTodayData.reversed.toList(),
                ),));
              }, 
              icon: const Icon(
                Icons.summarize_outlined,
                color: Colors.white,
              ),
              tooltip: "View Report",
            ),
          ],
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
                    height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height * 0.75 :  MediaQuery.of(context).size.height * 0.25,
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        TodayUploadedData(selectedCategories: selectedCategories, isLoadingTodayData: _isLoadingTodayData, token: widget.token,),
                        PopulationDataWidget(selectedCategories: selectedCategories,),
                      ]
                    ),
                  ),
                ],
              ),
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
    await Provider.of<DataProvider>(context, listen: false).fetchTodayData(context, token: widget.token, date: DateTime.now().toString().split(' ')[0]);
    setState(() {
      _isLoadingTodayData = false;
    });
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
    }
  }
}