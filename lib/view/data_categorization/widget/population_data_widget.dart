import 'package:flutter/material.dart';
import 'package:mksc/model/population_data.dart';
import 'package:mksc/provider/data_provider.dart';
import 'package:provider/provider.dart';

class PopulationDataWidget extends StatefulWidget {

  final List<String> selectedCategories;
  const PopulationDataWidget({super.key, required this.selectedCategories});

  @override
  State<PopulationDataWidget> createState() => _PopulationDataState();
}

class _PopulationDataState extends State<PopulationDataWidget> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List<PopulationData> populationData = Provider.of<DataProvider>(context).populationData;
    List<PopulationData> filteredPopulationData = Provider.of<DataProvider>(context).filteredPopulationData(widget.selectedCategories);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // Text(
          //   "Population Data (${filteredPopulationData.length})",
          //   style: Theme.of(context).textTheme.bodyLarge,
          // ),
          
          populationData.isEmpty ? Center(
            child: Text(
            'No data available',
            style: Theme.of(context).textTheme.bodyLarge,
            )
          ):
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: filteredPopulationData.length,
            itemBuilder: (BuildContext context, int index) {
              var data = filteredPopulationData[index];
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
    );
  }
}