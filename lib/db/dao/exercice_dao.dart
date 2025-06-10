import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import './dao_factory.dart';
import '../../models/exercice_model.dart';

class ExerciceDao  {
  final DaoFactory _daofactory;

  static const String table = 'Exercices';

  ExerciceDao (this._daofactory);

  /// Enregistre une exercice dans la base de données
  Future<void> storeOne(ExerciceModel exercice) async {
    final Database db = await _daofactory.getDatabaseInstance();

    await db.insert(table, exercice.toJson());
  }

  /// Enregistre plusieurs exercices dans la base de données
  Future<void> storeMultiple(List<ExerciceModel> exercices) async {
    final Database db = await _daofactory.getDatabaseInstance();
    
    db.transaction((trx) async {
      Batch batch = trx.batch();
      
      for(var exercice in exercices) {
        batch.insert(table, exercice.toJson());
      }

      await batch.commit();
    });
  }


  /// Récupère une exercice de la base de données
  Future<ExerciceModel?> selectOne(int id) async {
    final Database db = await _daofactory.getDatabaseInstance();

    List<Map<String, dynamic>> results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1
    );

    if(results.isEmpty) return null;

    return ExerciceModel.fromJson(results.first);
  }

  /// Récupère toutes les exercices d'une leçons dans la base de données
  Future<List<ExerciceModel>> selectByLecon(int id) async {
    final Database db = await _daofactory.getDatabaseInstance();

    // Récuperer les lignes
    List<Map<String, dynamic>> list = await db.query(
      table,
      where: 'lecon_id = ?',
      whereArgs: [id],
    );

    List<ExerciceModel> exercices = [];
    for (var element in list) {
      exercices.add(ExerciceModel.fromJson(element));
    }

    print(exercices);

    return exercices;
  }

  

  Future<void> delete(int id) async {
    final Database db = await _daofactory.getDatabaseInstance();

    db.delete(
      table, 
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}