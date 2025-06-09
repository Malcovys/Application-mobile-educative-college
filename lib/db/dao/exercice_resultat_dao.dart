import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import './dao_factory.dart';
import '../../models/exercice_resultat_model.dart';

class ExerciceResultatDao  {
  final DaoFactory _daofactory;

  static const String table = 'Exercices';

  ExerciceResultatDao (this._daofactory);

  /// Enregistre une resulat dans la base de données
  Future<void> storeOne(ExerciceResultatModel resultat) async {
    final Database db = await _daofactory.getDatabaseInstance();

    await db.insert(table, resultat.toJson());
  }

  /// Enregistre plusieurs resultats dans la base de données
  Future<void> storeMultiple(List<ExerciceResultatModel> resultats) async {
    final Database db = await _daofactory.getDatabaseInstance();
    
    db.transaction((trx) async {
      Batch batch = trx.batch();
      
      for(var resultat in resultats) {
        batch.insert(table, resultat.toJson());
      }

      await batch.commit();
    });
  }


  /// Récupère une resultat de la base de données
  Future<ExerciceResultatModel?> selectOne(int id) async {
    final Database db = await _daofactory.getDatabaseInstance();

    List<Map<String, dynamic>> results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1
    );

    if(results.isEmpty) return null;

    return ExerciceResultatModel.fromJson(results.first);
  }

  /// Récupère les resultats d'une exercices dans la base de données
  Future<List<ExerciceResultatModel>> selectByExercice(int id) async {
    final Database db = await _daofactory.getDatabaseInstance();

    // Récuperer les lignes
    List<Map<String, dynamic>> list = await db.query(
      table,
      where: 'exercice_id = ?',
      whereArgs: [id],
    );

    List<ExerciceResultatModel> resultats = [];
    for (var element in list) {
      resultats.add(ExerciceResultatModel.fromJson(element));
    }

    print(resultats);

    return resultats;
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