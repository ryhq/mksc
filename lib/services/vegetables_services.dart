import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/services/mksc_urls.dart';
import 'package:mksc/widgets/custom_alert.dart';

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

  static Future<List<Vegetable>> fetchTodayVegetableData(
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
      return List<Vegetable>.empty();
    }

    try {
      
      final response = await http.post(
        Uri.parse(MKSCUrls.availablevegetableUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'date': date, 'token': token})
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

  static Future<Vegetable> editVegetableData(
    BuildContext context,
    {
      required String token, 
      required String number,
      required String unit,
      required int id,
    }
  ) async{
    
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
      return Vegetable.empty();
    }

    try {
      
      final response = await http.patch(
        Uri.parse("${MKSCUrls.updateVegetableDataUrl}/$id"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'number': number, 'token': token, 'unit': unit})
      );

      debugPrint("\n\n\nResponse status code ${response.statusCode}");
      debugPrint("\n\n\nResponse body ${response.body}");


      if (response.statusCode == 200) {

        final responseBody = response.body;

        if (responseBody.isNotEmpty){

          try {
            final Map<String, dynamic> responseData = json.decode(responseBody);

            if (responseData.containsKey('data')) {
              if (responseData['data'] is List) {
                // Map the list of items to List<Vegetable>
                final List<Vegetable> vegetables = (responseData['data'] as List).map((item) => Vegetable.fromJson(item)).toList();

                if (vegetables.isNotEmpty) {
                  final Vegetable firstVegetable = vegetables.first;

                  debugPrint("Response data: ${firstVegetable.toJson()}");

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Update was Successfully"), backgroundColor: Colors.green,)
                    );
                  }

                  return firstVegetable;
                }
              } else if (responseData['data'] is Map<String, dynamic>) {
                // Handle the case where 'data' is a single object
                final Vegetable data = Vegetable.fromJson(responseData['data']);

                debugPrint("Response data: ${data.toJson()}");

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Update was Successfully"), backgroundColor: Colors.green,)
                  );
                }

                return data;
              } else {
                throw const FormatException("Invalid 'data' field format");
              }
            } else {
              throw const FormatException("Missing 'data' field");
            }
          } catch (e) {
            debugPrint("Error decoding response data: $e");
            throw FormatException("Failed to decode response body: $responseBody");
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Updating was unsuccessful:\n${response.statusCode} : ${json.decode(response.body)['error']}"), backgroundColor: Colors.red,)
            );
          }
        }
        
      } else {
        if(!context.mounted) return Vegetable.empty(); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Updating was unSuccessfull:\n${response.statusCode} : ${json.decode(response.body)['error']}"), backgroundColor: Colors.red,)
        );
      }
      
    } catch (e) {
      debugPrint("\n\n\nError fetching Population Data: $e\n\n\n");
      if(!context.mounted) return Vegetable.empty();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during authentication')),
      );
      rethrow;        
    }
    return Vegetable.empty();
  }

  static Future<Vegetable> saveVegetableData(
    BuildContext context,
    {
      required String token, 
      required String number,
      required String unit,
      required String date,
      required String item,
    }
  ) async{
    
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
      return Vegetable.empty();
    }

    try {
      
      final response = await http.post(
        Uri.parse(MKSCUrls.savevegetableUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'number': number, 'token': token, 'unit': unit, 'date' : date, 'item' : item})
      );

      debugPrint("\n\n\nResponse status code ${response.statusCode}");
      debugPrint("\n\n\nResponse body ${response.body}");


      if (response.statusCode == 200) {

        final responseBody = response.body;

        if (responseBody.isNotEmpty){

          try {
            final Map<String, dynamic> responseData = json.decode(responseBody);

            if (responseData.containsKey('data')) {
              if (responseData['data'] is List) {
                // Map the list of items to List<Vegetable>
                final List<Vegetable> vegetables = (responseData['data'] as List).map((item) => Vegetable.fromJson(item)).toList();

                if (vegetables.isNotEmpty) {
                  final Vegetable firstVegetable = vegetables.first;

                  debugPrint("Response data: ${firstVegetable.toJson()}");

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Saved Successfully"), backgroundColor: Colors.green,)
                    );
                  }

                  return firstVegetable;
                }
              } else if (responseData['data'] is Map<String, dynamic>) {
                // Handle the case where 'data' is a single object
                final Vegetable data = Vegetable.fromJson(responseData['data']);

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
            } else {
              throw const FormatException("Missing 'data' field");
            }

          } catch (e) {
            debugPrint("Error decoding response data: $e");
            throw FormatException("Failed to decode response body: $responseBody");
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Saved was unsuccessful:\n${response.statusCode} : ${json.decode(response.body)['error']}"), backgroundColor: Colors.red,)
            );
          }
        }
        
      } else if(response.statusCode == 422){
        if(!context.mounted) return Vegetable.empty(); 
        CustomAlert.showAlert(context, "Error 422", "The unit field is required.");
      }  else {
        if(!context.mounted) return Vegetable.empty(); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Saved was unSuccessfull:\n${response.statusCode} : ${json.decode(response.body)['error']}"), backgroundColor: Colors.red,)
        );
      }
      
    } catch (e) {
      debugPrint("\n\n\nError fetching Population Data: $e\n\n\n");
      if(!context.mounted) return Vegetable.empty();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during authentication')),
      );
      rethrow;        
    }
    return Vegetable.empty();
  }
}