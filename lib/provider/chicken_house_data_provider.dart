import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:mksc/services/chicken_house_data_services.dart';
import 'package:mksc/services/chicken_house_local_data_services.dart';
import 'package:mksc/services/handle_exception.dart';
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

  Future<void> uploadData(BuildContext context, {required String token,}) async {
    try {
      // Check for network connection and internet access
      bool isConnected = await HandleException.checkConnectionAndInternetWithToast();

      if (!isConnected) {
        if (!context.mounted) return;
        CustomAlert.showAlert(
          context,
          "Network Error",
          "Sorry, you do not have active internet connection, kindly check your internet connection and try again."
        );
        return;
      }

      // First fetch data from the server.
      if (!context.mounted) return;
      
      List<ChickenHouseData> chickenHouseData7DaysList = await ChickenHouseDataServices.fetchChickenHouseData7Days(context);

      // Then, fetch data from the local storage.
      if (!context.mounted) return;
      List<ChickenHouseData> allLocalDataList = await ChickenHouseLocalDataServices.fetchChickenHouseAllData(context);

      // Store modified list separately to avoid concurrent modification
      List<ChickenHouseData> newLocalDataList = List.from(allLocalDataList);

      // Looping through the data to be uploaded allLocalDataList

      for (var data in allLocalDataList) {
        // If server data exists
        if (chickenHouseData7DaysList.isNotEmpty) {
          bool dataExists = false;
          // Looping to check if data already exist on the server.
          for (var chickenHouseData in chickenHouseData7DaysList) {
            // If data already exists on the server
            if (data.item == chickenHouseData.item && data.created_at == chickenHouseData.created_at) {
              if (!context.mounted) return;
              CustomAlert.showAlert(
                context,
                "Data Conflict",
                "Sorry, '${data.item}' data already exists on MKSC server, try editing the real data on '${chickenHouseData.created_at}'."
              );
              dataExists = true;
              break;
            }
          }

          // If the data does not exist on the server, upload it
          if (!dataExists) {
            if (!context.mounted) return;
            await ChickenHouseLocalDataServices.uploadData(
              context,
              chickenHouseData: data,
              token: token,
              date: data.created_at!.isEmpty ? "" : data.created_at!
            );
            if (!context.mounted) return;
            newLocalDataList = await ChickenHouseLocalDataServices.fetchChickenHouseAllData(context);
            notifyListeners();
          }
        } else {
          // If server data is not present, upload it
          if (!context.mounted) return;
          await ChickenHouseLocalDataServices.uploadData(
            context,
            chickenHouseData: data,
            token: token,
            date: data.created_at!.isEmpty ? "" : data.created_at!
          );
          if (!context.mounted) return;
          newLocalDataList = await ChickenHouseLocalDataServices.fetchChickenHouseAllData(context);
          notifyListeners();
        }
      }

      // // After loop, update the local data list
      // _chickenHouseDataLocalList = newLocalDataList;
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Error ${e.toString()}\n@ChickenHouseDataProvider.uploadData");
    }
  }

}