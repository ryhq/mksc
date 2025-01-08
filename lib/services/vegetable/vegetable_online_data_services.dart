import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/services/handle_exception.dart';
import 'package:mksc/services/mksc_urls.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/services/vegetable/vegetable_local_data_services.dart';


class VegetableOnlineDataServices {
  
  static Future<List<Vegetable>> fetchVegetableData({required BuildContext context}) async{
    try {
      final response = await http.get(
        Uri.parse(MKSCUrls.vegetableUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final Map<String, dynamic> responseData = json.decode(responseBody);
        final List<dynamic> dataList = responseData['data'];
        final List<Vegetable>  fetchedData = dataList.map((data) => Vegetable.fromJson(data)).toList();
        return fetchedData;
      } else {
        if(!context.mounted) return List<Vegetable>.empty();
        HandleException.handleHttpError(
          context: context, 
          statusCode: response.statusCode, 
          responseBody: response.body
        );
      }
    }on Exception catch (exception) {
      if(!context.mounted) return List<Vegetable>.empty();
      HandleException.handleExceptionsWithToast(
        exception: exception, 
        location: "VegetablesServices.fetchVegetableData"
      );
      rethrow;        
    }
    return List<Vegetable>.empty();
  }

  static Future<List<Vegetable>> fetchVegetableDataByDate(
    {
      required BuildContext context,
      required String token, 
      required String date,
    }
  ) async{
    try {
      final response = await http.post(
        Uri.parse(MKSCUrls.availablevegetableUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'date': date,})
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        final Map<String, dynamic> responseData = json.decode(responseBody);
        final List<dynamic> dataList = responseData['data'];
        final List<Vegetable>  fetchedData = dataList.map((data) => Vegetable.fromJson(data)).toList();
  
        return fetchedData;
      } else {
        if(!context.mounted) return List<Vegetable>.empty();
        HandleException.handleHttpError(
          context: context, 
          statusCode: response.statusCode, 
          responseBody: response.body
        );
      }
    } on Exception catch (exception) {
      if(!context.mounted) return List<Vegetable>.empty();
      HandleException.handleExceptionsWithToast(
        exception: exception, 
        location: "VegetablesServices.fetchTodayVegetableData"
      );
      rethrow;        
    }
    return List<Vegetable>.empty();
  }


