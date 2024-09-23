import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mksc/model/camp.dart';
import 'package:mksc/services/camp_services.dart';

class CampProvider with ChangeNotifier {
  
  List<Camp> _campList = [];

  List<Camp> get campList => _campList;

  Future<void> fetchCamps() async{
    try {
      final List<Camp> fetchedCamps = await CampServices.getCamps();
      if (fetchedCamps.isNotEmpty) {
        _campList.clear();
        _campList = fetchedCamps;
      }
      notifyListeners();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Sorry, unable to fetch camps, please try again later or check your network connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    }
  }
}