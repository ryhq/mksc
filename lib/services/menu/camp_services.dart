import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/model/camp.dart';
import 'package:mksc/services/handle_exception.dart';
import 'package:mksc/services/mksc_urls.dart';

class CampServices {

  static Future<List<Camp>>  getCamps() async{
    // Check for network connection and internet access
    bool isConnected = await HandleException.checkConnectionAndInternetWithToast();

    if (!isConnected) {
      return List<Camp>.empty();
    }

    try {
      final response = await http.get(Uri.parse(MKSCUrls.getcampurl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Camp> camps = data.map((camp) => Camp.fromJson(camp)).toList();
        return camps;
      } else {
        if (!kIsWeb && Platform.isLinux){
          debugPrint("Sorry, unable to fetch camps, please try again later or check your network connection.");
          return List<Camp>.empty();
        }
        Fluttertoast.showToast(
          msg: "Sorry, unable to fetch camps, please try again later or check your network connection.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return List<Camp>.empty();
      }
    } on Exception catch (exception) {
      HandleException.handleExceptionsWithToast(exception: exception, location: "CampServices.getCamps");
      return List<Camp>.empty();
    }
  }
}