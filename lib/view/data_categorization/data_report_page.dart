import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mksc/model/data.dart';
import 'package:mksc/model/population_data.dart';
import 'package:mksc/provider/theme_provider.dart';
import 'package:mksc/view/data_categorization/widget/export_data_pie_chart.dart';
import 'package:mksc/view/data_categorization/widget/report_data.dart';
import 'package:mksc/view/data_categorization/widget/report_header.dart';
import 'package:mksc/view/data_categorization/widget/report_population_data.dart';
import 'package:mksc/widgets/app_pie_chart_fl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pdf/widgets.dart' as pw;

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

  List<String> extractUniqueMonths(List<PopulationData> populationDataList) {
    final Set<String> uniqueMonths = {};
    for (var data in populationDataList) {
      uniqueMonths.add(data.month); 
    }
    return uniqueMonths.toList();
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
                  createPdf(
                    populationDataList: widget.populationDataList, 
                    dataList: widget.dataList,
                    context: context,
                    pieChart: pieChart
                  );
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

  List<PopulationData> extractPopulationDataPerMonth(List<PopulationData> populationDataList, String month){
    return populationDataList.where((data) => month.toLowerCase().contains(data.month.toLowerCase())).toList();
  }

  // Helper function to generate pie charts as images
  Future<Uint8List> generatePieChart(BuildContext context, List<PopulationData> populationDataList, String month) async {

    final GlobalKey repaintBoundaryKey = GlobalKey();

    final pie = RepaintBoundary(
      key: repaintBoundaryKey,
      child: AppPieChartFl(populationDataList: populationDataList, month: month)
    );

    // Render the pie chart widget off-screen by attaching it to a BuildContext
    final BuildContext overlayContext = context;

    // Create an OverlayEntry to render the widget temporarily off-screen
    final overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Center(child: pie),
      ),
    );

    // Add the overlay entry to the overlay
    Overlay.of(overlayContext).insert(overlayEntry);

    // Wait for the widget to be fully rendered
    await Future.delayed(const Duration(milliseconds: 100));

    // Capture the image from the RepaintBoundary
    final RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);  // Adjust pixelRatio as needed
    final byteData = await image.toByteData(format: ImageByteFormat.png);

    // Remove the overlay entry after capturing the image
    overlayEntry.remove();

    return byteData!.buffer.asUint8List();
  }

  Future<Uint8List> generateDataPieChart(BuildContext context, List<Data> dataList) async {
    final GlobalKey repaintBoundaryKey = GlobalKey();
    final pie = RepaintBoundary(
      key: repaintBoundaryKey,
      child: ExportDataPieChart.exportPieChart(context, dataList)
    );
    final BuildContext overlayContext = context;
    final overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Center(child: pie),
      ),
    );
    Overlay.of(overlayContext).insert(overlayEntry);
    await Future.delayed(const Duration(milliseconds: 100));
    final RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    overlayEntry.remove();
    return byteData!.buffer.asUint8List();
  }

  Future<void> _requestStoragePermission() async {
    debugPrint("\n\n\n\nChecking Storage Permission");
    if (await Permission.storage.isGranted) {
      debugPrint("\n\n\n\nStorage Permission Status 👉️👉️👉️👉️👉️ True 🔔️🔔️🔔️");
      // Storage permission already granted
      return;
    } else {
      // Request storage permission
      debugPrint("\n\n\n\nStorage Permission Status 👉️👉️👉️👉️👉️ False 🔔️🔔️🔔️");
      await Permission.storage.request();
    }
  }

  Future<String> createFolderAndSavePdf(Uint8List pdfBytes) async {
    await _requestStoragePermission();
    Directory? directory = await getExternalStorageDirectory();

    if (directory != null) {
      // Define the folder path (Outside Android folder) and include 'MKSC'
      String path = "/storage/emulated/0/MKSC/reports"; 
      final folder = Directory(path);

      // Check if folder exists, if not, create it
      bool folderExist = await folder.exists();

      if (!folderExist) {
        debugPrint("\n\n\nCreating a folder at $path}");
        await folder.create(recursive: true); // Create the folder if it doesn't exist
      }
      debugPrint("\n\n\nFolder at 👉️👉️👉️👉️👉️ $path exists status : ${await folder.exists()}🔔️🔔️🔔️\n\n\n");

      // Save the PDF file in the MKSC folder
      File pdfFile = File('$path/report_${DateTime.now()}.pdf');
      await pdfFile.writeAsBytes(pdfBytes);

      // Return the path to the saved PDF
      return pdfFile.path;
    }

    throw Exception("Unable to find storage directory");
  }

  // Helper to load fonts
  Future<pw.Font> loadCustomFont() async {
    final fontData = await rootBundle.load('assets/fonts/roboto/Roboto-Regular.ttf');
    return pw.Font.ttf(fontData);
  }


  Future<void> createPdf({
    required List<PopulationData> populationDataList, 
    required List<Data> dataList,
    required bool pieChart,
    required BuildContext context,
  }) async {

    final pdf = pw.Document();
    Uint8List? dataPieChart;

    if(!context.mounted) return;
    var height = MediaQuery.of(context).size.height * 0.5;
    if(!context.mounted) return;
    
    final imageData = await rootBundle.load('assets/logo/MKSC_Logo.jpg');
    final imageUint8List = imageData.buffer.asUint8List();

    // Load custom font
    final ttf = await loadCustomFont();

    // Pre-generate pie chart images for all population data
    List<Uint8List> pieChartImages = [];
    if (pieChart) {
      List<String> months = extractUniqueMonths(populationDataList);
      if(!context.mounted) return;
      dataPieChart = await generateDataPieChart(context, dataList);
      for (var month in months) {
        if(!context.mounted) return;
        pieChartImages.add(await generatePieChart(context, populationDataList, month));
      }
    }

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(base: ttf),
        build: (context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Add Report Title and Date
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Center(
                    child: pw.Container(
                      width: 60, 
                      height: 60,
                      decoration: pw.BoxDecoration(
                        shape: pw.BoxShape.circle,
                        image: pw.DecorationImage(
                          image: pw.MemoryImage(imageUint8List),
                          fit: pw.BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 12.0),
                    child: pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text("MKSC Data Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                        pw.Text(DateFormat('EEEE dd, MMMM yyyy').format(DateTime.now()), style: const pw.TextStyle(fontSize: 16)),
                      ]
                    )
                  )
                ]
              ),
              
              pw.SizedBox(height: 20),

              // Add Population Data Section
              pw.Text("Population Data", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Divider(thickness: 2),

              // Add Actual Data Section
              pw.Text("Actual Data", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              
              pw.Divider(thickness: 2),

              pw.TableHelper.fromTextArray(
                headers: ['Month', 'Item', 'Total'],
                data: populationDataList.map((data) {
                  return [data.month, data.item, data.total];
                }).toList(),
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                // Customize header style
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.blue,
                ),
                cellStyle: const pw.TextStyle(
                  fontSize: 12,
                ),
                cellAlignment: pw.Alignment.center,  
                headerAlignment: pw.Alignment.center,
                cellPadding: const pw.EdgeInsets.all(5), 
                columnWidths: const {
                  0: pw.FlexColumnWidth(1),
                  1: pw.FlexColumnWidth(3),  
                  2: pw.FlexColumnWidth(1),  
                },
              ),  
              // Add pie charts if needed
              if (pieChart)...[

                pw.Divider(thickness: 2),

                pw.Text("Pie Charts per Months", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic)),
                pw.Divider(thickness: 2),
                ...List.generate(pieChartImages.length, (index) {
                  // final data = widget.populationDataList[index];
                  final pieChartImage = pieChartImages[index];
                  return pw.Column(
                    children: [
                      // pw.Text(data.month.toUpperCase(), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.Container(
                        height: height,
                        child: pw.Image(
                          pw.MemoryImage(pieChartImage),
                          fit: pw.BoxFit.cover,
                        ),
                      ),
                      pw.Divider(thickness: 1),
                    ],
                  );
                }),  
              ],
              
              pw.SizedBox(height: 20),

              // Add Population Data Section
              pw.Text("Data", style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.Divider(thickness: 2),

              // Add Actual Data Section
              pw.Text("Actual Data", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              
              pw.Divider(thickness: 2),

              pw.TableHelper.fromTextArray(
                headers: ['Item', 'Number'],
                data: dataList.map((data) {
                  return [data.item, data.number,];
                }).toList(),
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
                // Customize header style
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColors.blue,
                ),
                cellStyle: const pw.TextStyle(
                  fontSize: 12,
                ),
                cellAlignment: pw.Alignment.center,  
                headerAlignment: pw.Alignment.center,
                cellPadding: const pw.EdgeInsets.all(5), 
                columnWidths: const {
                  0: pw.FlexColumnWidth(2),
                  1: pw.FlexColumnWidth(1),  
                },
              ), 
              // Add pie charts if needed
              if (pieChart)...[

                pw.Divider(thickness: 2),

                pw.Text("Pie Charts", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic)),
                pw.Divider(thickness: 2),
                pw.Column(
                  children: [
                    pw.Container(
                      height: height,
                      child: pw.Image(
                        pw.MemoryImage(dataPieChart!),
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                    pw.Divider(thickness: 1),
                  ],
                ), 
              ],        
            ],
          ),
        ],
      ),
    );

    // Convert the PDF document to bytes
    Uint8List pdfBytes = await pdf.save();
    
    String pdfPath = await createFolderAndSavePdf(pdfBytes);

    debugPrint("PDF saved at: $pdfPath");
  }
}