import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mksc/helper/database_helper.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:mksc/provider/chicken_house_data_provider.dart';
import 'package:mksc/services/handle_exception.dart';
import 'package:mksc/services/mksc_urls.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqlite_api.dart';

class ChickenHouseLocalDataServices {

  static Future<int> fetchChickenHouseDataStatus() async {
    try {
      Database mksc = await DatabaseHelper.database;
      List<Map<String, dynamic>> data = await mksc.query(
        'ChickenHouse',
      );
      List<ChickenHouseData> list = data.map((data) => ChickenHouseData.fromJson(data)).toList();
      return list.length;
    } catch (e) {
      return 0;
    }
  }

  static Future<List<ChickenHouseData>> fetchChickenHouseData(
    BuildContext context, {
    required String date,
  }) async {
    try {
      await Provider.of<ChickenHouseDataProvider>(context, listen: false).fetchChickenHouseDataStatus();
      Database mksc = await DatabaseHelper.database;
      List<Map<String, dynamic>> data = await mksc.query(
        'ChickenHouse',
        where: 'created_at = ? ',
        whereArgs: [
          date,
        ],
        orderBy: 'created_at ASC',
      );
      debugPrint("\n\n\n$data");
      List<ChickenHouseData> list = data.map((data) => ChickenHouseData.fromJson(data)).toList();
      return list;
    } on Exception catch (exception) {
      if (!context.mounted) return List<ChickenHouseData>.empty();
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "ChickenHouseLocalDataServices.fetchChickenHouseData"
      );
    }
    return List<ChickenHouseData>.empty();
  }

  static Future<List<ChickenHouseData>> fetchChickenHouseAllData(BuildContext context) async {
    try {
      await Provider.of<ChickenHouseDataProvider>(context, listen: false).fetchChickenHouseDataStatus();
      Database mksc = await DatabaseHelper.database;
      List<Map<String, dynamic>> data = await mksc.query(
        'ChickenHouse',
        orderBy: 'created_at ASC',
      );
      List<ChickenHouseData> list = data.map((data) => ChickenHouseData.fromJson(data)).toList();
      return list;
    }on Exception catch (exception) {
      if (!context.mounted) return List<ChickenHouseData>.empty();
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "ChickenHouseLocalDataServices.fetchChickenHouseData"
      );
    }
    return List<ChickenHouseData>.empty();
  }
  
  static Future<void> uploadData(
    BuildContext context, {
    required ChickenHouseData chickenHouseData,
    required String token,
    required String date,
  }) async {
    // Check for network connection and internet access
    bool _internetConnection = await HandleException.checkConnectionAndInternetWithToast();

    if (!_internetConnection) {
      return;
    }

    try {
      if (!context.mounted) return;
      // Uploading data  to the server
      await _uploadChickenHouseData(context, chickenHouseData: chickenHouseData, token: token, date : date);
      if (!context.mounted) return;
      // After uploading we delete the data from the local storage.
      await deleteChickenHouseData(
        context,
        chickenHouseData: chickenHouseData,
      );

      if (!context.mounted) return;
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Successfully Uploaded ${chickenHouseData.item}'),
      //     backgroundColor: Colors.green,
      //     duration: const Duration(seconds: 1),
      //   ),
      // );
      await Provider.of<ChickenHouseDataProvider>(context, listen: false).fetchChickenHouseDataStatus();
    } on Exception catch (e) {
      if (!context.mounted) return;
      // Handle any other types of exceptions
      HandleException.handleExceptions(
        exception: e, 
        context: context, 
        location: "ChickenHouseLocalDataServices.uploadData"
      );
      debugPrint("\n\n\nError : \n\n${e.toString()}\n@ChickenHouseLocalDataServices.fetchChickenHouseData");
      await Provider.of<ChickenHouseDataProvider>(context, listen: false).fetchChickenHouseDataStatus();
      rethrow;
    }
  }

  static Future<void> saveChickenHouseData(BuildContext context,
      {required String item, required int number, required String date}) async {
    try {
      Database mksc = await DatabaseHelper.database;
      await mksc.insert('ChickenHouse', {
        "item": item,
        "number": number,
        "created_at": date,
      });
      if (!context.mounted) return;
      await Provider.of<ChickenHouseDataProvider>(context, listen: false).fetchChickenHouseDataStatus();
    } on Exception catch  (e) {
      if (!context.mounted) return;
      // Handle any other types of exceptions
      HandleException.handleExceptions(
        exception: e, 
        context: context, 
        location: "ChickenHouseLocalDataServices.saveChickenHouseData"
      );
    }
  }

  static Future<void> editChickenHouseData(
    BuildContext context, {
    required ChickenHouseData chickenHouseData,
    required int number,
  }) async {
    Map<String, dynamic> json = {
      "item": chickenHouseData.item,
      "number": number,
      "updatedAt": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    };

    debugPrint("\n\n\n$json");
    try {
      Database mksc = await DatabaseHelper.database;
      await mksc.update(
        'ChickenHouse',
        json,
        where: 'id = ? AND created_at = ?',
        whereArgs: [chickenHouseData.id, chickenHouseData.created_at],
      );
    } on Exception catch  (e) {
      if (!context.mounted) return;
      // Handle any other types of exceptions
      HandleException.handleExceptions(
        exception: e, 
        context: context, 
        location: "ChickenHouseLocalDataServices.editChickenHouseData"
      );
    }
  }

  static Future<void> deleteChickenHouseData(
    BuildContext context, {
    required ChickenHouseData chickenHouseData,
  }) async {
    try {
      Database mksc = await DatabaseHelper.database;
      await mksc.delete(
        'ChickenHouse',
        where: 'id = ? AND created_at = ?',
        whereArgs: [chickenHouseData.id, chickenHouseData.created_at],
      );
      if (!context.mounted) return;
      await Provider.of<ChickenHouseDataProvider>(context, listen: false).fetchChickenHouseDataStatus();
    } on Exception catch  (e) {
      if (!context.mounted) return;
      // Handle any other types of exceptions
      HandleException.handleExceptions(
        exception: e, 
        context: context, 
        location: "ChickenHouseLocalDataServices.deleteChickenHouseData"
      );
    }
  }

  static Future<void> _uploadChickenHouseData(
    BuildContext context, 
    {
      required ChickenHouseData chickenHouseData, 
      required String token,
      required String date,
    }
  ) async{
    // Check for network connection and internet access
    bool isConnected = await HandleException.checkConnectionAndInternetWithToast();

    if (!isConnected) {
      return;
    }
    
    Map<String, dynamic> dataJSON = {
      "item" : chickenHouseData.item,
      "number" : chickenHouseData.number,
      'token': token,
      'date': date,
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

      if (response.statusCode == 200) {  

        final responseBody = response.body;

        if (responseBody.isNotEmpty){

          try {
            final Map<String, dynamic> responseData = json.decode(responseBody);
            if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic>) {
              // final ChickenHouseData data = ChickenHouseData.fromJson(responseData['data']);
              // if (context.mounted) {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(content: Text("Successfully Uploaded ${data.number} ${data.item}"), backgroundColor: Colors.green,)
              //   );
              // }
              return;
            } else {
              throw const FormatException("Invalid 'data' field format");
            }
          } catch (e) {
            debugPrint("Error decoding response data: $e");
            throw FormatException("Failed to decode response body: $responseBody");
          }
        } else {
          // if (context.mounted) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text("An error occured while decoding response"), backgroundColor: Colors.orange,)
          //   );
          // }
        }
      } else {
        if(!context.mounted) return;
        HandleException.handleHttpError(
          context: context, 
          statusCode: response.statusCode, 
          responseBody: response.body
        );
      }

    } on Exception catch (exception) {
      HandleException.handleExceptionsWithToast(
        exception: exception, 
        location: "ChickenHouseLocalDataServices._uploadChickenHouseData"
      );
    }
  }
}
