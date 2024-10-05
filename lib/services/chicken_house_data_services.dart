import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/provider/chicken_house_data_provider.dart';
import 'package:mksc/services/handle_exception.dart';
import 'package:mksc/services/mksc_urls.dart';
import 'package:mksc/widgets/custom_alert.dart';
import 'package:provider/provider.dart';

class ChickenHouseDataServices {

  static Future<List<ChickenHouseData>> fetchChickenHouseData(
    BuildContext context, 
    {
      required String token, 
      required String date,
    }
  ) async{    

    // Check for network connection and internet access
    bool isConnected = await HandleException.checkConnectionAndInternetWithToast();

    if (!isConnected) {
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

      } else {
        if(!context.mounted) return List<ChickenHouseData>.empty();
        HandleException.handleHttpError(
          context: context, 
          statusCode: response.statusCode, 
          responseBody: response.body
        );
        return List<ChickenHouseData>.empty();
      }
    } on Exception catch (exception) {
      if(!context.mounted) return List<ChickenHouseData>.empty();
      HandleException.handleExceptions(context: context, exception: exception, location: "ChickenHouseDataServices.fetchChickenHouseData");
      return List<ChickenHouseData>.empty();
    }
  }

  static Future<ChickenHouseData> saveChickenHouseData(BuildContext context, {required String item, required int number, required String token, required String date}) async{
    
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
                  SnackBar(content: Text("Successfully saved ${data.number} ${data.item}"), backgroundColor: Colors.green,)
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
              const SnackBar(content: Text("An error occured while decoding response"), backgroundColor: Colors.orange,)
            );
          }
        }
      } else {

        if(!context.mounted) return ChickenHouseData.empty(); 
        HandleException.handleHttpError(
          context: context, 
          statusCode: response.statusCode, 
          responseBody: response.body
        );

        await Provider.of<ChickenHouseDataProvider>(context, listen: false).saveChickenHouseDataToLocal(
          context,
          item: item,
          number: number,
          date: date
        );
        CustomAlert.showAlert(context, "Support", "An error occured, currently the $item is saved locally, you may sync later.");

        return ChickenHouseData.empty(); 
      }

    } on Exception catch (exception) {

      if(!context.mounted) return ChickenHouseData.empty();
      HandleException.handleExceptions(context: context, exception: exception, location: "ChickenHouseDataServices.saveChickenHouseData");

      await Provider.of<ChickenHouseDataProvider>(context, listen: false).saveChickenHouseDataToLocal(
        context,
        item: item,
        number: number,
        date: date
      );
      CustomAlert.showAlert(context, "Support", "An error occured, currently the $item is saved locally, you may sync later.");
      return ChickenHouseData.empty();
    }
    return ChickenHouseData.empty();
  }

  static Future<ChickenHouseData> editChickenHouseData(BuildContext context, {required String item, required int number, required String token, required int id,}) async{
  
    // Check for network connection and internet access
    bool isConnected = await HandleException.checkConnectionAndInternetWithToast();

    if (!isConnected) {
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
                  SnackBar(content: Text("Successfully Updated ${data.item} quantity to ${data.number}"), backgroundColor: Colors.green,)
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
              const SnackBar(content: Text("An error occured while decoding response"), backgroundColor: Colors.orange,)
            );
          }
        }
      } else {

        if(!context.mounted) return ChickenHouseData.empty(); 
        HandleException.handleHttpError(
          context: context, 
          statusCode: response.statusCode, 
          responseBody: response.body
        );
        return ChickenHouseData.empty(); 
      }
    } on Exception catch (exception) {
      if(!context.mounted) return ChickenHouseData.empty();
      HandleException.handleExceptions(context: context, exception: exception, location: "ChickenHouseDataServices.saveChickenHouseData");
      return ChickenHouseData.empty();
    }
    return ChickenHouseData.empty();
  }
}