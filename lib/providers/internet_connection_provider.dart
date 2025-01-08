import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class InternetConnectionProvider with ChangeNotifier {
  bool _isConnected = false;
  Timer? _timer;

  bool get isConnected => _isConnected;

  InternetConnectionProvider() {
    // Start checking connectivity when the provider is initialized
    checkConnectivityStatus();
  }

  // This method will start a timer that checks the internet connection every 300 milliseconds
  void checkConnectivityStatus() {
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) async {
      bool isConnected = await _checkInternetConnection();
      // If there's a change in connection status, update the UI
      if (isConnected != _isConnected) {
        _isConnected = isConnected;
        notifyListeners();
      }
    });
  }

  // This method should be called when you no longer need to check connectivity (e.g., when the app is closed)
  void stopChecking() {
    _timer?.cancel();
  }
  

  @override
  void dispose() {
    stopChecking(); // Ensure the timer is stopped when the provider is disposed
    super.dispose();
  }

  Future<bool> _checkInternetConnection() async{
    try {
      final List<InternetAddress> lookupResults = await InternetAddress.lookup('youtube.com');

      // for (var lookup in lookupResults) {
      //   debugPrint("\n👉 Look UP : \tAddress : \t${lookup.address}");
      //   debugPrint("\n👉 Look UP : \tHost : \t${lookup.host}");
      //   debugPrint("\n👉 Look UP : \tIs Lick Local : \t${lookup.isLinkLocal}");
      //   debugPrint("\n👉 Look UP : \tIs Loop Back : \t${lookup.isLoopback}");
      //   debugPrint("\n👉 Look UP : \tIs Multi Cast  : \t${lookup.isMulticast}");
      //   debugPrint("\n👉 Look UP : \tRaw Address  : \t${lookup.rawAddress}");
      //   debugPrint("\n👉 Look UP : \tType  : \t${lookup.type}");
      // }

      if (lookupResults.isNotEmpty && lookupResults[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    } 
  }
}
