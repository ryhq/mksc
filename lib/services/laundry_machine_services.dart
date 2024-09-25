import 'dart:convert';

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
  
  static Future<List<LaundryData>> editLaundryDataByDate({
    required String camp, 
    required String circle,
    required String token,
    required String machineType,
    required int id,
  }) async{
    final response = await http.post(
      Uri.parse("${MKSCUrls.updateLaundryDataUrl}/$id"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode({'camp': camp, 'circle': circle, 'token': token, 'machineType': machineType,})
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
}