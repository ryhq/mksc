import 'package:flutter/material.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:mksc/services/chicken_house_data_services.dart';
import 'package:mksc/widgets/custom_alert.dart';


class ChickenHouseDataProvider with ChangeNotifier {
  List<ChickenHouseData> _chickenHouseDataList = [];

  List<ChickenHouseData> get chickenHouseDataList => _chickenHouseDataList;

  
  Future<void> fetchChickenHouseData (
    BuildContext context, 
    {
      required String token, 
      required String date,
    }
  ) async{
    try {
      final List<ChickenHouseData> fetchedData = await ChickenHouseDataServices.fetchChickenHouseData(context, token: token, date: date);
      _chickenHouseDataList = fetchedData;
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Failed to load today chicken house data: \n\n${e.toString()}");      
    }
  }
  
  Future<void> saveChickenHouseData(BuildContext context, {required String item, required int number, required String token, required String date}) async{
    try {
      ChickenHouseData newData = await ChickenHouseDataServices.saveChickenHouseData(context, item: item, number: number, token: token, date: date);
      newData.id == 0 ? null : _chickenHouseDataList.add(newData);
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Failed to save chicken house data: ${e.toString()}");      
    }
  }
  
  Future<void> editChickenHouseData(BuildContext context, {required String item, required int number, required String token, required int id}) async{
    try {
      ChickenHouseData newData = await ChickenHouseDataServices.editChickenHouseData(context, item: item, number: number, token: token, id: id);

      final index = _chickenHouseDataList.indexWhere((data) => data.id == newData.id);
      if (index != -1) {
        _chickenHouseDataList[index] = newData;
      }
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Failed to update chicken house data: ${e.toString()}");      
    }
  }
}