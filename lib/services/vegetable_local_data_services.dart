import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mksc/helper/database_helper.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/provider/vegetable_provider.dart';
import 'package:mksc/services/handle_exception.dart';
import 'package:mksc/services/mksc_urls.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:http/http.dart' as http;

class VegetableLocalDataServices {
  
  static Future<void> saveVegetableBaseData(
    {
      required Vegetable vegetable,
    }
  ) async {
    try {
      Database mksc = await DatabaseHelper.database;
      await mksc.insert(
        'BaseVegeTable', 
        {
          "name": vegetable.name,
          "image": vegetable.image
        }
      );
    } catch (e) {
      debugPrint("Failed to save Vegetable ${vegetable.name}");
    }
  }
  
  static Future<void> deleteAllVegetableBaseData() async {
    try {
      Database mksc = await DatabaseHelper.database;
      await mksc.delete('BaseVegeTable',);
    } catch (e) {
      debugPrint("Failed to delete Vegetable data");
    }
  }

  static Future<List<Vegetable>> fetchVegetableBaseData(BuildContext context,) async {
    try {
      Database mksc = await DatabaseHelper.database;
      List<Map<String, dynamic>> data = await mksc.query(
        'BaseVegeTable',
        // orderBy: 'name ASC',
      );
      List<Vegetable> list = data.map((data) => Vegetable.fromJson(data)).toList();
      return list;
    } on Exception catch  (e) {
      if (!context.mounted) return List<Vegetable>.empty();
      // Handle any other types of exceptions
      HandleException.handleExceptions(
        exception: e, 
        context: context, 
        location: "VegetableLocalDataServices.fetchVegetableBaseData"
      );
    }
    return List<Vegetable>.empty();
  }

  static Future<int> fetchVegetableDataStatus() async {
    try {
      Database mksc = await DatabaseHelper.database;
      List<Map<String, dynamic>> data = await mksc.query(
        'VegeTable',
      );
      List<Vegetable> list = data.map((data) => Vegetable.fromJson(data)).toList();
      return list.length;
    } catch (e) {
      return 0;
    }
  }

  static Future<List<Vegetable>> fetchVegetableData(
    BuildContext context, {
    required String date,
  }) async {
    try {
      await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataStatus();
      Database mksc = await DatabaseHelper.database;
      List<Map<String, dynamic>> data = await mksc.query(
        'VegeTable',
        where: 'created_at = ? ',
        whereArgs: [
          date,
        ],
        orderBy: 'created_at ASC',
      );
      List<Vegetable> list = data.map((data) => Vegetable.fromJson(data)).toList();

      debugPrint("\n\n\n...............................Fetched Today Vegetable Data From Local Storage...............................");
      
      for (var veg in list) {
        debugPrint("\n ️‍🔥️ Id : ${veg.id} Name : ${veg.name} number : ${veg.number} created at : ${veg.created_at}");
      }

      return list;
    } on Exception catch  (e) {
      if (!context.mounted) return List<Vegetable>.empty();
      // Handle any other types of exceptions
      HandleException.handleExceptions(
        exception: e, 
        context: context, 
        location: "VegetableLocalDataServices.fetchVegetableData"
      );
      await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataStatus();
      return List<Vegetable>.empty();
    }
  }

  static Future<List<Vegetable>> fetchVegetableAllData(BuildContext context) async {
    try {
      await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataStatus();
      Database mksc = await DatabaseHelper.database;
      List<Map<String, dynamic>> data = await mksc.query(
        'VegeTable',
        orderBy: 'created_at ASC',
      );
      List<Vegetable> list = data.map((data) => Vegetable.fromJson(data)).toList();
      return list;
    }  on Exception catch  (e) {
      if (!context.mounted) return List<Vegetable>.empty();
      // Handle any other types of exceptions
      HandleException.handleExceptions(
        exception: e, 
        context: context, 
        location: "VegetableLocalDataServices.fetchVegetableAllData"
      );
      await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataStatus();
      return List<Vegetable>.empty();
    }
  }
  
