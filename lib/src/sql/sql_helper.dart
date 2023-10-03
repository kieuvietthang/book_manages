import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        book_title TEXT,
        money TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<void> createManageTables(sql.Database database) async {
    await database.execute("""CREATE TABLE manages(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        name TEXT,
        year_of_birth TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbtech.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
        await createManageTables(database);
      },
    );
  }

  static Future<int> createItem(String title, String? bookTitle, String? money) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'book_title': bookTitle,'money':money};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(
      int id, String title, String? bookTitle, String? money) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'book_title': bookTitle,
      'money': money,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }



  static Future<int> createManage(
      String title, String? name, String? yearOfBirth) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'name': name, 'year_of_birth': yearOfBirth};
    final id = await db.insert('manages', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getManages() async {
    final db = await SQLHelper.db();
    return db.query('manages', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getManage(int id) async {
    final db = await SQLHelper.db();
    return db.query('manages', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateManage(
      int id, String title, String? name, String? yearOfBirth) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'name': name,
      'year_of_birth': yearOfBirth,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('manages', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteManage(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("manages", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}