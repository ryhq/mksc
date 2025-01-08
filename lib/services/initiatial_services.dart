import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InitiatialServices {

  Future<List<ConnectivityResult>> checkConnectivity() async{
    List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult;
  }

  Future<bool> checkInternetConnectionBool() async{
    try {
      final List<InternetAddress> lookupResults = await InternetAddress.lookup('mkscportal.co.tz');
      if (lookupResults.isNotEmpty && lookupResults[0].rawAddress.isNotEmpty) {
        if (!kIsWeb && Platform.isLinux){
          debugPrint("Internet Connection is available");
          return true;
        }
        // Fluttertoast.showToast(
        //   msg: "Internet Connection is available",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        //   timeInSecForIosWeb: 1,
        //   backgroundColor: Colors.green,
        //   textColor: Colors.white,
        //   fontSize: 16.0
        // ); 
        return true;
      } else {
        if (!kIsWeb && Platform.isLinux){
          debugPrint("Internet Connection is not available",);
          return false;
        }
        Fluttertoast.showToast(
          msg: "Internet Connection is not available",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
        return false;
      }
    } catch (e) {
      if (!kIsWeb && Platform.isLinux){
        debugPrint("An error occured while trying to reach the internet. Please check you connection.",);
        return false;
      }
      Fluttertoast.showToast(
        msg: "An error occured while trying to reach the internet. Please check you connection.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      return false;
    } 
  }
}