import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DB {
  static const String _dbName = 'chat-app.db';
  static const String usersTable = 'users';
  static const String _createDb =
      'CREATE TABLE users (uid TEXT PRIMARY KEY, username TEXT);';

  static Future<Database> _getDB() async {
    final db = await sql.openDatabase(
        path.join(await sql.getDatabasesPath(), DB._dbName),
        onCreate: (db, version) => db.execute(_createDb),
        version: 1);
    return db;
  }

  static Future<void> insert(
      String tableName, Map<String, dynamic> values) async {
    final db = await _getDB();
    // Updates Existing Entry, else Inserts new one!
    await db.insert(tableName, values,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String tableName) async {
    final db = await _getDB();
    return db.query(tableName);
  }

  static Future<void> reset() async {
    await sql
        .deleteDatabase(path.join(await sql.getDatabasesPath(), DB._dbName));
  }
}
