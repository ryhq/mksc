import 'package:flutter/material.dart';
import 'package:mksc/model/population_data.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';

class PopulationDataWidget extends StatefulWidget {
  final List<PopulationData> populationData;
  final List<PopulationData> filteredPopulationData;
  const PopulationDataWidget({super.key, required this.populationData, required this.filteredPopulationData});

  @override
  State<PopulationDataWidget> createState() => _PopulationDataState();
}

class _PopulationDataState extends State<PopulationDataWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.populationData.isEmpty?
    Center(child: Text(
      'No data available',
      style: Theme.of(context).textTheme.bodyLarge,
      )
    ):
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Population Data (${widget.filteredPopulationData.length})",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        widget.populationData.isEmpty ? const BallPulseIndicator() :
        ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.filteredPopulationData.length,
          itemBuilder: (BuildContext context, int index) {
            var data = widget.filteredPopulationData[index];
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
    );
  }
}