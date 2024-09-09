import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/view/home/home_widget/major_category_card.dart';

class MKSCHome extends StatefulWidget {
  const MKSCHome({super.key});

  @override
  State<MKSCHome> createState() => _MKSCHomeState();
}

class _MKSCHomeState extends State<MKSCHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: const OvalBorder(eccentricity: 1, side: BorderSide.none),
          onPressed: () {
            
          },
          child: const Icon(
            CupertinoIcons.printer
          ),
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).colorScheme.primary,
              centerTitle: false,
              title: LayoutBuilder(
                builder: (context, constraints) {
                  bool isCollapsed = constraints.biggest.height <= kToolbarHeight + MediaQuery.of(context).padding.top;
                  return isCollapsed ? Text('Hello', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white,fontWeight: FontWeight.bold,),) : const SizedBox();
                },
              ),
              flexibleSpace: LayoutBuilder(
                builder:  (context, constraints) {
                  bool isCollapsed = constraints.biggest.height <= kToolbarHeight + MediaQuery.of(context).padding.top;
                  return FlexibleSpaceBar(
                    centerTitle: true,
                    title: isCollapsed ? Text('Hello', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white,fontWeight: FontWeight.bold,),): null,
                    background: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(21),
                        bottomRight: Radius.circular(21),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff569CEA),
                              Color(0xff9BC5EF),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(21),
                            bottomRight: Radius.circular(21),
                          ),
                        ),
                        child: SingleChildScrollView(
                          reverse: true,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: AssetImage('assets/logo/MKSC_Logo.jpg'),
                                ),
                                Text(
                                  'Welcome to MKSC Official Data Collection App',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
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
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(21)),
              ),
              expandedHeight: MediaQuery.of(context).size.height * 0.20,
              floating: false,
              pinned: true,
            ),
            SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3, // For landscape mode, show 4 items per row,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                childAspectRatio: 1.0
              ),
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return switch (index) {
                  0 => const MajorCategoryCard(
                    title: "Chicken House", 
                    iconData: Icons.donut_large
                  ),
                  1 => const MajorCategoryCard(
                    title: "Menu", 
                    iconData: Icons.local_pizza
                  ),
                  2 => const MajorCategoryCard(
                    title: "Vegetables", 
                    iconData: Icons.grass
                  ),
                  3 => const MajorCategoryCard(
                    title: "Laundry", 
                    iconData: Icons.local_laundry_service
                  ),
                  4 => const MajorCategoryCard(
                    title: "Beverage", 
                    iconData: Icons.emoji_food_beverage
                  ),
                  5 => const MajorCategoryCard(
                    title: "Lodge Rooms", 
                    iconData: Icons.bed
                  ),
                  int() => throw UnimplementedError(),
                };
              },
            )
          ],
        ),
      ),
    );
  }
}
