import 'package:flutter/material.dart';
import 'package:mksc/provider/chicken_house_data_provider.dart';
import 'package:mksc/provider/greeting_provider.dart';
import 'package:mksc/view/home/home_widget/category_card.dart';
import 'package:provider/provider.dart';

class MKSCHome extends StatefulWidget {
  const MKSCHome({super.key});

  @override
  State<MKSCHome> createState() => _MKSCHomeState();
}

class _MKSCHomeState extends State<MKSCHome> {
  @override
  void initState() {
    super.initState();
    initiateLocalDataStatus();
  }
  @override
  Widget build(BuildContext context) {
    String greeting = Provider.of<GreetingProvider>(context).currentGreeting;
    int chickenHouseLocalDataQuantity = Provider.of<ChickenHouseDataProvider>(context,).chickenHouseLocalDataStatus;
    debugPrint("\n\n\nGreeting to user: $greeting");
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: LayoutBuilder(
              builder: (context, constraints) {
                bool isCollapsed = constraints.biggest.height <= kToolbarHeight + MediaQuery.of(context).padding.top;
                return isCollapsed ? Text(
                  greeting,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith( color: Colors.white, fontWeight: FontWeight.bold,),
                ): const SizedBox();
              },
            ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                bool isCollapsed = constraints.biggest.height <= kToolbarHeight + MediaQuery.of(context).padding.top;
                return MediaQuery.of(context).orientation == Orientation.landscape ? 
                FlexibleSpaceBar(
                  centerTitle: false,
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Theme.of(context).colorScheme.surface,width: 3)
                          ),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15.0,
                            backgroundImage: AssetImage('assets/logo/logo.png'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            greeting,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ) 
                : 
                FlexibleSpaceBar(
                  centerTitle: true,
                  title: isCollapsed ? 
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.surface,
                              width: 3
                            )
                          ),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 15.0,
                            backgroundImage:
                                AssetImage('assets/logo/logo.png'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            greeting,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white,fontWeight: FontWeight.bold,),
                          ),
                        ),
                      ],
                    ),
                  )
                  : null,
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
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Theme.of(context).colorScheme.surface,width: 3)
                                ),
                                child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30.0,
                                  backgroundImage: AssetImage('assets/logo/logo.png'),
                                ),
                              ),
                              Text(
                                greeting,
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white,fontWeight: FontWeight.bold,),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Welcome to MKSC Official Data Collection App',
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
                      localData: chickenHouseLocalDataQuantity,
                    ),
                  1 => const CategoryCard(
                      title: "Menu",
                      svgicon: "assets/icons/menu.svg",
                      localData: 0,
                    ),
                  2 => const CategoryCard(
                      title: "Vegetables",
                      svgicon: "assets/icons/vegetables.svg",
                      localData: 0,
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
    await Provider.of<ChickenHouseDataProvider>(context, listen: false).fetchChickenHouseDataStatus();
  }
}
