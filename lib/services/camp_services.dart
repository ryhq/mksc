import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mksc/model/camp.dart';
import 'package:http/http.dart' as http;
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
      debugPrint("\n\n\n👉👉👉Response status code ${response.statusCode}");
      // debugPrint("\n\n\n👉👉👉Response body ${response.body}");
      // debugPrint("\n\n\n👉👉👉Response bodyBytes ${response.bodyBytes}");
      // debugPrint("\n\n\n👉👉👉Response contentLength ${response.contentLength}");
      // debugPrint("\n\n\n👉👉👉Response isRedirect ${response.isRedirect}");
      // debugPrint("\n\n\n👉👉👉Response persistentConnection ${response.persistentConnection}");
      // debugPrint("\n\n\n👉👉👉Response reasonPhrase ${response.reasonPhrase}");
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        List<Camp> camps = data.map((camp) => Camp.fromJson(camp)).toList();
        return camps;
      } else {
        Fluttertoast.showToast(
          msg: "Sorry, unable to fetch camps, please try again later or check your network connection\nStatus Code : ${response.statusCode}\n@CampServices.getCamps",
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