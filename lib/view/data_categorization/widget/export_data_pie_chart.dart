import 'package:flutter/material.dart';
import 'package:mksc/model/data.dart';
import 'package:pie_chart/pie_chart.dart';

class ExportDataPieChart {
  static PieChart exportPieChart(BuildContext context, List<Data> dataList) {
    return PieChart(
      dataMap: _createItemToNumberMap(dataList),
      animationDuration: const Duration(milliseconds: 0),
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
    );
  }

  static Map<String, double> _createItemToNumberMap(List<Data> dataList){
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