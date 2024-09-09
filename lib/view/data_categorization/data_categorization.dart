import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/population_data.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/services/population_data_services.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:provider/provider.dart';

class DataCategorization extends StatefulWidget {
  final String categoryTitle;
  const DataCategorization({super.key, required this.categoryTitle});

  @override
  State<DataCategorization> createState() => _DataCategorizationState();
}

class _DataCategorizationState extends State<DataCategorization> {
  List<PopulationData> populationData = [];

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
                    return switch (index) {
                      0 => const CardCategory(title: "Cock", iconData: Icons.egg),
                      1 => const CardCategory(title: "Hen", iconData: Icons.egg),
                      2 => const CardCategory(title: "Chick", iconData: Icons.egg),
                      3 => const CardCategory(title: "Eggs", iconData: Icons.egg),
                      int() => throw UnimplementedError(),
                    };
                  },
                ),
                Text(
                  "Today Uploaded Data",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                
                const BallPulseIndicator(),
                
                Text(
                  "Population Data",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                populationData.isEmpty ? const BallPulseIndicator() :
                ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: populationData.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = populationData[index];
                    return Card(
                      elevation: 3,
                      shape: const  RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))
                      ),
                      child: ListTile(
                        title: Text(
                          "${data.item[0].toUpperCase()}${data.item.replaceFirst(RegExp(data.item[0]), '',)}",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          data.month,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        trailing: Text(
                          data.total,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    );
                  },
                ),
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
    });
  }
}

class CardCategory extends StatefulWidget {
  final String title;
  final IconData iconData;
  const CardCategory({
    super.key, required this.title, required this.iconData,
  });

  @override
  State<CardCategory> createState() => _CardCategoryState();
}

class _CardCategoryState extends State<CardCategory> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: Card(
        elevation: 3,
        color: _isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
        shape: const  RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isSelected ? Icons.check : widget.iconData,
              color: _isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
              size: Provider.of<ThemeProvider>(context).fontSize + 7,
            ),
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: _isSelected ? Colors.white : Theme.of(context).colorScheme.primary),
            )
          ],
        ),
      ),
    );
  }
}