import 'package:flutter/cupertino.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/services/vegetables_services.dart';
import 'package:mksc/widgets/custom_alert.dart';

class VegetableProvider with ChangeNotifier{
  List<Vegetable> _vegetableDataList = [];

  List<Vegetable> _todayVegetableDataList = [];

  List<Vegetable> get vegetableDataList => _vegetableDataList;

  List<Vegetable> get todayVegetableDataList => _todayVegetableDataList;
  
  Future<void> fetchVegetableData (BuildContext context) async{
    try {
      final List<Vegetable> fetchedData = await VegetablesServices.fetchVegetableData(context);
      _vegetableDataList = fetchedData;
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Failed to load vegetable data:2w \n\n${e.toString()}");      
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
      _todayVegetableDataList.isEmpty ? fetchVegetableData(context) : null;
      _filterVegetableDataList();
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Failed to load today vegetable data:2w \n\n${e.toString()}");      
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
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Failed to update vegetable data: \n\n${e.toString()}");      
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
    try {
      await VegetablesServices.saveVegetableData(context, token: token, number: number, unit: unit, date: date, item: item);
      if (!context.mounted) return;
      fetchTodayVegetableData(context, token: token, date: date);
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Failed to load today vegetable data:2w \n\n${e.toString()}");      
    }
  }

  void _filterVegetableDataList() {

    for (int i = 0; i < _vegetableDataList.length; i++) {
      final vegetable = _vegetableDataList[i];

      for (var index = 0; index < _todayVegetableDataList.length; index++) {
        if (_todayVegetableDataList[index].name == vegetable.name) {
          _vegetableDataList[i] = vegetable.copyWith(
            tempId: _todayVegetableDataList[index].tempId,
            camp: _todayVegetableDataList[index].camp,
            number: _todayVegetableDataList[index].number,
            unit: _todayVegetableDataList[index].unit,
          );
          debugPrint("\n\n\n 🔥️‍🔥️‍🔥️‍🔥 Edited vegetableData : \n\tCamp ${_vegetableDataList[i].camp} name ${_vegetableDataList[i].name} number${_vegetableDataList[i].number}");
        }
      }
    }

    notifyListeners();
  }


}