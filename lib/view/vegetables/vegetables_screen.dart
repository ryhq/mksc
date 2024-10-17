import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/provider/vegetable_provider.dart';
import 'package:mksc/view/vegetables/vegetables_sync_screen.dart';
import 'package:mksc/view/vegetables/widget/vegetable_card.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/log_out_action_button.dart';
import 'package:mksc/widgets/shimmer_widgets.dart';
import 'package:provider/provider.dart';

class VegetablesScreen extends StatefulWidget {

  final String? token;

  final String categoryTitle;

  const VegetablesScreen({super.key, this.token, required this.categoryTitle});

  @override
  
  State<VegetablesScreen> createState() => _VegetablesScreenState();
}

class _VegetablesScreenState extends State<VegetablesScreen> {

  TextEditingController dateController = TextEditingController(); 

  TextEditingController searchQueryController = TextEditingController(); 

  DateTime dateTime = DateTime.now();
  
  bool isLoading = false;

  bool isSyncing = false;

  bool isSearchingMode = false;

  @override
  void initState() {
    
    super.initState();
    setState(() {
      dateController.text = DateTime.now().toString().split(' ')[0];
    });

    fetchVegetableData();
  }

  @override
  Widget build(BuildContext context) {

    List<Vegetable> vegetableDataList = Provider.of<VegetableProvider>(context).vegetableDataList.reversed.toList();
    int vegetableLocalDataStatus = Provider.of<VegetableProvider>(context).vegetableLocalDataStatus;

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
            !isSyncing && vegetableDataList.isNotEmpty ? 
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

            if(widget.token != null && vegetableLocalDataStatus != 0)...[
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

            if(widget.token != null && !isSyncing && !isSearchingMode)...[
              LogOutActionButton(categoryTitle: widget.categoryTitle)
            ],
          ],
          centerTitle: isSearchingMode ? false : true,
          backgroundColor: isSearchingMode ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.primary,
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
                    child: const VegetablesSyncScreen()
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
                          isSearchingMode && searchKeyWord(searchQueryController.text, vegetableDataList).isEmpty ? 
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
                              return widget.token == null ?
                              VegetableCard(
                                vegetableData: vegetableData,
                                date: dateController.text,
                              )
                              :
                              VegetableCard(
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
              ],
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
      if (widget.token == null) {
        await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataLocally(context, date: dateController.text);
      } else {
        fetchTodayVegetableData(context, token: widget.token!, date: dateController.text);
      }
    }
  }
  void fetchVegetableData() async {
    setState(() {
      isLoading = true;
    });

    await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableData(context);

    if (widget.token == null) {
      await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataLocally(context, date: dateController.text);
    } else {
      await syncData();
      fetchTodayVegetableData(context, token: widget.token!, date: dateController.text);
    }

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
    
    await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataLocally(context, date: date);

    await Provider.of<VegetableProvider>(context, listen: false).fetchTodayVegetableData(context, token: token, date: date);

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
  
  Future<void> syncData() async {
    setState(() {
      isSyncing = true;
    });

    // CustomAlert.showAlert(context, "Service Unavailable", "Sorry, this service is temporarily under development.");
    // setState(() {
    //   isSyncing = false;
    // });
    // return;
    debugPrint("\n👉 Syncing state  : \t$isSyncing");
    await Provider.of<VegetableProvider>(
      context, 
      listen: false
    ).uploadData(context, token: widget.token!);
    setState(() {
      isSyncing = false;
    });
    if (!context.mounted) return;
    await fetchTodayVegetableData(context, token: widget.token!, date: dateController.text);
    debugPrint("\n👉 Syncing state  : \t$isSyncing");
  }
}
