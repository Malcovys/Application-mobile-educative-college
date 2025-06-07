import 'dart:io';
import 'package:path/path.dart';
import 'sqlfile_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Classe DatabaseHelper pour gérer la base de données SQLite
class DatabaseHelper {
  static Database? _database;
  static final String _dbDbName = 'educative_college.db';
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal() {
     _initializeSQLiteFfi();
  }

  static void _initializeSQLiteFfi() {
    if(Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  /// Méthode pour obtenir une instance de la base de données
  Future<Database> getDatabase() async {
    if(_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _dbDbName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await SQLFileHelper.executeInstructionsFromSQLFile(db, 'lib/db/repositories/database_v1.sql');
      },
      onOpen: (Database db) {
        db.execute('PRAGMA foreign_keys = ON');
      }
    );
  }
}
