import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'sqlfile_helper.dart';

/// Classe DatabaseHelper pour gérer la base de données SQLite
class DatabaseHelper {
  static Database? _database;
  static final String _dbDbName = 'educative_college.db';
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  

  /// Factory constructor pour obtenir l'instance unique de DatabaseHelper
  factory DatabaseHelper() {
    return _instance;
  }

  // Contructeur nommé privé
  DatabaseHelper._internal();

  /// Méthode pour obtenir une instance de la base de données
  Future<Database> getDatabase() async {
    if(_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
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
