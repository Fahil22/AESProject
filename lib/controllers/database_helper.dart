import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Get the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app2.db');
    return _database!;
  }

  // Initialize the database
Future<Database> _initDB(String fileName) async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, fileName);

  return await openDatabase(
    path,
    version: 1, // Increment version
    onCreate: _createDB,
    // onUpgrade: _onUpgrade,
  );
}

  // Create tables
  Future _createDB(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Create passwords table
    await db.execute('''
      CREATE TABLE passwords (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        encrypted_password TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
await db.insert('users', {'username': 'Mohammad22', 'password': '123456'});
await db.insert('users', {'username': 'bakr22', 'password': '123456'});

  }

  // Get user by username and password
  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await instance.database;

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    return result.isNotEmpty ? result.first : null;
  }

  // Insert a new password
  Future<int> insertPassword(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('passwords', row);
  }

  // Update an existing password
  Future<int> updatePassword(Map<String, dynamic> row, int id) async {
    final db = await instance.database;
    return await db.update(
      'passwords',
      row,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a password
  Future<int> deletePassword(int id) async {
    final db = await instance.database;
    return await db.delete(
      'passwords',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get all passwords for a user
  Future<List<Map<String, dynamic>>> getPasswords(int userId) async {
    final db = await instance.database;
    return await db.query(
      'passwords',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }
   Future<void> showAllTablesAndRecords() async {
    final db = await instance.database;

    // Get all table names
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
    );

    for (var table in tables) {
      final tableName = table['name'];
      print('\nTable: $tableName');

      // Get all records in the table
      final records = await db.query(tableName as String);
      if (records.isNotEmpty) {
        for (var record in records) {
          print(record);
        }
      } else {
        print('No records found.');
      }
    }
}
 Future<void> flushDatabase() async {
    final db = await instance.database;

    // Get all table names
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
    );

    // Delete all records from each table
    for (var table in tables) {
      final tableName = table['name'];
      if (tableName != null) {
        print('Flushing table: $tableName');
        await db.delete(tableName as String);
      }
    }

    print('Database flushed successfully.');
  }
Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    // Add the passwords table
    await db.execute('''
      CREATE TABLE passwords (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        encrypted_password TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
      )
    ''');
  }
}}