import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'aquarium.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fishCount INTEGER,
            fishSpeed REAL,
            fishColor INTEGER
          )
        ''');
      },
    );
  }

  Future<void> saveSettings(int fishCount, double fishSpeed, int fishColor) async {
    final db = await database;
    await db.insert('Settings', {
      'fishCount': fishCount,
      'fishSpeed': fishSpeed,
      'fishColor': fishColor,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>> loadSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('Settings', limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return {
        'fishCount': 0,
        'fishSpeed': 1.0,
        'fishColor': Colors.orange.value,
      };
    }
  }
}
