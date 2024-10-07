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

  static Future addIndexes(Database db, int version) async {
    await db.execute('''
      CREATE INDEX idx_chicken_house_id ON ChickenHouse (id);
    ''');
  }
}
