import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:mksc/services/chicken_house_data_services.dart';
import 'package:mksc/services/chicken_house_local_data_services.dart';
import 'package:mksc/services/handle_exception.dart';


class ChickenHouseDataProvider with ChangeNotifier {

  List<ChickenHouseData> _chickenHouseDataList = [];

  List<ChickenHouseData> _chickenHouseDataLocalList = [];

  int _chickenHouseLocalDataStatus = 0;
 
  List<ChickenHouseData> get chickenHouseDataList => _chickenHouseDataList;
  
  List<ChickenHouseData> get chickenHouseDataLocalList => _chickenHouseDataLocalList;

  int get chickenHouseLocalDataStatus => _chickenHouseLocalDataStatus;

  Future<void> fetchChickenHouseDataStatus() async{
    _chickenHouseLocalDataStatus = await ChickenHouseLocalDataServices.fetchChickenHouseDataStatus();
    notifyListeners();
  }
  
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

    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "ChickenHouseDataProvider.fetchChickenHouseData"
      );
    }
  }
  
  Future<void> saveChickenHouseData(BuildContext context, {required String item, required int number, required String token, required String date}) async{
    try {
      ChickenHouseData newData = await ChickenHouseDataServices.saveChickenHouseData(context, item: item, number: number, token: token, date: date);
      newData.id == 0 ? null : _chickenHouseDataList.add(newData);
      notifyListeners();
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "ChickenHouseDataProvider.saveChickenHouseData"
      );
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
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "ChickenHouseDataProvider.editChickenHouseData"
      );
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
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "ChickenHouseDataProvider.fetchChickenHouseDataFromLocal"
      );
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
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "ChickenHouseDataProvider.saveChickenHouseDataToLocal"
      );
    }
  }


  
  Future<void> editChickenHouseDataFromLocal(BuildContext context, {required ChickenHouseData chickenHouseData, required int number, required String date}) async{
    try {
      await ChickenHouseLocalDataServices.editChickenHouseData(context, chickenHouseData: chickenHouseData, number: number,);
      fetchChickenHouseDataFromLocal(context, date: date);
      notifyListeners();
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "ChickenHouseDataProvider.editChickenHouseDataFromLocal"
      );
    }
  }


  
  Future<void> deleteChickenHouseData(BuildContext context, {required ChickenHouseData chickenHouseData, required String date}) async{
    try {
      await ChickenHouseLocalDataServices.deleteChickenHouseData(context, chickenHouseData: chickenHouseData,);
      if (!context.mounted) return;
      fetchChickenHouseDataFromLocal(context, date: date);
      notifyListeners();
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "ChickenHouseDataProvider.deleteChickenHouseData"
      );
    }
  }

  String _formatDateTime(String dateTimeString) {
    // Parse the server response string into a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeString);
    
    // Create a DateFormat for the desired output format
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    
    // Format the DateTime object into the desired string format
    return formatter.format(dateTime);
  }

  Future<void> uploadData(BuildContext context, {required String token,}) async {
    try {
      // Check for network connection and internet access
      bool isConnected = await HandleException.checkConnectionAndInternetWithToast();

      if (!isConnected) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.red, content: Text("Network Error\nSorry, you do not have active internet connection, kindly check your internet connection and try again."))
        );
        return;
      }

      // First fetch data from the server.
      if (!context.mounted) return;
      
      List<ChickenHouseData> chickenHouseData7DaysList = await ChickenHouseDataServices.fetchChickenHouseData7Days(
        context,
        token: token
      );

      debugPrint("\n\n\n👉👉👉.......................Fetched chicken House Data in past Seven (07) Days.......................\n\n\n");

      for (var chick in chickenHouseData7DaysList) {
        debugPrint("\nItem : ${chick.item} : Number${chick.number}");
      }

      // Then, fetch data from the local storage.
      if (!context.mounted) return;
      List<ChickenHouseData> allLocalDataList = await ChickenHouseLocalDataServices.fetchChickenHouseAllData(context);

      debugPrint("\n\n\n👉👉👉.......................All chicken House Data locally stored.......................\n\n\n");

      for (var chick in allLocalDataList) {
        debugPrint("\nItem : ${chick.item} : Number${chick.number}");
      }

      // Looping through the data to be uploaded allLocalDataList

      for (var data in allLocalDataList) {
        // If server data exists
        if (chickenHouseData7DaysList.isNotEmpty) {

          bool dataExists = false;
          // Looping to check if data already exist on the server.
          for (var chickenHouseData in chickenHouseData7DaysList) {

            debugPrint("\n\n\n 👉👉👉 Comparing ${_formatDateTime(data.created_at!)} to ${_formatDateTime(chickenHouseData.created_at!)} : ${_formatDateTime(data.created_at!) == _formatDateTime(chickenHouseData.created_at!)}");
            // If data already exists on the server
            if (data.item == chickenHouseData.item && _formatDateTime(data.created_at!) == _formatDateTime(chickenHouseData.created_at!)) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Sorry, '${data.item}' data already exists on MKSC server, try editing the real data on '${_formatDateTime(chickenHouseData.created_at!)}'."
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 1),
                ),
              );
        
              // Set isConflict to true
              // int index = _chickenHouseDataLocalList.indexOf(data);
              int index = 0;

              fetchChickenHouseDataFromLocal(context, date: data.created_at!);

              for (int i = 0; i < _chickenHouseDataLocalList.length; i++) {
                if (data.id == _chickenHouseDataList[i].id) {
                  index = i;
                }
              }

              if (index != -1) {
                _chickenHouseDataLocalList[index] = data.copyWith(isConflict: true);
              }

              // Deleting from the local storage incase of conflict

              ChickenHouseLocalDataServices.deleteChickenHouseData(
                context, chickenHouseData: data
              );

              notifyListeners();
              dataExists = true;
              return;
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
            data.created_at!.isEmpty ? null : await fetchChickenHouseDataFromLocal(context, date: data.created_at!);
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
          data.created_at!.isEmpty ? null : await fetchChickenHouseDataFromLocal(context, date: data.created_at!);
        }
      }
      notifyListeners();
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "ChickenHouseDataProvider.uploadData"
      );
    }
  }

}