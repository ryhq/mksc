import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mksc/model/camp.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/services/mksc_urls.dart';

class CampServices {

  static Future<List<Camp>>  getCamps() async{
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
      return List<Camp>.empty();
    }
  }
}