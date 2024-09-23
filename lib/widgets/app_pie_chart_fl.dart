import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/population_data.dart';
import 'package:mksc/widgets/indicator.dart';

class AppPieChartFl extends StatefulWidget {
  final List<PopulationData> populationDataList;
  final String month;
  const AppPieChartFl({
    super.key, 
    required this.populationDataList, 
    required this.month
  });

  @override
  State<AppPieChartFl> createState() => _AppPieChartFlState();
}

class _AppPieChartFlState extends State<AppPieChartFl> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.month.toUpperCase(),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold,),
          ),
          Row(
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
          
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: Theme.of(context).colorScheme.onSurface, width: 3)
                      ),
                      sectionsSpace: 3,
                      centerSpaceRadius: 40,
                      sections: showingSections(
                        extractPopulationDataPerMonth(
                          widget.populationDataList, 
                          widget.month
                        )
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: generateIndicator(
                  extractPopulationDataPerMonth(
                    widget.populationDataList, 
                    widget.month
                  )
                )
              ),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Indicator> generateIndicator(List<PopulationData> populationDataList){
    return List.generate(
      populationDataList.length, 
      (index){
        return Indicator(
          color: defaultColorList[index % defaultColorList.length], 
          text: populationDataList[index].item, 
          isSquare: true,
        );
      }
    );
  }

  List<PieChartSectionData> showingSections(List<PopulationData> populationDataList) {
    double total = 0.0;
    for (var populationData in populationDataList) {
      total += populationData.total;
    }
    return List.generate(populationDataList.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      return PieChartSectionData(
        color: defaultColorList[i % defaultColorList.length],
        value: populationDataList[i].total / 1.0,
        title: "${(populationDataList[i].total / total * 100).toStringAsFixed(2)}%".toString(),
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.surface,
          shadows: shadows,
        ),
      );
    });
  }

  List<PopulationData> extractPopulationDataPerMonth(List<PopulationData> populationDataList, String month){
    return populationDataList.where((data) => month.toLowerCase().contains(data.month.toLowerCase())).toList();
  }

  List<Color> defaultColorList = const[
    Color(0xFFff7675),
    Color(0xFF74b9ff),
    Color(0xFF55efc4),
    Color(0xFFffeaa7),
    Color(0xFFa29bfe),
    Color(0xFFfd79a8),
    Color(0xFFe17055),
    Color(0xFF00b894),
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Color(0xFF8A2BE2), // Violet
  ];
}
