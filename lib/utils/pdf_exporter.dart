import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mksc/model/population_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfExporter {
  Future<void> exportPdf(List<PopulationData> populationDataList) async{
    final pdf = pw.Document();  // Create a PDF document
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                "Population Data"
              ),
              pw.SizedBox(height: 20)
            ]
          );
        },
      )
    );
    // Save PDF file to device
    final output = await getExternalStorageDirectories(type: StorageDirectory.documents);
    final file = File("${output?[0].path}/PopulationData.pdf");
    await file.writeAsBytes(await pdf.save());
    debugPrint("PDF Saved to: ${file.path}");
  }

  List<String> extractUniqueMonths(List<PopulationData> populationDataList) {
    final Set<String> uniqueMonths = {};
    for (var data in populationDataList) {
      uniqueMonths.add(data.month); 
    }
    return uniqueMonths.toList();
  }
}