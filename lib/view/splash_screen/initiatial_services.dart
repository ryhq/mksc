import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class InitiatialServices {

  Future<List<ConnectivityResult>> checkConnectivity() async{

    List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      Fluttertoast.showToast(
        msg: "You're on the move with Mobile Data!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0 
      );  
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      Fluttertoast.showToast(
        msg: "Connected to WiFi – surf away!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      Fluttertoast.showToast(
        msg: "Hardwired! Ethernet is strong and steady.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      Fluttertoast.showToast(
        msg: "Safe and secure: VPN connection active.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      Fluttertoast.showToast(
        msg: "Connected via Bluetooth – short-range, but sweet!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      Fluttertoast.showToast(
        msg: "You're online, but it's an unusual connection.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      Fluttertoast.showToast(
        msg: "Oops! You're currently offline.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    }

    return connectivityResult;
  }
}