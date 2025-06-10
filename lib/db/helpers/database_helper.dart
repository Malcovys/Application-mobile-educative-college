import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'sql_file_helper.dart';

class DatabaseHelper {
  static Database? _database;
  static const _dbName = 'educative_college.db';
  static final DatabaseHelper instance = DatabaseHelper._internal();

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal() {
    _initializeFactory();
  }

  void _initializeFactory() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Desktop : initialise FFI
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    } else {
      // Mobile (Android/iOS) : sqlite3_flutter_libs doit être dans pubspec.yaml
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, _dbName);

    return await databaseFactory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await SQLFileHelper.executeInstructionsFromSQLFile(
            db,
            'lib/db/repositories/database_v1.sql',
          );
        },
        onOpen: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },
      ),
    );
  }

  Future<void> deleteDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, _dbName);
    if (await databaseFactory.databaseExists(path)) {
      await databaseFactory.deleteDatabase(path);
      _database = null;
      if (kDebugMode) {
        print('Base de données supprimée : $path');
      }
    }
  }
}
