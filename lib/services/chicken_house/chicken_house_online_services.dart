import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/services/chicken_house/chicken_house_local_services.dart';
import 'package:mksc/services/handle_exception.dart';
import 'package:mksc/services/mksc_urls.dart';

class ChickenHouseOnlineServices {
  static Future<List<ChickenHouseData>> fetchChickenHouseOnlineData(
    {
      required BuildContext context,
      required String token, 
      required String date,
    }
  ) async{ 
    try {
      final response = await http.post(
        Uri.parse(MKSCUrls.chickenToDayUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'date': date,}),
      );

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
      HandleException.handleExceptions(context: context, exception: exception, location: "ChickenHouseOnlineServices.fetchChickenHouseOnlineData");
      return List<ChickenHouseData>.empty();
    }
  }

  static Future<List<ChickenHouseData>> fetchChickenHouseData7Days(
    {
      required BuildContext context,
      required String token,
    }
  ) async{
    try {
      
      final response = await http.get(
        Uri.parse(MKSCUrls.chicken7DaysUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

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
      HandleException.handleExceptions(context: context, exception: exception, location: "ChickenHouseDataServices.fetchChickenHouseData7Days");
      return List<ChickenHouseData>.empty();
    }
  }

  static Future<ChickenHouseData> saveChickenHouseData({
    required BuildContext context,
    required String item,
    required int number,
    required String token,
    required String date,
  }) async {
    try {
      http.Response response = await _postSave(token, item, number, date);

      if (response.statusCode == 200) {
        if(!context.mounted) return ChickenHouseData.empty();
        return _handleSuccessResponse(context, response);
      } else {
        if(!context.mounted) return ChickenHouseData.empty();
        return await _handleErrorResponse(context, item, number, date, response);
      }
    } on Exception catch (exception) {
      return await _handleException(context, item, number, date, exception);
    }
  }

  static Future<ChickenHouseData> uploadChickenHouseData({
    required BuildContext context,
    required String item,
    required int number,
    required String token,
    required String date,
  }) async {
    try {
      http.Response response = await _postSave(token, item, number, date);

      if (response.statusCode == 200) {
        if(!context.mounted) return ChickenHouseData.empty();
        final responseBody = response.body;
        if (responseBody.isEmpty) {
          throw const FormatException("Response body is empty");
        }
        final Map<String, dynamic> responseData = json.decode(responseBody);
        if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic>) {
          final ChickenHouseData data = ChickenHouseData.fromJson(responseData['data']);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Successfully uploaded ${data.number} ${data.item} for $date"),
                backgroundColor: Colors.green,
              ),
            );
          }
          return data;
        } else {
          return ChickenHouseData.empty();
        }
      } else {
        if(!context.mounted) return ChickenHouseData.empty();
        return ChickenHouseData.empty();
      }
    } on Exception catch (exception) {
      if (context.mounted) {
        HandleException.handleExceptions(
          context: context,
          exception: exception,
          location: "ChickenHouseDataServices.uploadChickenHouseData",
        );
      }
      return ChickenHouseData.empty();
    }
  }

  static Future<http.Response> _postSave(String token, String item, int number, String date) async {
    final response = await http.post(
      Uri.parse(MKSCUrls.chickenUrl),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "item": item,
        "number": number,
        "date": date,
      }),
    );
    return response;
  }

  static ChickenHouseData _handleSuccessResponse(
    BuildContext context,
    http.Response response,
  ) {
    final responseBody = response.body;

    if (responseBody.isEmpty) {
      throw const FormatException("Response body is empty");
    }

    final Map<String, dynamic> responseData = json.decode(responseBody);

    if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic>) {
      final ChickenHouseData data = ChickenHouseData.fromJson(responseData['data']);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Successfully saved ${data.number} ${data.item}"),
            backgroundColor: Colors.green,
          ),
        );
      }

      return data;
    } else {
      throw const FormatException("Invalid 'data' field format");
    }
  }

  static Future<ChickenHouseData> _handleErrorResponse(
    BuildContext context,
    String item,
    int number,
    String date,
    http.Response response,
  ) async {
    if (context.mounted) {
      HandleException.handleHttpError(
        context: context,
        statusCode: response.statusCode,
        responseBody: response.body,
      );
    }

    await ChickenHouseLocalServices.saveChickenHouseLocalData(
      context: context,
      item: item,
      number: number,
      date: date,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$item is saved locally, you may sync later."),
          backgroundColor: Colors.orange,
        ),
      );
    }
    return ChickenHouseData.empty();
  }

  static Future<ChickenHouseData> _handleException(
    BuildContext context,
    String item,
    int number,
    String date,
    Exception exception,
  ) async {
    if (context.mounted) {
      HandleException.handleExceptions(
        context: context,
        exception: exception,
        location: "ChickenHouseDataServices.saveChickenHouseData",
      );
    }

    await ChickenHouseLocalServices.saveChickenHouseLocalData(
      context: context,
      item: item,
      number: number,
      date: date,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$item is saved locally, you may sync later."),
          backgroundColor: Colors.orange,
        ),
      );
    }
    return ChickenHouseData.empty();
  }

  static Future<ChickenHouseData> editChickenHouseData({
    required BuildContext context,
    required ChickenHouseData chickenHouseData,
    required int number, 
    required String token, 
  }) async{

    // Prepare the data for the PATCH request
    final Map<String, dynamic> dataJSON = {
      "item": chickenHouseData.item,
      "number": number,
    };

    try {

      final response = await http.patch(
        Uri.parse("${MKSCUrls.chickenUrl}/${chickenHouseData.id}"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(dataJSON),
      );

      // Handle success response
      if (response.statusCode == 200) {
        final responseBody = response.body;

        // Decode and validate the response
        if (responseBody.isNotEmpty) {
          final Map<String, dynamic> responseData = json.decode(responseBody);
          if (responseData.containsKey('data') && responseData['data'] is Map<String, dynamic>) {
            final ChickenHouseData data = ChickenHouseData.fromJson(responseData['data']);

            // Notify the user about the successful update
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Successfully updated ${data.item} quantity to ${data.number}"),
                  backgroundColor: Colors.green,
                ),
              );
            }
            return data;
          } else {
            throw const FormatException("Invalid 'data' field format");
          }
        } else {
          throw const FormatException("Response body is empty");
        }
      } else {
        if(!context.mounted) return ChickenHouseData.empty();
        // Handle HTTP errors and notify the user
        return await _handleErrorResponseForEdit(context, response);
      }
    } on Exception catch (exception) {
      if(!context.mounted) return ChickenHouseData.empty();
      
      // Handle exceptions and notify the user
      return await _handleExceptionResponseForEdit(context, exception);
    }
  }

  // Handles HTTP errors and notifies the user with a friendly message
  static Future<ChickenHouseData> _handleErrorResponseForEdit(
    BuildContext context,
    http.Response response,
  ) async {
    if (context.mounted) {
      HandleException.handleHttpError(
        context: context,
        statusCode: response.statusCode,
        responseBody: response.body,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update record. Please try again later."),
          backgroundColor: Colors.red,
        ),
      );
    }
    return ChickenHouseData.empty();
  }

  // Handles exceptions and notifies the user with a friendly message
  static Future<ChickenHouseData> _handleExceptionResponseForEdit(
    BuildContext context,
    Exception exception,
  ) async {
    if (context.mounted) {
      HandleException.handleExceptions(
        context: context,
        exception: exception,
        location: "ChickenHouseDataServices.editChickenHouseData",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("An error occurred while updating. Please check your connection."),
          backgroundColor: Colors.red,
        ),
      );
    }
    return ChickenHouseData.empty();
  }

}