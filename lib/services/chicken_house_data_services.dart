import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/services/mksc_urls.dart';
import 'package:mksc/widgets/custom_alert.dart';

class ChickenHouseDataServices {

  static Future<List<ChickenHouseData>> fetchChickenHouseData(
    BuildContext context, 
    {
      required String token, 
      required String date,
    }
  ) async{    
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
      return List<ChickenHouseData>.empty();
    }

    try {
      
      final response = await http.post(
        Uri.parse(MKSCUrls.chickenToDayUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'date': date, 'token': token}),
      );

      debugPrint("Response status code ${response.statusCode}");

      if (response.statusCode == 200) {  
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        final List<dynamic> dataList = responseData['data'];

        final List<ChickenHouseData>  fetchedData = dataList.map((data) => ChickenHouseData.fromJson(data)).toList();

        return fetchedData;

      } else if(response.statusCode == 508 && context.mounted){
        CustomAlert.showAlert(context, "508 Error", "Resource Limit Is Reached");
        return List<ChickenHouseData>.empty();
      } else {
        return List<ChickenHouseData>.empty();
      }
    } catch (e) {
      debugPrint("\n\n\nError fetching Population Data: $e\n\n\n");
      if(!context.mounted) return List<ChickenHouseData>.empty();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during authentication')),
      );
      rethrow;        
    }
  }

  static Future<ChickenHouseData> saveChickenHouseData(BuildContext context, {required String item, required int number, required String token, required String date}) async{
    
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
      return ChickenHouseData.empty(); 
    }
    
    Map<String, dynamic> dataJSON = {
      "item" : item,
      "number" : number,
      'token': token,
      'date': date
    };

    try {

      final response = await http.post(
        Uri.parse(MKSCUrls.chickenUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(dataJSON),
      );

      debugPrint("\n\n\nResponse status code ${response.statusCode}");
      debugPrint("\n\n\nResponse body ${response.body}");

      if (response.statusCode == 200) {  

        final responseBody = response.body;

        if (responseBody.isNotEmpty){

          try {
            final Map<String, dynamic> responseData = json.decode(responseBody);

            if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic>) {
              final ChickenHouseData data = ChickenHouseData.fromJson(responseData['data']);

              debugPrint("Response data: ${data.toJson()}");

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Saved Successfully"), backgroundColor: Colors.green,)
                );
              }

              return data;

            } else {
              throw const FormatException("Invalid 'data' field format");
            }
          } catch (e) {
            debugPrint("Error decoding response data: $e");
            throw FormatException("Failed to decode response body: $responseBody");
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Saving '$number' $item was unsuccessful:\n${response.statusCode} : ${json.decode(response.body)['error']}"), backgroundColor: Colors.red,)
            );
          }
        }
      } else {
        if(!context.mounted) return ChickenHouseData.empty(); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Saving '$number' $item was unSuccessfull:\n${response.statusCode} : ${json.decode(response.body)['error']}"), backgroundColor: Colors.red,)
        );
      }

    } catch (e) {
      debugPrint("\n\n\nError saving data: $e\n\n\n");
      if(!context.mounted) return ChickenHouseData.empty(); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during saving Chicken House Data')),
      );
      rethrow;        
    }
    return ChickenHouseData.empty();
  }

  static Future<ChickenHouseData> editChickenHouseData(BuildContext context, {required String item, required int number, required String token, required int id,}) async{
    
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
      return ChickenHouseData.empty(); 
    }
    
    Map<String, dynamic> dataJSON = {
      "item" : item,
      "number" : number,
      'token': token,
    };

    try {

      final response = await http.patch(
        Uri.parse("${MKSCUrls.chickenUrl}/$id"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(dataJSON),
      );

      debugPrint("\n\n\nResponse status code ${response.statusCode}");
      debugPrint("\n\n\nResponse body ${response.body}");

      if (response.statusCode == 200) {  

        final responseBody = response.body;

        if (responseBody.isNotEmpty){

          try {
            final Map<String, dynamic> responseData = json.decode(responseBody);

            if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic>) {
              final ChickenHouseData data = ChickenHouseData.fromJson(responseData['data']);

              debugPrint("Response data: ${data.toJson()}");

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Update Successfully"), backgroundColor: Colors.green,)
                );
              }

              return data;

            } else {
              throw const FormatException("Invalid 'data' field format");
            }
          } catch (e) {
            debugPrint("Error decoding response data: $e");
            throw FormatException("Failed to decode response body: $responseBody");
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Updating '$number' $item was unsuccessful:\n${response.statusCode} : ${json.decode(response.body)['error']}"), backgroundColor: Colors.red,)
            );
          }
        }
      } else {
        if(!context.mounted) return ChickenHouseData.empty(); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Updating '$number' $item was unSuccessfull:\n${response.statusCode} : ${json.decode(response.body)['error']}"), backgroundColor: Colors.red,)
        );
      }

    } catch (e) {
      debugPrint("\n\n\nError saving data: $e\n\n\n");
      if(!context.mounted) return ChickenHouseData.empty(); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during saving Chicken House Data')),
      );
      rethrow;        
    }
    return ChickenHouseData.empty();
  }
}