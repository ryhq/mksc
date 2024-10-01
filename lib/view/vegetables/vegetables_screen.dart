import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/provider/vegetable_provider.dart';
import 'package:mksc/view/vegetables/widget/vegetable_card.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/log_out_action_button.dart';
import 'package:mksc/widgets/shimmer_widgets.dart';
import 'package:provider/provider.dart';

class VegetablesScreen extends StatefulWidget {

  final String token;

  final String categoryTitle;

  const VegetablesScreen({super.key, required this.token, required this.categoryTitle});

  @override
  
  State<VegetablesScreen> createState() => _VegetablesScreenState();
}

class _VegetablesScreenState extends State<VegetablesScreen> {
  TextEditingController dateController = TextEditingController(); 
  TextEditingController searchQueryController = TextEditingController(); 
  DateTime dateTime = DateTime.now();
  bool isLoading = false;

  bool isSearchingMode = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      dateController.text = DateTime.now().toString().split(' ')[0];
    });

    fetchVegetableData();
  }

  void fetchVegetableData() async {
    setState(() {
      isLoading = true;
    });

    await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableData(context);

    await fetchTodayVegetableData(context, token: widget.token, date: dateController.text);

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchTodayVegetableData(
    BuildContext context, {
    required String token,
    required String date,
  }) async {
    setState(() {
      isLoading = true;
    });

    await Provider.of<VegetableProvider>(context, listen: false).fetchTodayVegetableData(context, token: widget.token, date: dateController.text);

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  List<Vegetable> searchKeyWord(String searchQuery, List<Vegetable> vegetableDataList) {
    List<Vegetable> result = vegetableDataList.where((data) {
      return data.name.toLowerCase().startsWith(searchQuery.toLowerCase());
    }).toList();
    return result;
  }

  @override
  Widget build(BuildContext context) {

    List<Vegetable> vegetableDataList = Provider.of<VegetableProvider>(context,).vegetableDataList.reversed.toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(21.0),
                    child: Icon(
                      CupertinoIcons.back,
                      color: isSearchingMode ? Theme.of(context).colorScheme.primary : Colors.white,
                      size: Provider.of<ThemeProvider>(context).fontSize + 7,
                    ),
                  ),
                ),
              );
            },
          ),
          title: isSearchingMode ? 
          AppTextFormField(
            hintText: "Search in ${widget.categoryTitle}",
            iconData: Icons.search,
            obscureText: false,
            textInputType: TextInputType.text,
            onChanged: (String searchQuery) {
              setState(() {
                searchQueryController.text = searchQuery;
              });
            },
          )
          : 
          Text(
            widget.categoryTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          actions: [
            vegetableDataList.isNotEmpty ? 
            IconButton(
              tooltip: 'Search',
              onPressed: () {
                setState(() {
                  isSearchingMode = !isSearchingMode;
                  searchQueryController.clear();
                });
              },
              icon: Icon(
                isSearchingMode ? Icons.cancel : Icons.search,
                color: isSearchingMode ? Theme.of(context).colorScheme.primary : Colors.white,
                size: Provider.of<ThemeProvider>(context).fontSize + 7,
              )
            ) : const SizedBox(),
            LogOutActionButton(categoryTitle: widget.categoryTitle),
          ],
          centerTitle: isSearchingMode ? false : true,
          backgroundColor: isSearchingMode ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary,
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
                // Colors.blue[100]!,
                Colors.grey[50]!,
                Colors.white,
                Colors.grey[50]!,
                // Colors.blue[100]!,
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
                children: [
                  Text(
                    "Welcome to ${widget.categoryTitle} Data Management",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 21,),
                  if (!isSearchingMode) ...[
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
                    const SizedBox(
                      height: 21,
                    ),
                  ],
                  isLoading ? ShimmerWidgets(totalShimmers: vegetableDataList.isEmpty ? 3 : vegetableDataList.length)
                  : 
                  searchKeyWord( searchQueryController.text, vegetableDataList).isEmpty ? 
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "No Results for \"${searchQueryController.text}\"\nCheck the Spelling or try a new search ",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  )
                  : 
                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: isSearchingMode ? searchKeyWord(searchQueryController.text, vegetableDataList).length : vegetableDataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var vegetableData = isSearchingMode ? searchKeyWord(searchQueryController.text, vegetableDataList)[index] : vegetableDataList[index];
                      return VegetableCard(
                        vegetableData: vegetableData,
                        token: widget.token,
                        date: dateController.text,
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
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        dateTime = pickedDate;
        dateController.text = pickedDate.toString().split(' ')[0];
      });
      if (!context.mounted) return;
      fetchTodayVegetableData(context, token: widget.token, date: dateController.text);
    }
  }
}
