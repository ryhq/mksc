import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mksc/helper/database_helper.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:mksc/provider/chicken_house_data_provider.dart';
import 'package:mksc/services/handle_exception.dart';
import 'package:mksc/widgets/custom_alert.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';

class ChickenHouseLocalDataServices {
  static Future<bool> fetchChickenHouseDataForCard() async {
    try {
      Database mksc = await DatabaseHelper.database;
      List<Map<String, dynamic>> data = await mksc.query(
        'ChickenHouse',
      );
      List<ChickenHouseData> list =
          data.map((data) => ChickenHouseData.fromJson(data)).toList();
      return list.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<List<ChickenHouseData>> fetchChickenHouseData(
    BuildContext context, {
    required String date,
  }) async {
    try {
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
      List<ChickenHouseData> list =
          data.map((data) => ChickenHouseData.fromJson(data)).toList();
      return list;
    } catch (e) {
      if (!context.mounted) return List<ChickenHouseData>.empty();
      CustomAlert.showAlert(context, "Error",
          "Error : ${e.toString()}\n@ChickenHouseLocalDataServices.fetchChickenHouseData");
      rethrow;
    }
  }

  static Future<List<ChickenHouseData>> fetchChickenHouseAllData(BuildContext context) async {
    try {
      Database mksc = await DatabaseHelper.database;
      _printSchema(mksc, "ChickenHouse");
      List<Map<String, dynamic>> data = await mksc.query(
        'ChickenHouse',
        orderBy: 'created_at ASC',
      );
      List<ChickenHouseData> list = data.map((data) => ChickenHouseData.fromJson(data)).toList();
      return list;
    } on DatabaseException catch (e) {
      // Handle database-specific exceptions
      if (!context.mounted) return List<ChickenHouseData>.empty();
      CustomAlert.showAlert(context, "Database Error", "Failed to fetch data from the database: ${e.toString()}\nPlease try again later.");
      return List<ChickenHouseData>.empty(); // Return an empty list if an error occurs
    } on Exception catch (e) {
      // Handle any other types of exceptions
      if (!context.mounted) return List<ChickenHouseData>.empty();
      CustomAlert.showAlert(context, "Error", 
        "An unexpected error occurred: ${e.toString()}\n@ChickenHouseLocalDataServices.fetchChickenHouseData");
      return List<ChickenHouseData>.empty(); // Return an empty list if an error occurs
    }

  }

  // Method to print the schema of a specific table
  static Future<void> _printSchema(Database db, String tableName) async {
    List<Map<String, dynamic>> result = await db.rawQuery('PRAGMA table_info($tableName);');
    debugPrint('\n\n\nSchema for table $tableName:');
    for (var row in result) {
      debugPrint("\n$row\n");
    }
  }

  static Future<void> uploadData(
    BuildContext context, {
    required ChickenHouseData chickenHouseData,
    required String token,
    required String date,
  }) async {
    // Check for network connection and internet access
    bool isConnected = await HandleException.checkConnectionAndInternetWithToast();

    if (!isConnected) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Network Error", "Sorry, you do not have active internet connection, kindly check you internet connection and try again.");
      return;
    }

    try {
      if (!context.mounted) return;
      // Uploading data  to the server
      await Provider.of<ChickenHouseDataProvider>(context, listen: false).saveChickenHouseData(context,
        item: chickenHouseData.item,
        number: chickenHouseData.number,
        date: date,
        token: token
      );
      if (!context.mounted) return;
      // After uploading we delete the data from the local storage.
      await deleteChickenHouseData(
        context,
        chickenHouseData: chickenHouseData,
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully Uploaded ${chickenHouseData.item}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Error : ${e.toString()}\n@ChickenHouseLocalDataServices.fetchChickenHouseData");
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
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error",
          "Error : ${e.toString()}\n@ChickenHouseLocalDataServices.saveChickenHouseData");
      rethrow;
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
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error",
          "Error : ${e.toString()}\n@ChickenHouseLocalDataServices.editChickenHouseData");
      rethrow;
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
    } catch (e) {
      if (!context.mounted) return;
      CustomAlert.showAlert(context, "Error", "Error : ${e.toString()}\n@ChickenHouseLocalDataServices.deleteChickenHouseData");
      rethrow;
    }
  }
}
