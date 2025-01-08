import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mksc/model/laundry_data.dart';
import 'package:mksc/model/laundry_machine.dart';
import 'package:mksc/services/handle_exception.dart';
import 'package:mksc/services/laundry/laundry_machine_services.dart';

class LaundryMachineProvider with ChangeNotifier {
  
  List<LaundryMachine> _laundryMachineList = [];

  List<LaundryData> _laundryDataList = [];

  List<LaundryMachine> get laundryMachineList => _laundryMachineList;
  
  List<LaundryData> get laundryDataList => _laundryDataList;

  Future<void> fetchLaundryMachines({required String camp}) async{
    try {
      final List<LaundryMachine> fetchedLaundryMachines = await LaundryMachineServices.getLaundryMachines(camp: camp);
      if (fetchedLaundryMachines.isNotEmpty) {
        _laundryMachineList.clear();
        _laundryMachineList = fetchedLaundryMachines;
      }
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Sorry, unable to fetch Laundry Machine, please try again later or check your network connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    }
  }

  Future<void> getLaundryDataByDate({required String camp, required String date}) async{
    try {
      final List<LaundryData> fetchedLaundryData = await LaundryMachineServices.getLaundryDataByDate(camp: camp, date: date);
      _laundryDataList.clear();
      _laundryDataList = fetchedLaundryData;
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Sorry, unable to fetch Laundry Data, please try again later or check your network connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    }
  }

  Future<void> editLaundryDataByDate(
    BuildContext context,
    {
      required String camp, 
      required String circle,
      required String token,
      required String machineType,
      required int id,
    }
  ) async{
    try {
      final LaundryData newData = await LaundryMachineServices.editLaundryDataByDate(context, camp: camp, circle: circle, token: token, machineType: machineType, id: id);
      final index = _laundryDataList.indexWhere((data) => data.id == newData.id);
      if (index != -1) {
        _laundryDataList[index] = newData;
      }
      notifyListeners();
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "LaundryMachineProvider.editLaundryDataByDate"
      );
    }
  }

  Future<void> saveLaundryDataByDate(
    BuildContext context,
    {
      required String camp, 
      required String circle,
      required String token,
      required String machineType,
      required String date,
    }
  ) async{
    try {
      final LaundryData newData = await LaundryMachineServices.saveLaundryDataByDate(context, camp: camp, circle: circle, token: token, machineType: machineType, date: date);
      newData.id == 0 ? null : _laundryDataList.add(newData);
      notifyListeners();
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "LaundryMachineProvider.saveLaundryDataByDate"
      );
    }
  }
  
}