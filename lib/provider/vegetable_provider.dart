import 'package:flutter/cupertino.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/services/vegetables_services.dart';
import 'package:mksc/widgets/custom_alert.dart';

class VegetableProvider with ChangeNotifier{
  List<Vegetable> _vegetableDataList = [];

  List<Vegetable> get vegetableDataList => _vegetableDataList;
  
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
}