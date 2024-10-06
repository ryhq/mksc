import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:mksc/services/chicken_house_data_services.dart';
import 'package:mksc/services/chicken_house_local_data_services.dart';
import 'package:mksc/widgets/custom_alert.dart';


class ChickenHouseDataProvider with ChangeNotifier {

  List<ChickenHouseData> _chickenHouseDataList = [];

  List<ChickenHouseData> _chickenHouseDataLocalList = [];

  List<ChickenHouseData> get chickenHouseDataList => _chickenHouseDataList;
  
  List<ChickenHouseData> get chickenHouseDataLocalList => _chickenHouseDataLocalList;

  
  Future<void> fetchChickenHouseData (
    BuildContext context, 
    {
      required String token, 
      required String date,
    }
  ) async{
    try {
      final List<ChickenHouseData> fetchedData = await ChickenHouseDataServices.fetchChickenHouseData(context, token: token, date: date);

      if(!context.mounted) return;
      _chickenHouseDataLocalList = await ChickenHouseLocalDataServices.fetchChickenHouseData(context, date: date);
      
      _chickenHouseDataList = fetchedData;
      
      notifyListeners();

    } on SocketException catch (_) {
      // Handle network issues (e.g., no internet, DNS failures)
      debugPrint("Network error: Could not resolve hostname.");
      if (context.mounted) {
        CustomAlert.showAlert(context, "Error", "Network error: Could not reach the server. Please check your internet connection.");      
      }
    }catch (e) {
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

  /// For local Storage 
  
  Future<void> fetchChickenHouseDataFromLocal (
    BuildContext context, 
    {
      required String date,
    }
  ) async{
    try {
      final List<ChickenHouseData> fetchedData = await ChickenHouseLocalDataServices.fetchChickenHouseData(context, date: date);
      _chickenHouseDataLocalList = fetchedData;
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Error : ${e.toString()}\n@ChickenHouseDataProvider.fetchChickenHouseDataFromLocal");      
    }
  }

  void clearChickenHouseDataList(){
    _chickenHouseDataList.clear();
    notifyListeners();
  }
  
  Future<void> saveChickenHouseDataToLocal(BuildContext context, {required String item, required int number, required String date}) async{
    try {
      await ChickenHouseLocalDataServices.saveChickenHouseData(context, item: item, number: number,  date: date);
      fetchChickenHouseDataFromLocal(context, date: date);
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Failed to save chicken house data: ${e.toString()}\n@ChickenHouseDataProvider.saveChickenHouseDataToLocal");      
    }
  }


  
  Future<void> editChickenHouseDataFromLocal(BuildContext context, {required ChickenHouseData chickenHouseData, required int number, required String date}) async{
    try {
      await ChickenHouseLocalDataServices.editChickenHouseData(context, chickenHouseData: chickenHouseData, number: number,);
      fetchChickenHouseDataFromLocal(context, date: date);
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Failed to update chicken house data: ${e.toString()}\n@ChickenHouseDataProvider.editChickenHouseDataFromLocal");      
    }
  }


  
  Future<void> deleteChickenHouseData(BuildContext context, {required ChickenHouseData chickenHouseData, required String date}) async{
    try {
      await ChickenHouseLocalDataServices.deleteChickenHouseData(context, chickenHouseData: chickenHouseData,);
      if (!context.mounted) return;
      fetchChickenHouseDataFromLocal(context, date: date);
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Failed to update chicken house data: ${e.toString()}\n@ChickenHouseDataProvider.deleteChickenHouseData");      
    }
  }


  
  Future<void> uploadData(
    BuildContext context, 
    {
      required String token,
      required String date,
    }
  ) async{
    try {

      // First fetch data from the server corresponding with the date selected
      
      await fetchChickenHouseData(context, token: token, date: date);

      // We then upload the single local data at a time

      for (var data in _chickenHouseDataLocalList) {

        // If the data from the server are present

        if (_chickenHouseDataList.isNotEmpty) {

          for (var chickenHouseData in _chickenHouseDataList) {

            // If data already exist on the server

            if (data.item == chickenHouseData.item) {
              if(!context.mounted) return;
              CustomAlert.showAlert(
                context, 
                "Data Conflict", 
                "Sorry, '${data.item}' data already exist on MKSC server, try edit the real data on '$date'."
              );
              return;
            }else{
              if(!context.mounted) return;
              await ChickenHouseLocalDataServices.uploadData(
                context, 
                chickenHouseData: data, 
                token: token, 
                date: date
              );
              if(!context.mounted) return;
              _chickenHouseDataLocalList = await ChickenHouseLocalDataServices.fetchChickenHouseData(context, date: date);
              notifyListeners();
            }
          }
        }else {
          // If the data from the server are not present
          if(!context.mounted) return;
          await ChickenHouseLocalDataServices.uploadData(
            context, 
            chickenHouseData: data, 
            token: token, 
            date: date
          );
          if(!context.mounted) return;
          _chickenHouseDataLocalList = await ChickenHouseLocalDataServices.fetchChickenHouseData(context, date: date);
          notifyListeners();
        }
      }
      await fetchChickenHouseData(context, token: token, date: date);
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Error ${e.toString()}\n@ChickenHouseDataProvider.uploadData");      
    }
  }
}