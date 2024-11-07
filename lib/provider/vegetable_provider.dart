import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/services/handle_exception.dart';
import 'package:mksc/services/vegetable_local_data_services.dart';
import 'package:mksc/services/vegetables_services.dart';

class VegetableProvider with ChangeNotifier{
  
  List<Vegetable> _vegetableDataList = [];

  List<Vegetable> _localVegetableDataList = [];

  List<Vegetable> _todayVegetableDataList = [];

  int _vegetableLocalDataStatus = 0;

  List<Vegetable> get vegetableDataList => _vegetableDataList;

  List<Vegetable> get todayVegetableDataList => _todayVegetableDataList;

  int get vegetableLocalDataStatus => _vegetableLocalDataStatus;

  Future<void> fetchVegetableDataStatus() async{
    _vegetableLocalDataStatus = await VegetableLocalDataServices.fetchVegetableDataStatus();
    notifyListeners();
  }

  Future<void> fetchVegetableDataLocally(BuildContext context, {required String date,}) async{
    _localVegetableDataList = await VegetableLocalDataServices.fetchVegetableData(context, date: date);
    await fetchVegetableData(context);
    await _filterVegetableDataList();
    notifyListeners();
  }

  Future<void> fetchVegetableData (BuildContext context) async{
    try {
      final List<Vegetable> fetchedData = await VegetableLocalDataServices.fetchVegetableBaseData(context);
      _vegetableDataList = fetchedData;
      notifyListeners();
    }  on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "VegetableProvider.editLaundryDataByDate"
      );
    }
  }

  Future<void> fetchTodayVegetableData (
    BuildContext context,
    {
      required String token, 
      required String date,
    }
  ) async{
    try {
      final List<Vegetable> fetchedData = await VegetablesServices.fetchTodayVegetableData(context, token: token, date: date);
      _todayVegetableDataList = fetchedData;
      if (!context.mounted) return;
      _todayVegetableDataList.isEmpty ? await fetchVegetableData(context) : null;
      await _filterVegetableDataList();
      notifyListeners();
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "LaundryMachineProvider.fetchTodayVegetableData"
      );
    }
  }

  Future<void> editVegetableData (
    BuildContext context,
    {
      required String token, 
      required String number,
      required String unit,
      required String date,
      required int id,
    }
  ) async{
    try {
      await VegetablesServices.editVegetableData(context, token: token, number: number, unit: unit, id: id);
      if (!context.mounted) return;
      fetchTodayVegetableData(context, token: token, date: date);
      notifyListeners();
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "VegetableProvider.editVegetableData"
      );
    }
  }

  Future<void> saveVegetableData (
    BuildContext context,
    {
      required String token, 
      required String number,
      required String unit,
      required String date,
      required String item,
    }
  ) async{
    bool internet = await HandleException.checkConnectionAndInternetWithToast();
    try {
      if (!context.mounted) return;
      await VegetablesServices.saveVegetableData(context, token: token, number: number, unit: unit, date: date, item: item);
      if (!context.mounted) return;
      internet ? fetchTodayVegetableData(context, token: token, date: date) : null;
      fetchVegetableDataLocally(context, date: date);
      await _filterVegetableDataList();
      notifyListeners();
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "VegetableProvider.saveVegetableData"
      );
      // Incase of any faults, save the data locally
      await VegetableLocalDataServices.saveVegetableData(context, number: number, unit: unit, date: date, item: item);
    }
  }

  // Local Services

  // Method called during app initialization step

  Future<void> fetchVegetableBaseData(BuildContext context) async{
    List<Vegetable> vegetableList = await VegetablesServices.fetchVegetableData(context);
    
    await VegetableLocalDataServices.deleteAllVegetableBaseData();
    for (var vegetable in vegetableList) {
      await VegetableLocalDataServices.saveVegetableBaseData(vegetable: vegetable);
    }
  }

  Future<void> saveVegetableDataLocally (
    BuildContext context,
    {
      required String number,
      required String unit,
      required String date,
      required String item,
    }
  ) async{
    try {
      if (!context.mounted) return;
      await VegetableLocalDataServices.saveVegetableData(context, number: number, unit: unit, date: date, item: item);
      if (!context.mounted) return;
      fetchVegetableDataLocally(context, date: date);
      await _filterVegetableDataList();
      notifyListeners();
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "VegetableProvider.saveVegetableDataLocally"
      );
      // Incase of any faults, save the data locally
      await VegetableLocalDataServices.saveVegetableData(context, number: number, unit: unit, date: date, item: item);
    }
  }

  Future<void> editVegetableLocalData (
    BuildContext context,
    { 
      required Vegetable vegetable,
      required String number,
      required String unit,
      required String date,
    }
  ) async{
    try {
      await VegetableLocalDataServices.editVegetableData(context, vegetable: vegetable, number: number, unit: unit,);
      if (!context.mounted) return;
      await fetchVegetableDataLocally(context, date: date);
      await _filterVegetableDataList();
      notifyListeners();
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "VegetableProvider.saveVegetableDataLocally"
      );
    }
  }


  
  Future<void> deleteVegetableData(BuildContext context, {required Vegetable vegetable, required String date}) async{
    try {
      _vegetableDataList.remove(vegetable);
      notifyListeners();
      await VegetableLocalDataServices.deleteVegetableData(context, vegetable: vegetable);
      if (!context.mounted) return;
      await fetchVegetableBaseData(context);
      await _filterVegetableDataList();
      if (!context.mounted) return;
      await fetchVegetableDataLocally(context, date: date);
      await _filterVegetableDataList();
      notifyListeners();
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "VegetableProvider.deleteVegetableData"
      );
    }
  }

  Future<void> _filterVegetableDataList() async {

    for (int i = 0; i < _vegetableDataList.length; i++) {
      final vegetable = _vegetableDataList[i];

      _vegetableDataList[i] = vegetable.copyWith(
        name: _vegetableDataList[i].name.toLowerCase()
      );

      for (var index = 0; index < _todayVegetableDataList.length; index++) {
        if (
          // _todayVegetableDataList[index].name.toLowerCase() == vegetable.name.toLowerCase()
          // _todayVegetableDataList[index].name.toUpperCase() == vegetable.name.toUpperCase() ||
          _todayVegetableDataList[index].name == vegetable.name
        ) {
          _vegetableDataList[i] = vegetable.copyWith(
            tempId: _todayVegetableDataList[index].tempId,
            camp: _todayVegetableDataList[index].camp,
            number: _todayVegetableDataList[index].number,
            unit: _todayVegetableDataList[index].unit,
          );
        }
      }

      for (var index = 0; index < _localVegetableDataList.length; index++) {
        if (_localVegetableDataList[index].name == vegetable.name) {
          debugPrint("\nComparing ${_localVegetableDataList[index].name} == ${vegetable.name} : ${_localVegetableDataList[index].name == vegetable.name}");
          _vegetableDataList[i] = vegetable.copyWith(
            id: _localVegetableDataList[index].id,
            tempId: _localVegetableDataList[index].tempId,
            camp: _localVegetableDataList[index].camp,
            number: _localVegetableDataList[index].number,
            unit: _localVegetableDataList[index].unit,
            image: _localVegetableDataList[index].unit,
            created_at: _localVegetableDataList[index].created_at,
            updatedAt: _localVegetableDataList[index].updatedAt,
            offline: true
          );
        }
      }
    }
    
    // debugPrint("\n\n\nAfter Filtering\n\n\n");

    // for (var element in _vegetableDataList) {
    //   if (element.offline) {
    //     debugPrint("\nId ${element.id} Name ${element.name} Number ${element.number} Unit ${element.unit} Offline Status ${element.offline}");
    //   }
    // }

    notifyListeners();
  }

  Future<void> uploadData(BuildContext context, {required String token}) async {
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
      List<Vegetable> fetchedData = await VegetablesServices.fetchVegetableData7Days(context);

      // Then, fetch data from the local storage.
      if (!context.mounted) return;
      List<Vegetable> localVegetableData = await VegetableLocalDataServices.fetchVegetableAllData(context);

      for (var local in localVegetableData) {
        if (fetchedData.isNotEmpty) {
          bool dataExists = false;
          for (var online in fetchedData) {
            if (local.name == online.name && _formatDateTime(local.created_at!) == _formatDateTime(online.created_at!)) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Sorry, '${local.name}' data already exists on MKSC server, try editing the real data on '${_formatDateTime(online.created_at!)}'."
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 1),
                ),
              );
              dataExists = true;
              break;
            }
          }

          // If the data does not exist on the server, upload it
          if (!dataExists) {
            if (!context.mounted) return;
            await VegetableLocalDataServices.uploadData(
              context,
              vegetable: local,
              token: token,
              date: local.created_at!.isEmpty ? "" : local.created_at!
            );
            if (!context.mounted) return;
            local.created_at!.isEmpty ? null : await fetchVegetableDataLocally(context, date: local.created_at!);
            notifyListeners();
          }
        } else {
          // If server data is not present, upload it
          if (!context.mounted) return;
          await VegetableLocalDataServices.uploadData(
            context,
            vegetable: local,
            token: token,
            date: local.created_at!.isEmpty ? "" : local.created_at!
          );
          if (!context.mounted) return;
          local.created_at!.isEmpty ? null : await fetchVegetableDataLocally(context, date: local.created_at!);
          notifyListeners();
        }
      }
    }  on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "VegetableProvider.uploadData"
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
}