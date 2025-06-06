import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;


class SQLFileHelper {

  static Future<void> executeInstructionsFromSQLFile(Database db, String path) async {
    List<String> sqlInstructions = await loadInstructionsFromSQLFile(path);

    for(String instruction in sqlInstructions) {
      if(instruction.trim().isNotEmpty) {
        await db.execute(instruction);
      }
    }
  }

  static Future<List<String>> loadInstructionsFromSQLFile(String path) async {
    // Charger le fichier SQL
    String sqlScript = await rootBundle.loadString(path);

    // Diviser le script en instructions individuelles
    List<String> sqlInstructions = sqlScript.split(';')
      .where((instruction) => instruction.trim().isNotEmpty)
      .toList();

    return sqlInstructions;
  }
}