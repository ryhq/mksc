import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mksc/model/population_data.dart';
import 'package:http/http.dart' as http;

class PopulationDataServices {

  static Future<List<PopulationData>> fetchPopulationData(BuildContext context) async{
    try {
      final response = await http.get(
        Uri.parse('https://nethub.co.tz/demo/api/v2/chickenHouse'),
      );

      debugPrint("Response status code ${response.statusCode}");
      debugPrint("Response body ${response.body}");
      debugPrint("Response bodyBytes ${response.bodyBytes}");
      debugPrint("Response contentLength ${response.contentLength}");
      debugPrint("Response isRedirect ${response.isRedirect}");
      debugPrint("Response persistentConnection ${response.persistentConnection}");
      debugPrint("Response reasonPhrase ${response.reasonPhrase}");

      if (response.statusCode == 200) {  
        final Map<String, dynamic> responseData = json.decode(response.body);
        debugPrint("\n\n\nData $responseData");
        // Extract the populationData list
        final List<dynamic> populationDataList = responseData['populationData'];
        debugPrint("\n\n\nPopulation Data $populationDataList");

        final List<PopulationData>  fetchedPopulationData = populationDataList.map((data) => PopulationData.fromJson(data)).toList();
        return fetchedPopulationData;
      } else {
        return List<PopulationData>.empty();
      }
    } catch (e) {
      debugPrint("\n\n\nError fetching Population Data: $e\n\n\n");
      if(!context.mounted) return List<PopulationData>.empty();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during authentication')),
      );
      rethrow;        
    }
  }
}