import 'package:flutter/material.dart';
import 'package:mksc/services/database_services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() {
    return _instance;
  }
  static Database? _database;
  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase(); // Initialize the database if it's null
    return _database!;
  }

  // Method to initialize the database
  static Future<Database> _initDatabase() async {
    // Get the path to the databases directory and create the 'task_anchor.db' database
    debugPrint("\n\n\nCreating database...\n\n\n");
    String path = join(await getDatabasesPath(), 'mksc.db');
    debugPrint("\n\n\nDatabase Path $path...\n\n\n");
    // Open the database and set the version and onCreate callback
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future _onCreate(Database db, int version) async{
    // When the database is created, create the tables
    await DatabaseServices.createChickenHouseTable(db, version);
    await DatabaseServices.addIndexes(db, version);

    await _printSchema(db, "ChickenHouse");
  }

  // Method to print the schema of a specific table
  static Future<void> _printSchema(Database db, String tableName) async {
    List<Map<String, dynamic>> result = await db.rawQuery('PRAGMA table_info($tableName);');
    debugPrint('\n\n\nSchema for table $tableName:');
    for (var row in result) {
      debugPrint("$row");
    }
  }
}