  static Future<void> saveVegetableData(
    BuildContext context,
    {
      required String number,
      required String unit,
      required String date,
      required String item,
    }
  ) async {
    try {
      Database mksc = await DatabaseHelper.database;
      await mksc.insert(
        'Vegetable', 
        {
          "name": item,
          "number": number,
          "unit": unit,
          "created_at": date,
        }
      );
      if (!context.mounted) return;
      await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataStatus();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully saved $number $item offline'),
          backgroundColor: Colors.green,
        ),
      );
    } on Exception catch  (e) {
      if (!context.mounted) return;
      // Handle any other types of exceptions
      HandleException.handleExceptions(
        exception: e, 
        context: context, 
        location: "VegetableLocalDataServices.saveVegetableData"
      );
      await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataStatus();
    }
  }
  
  static Future<void> editVegetableData(
    BuildContext context,
    {
      required Vegetable vegetable,
      required String number,
      required String unit,
    }
  ) async {
    try {
      Database mksc = await DatabaseHelper.database;
      await mksc.update(
        'Vegetable', 
        {
          "name": vegetable.name,
          "number": number,
          "unit": unit,
          "updatedAt": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        },
        where: 'id = ? AND created_at = ?',
        whereArgs: [vegetable.id, vegetable.created_at],
      );

      if (!context.mounted) return;
      await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataStatus();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully updated ${vegetable.name} to $number $unit offline'),
          backgroundColor: Colors.green,
        ),
      );
    } on Exception catch  (e) {
      if (!context.mounted) return;
      // Handle any other types of exceptions
      HandleException.handleExceptions(
        exception: e, 
        context: context, 
        location: "VegetableLocalDataServices.editVegetableData"
      );
      await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataStatus();
    }
  }

  static Future<void> deleteVegetableData(
    BuildContext context, {
    required Vegetable vegetable,
  }) async {
    try {
      Database mksc = await DatabaseHelper.database;

      debugPrint("\n\n\n ️‍🔥️ Trying to delete ${vegetable.name} with ${vegetable.id} as ID created at ${vegetable.created_at}");
      await mksc.delete(
        'Vegetable',
        where: 'id = ? AND created_at = ?',
        whereArgs: [vegetable.id, vegetable.created_at],
      );
      if (!context.mounted) return;
      await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataStatus();
    } on Exception catch  (e) {
      if (!context.mounted) return;
      // Handle any other types of exceptions
      HandleException.handleExceptions(
        exception: e, 
        context: context, 
        location: "VegetableLocalDataServices.deleteVegetableData"
      );
      await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataStatus();
    }
  }

  static Future<void> uploadData(
    BuildContext context, {
    required Vegetable vegetable,
    required String token,
    required String date,
  }) async {
    // Check for network connection and internet access
    bool internetConnection = await HandleException.checkConnectionAndInternetWithToast();
    
    if (!internetConnection) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.red, content: Text("Network Error\nSorry, you do not have active internet connection, kindly check your internet connection and try again."))
      );
      return;
    }

    try {
      if (!context.mounted) return;
      // Uploading data  to the server
      await _uploadVegetableData(context, vegetable: vegetable, token: token, date : date);
      if (!context.mounted) return;
      // After uploading we delete the data from the local storage.
      await deleteVegetableData(
        context,
        vegetable: vegetable,
      );
      await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataStatus();
    }on Exception catch  (e) {
      if (!context.mounted) return;
      // Handle any other types of exceptions
      HandleException.handleExceptions(
        exception: e, 
        context: context, 
        location: "VegetableLocalDataServices.uploadData"
      );
      await Provider.of<VegetableProvider>(context, listen: false).fetchVegetableDataStatus();
    }
  }
  
  static Future<void> _uploadVegetableData(BuildContext context, {required Vegetable vegetable, required String token, required String date}) async{

    // Check for network connection and internet access
    bool isConnected = await HandleException.checkConnectionAndInternetWithToast();

    if (!isConnected) {
      return;
    }
    
    Map<String, dynamic> dataJSON = {
      "item" : vegetable.name,
      "number" : vegetable.number,
      "unit" : vegetable.unit,
      'token': token,
      'date': date,
    };

    try {

      final response = await http.post(
        Uri.parse(MKSCUrls.savevegetableUrl),
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
            if (responseData.containsKey('data')) {
              if (responseData['data'] is List) {
                // Map the list of items to List<Vegetable>
                final List<Vegetable> vegetables = (responseData['data'] as List).map((item) => Vegetable.fromJson(item)).toList();

                if (vegetables.isNotEmpty) {
                  final Vegetable firstVegetable = vegetables.first;

                  debugPrint("Response data: ${firstVegetable.toJson()}");

                  // if (context.mounted) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text("Successfully Uploaded ${firstVegetable.number} ${firstVegetable.name}"), backgroundColor: Colors.green,)
                  //   );
                  // }
                }
              } else if (responseData['data'] is Map<String, dynamic>) {
                // Handle the case where 'data' is a single object
                final Vegetable data = Vegetable.fromJson(responseData['data']);

                debugPrint("Response data: ${data.toJson()}");

                if (context.mounted) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text("Successfully Uploaded ${data.number} ${data.name}"), backgroundColor: Colors.green,)
                  // );
                }
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
        location: "VegetableLocalDataServices._uploadVegetableData"
      );
    }
  }
}