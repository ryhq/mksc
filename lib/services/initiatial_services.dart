import 'dart:io';

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
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );  
    }

    return connectivityResult;
  }

  Future<List<InternetAddress>> checkInternetConnection() async{
    try {
      final List<InternetAddress> lookupResults = await InternetAddress.lookup('google.com');

      for (var lookup in lookupResults) {
        debugPrint("\n👉 Look UP : \tAddress : \t${lookup.address}");
        debugPrint("\n👉 Look UP : \tHost : \t${lookup.host}");
        debugPrint("\n👉 Look UP : \tIs Lick Local : \t${lookup.isLinkLocal}");
        debugPrint("\n👉 Look UP : \tIs Loop Back : \t${lookup.isLoopback}");
        debugPrint("\n👉 Look UP : \tIs Multi Cast  : \t${lookup.isMulticast}");
        debugPrint("\n👉 Look UP : \tRaw Address  : \t${lookup.rawAddress}");
        debugPrint("\n👉 Look UP : \tType  : \t${lookup.type}");
      }
      if (lookupResults.isNotEmpty && lookupResults[0].rawAddress.isNotEmpty) {
        Fluttertoast.showToast(
          msg: "Internet Connection is available",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
        ); 
        return lookupResults;
      } else {
        Fluttertoast.showToast(
          msg: "Internet Connection is not available",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
        );
        return List<InternetAddress>.empty();
      }
    } catch (e) {
      
      Fluttertoast.showToast(
        msg: "An error occured while trying to reach the internet. Please check you connection.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
      
      return List<InternetAddress>.empty();
    } 
  }

  Future<bool> checkInternetConnectionBool() async{
    try {
      final List<InternetAddress> lookupResults = await InternetAddress.lookup('youtube.com');

      for (var lookup in lookupResults) {
        debugPrint("\n👉 Look UP : \tAddress : \t${lookup.address}");
        debugPrint("\n👉 Look UP : \tHost : \t${lookup.host}");
        debugPrint("\n👉 Look UP : \tIs Lick Local : \t${lookup.isLinkLocal}");
        debugPrint("\n👉 Look UP : \tIs Loop Back : \t${lookup.isLoopback}");
        debugPrint("\n👉 Look UP : \tIs Multi Cast  : \t${lookup.isMulticast}");
        debugPrint("\n👉 Look UP : \tRaw Address  : \t${lookup.rawAddress}");
        debugPrint("\n👉 Look UP : \tType  : \t${lookup.type}");
      }

      if (lookupResults.isNotEmpty && lookupResults[0].rawAddress.isNotEmpty) {
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