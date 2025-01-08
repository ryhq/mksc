import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mksc/helper/database_helper.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:mksc/services/handle_exception.dart';
import 'package:sqflite/sqlite_api.dart';

class ChickenHouseLocalServices {

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
  
  static Future<List<ChickenHouseData>> fetchChickenHousesLocalData({
    required BuildContext context,
    required String date,
  }) async {
    try {
      Database db = await DatabaseHelper.database;
      List<Map<String, dynamic>> chickenHouseMap = await db.query(
        'ChickenHouse',
        where: 'created_at = ? ',
        whereArgs: [date,],
        orderBy: 'created_at ASC',
      );
      List<ChickenHouseData> chickenHouseList = chickenHouseMap.map((entry) => ChickenHouseData.fromJson(entry)).toList();
      return chickenHouseList;
    } on Exception catch (exception) {
      if (!context.mounted) return List<ChickenHouseData>.empty();
      HandleException.handleExceptions(
        exception: exception,
        context: context,
        location: "ChickenHouseLocalServices.fetchChickenHousesLocalData",
      );
      return List<ChickenHouseData>.empty();
    }
  }

  static Future<List<ChickenHouseData>> fetchChickenHousesAllLocalData(
    {
      required BuildContext context
    }
  ) async {
    try {
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
        location: "ChickenHouseLocalServices.fetchChickenHousesAllLocalData"
      );
    }
    return List<ChickenHouseData>.empty();
  }

  static Future<void> saveChickenHouseLocalData({
    required BuildContext context,
    required String item,
    required int number,
    required String date,
  }) async {
    try {
      Database db = await DatabaseHelper.database;

      // Fetch existing items to check for duplicates on the same date
      List<Map<String, dynamic>> chickenHouseMap = await db.query(
        'ChickenHouse',
        where: 'created_at = ? ',
        whereArgs: [date,],
        orderBy: 'created_at ASC',
      );
      List<ChickenHouseData> chickenHouseList = chickenHouseMap.map((entry) => ChickenHouseData.fromJson(entry)).toList();

      // Check for duplicate
      for (var house in chickenHouseList) {
        if (house.item.toLowerCase() == item.toLowerCase()) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "The item '$item' already exists, added on ${house.created_at}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            )
          );
          return;
        }
      }

      await db.insert(
        'ChickenHouse',
        {
          "item": item,
          "number": number,
          "created_at": date,
        },
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully saved $item on $date.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception,
        context: context,
        location: "ChickenHouseLocalServices.saveChickenHouseLocalData",
      );
    }
  }

  static Future<void> editChickenHouseLocalData({
    required BuildContext context,
    required ChickenHouseData chickenHouseData,
    required int number,
  }) async {
    try {
      Database db = await DatabaseHelper.database;

      await db.update(
        'ChickenHouse',
        {
          "item": chickenHouseData.item,
          "number": number,
          "updatedAt": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        },
        where: 'id = ? AND created_at = ?',
        whereArgs: [chickenHouseData.id, chickenHouseData.created_at],
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully updated ${chickenHouseData.item} to $number.'),
          backgroundColor: Colors.green,
        ),
      );
    } on Exception catch (exception) {
      HandleException.handleExceptions(
        exception: exception,
        context: context,
        location: "ChickenHouseLocalServices.editChickenHouseLocalData",
      );
    }
  }

  static Future<void> deleteChickenHouseLocalData({
    required BuildContext context,
    required ChickenHouseData chickenHouseData,
  }) async {
    try {
      Database db = await DatabaseHelper.database;
      await db.delete(
        'ChickenHouse',
        where: 'id = ? AND created_at = ?',
        whereArgs: [chickenHouseData.id, chickenHouseData.created_at],
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully deleted ${chickenHouseData.item}.'),
          backgroundColor: Colors.green,
        ),
      );
    } on Exception catch (exception) {
      HandleException.handleExceptions(
        exception: exception,
        context: context,
        location: "ChickenHouseLocalServices.deleteChickenHouseLocalData",
      );
    }
  }

  static Future<void> deleteChickenHouseLocalDataAfterUpload({
    required ChickenHouseData chickenHouseData,
  }) async {
    try {
      Database db = await DatabaseHelper.database;
      await db.delete(
        'ChickenHouse',
        where: 'id = ? AND created_at = ?',
        whereArgs: [chickenHouseData.id, chickenHouseData.created_at],
      );
    } on Exception catch (exception) {
      HandleException.handleExceptionsWithToast(
        exception: exception,
        location: "ChickenHouseLocalServices.deleteChickenHouseLocalData",
      );
    }
  }
}
