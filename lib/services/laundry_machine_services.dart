import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mksc/model/laundry_data.dart';
import 'package:mksc/model/laundry_machine.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/services/mksc_urls.dart';


class LaundryMachineServices {
  
  static Future<List<LaundryMachine>> getLaundryMachines({required String camp}) async{
    final response = await http.post(
      Uri.parse(MKSCUrls.machineSize),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'camp': camp})
    );
    debugPrint("\n\n\n👉👉👉Response status code ${response.statusCode}");
    debugPrint("\n\n\n👉👉👉Response body ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      List<LaundryMachine> laundryMachines = data.map((machine) => LaundryMachine.fromJson(machine)).toList();
      return laundryMachines;
    } else {
      return List<LaundryMachine>.empty();
    }
  }
  
  static Future<List<LaundryData>> getLaundryDataByDate({required String camp, required String date}) async{
    final response = await http.post(
      Uri.parse(MKSCUrls.laundryDataDate),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'camp': camp, 'date': date})
    );
    debugPrint("\n\n\n👉👉👉Response status code ${response.statusCode}");
    debugPrint("\n\n\n👉👉👉Response body ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      
      final List<dynamic> dataList = responseData['data'];

      final List<LaundryData>  fetchedData = dataList.map((data) => LaundryData.fromJson(data)).toList();

      return fetchedData;
    } else {
      return List<LaundryData>.empty();
    }
  }
  
  static Future<LaundryData> editLaundryDataByDate(
    BuildContext context,
    {
    required String camp, 
    required String circle,
    required String token,
    required String machineType,
    required int id,
  }) async{
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
      return LaundryData.empty(); 
    }
    try {
      final response = await http.patch(
        Uri.parse("${MKSCUrls.updateLaundryDataUrl}/$id"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'camp': camp, 'circle': circle, 'machineType': machineType,})
      );
      debugPrint("\n\n\n👉👉👉Response status code ${response.statusCode}");
      debugPrint("\n\n\n👉👉👉Response body ${response.body}");

      if (response.statusCode == 200) {
        
        final responseBody = response.body;

        if (responseBody.isNotEmpty) {
          try {
            
            final Map<String, dynamic> responseData = json.decode(responseBody);
            
            if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic>) {
              final LaundryData data = LaundryData.fromJson(responseData['data']);

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
              SnackBar(content: Text("Updating to '$machineType' $circle was unsuccessful:\n${response.statusCode} : ${json.decode(response.body)['error']}"), backgroundColor: Colors.red,)
            );
          }
        }
      } else {
        if(!context.mounted) return LaundryData.empty(); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Updating to '$machineType' $circle was unSuccessfull:\n${response.statusCode} : ${json.decode(response.body)['error']}"), backgroundColor: Colors.red,)
        );
      }
    } catch (e) {
      debugPrint("\n\n\nError saving data: $e\n\n\n");
      if(!context.mounted) return LaundryData.empty(); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during updating Laundry Data')),
      );
      rethrow;        
    }
    return LaundryData.empty();
  }
  
  static Future<LaundryData> saveLaundryDataByDate(
    BuildContext context,
    {
    required String camp, 
    required String circle,
    required String token,
    required String machineType,
    required String date,
  }) async{
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none) && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please check your connection and try again.')),
      );
      return LaundryData.empty(); 
    }
    try {
      final response = await http.post(
        Uri.parse(MKSCUrls.storeLaundryDataUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'camp': camp, 'circle': circle, 'machineType': machineType, 'date': date})
      );
      debugPrint("\n\n\n👉👉👉Response status code ${response.statusCode}");
      debugPrint("\n\n\n👉👉👉Response body ${response.body}");

      if (response.statusCode == 200) {
        
        final responseBody = response.body;

        if (responseBody.isNotEmpty) {
          try {
            
            final Map<String, dynamic> responseData = json.decode(responseBody);
            
            if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic>) {
              final LaundryData data = LaundryData.fromJson(responseData['data']);

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
              SnackBar(content: Text("Saving '$machineType' $circle was unsuccessful:\n${response.statusCode} : ${json.decode(response.body)['error']}"), backgroundColor: Colors.red,)
            );
          }
        }
      } else {
        if(!context.mounted) return LaundryData.empty(); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Saving '$machineType' $circle was unSuccessfull:\n${response.statusCode} : ${json.decode(response.body)['error']}"), backgroundColor: Colors.red,)
        );
      }
    } catch (e) {
      debugPrint("\n\n\nError saving data: $e\n\n\n");
      if(!context.mounted) return LaundryData.empty(); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred during saving Laundry Data')),
      );
      rethrow;        
    }
    return LaundryData.empty();
  }
}