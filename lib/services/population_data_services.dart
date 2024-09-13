import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/data.dart';
import 'package:mksc/model/population_data.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/widgets/custom_alert.dart';

class PopulationDataServices {

  static Future<List<PopulationData>> fetchPopulationData(BuildContext context) async{
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
      return List<PopulationData>.empty(); 
    } else {
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
        debugPrint("\n\n\nError fetching Population Data: \nPopulationDataServices@fetchPopulationData\n$e\n\n\n");
        if(!context.mounted) return List<PopulationData>.empty();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occurred during authentication')),
        );
        rethrow;        
      }
    }
  }



  static Future<List<PopulationData>> fetchPopulationDataByDate(String date, BuildContext context) async{
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
      return List<PopulationData>.empty(); 
    } else {
      Map<String, dynamic> dataJSON = {
        "date" : date,
      };
      try {
        final response = await http.post(
          Uri.parse('https://nethub.co.tz/demo/api/v2/ChickenHouseDataDate'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(dataJSON),
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

  static Future<List<Data>> fetchTodayData(BuildContext context) async{    
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
      return List<Data>.empty();
    }

    try {
      
      final response = await http.get(
        Uri.parse('https://nethub.co.tz/demo/api/v2/chicken/House/today'),
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
        final List<dynamic> dataList = responseData['data'];
        debugPrint("\n\n\nPopulation Data $dataList");

        final List<Data>  fetchedData = dataList.map((data) => Data.fromJson(data)).toList();
        return fetchedData;
      } else if(response.statusCode == 508 && context.mounted){
        CustomAlert.showAlert(context, "508 Error", "Resource Limit Is Reached");
        return List<Data>.empty();
      } else {
        return List<Data>.empty();
      }
    } catch (e) {
      debugPrint("\n\n\nError fetching Population Data: $e\n\n\n");
      if(!context.mounted) return List<Data>.empty();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during authentication')),
      );
      rethrow;        
    }
  }

  static Future<Data> saveData(BuildContext context, {required String item, required int number}) async{
    
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
      return Data.empty(); 
    }
    
    Map<String, dynamic> dataJSON = {
      "item" : item,
      "number" : number,
    };

    try {

      final response = await http.post(
        Uri.parse('https://nethub.co.tz/demo/api/v2/chickenHouse'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dataJSON),
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
        final Data data = Data.fromJson(responseData['data']);

        if(context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Saved Successfull"), backgroundColor: Colors.green,)
          );
        }

        return data;
      } else {
        if(!context.mounted) return Data.empty(); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Saving '$number' $item was unSuccessfull:\n${response.statusCode} : ${json.decode(response.body)['error']}"), backgroundColor: Colors.red,)
        );
      }

    } catch (e) {
      debugPrint("\n\n\nError saving data: $e\n\n\n");
      if(!context.mounted) return Data.empty(); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during saving data')),
      );
      rethrow;        
    }
    return Data.empty();
  }
}