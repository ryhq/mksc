import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/population_data.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/services/population_data_services.dart';
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

class _DataCategorizationState extends State<DataCategorization> {

  TextEditingController dateController = TextEditingController();
  DateTime dateTime = DateTime.now();
  
  List<PopulationData> populationData = [];
  List<String> selectedCategories = [];

  bool _isLoading = true;

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
  }

  @override
  Widget build(BuildContext context) {
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
                  "Please select Category",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 21,),
                GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3, // For landscape mode, show 4 items per row,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                    childAspectRatio: 3.0
                  ),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    final categories = ['cock', 'hen', 'chick', 'eggs'];
                    return CardCategory(
                      title: categories[index],
                      iconData: Icons.egg,
                      isSelected: selectedCategories.contains(categories[index]),
                      onCategorySelected: onCategorySelected,
                    );
                  },
                ),
                const SizedBox(height: 21,),
                AddDataToCategory(selectedCategories: selectedCategories, categoryTitle: widget.categoryTitle),
                const SizedBox(height: 21,),
                const TodayUploadedData(),
                const SizedBox(height: 21,),
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

                _isLoading ? const Center(child: BallPulseIndicator(),) : 
                PopulationDataWidget(populationData: populationData, filteredPopulationData: filteredPopulationData),
              ],
            ),
          ),
        ),
      )
    );
  }

  Future<void> fetchPopulationData()async{
    List<PopulationData> fetchedPopulationData = await PopulationDataServices.fetchPopulationData(context);
    setState(() {
      populationData = fetchedPopulationData;
      _isLoading = false;
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