

import 'package:flutter/cupertino.dart';
import 'package:mksc/model/population_data.dart';
import 'package:pie_chart/pie_chart.dart';

class AppPieChart extends StatelessWidget {
  final List<PopulationData> populationDataList; 
  final String month;
  final bool? isHorizontalView;
  const AppPieChart({
    super.key, 
    required this.populationDataList, 
    required this.month, 
    this.isHorizontalView = true,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = PopulationData.createItemTotalMap(
      extractPopulationDataPerMonth(populationDataList, month)
    );
    return PieChart(
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 1800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      // colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 32,
      centerText: month,
      legendOptions: LegendOptions(
        showLegendsInRow: isHorizontalView! &&  dataMap.length > 3 ? true : false,
        legendPosition: isHorizontalView! &&  dataMap.length > 3 ? LegendPosition.bottom : LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: const TextStyle(
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
    );
  }

  List<PopulationData> extractPopulationDataPerMonth(List<PopulationData> populationDataList, String month){
    return populationDataList.where((data) => month.toLowerCase().contains(data.month.toLowerCase())).toList();
  }
}