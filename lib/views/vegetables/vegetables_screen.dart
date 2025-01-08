import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/auth_token.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/providers/internet_connection_provider.dart';
import 'package:mksc/providers/theme_provider.dart';
import 'package:mksc/providers/vegetable_provider.dart';
import 'package:mksc/storage/token_storage.dart';
import 'package:mksc/views/vegetables/vegetables_sync_screen.dart';
import 'package:mksc/views/vegetables/widgets/vegetable_card.dart';
import 'package:mksc/widgets/app_animated_switcher.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/log_out_action_button.dart';
import 'package:mksc/widgets/shimmer_widgets.dart';
import 'package:provider/provider.dart';

class VegetablesScreen extends StatefulWidget {
  final String categoryTitle;
  const VegetablesScreen({super.key, required this.categoryTitle});

  @override
  State<VegetablesScreen> createState() => _VegetablesScreenState();
}

class _VegetablesScreenState extends State<VegetablesScreen> {
  TextEditingController dateController = TextEditingController(); 
  TextEditingController searchQueryController = TextEditingController(); 
  DateTime dateTime = DateTime.now();
  bool isSyncing = false;
  bool isSearchingMode = false;
  AuthToken authToken = AuthToken.empty();
  @override
  void initState() {
    super.initState();
    setState(() {
      dateController.text = DateTime.now().toString().split(' ')[0];
    });
    getTokenDirect();
    fetchVegetableData();
  }

  void getTokenDirect() async{
    TokenStorage tokenStorage = TokenStorage();
    authToken = await tokenStorage.getTokenDirect(tokenKey: widget.categoryTitle);
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    double fontSize = Provider.of<ThemeProvider>(context).fontSize;
    final vegetableProvider = Provider.of<VegetableProvider>(context);
    int localVegetableDataStatus = vegetableProvider.localVegetableDataStatus;
    List<Vegetable> vegetableDataList = vegetableProvider.vegetablesList.reversed.toList();
    bool isLoading = vegetableProvider.isFetchingVegetableData;
    bool internetConnection = Provider.of<InternetConnectionProvider>(context).isConnected;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: !isSearchingMode,
          leading: isSearchingMode ? null : IconButton(
            icon: Icon(
              CupertinoIcons.back, 
              size: fontSize + 7,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title:  isSearchingMode ? 
          AppTextFormField(
            hintText: "Search in ${widget.categoryTitle}",
            iconData: Icons.search,
            obscureText: false,
            autofocus: true,
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
            AppAnimatedSwitcher(
              show: !isSyncing && vegetableDataList.length > 7, 
              child: IconButton(
                tooltip: isSearchingMode ? 'Cancel' : 'Search',
                onPressed: () {
                  setState(() {
                    isSearchingMode = !isSearchingMode;
                    searchQueryController.clear();
                  });
                },
                icon: Icon(
                  isSearchingMode ? Icons.cancel : Icons.search,
                  color: isSearchingMode ? Theme.of(context).colorScheme.error : Colors.white,
                  size: Provider.of<ThemeProvider>(context).fontSize + 7,
                )
              )
            ),
            AppAnimatedSwitcher(
              show: !isSearchingMode && localVegetableDataStatus > 0 && internetConnection,
              child: isSyncing ? SizedBox(
                width: Provider.of<ThemeProvider>(context).fontSize + 7,
                height: Provider.of<ThemeProvider>(context).fontSize + 7,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                ),
              ) 
              :
              IconButton(
                onPressed: () async {
                  syncData();
                }, 
                tooltip: 'Sync',
                icon: Icon(
                  Icons.sync,
                  color:Colors.white,
                  size: Provider.of<ThemeProvider>(context).fontSize + 7,
                )
              ),
            ),
            AppAnimatedSwitcher(
              show: !isSearchingMode && authToken.token.isNotEmpty,
              child: LogOutActionButton(
                categoryTitle: widget.categoryTitle
              )
            )
          ],
          centerTitle: isSearchingMode ? false : true,
          backgroundColor: isSearchingMode ? Theme.of(context).colorScheme.surface : primaryColor,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: AbsorbPointer(
          absorbing: isSyncing,
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
                          
                        ],
                        AppAnimatedSwitcher(
                          show: !isSearchingMode, 
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Search or filter ${widget.categoryTitle} data by date.",
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
                          )
                        ),
                        isLoading ? ShimmerWidgets(totalShimmers: vegetableDataList.isEmpty ? 7 : vegetableDataList.length)
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
                            return VegetableCard(
                              vegetableData: vegetableData,
                              title: widget.categoryTitle,
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
      )
    );
  }

  void fetchVegetableData() async {
    await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableData(
      context: context,
      date: dateController.text,
      title: widget.categoryTitle
    );
  }

  void syncData() async {
    int data = Provider.of<VegetableProvider>(context, listen: false).localVegetableDataStatus;
    if (data == 0) {
      return;
    }
    setState(() {
      isSyncing = true;
    });

    await Provider.of<VegetableProvider>(
      context, 
      listen: false
    ).uploadAndDeleteLocalData(context: context, title: widget.categoryTitle);
    fetchVegetableData();
    setState(() {
      isSyncing = false;
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
      fetchVegetableData();
    }
  }

  List<Vegetable> searchKeyWord(String searchQuery, List<Vegetable> vegetableDataList) {
    List<Vegetable> result = vegetableDataList.where((data) {
      return data.name.toLowerCase().startsWith(searchQuery.toLowerCase());
    }).toList();
    return result;
  }
}