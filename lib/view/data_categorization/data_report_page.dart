import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/data.dart';
import 'package:mksc/model/population_data.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/view/data_categorization/methods/report_methods.dart';
import 'package:mksc/view/data_categorization/widget/report_data.dart';
import 'package:mksc/view/data_categorization/widget/report_header.dart';
import 'package:mksc/view/data_categorization/widget/report_population_data.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
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
  bool creatingPdf = false;
  ReportMethods reportMethods = ReportMethods();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: creatingPdf ? Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // const Spacer(),
                const BallPulseIndicator(),
                Text("Generating Report PDF...", style: Theme.of(context).textTheme.headlineSmall,),
                const SizedBox(height: 21,),
              ],
            ),
          ),
        ),
      ):
      Scaffold(
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
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
              // IconButton(
              //   onPressed: (){
      
              //   }, 
              //   icon: Icon(
              //     Icons.table_chart_sharp,
              //     color: Theme.of(context).colorScheme.primary,
              //   ),
              //   tooltip: "Share as csv",
              // ),
              IconButton(
                onPressed: () => createPdf(), 
                icon: Icon(
                  Icons.picture_as_pdf,
                  color: Theme.of(context).colorScheme.primary,
                ),
                tooltip: "Save Pdf",
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
                const ReportHeader(),
                ReportPopulationData(
                  populationDataList: widget.populationDataList, 
                  pieChart: pieChart, 
                  viewList: viewList
                ),
      
                const SizedBox(height: 42,),
      
                ReportData(
                  dataList: widget.dataList, 
                  pieChart: pieChart, 
                  viewList: viewList
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void createPdf() async{
    setState(() {
      creatingPdf = true;
    });
    await reportMethods.createPdf(
      populationDataList: widget.populationDataList, 
      dataList: widget.dataList,
      context: context,
      pieChart: pieChart,
      viewList: viewList
    );
    setState(() {
      creatingPdf = false;
    });
  }
}