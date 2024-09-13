import 'package:flutter/material.dart';
import 'package:mksc/model/data.dart';
import 'package:mksc/model/population_data.dart';
import 'package:mksc/services/population_data_services.dart';
import 'package:mksc/utils/pdf_exporter.dart';
import 'package:mksc/widgets/custom_alert.dart';

class DataProvider with ChangeNotifier {
  List<Data> _dataList = [];

  List<PopulationData> _populationDataList = [];

  final List<String> _categories = [];

  List<Data> get dataList => _dataList;
  
  List<PopulationData> get populationData => _populationDataList;

  List<String> get categories => _categories;

  List<Data> filteredData(List<String> selectedCategories){
    if (selectedCategories.isEmpty) {
      return _dataList;
    } else {
      return _dataList.where((data) => selectedCategories.contains(data.item.toLowerCase())).toList();
    }
  }  
  
  List<PopulationData> filteredPopulationData (List<String> selectedCategories){
    if (selectedCategories.isEmpty) {
      return _populationDataList;
    } else {
      return _populationDataList.where((populationData) => selectedCategories.contains(populationData.item.toLowerCase())).toList();
    }
  }

  
  Future<void> fetchTodayData (BuildContext context) async{
    try {
      final List<Data> fetchedData = await PopulationDataServices.fetchTodayData(context);
      fetchedData.isEmpty ? null : _dataList = fetchedData;
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Failed to load today data: ${e.toString()}");      
    }
  }
  
  Future<void> saveData(BuildContext context, {required String item, required int number}) async{
    try {
      Data newData = await PopulationDataServices.saveData(context, item: item, number: number);
      newData.id == 0 ? null : _dataList.add(newData);
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Failed to load today data: ${e.toString()}");      
    }
  }

  Future<void> fetchPopulationData (BuildContext context) async{
    try {
      final List<PopulationData> fetchedPopulationData = await PopulationDataServices.fetchPopulationData(context);
      fetchedPopulationData.isEmpty ? null : _populationDataList = fetchedPopulationData;
      if (fetchedPopulationData.isNotEmpty) {
        _categories.clear();
        for (var populationData in fetchedPopulationData) {
          _categories.contains(populationData.item.toLowerCase()) ? null : _categories.add(populationData.item);
        }
      }
      PdfExporter pdfExporter = PdfExporter();
      pdfExporter.exportPdf(_populationDataList,);
      
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Failed to load population data: \nDataProvider@fetchPopulationData\n${e.toString()}");      
    }
  }
}