  static Future<List<Vegetable>> fetchVegetableData7Days({required BuildContext context}) async{
    try {
      final response = await http.get(Uri.parse(MKSCUrls.vegetabl7DayseUrl));
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final Map<String, dynamic> responseData = json.decode(responseBody);
        final List<dynamic> dataList = responseData['data'];
        final List<Vegetable> fetchedData = dataList.map((data) => Vegetable.fromJson(data)).toList();
        return fetchedData;
      } else {
        if(!context.mounted) return List<Vegetable>.empty();
        HandleException.handleHttpError(
          context: context, 
          statusCode: response.statusCode, 
          responseBody: response.body
        );
      }
    } on Exception catch (exception) {
      if(!context.mounted) return List<Vegetable>.empty();
      HandleException.handleExceptionsWithToast(
        exception: exception, 
        location: "VegetablesServices.fetchVegetableData7Days"
      );
      rethrow;        
    }
    return List<Vegetable>.empty();
  }

  static Future<Vegetable> saveVegetableData({
    required BuildContext context,
    required String token,
    required String number,
    required String unit,
    required String date,
    required String item,
  }) async {
    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(MKSCUrls.savevegetableUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'number': number,
          'unit': unit,
          'date': date,
          'item': item,
        }),
      );

      if (response.statusCode == 200) {
        // Parse response body
        final responseBody = response.body;
        if (responseBody.isEmpty) {
          throw const FormatException("Response body is empty");
        }

        final Map<String, dynamic> responseData = json.decode(responseBody);

        if (responseData.containsKey('data')) {
          if (responseData['data'] is List) {
            // Handle case where 'data' is a list
            final List<Vegetable> vegetables = (
              responseData['data'] as List
            ).map(
              (item) => Vegetable.fromJson(item)
            ).toList();
            if (vegetables.isNotEmpty) {
              _showSuccessMessage(context, "${vegetables[0].name} is successfully saved");
              return vegetables.first; // Return the first item if needed
            }
          } else if (responseData['data'] is Map<String, dynamic>) {
            // Handle case where 'data' is a single object
            final Vegetable vegetable = Vegetable.fromJson(responseData['data']);
            _showSuccessMessage(context, "Saved Successfully");
            return vegetable;
          } else {
            throw const FormatException("Invalid 'data' field format");
          }
        } else {
          throw const FormatException("Missing 'data' field");
        }
      } else {
        // Handle non-200 status codes
        return await _handleErrorResponse(
          context: context,
          token: token,
          number: number,
          unit: unit,
          date: date,
          item: item,
          response: response,
        );
      }
    } on Exception catch (exception) {
      // Handle exceptions gracefully
      return await _handleException(
        context: context,
        number: number,
        unit: unit,
        date: date,
        item: item,
        exception: exception,
      );
    }
    return Vegetable.empty();
  }

  static Future<Vegetable> uploadVegetableData({
    required BuildContext context,
    required String token,
    required String number,
    required String unit,
    required String date,
    required String item,
  }) async {
    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(MKSCUrls.savevegetableUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'number': number,
          'unit': unit,
          'date': date,
          'item': item,
        }),
      );

      if (response.statusCode == 200) {
        // Parse response body
        final responseBody = response.body;
        if (responseBody.isEmpty) {
          throw const FormatException("Response body is empty");
        }

        final Map<String, dynamic> responseData = json.decode(responseBody);

        if (responseData.containsKey('data')) {
          if (responseData['data'] is List) {
            // Handle case where 'data' is a list
            final List<Vegetable> vegetables = (
              responseData['data'] as List
            ).map(
              (item) => Vegetable.fromJson(item)
            ).toList();
            if (vegetables.isNotEmpty) {
              _showSuccessMessage(context, "${vegetables[0].name} is successfully saved");
              return vegetables.first; // Return the first item if needed
            }
          } else if (responseData['data'] is Map<String, dynamic>) {
            // Handle case where 'data' is a single object
            final Vegetable vegetable = Vegetable.fromJson(responseData['data']);
            _showSuccessMessage(context, "Saved Successfully");
            return vegetable;
          } else {
            throw const FormatException("Invalid 'data' field format");
          }
        } else {
          throw const FormatException("Missing 'data' field");
        }
      } else {
        // Handle non-200 status codes
        return Vegetable.empty();
      }
    } on Exception catch (exception) {
      // Handle exceptions gracefully
      HandleException.handleExceptions(
        context: context,
        exception: exception,
        location: "VegetableServices.saveVegetableData",
      );
    }
    return Vegetable.empty();
  }

  static Future<Vegetable> _handleErrorResponse({
    required BuildContext context,
    required String token,
    required String number,
    required String unit,
    required String date,
    required String item,
    required http.Response response,
  }) async {
    if (context.mounted) {
      HandleException.handleHttpError(
        context: context,
        statusCode: response.statusCode,
        responseBody: response.body,
      );

      await VegetableLocalDataServices.saveVegetableData(
        context: context,
        number: number,
        unit: unit,
        date: date,
        item: item,
      );

      _showWarningMessage(context, "$item saved locally. Sync later.");
    }

    return Vegetable.empty();
  }

  static Future<Vegetable> _handleException({
    required BuildContext context,
    required String number,
    required String unit,
    required String date,
    required String item,
    required Exception exception,
  }) async {
    if (context.mounted) {
      HandleException.handleExceptions(
        context: context,
        exception: exception,
        location: "VegetableServices.saveVegetableData",
      );

      await VegetableLocalDataServices.saveVegetableData(
        context: context,
        number: number,
        unit: unit,
        date: date,
        item: item,
      );

      _showWarningMessage(context, "$item saved locally. Sync later.");
    }

    return Vegetable.empty();
  }

  static void _showSuccessMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  static void _showWarningMessage(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }


  static Future<Vegetable> editVegetableData(
    {
      required BuildContext context,
      required Vegetable vegetable,
      required String token, 
      required String number,
      required String unit,
    }
  ) async{
    try {
      final response = await http.patch(
        Uri.parse("${MKSCUrls.updateVegetableDataUrl}/${vegetable.tempId}"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'number': number, 'unit': unit})
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
        HandleException.handleHttpError(
          context: context, 
          statusCode: response.statusCode, 
          responseBody: response.body
        );
      }
    } on Exception catch (exception) {
      debugPrint("\n\n\nError fetching Population Data: $exception\n\n\n");
      if(!context.mounted) return Vegetable.empty();
      HandleException.handleExceptionsWithToast(
        exception: exception, 
        location: "VegetablesServices.fetchVegetableData"
      );
      rethrow;         
    }
    return Vegetable.empty();
  }
}