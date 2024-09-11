import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mksc/model/data.dart';
import 'package:mksc/model/population_data.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class DataReportPage extends StatefulWidget {
  final List<Data> dataList;
  final List<PopulationData> populationDataList;
  const DataReportPage({
    super.key, 
    required this.dataList, 
    required this.populationDataList
  });

  @override
  State<DataReportPage> createState() => _DataReportPageState();
}

class _DataReportPageState extends State<DataReportPage> {
  bool pieChart = true;
  bool viewList = true;
  @override
  Widget build(BuildContext context) {
    List<String> months = extractUniqueMonths(widget.populationDataList); 
    return Scaffold(
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
          "Report",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
        actions: [
          if(viewList || pieChart)...[
            IconButton(
              onPressed: (){
              }, 
              icon: Icon(
                Icons.table_chart_sharp,
                color: Theme.of(context).colorScheme.primary,
              ),
              tooltip: "Share as csv",
            ),
            IconButton(
              onPressed: (){
                
              }, 
              icon: Icon(
                Icons.picture_as_pdf,
                color: Theme.of(context).colorScheme.primary,
              ),
              tooltip: "Share as Pdf",
            ),
          ]
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 40), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: (){
                  setState(() {
                    pieChart = !pieChart;
                  });
                }, 
                icon: Icon(
                  pieChart ? Icons.pie_chart : Icons.pie_chart_outline,
                  color: pieChart ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                ),
                tooltip: "Pie Chart",
              ),
              IconButton(
                onPressed: (){
                  setState(() {
                    viewList = !viewList;
                  });
                }, 
                icon: Icon(
                  viewList ? Icons.list : Icons.list_alt_rounded,
                  color: viewList ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                ),
                tooltip: "List",
              ),
            ],
          )
        ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 30.0,
                    backgroundImage: AssetImage('assets/logo/MKSC_Logo.jpg'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "MKSC Data Report",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          DateFormat('EEEE dd, MMMM yyyy').format(DateTime.now()),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                    Text(
                      "Pie Charts per Months",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    Divider(color: Theme.of(context).colorScheme.primary, thickness: 1),

                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: ScrollController(),
                      shrinkWrap: true,
                      itemCount: months.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              months[index].toUpperCase(),
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold,),
                            ),
                            AppPieChart(
                              month: months[index],
                              populationDataList: widget.populationDataList,
                            ),
                            const SizedBox(height: 21,),
                            Divider(color: Theme.of(context).colorScheme.primary, thickness: 1,)
                          ],
                        );
                      },
                    ),
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
              ),

              const SizedBox(height: 42,),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> extractUniqueMonths(List<PopulationData> populationDataList) {
    final Set<String> uniqueMonths = {};
    for (var data in populationDataList) {
      uniqueMonths.add(data.month); 
    }
    return uniqueMonths.toList();
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

class AppPieChart extends StatelessWidget {
  final List<PopulationData> populationDataList; 
  final String month;
  const AppPieChart({
    super.key, required this.populationDataList, required this.month,
  });

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: PopulationData.createItemTotalMap(
        extractPopulationDataPerMonth(populationDataList, month)
      ),
      animationDuration: const Duration(milliseconds: 1800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 3.2,
      // colorList: colorList,
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 32,
      centerText: month,
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

  List<PopulationData> extractPopulationDataPerMonth(List<PopulationData> populationDataList, String month){
    return populationDataList.where((data) => month.toLowerCase().contains(data.month.toLowerCase())).toList();
  }
}