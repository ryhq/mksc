import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/services/mksc_urls.dart';

class VegetablesServices {
  static Future<List<Vegetable>> fetchVegetableData(BuildContext context) async{
    
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
      return List<Vegetable>.empty();
    }

    try {
      
      final response = await http.get(
        Uri.parse(MKSCUrls.vegetableUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      debugPrint("\n\n\nResponse status code ${response.statusCode}");
      debugPrint("\n\n\nResponse body ${response.body}");

      if (response.statusCode == 200) {

        final responseBody = response.body;

        final Map<String, dynamic> responseData = json.decode(responseBody);


        final List<dynamic> dataList = responseData['data'];

        final List<Vegetable>  fetchedData = dataList.map((data) => Vegetable.fromJson(data)).toList();

        return fetchedData;
        
      } else {
        return List<Vegetable>.empty();
      }
      
    } catch (e) {
      debugPrint("\n\n\nError fetching Population Data: $e\n\n\n");
      if(!context.mounted) return List<Vegetable>.empty();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during authentication')),
      );
      rethrow;        
    }

  }
}