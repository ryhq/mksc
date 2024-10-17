import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:http/http.dart' as http;
import 'package:mksc/services/handle_exception.dart';
import 'package:mksc/services/mksc_urls.dart';
import 'package:mksc/services/vegetable_local_data_services.dart';

class VegetablesServices {

  static Future<List<Vegetable>> fetchVegetableData(BuildContext context) async{
    
    // Check for network connection and internet access
    bool isConnected = await HandleException.checkConnectionAndInternet(context);
   
    if (!isConnected) {
      return List<Vegetable>.empty();
    }

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

        debugPrint("\n\n\n...............................Fetched Vegetable Data From Server...............................");
        
        for (var veg in fetchedData) {
          debugPrint("\n ️‍🔥️ Name : ${veg.name} number : ${veg.number} image : ${veg.image}");
        }

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

  static Future<List<Vegetable>> fetchTodayVegetableData(
    BuildContext context,
    {
      required String token, 
      required String date,
    }
  ) async{
    
    // Check for network connection and internet access
    bool isConnected = await HandleException.checkConnectionAndInternet(context);
   
    if (!isConnected) {
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

      if (response.statusCode == 200) {

        final responseBody = response.body;

        final Map<String, dynamic> responseData = json.decode(responseBody);

        final List<dynamic> dataList = responseData['data'];

        final List<Vegetable>  fetchedData = dataList.map((data) => Vegetable.fromJson(data)).toList();

        debugPrint("\n\n\n...............................Fetched Today Vegetable Data From Server...............................");
        
        for (var veg in fetchedData) {
          debugPrint("\n ️‍🔥️ Name : ${veg.name} number : ${veg.number} image : ${veg.image}");
        }

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

  static Future<List<Vegetable>> fetchVegetableData7Days(BuildContext context,) async{
    
    // Check for network connection and internet access
    bool isConnected = await HandleException.checkConnectionAndInternet(context);
   
    if (!isConnected) {
      return List<Vegetable>.empty();
    }

    try {
      
      final response = await http.get(Uri.parse(MKSCUrls.vegetabl7DayseUrl));

      if (response.statusCode == 200) {

        final responseBody = response.body;

        final Map<String, dynamic> responseData = json.decode(responseBody);

        final List<dynamic> dataList = responseData['data'];

        final List<Vegetable> fetchedData = dataList.map((data) => Vegetable.fromJson(data)).toList();

        debugPrint("\n\n\n...............................Fetched Vegetable Data From Server...............................");
        
        for (var veg in fetchedData) {
          debugPrint("\n ️‍🔥️ Name : ${veg.name} number : ${veg.number} image : ${veg.image}");
        }

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

  static Future<Vegetable> editVegetableData(
    BuildContext context,
    {
      required String token, 
      required String number,
      required String unit,
      required int id,
    }
  ) async{
    
    // Check for network connection and internet access
    bool isConnected = await HandleException.checkConnectionAndInternet(context);
   
    if (!isConnected) {
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
    
    // Check for network connection and internet access
    bool isConnected = await HandleException.checkConnectionAndInternetWithToast();
   
    if (!isConnected) {
      if(!context.mounted) return Vegetable.empty();
      await VegetableLocalDataServices.saveVegetableData(context, number: number, unit: unit, date: date, item: item);
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
        
      } else {
        if(!context.mounted) return Vegetable.empty();
        VegetableLocalDataServices.saveVegetableData(context, number: number, unit: unit, date: date, item: item);
        if(!context.mounted) return Vegetable.empty(); 
        HandleException.handleHttpError(
          context: context, 
          statusCode: response.statusCode, 
          responseBody: response.body
        );
      }
      
    } on Exception catch (exception) {
      if(!context.mounted) return Vegetable.empty();
      VegetableLocalDataServices.saveVegetableData(context, number: number, unit: unit, date: date, item: item);
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