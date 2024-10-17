import 'package:sqflite/sqflite.dart';

class DatabaseServices {
  
  static Future createChickenHouseTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ChickenHouse (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item VARCHAR(222) NOT NULL,
        number VARCHAR(222) NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      );
    ''');
  }

  static Future createVegeTableTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE VegeTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tempId INTEGER DEFAULT NULL,
        name VARCHAR(222) NOT NULL,
        image VARCHAR(222) DEFAULT NULL,
        number VARCHAR(222) DEFAULT NULL,
        camp VARCHAR(222) DEFAULT NULL,
        unit VARCHAR(222) DEFAULT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      );
    ''');
  }

  static Future createBaseVegeTableTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE BaseVegeTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(222) NOT NULL,
        image VARCHAR(222) DEFAULT NULL
      );
    ''');
  }

  static Future addIndexes(Database db, int version) async {
    await db.execute('''
      CREATE INDEX idx_chicken_house_id ON ChickenHouse (id);
      CREATE INDEX idx_vegetable_id ON VegeTable (id);
      CREATE INDEX idx_base_vegetable_id ON BaseVegeTable (id);
    ''');
  }
}
