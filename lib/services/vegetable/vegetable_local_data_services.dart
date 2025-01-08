import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mksc/helper/database_helper.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/services/handle_exception.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class VegetableLocalDataServices {

  /// This method initializes possible vegetables from the 
  /// server for local storage feature
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
  
  /// Incase of any changes of vegetable data from the 
  /// server, then use this method to delete and re-initialize
  /// BaseVegetable
  static Future<void> deleteAllVegetableBaseData() async {
    try {
      Database mksc = await DatabaseHelper.database;
      await mksc.delete('BaseVegeTable',);
    } catch (e) {
      debugPrint("Failed to delete Vegetable data");
    }
  }

  /// Retrieves all local vegetable base data
  static Future<List<Vegetable>> fetchVegetableBaseData({required BuildContext context}) async {
    try {
      Database mksc = await DatabaseHelper.database;
      List<Map<String, dynamic>> data = await mksc.query(
        'BaseVegeTable',
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

  /// This method retrieves the number of local vegetable data
  /// That are not yet sent to the server

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

  /// This method retrieves local vegetable data by a given date
  static Future<List<Vegetable>> fetchVegetableData({
    required BuildContext context, 
    required String date,
  }) async {
    try {
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
      return list;
    } on Exception catch  (e) {
      if (!context.mounted) return List<Vegetable>.empty();
      // Handle any other types of exceptions
      HandleException.handleExceptions(
        exception: e, 
        context: context, 
        location: "VegetableLocalDataServices.fetchVegetableData"
      );
      return List<Vegetable>.empty();
    }
  }

  /// To upload data to server we need a method to retrieve
  /// all possible locally stored vegetable data, this is the method
  /// for this case
  static Future<List<Vegetable>> fetchVegetableAllData(BuildContext context) async {
    try {
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
      return List<Vegetable>.empty();
    }
  }

  static Future<void> saveVegetableData(
    {
      required BuildContext context,
      required String number,
      required String unit,
      required String date,
      required String item,
    }
  ) async {
    try {
      Database mksc = await DatabaseHelper.database;

      // Checking if the data already exists on the same date
      List<Map<String, dynamic>> data = await mksc.query(
        'VegeTable',
        where: 'created_at = ? AND name = ?',
        whereArgs: [
          date,
          item,
        ],
        orderBy: 'created_at ASC',
      );

      if (data.isNotEmpty) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$item already exists on $date'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Else proceed saving the data
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
    }
  }
  
  static Future<void> editVegetableData(
    {
      required BuildContext context,
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
        where: 'name = ? AND created_at = ?',
        whereArgs: [vegetable.name, vegetable.created_at],
      );

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
    }
  }

  static Future<void> deleteVegetableData(
    BuildContext context, {
    required Vegetable vegetable,
  }) async {
    try {
      Database mksc = await DatabaseHelper.database;
      
      await mksc.delete(
        'Vegetable',
        where: 'name = ? AND created_at = ?',
        whereArgs: [vegetable.name, vegetable.created_at],
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully deleted ${vegetable.number} ${vegetable.unit} of ${vegetable.name}.'),
          backgroundColor: Colors.green,
        ),
      );
    } on Exception catch  (e) {
      if (!context.mounted) return;
      // Handle any other types of exceptions
      HandleException.handleExceptions(
        exception: e, 
        context: context, 
        location: "VegetableLocalDataServices.deleteVegetableData"
      );
    }
  }

  static Future<void> deleteLocalVegetableDataAfterUpload(
  {
    required Vegetable vegetable,
  }) async {
    try {
      Database mksc = await DatabaseHelper.database;
      await mksc.delete(
        'Vegetable',
        where: 'name = ? AND created_at = ?',
        whereArgs: [vegetable.name, vegetable.created_at],
      );
    } on Exception catch  (e) {
      HandleException.handleExceptionsWithToast(
        exception: e, 
        location: "VegetableLocalDataServices.deleteVegetableData"
      );
    }
  }
}