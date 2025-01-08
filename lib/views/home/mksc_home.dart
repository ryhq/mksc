import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/providers/chicken_house_provider.dart';
import 'package:mksc/providers/greeting_provider.dart';
import 'package:mksc/providers/theme_provider.dart';
import 'package:mksc/providers/vegetable_provider.dart';
import 'package:mksc/views/home/home_widget/category_card.dart';
import 'package:mksc/views/home/home_widget/flexible_space_bar_row_content.dart';
import 'package:mksc/views/home/home_widget/greeting_text.dart';
import 'package:mksc/views/home/home_widget/logo_circle_avatar.dart';
import 'package:provider/provider.dart';

class MKSCHome extends StatefulWidget {
  const MKSCHome({super.key});

  @override
  State<MKSCHome> createState() => _MKSCHomeState();
}

class _MKSCHomeState extends State<MKSCHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initiateLocalDataStatus();
  }

  List<String> fontFamilyList = [
    'caesar',
    'roboto',
    'NanumGothic',
    'Permola',
    'AdineKirnberg',
    'Angeles',
    'AutumnFlowers',
    'cormorant',
    'extreme-travel',
    'friday',
    'gessele',
    'georgia',
    'littlelordfontleroy',
    'playfair',
    'pac_libertas',
    'wall'
  ];

  List<String> sortFontFamilyListAlphabetically(List<String> fontFamilyList) {
    fontFamilyList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return fontFamilyList;
  }
  
  @override
  Widget build(BuildContext context) {
    String greeting = Provider.of<GreetingProvider>(context).currentGreeting;
    int localChickenHouseDataStatus = Provider.of<ChickenHouseProvider>(context,).localChickenHouseDataStatus;
    int localVegetableDataStatus = Provider.of<VegetableProvider>(context,).localVegetableDataStatus;
    String selectedFont = Provider.of<ThemeProvider>(context).fontFamily;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              duration: const Duration(seconds: 3),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LogoCircleAvatar(),
                    const SizedBox(height: 8),
                    Text(
                      'Version Control and Setting',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.verified_sharp),
              title: Text(
                'Version 2.1.1',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              subtitle: Text(
                '~ Data entry vulnerability fix and data integrity updates\n~ Decentralized Manual data synchronisation\n~ Simplified User experience\n~ Enhanced Offline Mode',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
            Text(
              "Font Size",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Slider(
              value: Provider.of<ThemeProvider>(context).fontSize,
              min: 10.0,
              max: 30.0,
              divisions: 7,
              label: Provider.of<ThemeProvider>(context).fontSize.round().toString(),
              onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).setFontSize(value),
            ),
            ListTile(
              title: Text(
                "Font Family", 
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedFont, 
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      CupertinoIcons.forward,
                      color: Theme.of(context).colorScheme.primary,
                      size: Provider.of<ThemeProvider>(context).fontSize + 7,
                    ),
                    onSelected: (String format) {
                      Provider.of<ThemeProvider>(context, listen: false).setFontFamily(format);
                    },
                    itemBuilder: (BuildContext context) {
                      return sortFontFamilyListAlphabetically(fontFamilyList).map((font){
                        return PopupMenuItem<String>(
                          value: font,
                          child: Text(
                            font,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontFamily: font
                            ),
                          ),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            ),
            ListTile(
              title: Text("Dark Mode", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),),
              // Dark mode switch
              trailing: CupertinoSwitch(
                value: Provider.of<ThemeProvider>(context).isDarkMode,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: LayoutBuilder(
              builder: (context, constraints) {
                bool isCollapsed = constraints.biggest.height <= kToolbarHeight + MediaQuery.of(context).padding.top;
                return isCollapsed ? GreetingText(greeting: greeting) : const SizedBox();
              },
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                bool isCollapsed = constraints.biggest.height <= kToolbarHeight + MediaQuery.of(context).padding.top;
                return MediaQuery.of(context).orientation == Orientation.landscape ? 
                FlexibleSpaceBar(
                  centerTitle: false,
                  title: FlexibleSpaceBarRowContent(greeting: greeting),
                ) 
                : 
                FlexibleSpaceBar(
                  centerTitle: true,
                  title: isCollapsed ? FlexibleSpaceBarRowContent(greeting: greeting) : null,
                  background: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(21),
                      bottomRight: Radius.circular(21),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primary,
                            // Theme.of(context).colorScheme.secondary,
                            // Color(0xff569CEA),
                            // const Color(0xff9BC5EF),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(21),
                          bottomRight: Radius.circular(21),
                        ),
                      ),
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _scaffoldKey.currentState?.openDrawer();
                                },
                                child: const LogoCircleAvatar(),
                              ),
                              GreetingText(greeting: greeting),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Welcome to MKSC Official Data Collection App',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(21)),),
            expandedHeight: MediaQuery.of(context).size.height * 0.20,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.primary,
            centerTitle: false,
            floating: false,
            pinned: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 3 : 6, // For landscape mode, show 4 items per row,
                crossAxisSpacing: MediaQuery.of(context).orientation == Orientation.portrait ? 10.0 : 5.0,
                mainAxisSpacing: MediaQuery.of(context).orientation == Orientation.portrait ? 10.0 : 5.0,
              ),
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return switch (index) {
                  0 => CategoryCard(
                      title: "Chicken House",
                      svgicon: "assets/icons/chicken_.svg",
                      localData: localChickenHouseDataStatus,
                    ),
                  1 => const CategoryCard(
                      title: "Menu",
                      svgicon: "assets/icons/menu.svg",
                      localData: 0,
                    ),
                  2 => CategoryCard(
                      title: "Vegetables",
                      svgicon: "assets/icons/vegetables.svg",
                      localData: localVegetableDataStatus
                    ),
                  3 => const CategoryCard(
                      title: "Laundry",
                      svgicon: "assets/icons/laundry.svg",
                      localData: 0,
                    ),
                  4 => const CategoryCard(
                      title: "Beverage",
                      svgicon: "assets/icons/beverage.svg",
                      localData: 0,
                    ),
                  5 => const CategoryCard(
                      title: "Louge Room",
                      svgicon: "assets/icons/bed.svg",
                      localData: 0,
                    ),
                  int() => throw UnimplementedError(),
                };
              },
            ),
          )
        ],
      ),
    );
  }

  void initiateLocalDataStatus() async {
    await Provider.of<ChickenHouseProvider>(context, listen: false).fetchChickenHouseDataStatus();
    await fetchVegetableDataStatus();
  }

  Future<void> fetchVegetableDataStatus() async {
    await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataStatus();
  }
}