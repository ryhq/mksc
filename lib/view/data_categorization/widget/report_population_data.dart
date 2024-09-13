import 'package:flutter/material.dart';
import 'package:mksc/model/population_data.dart';
import 'package:mksc/widgets/app_pie_chart.dart';

class ReportPopulationData extends StatefulWidget {
  final List<PopulationData> populationDataList;
  final bool pieChart;
  final bool viewList;
  const ReportPopulationData({super.key, required this.populationDataList, required this.pieChart, required this.viewList});

  @override
  State<ReportPopulationData> createState() => _ReportPopulationDataState();
}

class _ReportPopulationDataState extends State<ReportPopulationData> {
  bool pieChartHorizontally = true;
  @override
  Widget build(BuildContext context) {
    bool pieChart = widget.pieChart;
    bool viewList = widget.viewList;
    List<String> months = extractUniqueMonths(widget.populationDataList); 
    return 
    widget.populationDataList.isEmpty ? const SizedBox() : 
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Population Data",
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        Divider(color: Theme.of(context).colorScheme.primary, thickness: 3, endIndent: MediaQuery.of(context).size.width * 0.5,),
        
        if(pieChart)...[
          ListTile(
            title: Text(
              "Pie Charts per Months",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  pieChartHorizontally = !pieChartHorizontally;
                });
              }, 
              icon: Icon(
                pieChartHorizontally ? Icons.swap_vertical_circle_outlined : Icons.swap_horizontal_circle_outlined,
                color: Theme.of(context).colorScheme.primary,
              )
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
          ),

          Divider(color: Theme.of(context).colorScheme.primary, thickness: 1),

          SizedBox(
            height: pieChartHorizontally ? MediaQuery.of(context).size.width * 0.75 : null,
            child: ListView.builder(
              physics: pieChartHorizontally ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics() ,
              controller: ScrollController(),
              shrinkWrap: true,
              scrollDirection: pieChartHorizontally ? Axis.horizontal : Axis.vertical,
              itemCount: months.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: pieChartHorizontally ? (
                    index == 0 ? null : index == months.length - 1 ? null :
                    BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(
                          color: Theme.of(context).colorScheme.primary
                        ),
                      )
                    )
                  ) : null,
                  child: Padding(
                    padding: pieChartHorizontally ? const EdgeInsets.only(left: 42.0, right: 21.0) : const EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          months[index].toUpperCase(),
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold,),
                        ),
                        AppPieChart(
                          month: months[index],
                          populationDataList: widget.populationDataList,
                          isHorizontalView: pieChartHorizontally,
                        ),
                        const SizedBox(height: 21,),
                        Divider(color: Theme.of(context).colorScheme.primary, thickness: 1,)
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          pieChartHorizontally ?  Divider(color: Theme.of(context).colorScheme.primary, thickness: 1) : const SizedBox() ,
        ],

        if(viewList)...[
          Text(
            "Actual Population Data",
            style: Theme.of(context).textTheme.titleMedium,
          ),

          Divider(color: Theme.of(context).colorScheme.primary, thickness: 1),
          
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: ScrollController(),
            shrinkWrap: true,
            itemCount: widget.populationDataList.length,
            itemBuilder: (BuildContext context, int index) {
              final populationData =  widget.populationDataList[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Text(
                      (index + 1).toString(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                    title: Text(
                      populationData.item,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
                    ),
                    subtitle: Text(
                      populationData.month,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Text(
                      populationData.total,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  index < widget.populationDataList.length - 1 ?
                  Divider(color: Theme.of(context).colorScheme.primary, thickness: 1,) : const SizedBox(),
                ],
              );
            },
          ),
          Divider(color: Theme.of(context).colorScheme.primary, thickness: 3,),
        ]
      ],
    );
  }

  List<String> extractUniqueMonths(List<PopulationData> populationDataList) {
    final Set<String> uniqueMonths = {};
    for (var data in populationDataList) {
      uniqueMonths.add(data.month); 
    }
    return uniqueMonths.toList();
  }
}