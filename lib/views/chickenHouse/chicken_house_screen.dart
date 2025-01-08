import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mksc/model/auth_token.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:mksc/model/chicken_house_product.dart';
import 'package:mksc/providers/chicken_house_provider.dart';
import 'package:mksc/providers/theme_provider.dart';
import 'package:mksc/storage/token_storage.dart';
import 'package:mksc/views/chickenHouse/chicken_house_sync_screen.dart';
import 'package:mksc/views/chickenHouse/widgets/chicken_house_data_entry.dart';
import 'package:mksc/views/chickenHouse/widgets/chicken_house_data_list.dart';
import 'package:mksc/widgets/app_animated_switcher.dart';
import 'package:mksc/widgets/app_text_form_field.dart';
import 'package:mksc/widgets/log_out_action_button.dart';
import 'package:provider/provider.dart';

class ChickenHouseScreen extends StatefulWidget {
  final String categoryTitle;
  const ChickenHouseScreen({super.key, required this.categoryTitle});

  @override
  State<ChickenHouseScreen> createState() => _ChickenHouseScreenState();
}

class _ChickenHouseScreenState extends State<ChickenHouseScreen> {
  TextEditingController dateController = TextEditingController();
  DateTime dateTime = DateTime.now();
  final List<ChickenHouseProduct> chickenHouseCategories = [
    ChickenHouseProduct(svgicon: 'assets/icons/chicken_.svg', name: 'Cock'),
    ChickenHouseProduct(svgicon: 'assets/icons/hen.svg', name: 'Hen'),
    ChickenHouseProduct(svgicon: 'assets/icons/chick.svg', name: 'Chick'),
    ChickenHouseProduct(svgicon: 'assets/icons/egg.svg', name: 'Eggs'),
  ];
  ChickenHouseProduct selectedChickenHouseProduct = ChickenHouseProduct.empty();
  bool savingData = false;
  bool isSyncing = false;
  AuthToken authToken = AuthToken.empty();
  @override
  void initState() {
    super.initState();
    setState(() {
      dateController.text = DateTime.now().toString().split(' ')[0];
    });
    getTokenDirect();
    fetchChickenHousesLocalDataByDate();
  }

  void getTokenDirect() async{
    TokenStorage tokenStorage = TokenStorage();
    authToken = await tokenStorage.getTokenDirect(tokenKey: widget.categoryTitle);
  }

  @override
  Widget build(BuildContext context) {
    double fontSize = Provider.of<ThemeProvider>(context).fontSize;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final chickenHouseProviderListenTrue = Provider.of<ChickenHouseProvider>(context);
    List<ChickenHouseData> chickenHouseLocalDataList = chickenHouseProviderListenTrue.chickenHouseDataList;
    int localChickenHouseDataStatus = Provider.of<ChickenHouseProvider>(context, listen: false).localChickenHouseDataStatus;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              CupertinoIcons.back, 
              size: fontSize + 7,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.categoryTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          actions: [
            AppAnimatedSwitcher(
              show: localChickenHouseDataStatus > 0,
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
                icon: Icon(
                  Icons.sync,
                  color:Colors.white,
                  size: Provider.of<ThemeProvider>(context).fontSize + 7,
                )
              ),
            ),
            AppAnimatedSwitcher(
              show: authToken.token.isNotEmpty,
              child: LogOutActionButton(
                categoryTitle: widget.categoryTitle
              )
            )
          ],
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [

            Align(
              alignment: Alignment.center,
              child: AppAnimatedSwitcher(
                show: isSyncing || savingData,
                child: Opacity(
                  opacity: isSyncing || savingData ? 1.0 : 0.0,
                  child: const ChickenHouseSyncScreen()
                ),
              ),
            ),

            AbsorbPointer(
              absorbing: isSyncing || savingData ,
              child: Opacity(
                opacity: isSyncing || savingData ? 0.1 : 1.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                              readOnly: true,
                              iconData: Icons.date_range,
                              obscureText: false,
                              textInputType: TextInputType.number,
                              textEditingController: dateController,
                            ),
                          ),
                        ),
                        const SizedBox(height: 21,),
                        Text(
                          "Please Tap to select Category",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.13,
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isPortrait ? 2 : 4,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: isPortrait
                                    ? MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 8)
                                    : MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 2),
                              ),
                              itemCount: chickenHouseCategories.length,
                              itemBuilder: (BuildContext context, int index) {
                                final category = chickenHouseCategories[index];
                                
                                // Check if the category name exists in chickenHouseDataList
                                final isDisabled = chickenHouseLocalDataList.any(
                                  (data) => data.item == category.name
                                );
                                              
                                final isSelected = selectedChickenHouseProduct == category;
                                              
                                return GestureDetector(
                                  onTap: isDisabled ? null : () {
                                    setState(() {
                                      selectedChickenHouseProduct = isSelected ? ChickenHouseProduct.empty() : category;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isDisabled ? Colors.grey : primaryColor,
                                        width: isDisabled ? 1.0 : isSelected ? 2.0 : 0.5
                                      ),
                                      borderRadius: isDisabled ? BorderRadius.circular(32.0) : BorderRadius.circular(8.0),
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
                        AppAnimatedSwitcher(
                          show: selectedChickenHouseProduct.name.isNotEmpty,
                          child: ChickenHouseDataEntry(
                            chickenHouseProduct: selectedChickenHouseProduct, 
                            categoryTitle: widget.categoryTitle,
                            date: dateController.text,
                            onSaving: () {
                              setState(() {
                                savingData = true;
                              });
                            },
                            onSavingDone: () {
                              setState(() {
                                savingData = false;
                                selectedChickenHouseProduct = ChickenHouseProduct.empty();
                              });
                            },
                          ),
                        ),
                        ChickenHouseDataList(
                          title: widget.categoryTitle, 
                          date: dateController.text
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {

    if (selectedChickenHouseProduct.name.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Unselect the ${selectedChickenHouseProduct.name} category to continue."
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
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
      fetchChickenHousesLocalDataByDate();
    }
  }

  void fetchChickenHousesLocalDataByDate() async{
    final chickenHouseProviderListenFalse = Provider.of<ChickenHouseProvider>(context, listen: false);
    await chickenHouseProviderListenFalse.fetchChickenHouseDataOnlineAndOffline(
      context: context, 
      date: dateController.text,
      title: widget.categoryTitle,
    );
  }

  void syncData() async {
    int data = Provider.of<ChickenHouseProvider>(context, listen: false).localChickenHouseDataStatus;
    if (data == 0) {
      return;
    }
    setState(() {
      isSyncing = true;
    });

    await Provider.of<ChickenHouseProvider>(
      context, 
      listen: false
    ).uploadAndDeleteLocalData(context: context, title: widget.categoryTitle);
    fetchChickenHousesLocalDataByDate();
    setState(() {
      isSyncing = false;
    });
  }
}
