import 'package:flutter/material.dart';
import 'package:mksc/model/data.dart';
import 'package:pie_chart/pie_chart.dart';

class ReportData extends StatefulWidget {
  final List<Data> dataList;
  final bool pieChart;
  final bool viewList;
  const ReportData({
    super.key, 
    required this.dataList, 
    required this.pieChart, 
    required this.viewList
  });

  @override
  State<ReportData> createState() => _ReportDataState();
}

class _ReportDataState extends State<ReportData> {
  @override
  Widget build(BuildContext context) {
    bool pieChart = widget.pieChart;
    bool viewList = widget.viewList;
    return 
    widget.dataList.isEmpty ? const SizedBox() : 
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Data",
          style: Theme.of(context).textTheme.headlineSmall,
        ),

        Divider(color: Theme.of(context).colorScheme.primary, thickness: 3, endIndent: MediaQuery.of(context).size.width * 0.5,),
        
        if(pieChart)...[
          Text(
            "Pie Chart",
            style: Theme.of(context).textTheme.titleMedium,
          ),

          Divider(color: Theme.of(context).colorScheme.primary, thickness: 1),
          
          const SizedBox(height: 21,),

          PieChart(
            dataMap: createItemToNumberMap(widget.dataList),
            animationDuration: const Duration(milliseconds: 1800),
            chartLegendSpacing: 32,
            chartRadius: MediaQuery.of(context).size.width / 3.2,
            // colorList: colorList,
            initialAngleInDegree: 0,
            chartType: ChartType.ring,
            ringStrokeWidth: 32,
            // centerText: month,
            legendOptions: const LegendOptions(
              showLegendsInRow: false,
              legendPosition: LegendPosition.right,
              showLegends: true,
              legendShape: BoxShape.circle,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: true,
              showChartValues: true,
              showChartValuesInPercentage: true,
              showChartValuesOutside: true,
              decimalPlaces: 1,
            ),
          ),
          
          const SizedBox(height: 21,),

          Divider(color: Theme.of(context).colorScheme.primary, thickness: 1),
        ],

        if(viewList)...[
          Text(
            "Actual Data",
            style: Theme.of(context).textTheme.titleMedium,
          ),

          Divider(color: Theme.of(context).colorScheme.primary, thickness: 1),
          

          ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: ScrollController(),
            shrinkWrap: true,
            itemCount: widget.dataList.length,
            itemBuilder: (BuildContext context, int index) {
              final data =  widget.dataList[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Text(
                      (index + 1).toString(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                    title: Text(
                      data.item,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
                    ),
                    subtitle: Text(
                      data.id.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    trailing: Text(
                      data.number,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  index < widget.dataList.length - 1 ?
                  Divider(color: Theme.of(context).colorScheme.primary, thickness: 1,) : const SizedBox(),
                ],
              );
            },
          ),
        ]
      ],
    );
  }

  Map<String, double> createItemToNumberMap(List<Data> dataList){
    Map<String, double> itemTotalMap = {};
    for (var data in dataList) {
      if (itemTotalMap.keys.contains(data.item.toLowerCase())) {
        itemTotalMap[data.item.toLowerCase()] = (itemTotalMap[data.item.toLowerCase()]! + double.parse(data.number));
      } else {
        itemTotalMap[data.item.toLowerCase()] = double.parse(data.number);
      }
    }
    return itemTotalMap;
  }
}