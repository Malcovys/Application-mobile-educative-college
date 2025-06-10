import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import './dao_factory.dart';
import '../../models/chapitre_model.dart';

class ChapitreDao {
  final DaoFactory _daofactory;

  static const String table = 'Chapitres';

  ChapitreDao(this._daofactory);

  /// Enregistre un chapitre dans la base de données
  Future<void> storeOne(ChapitreModel chapitre) async {
    final Database db = await _daofactory.getDatabaseInstance();
    
    final Map<String, dynamic> mappedChapitre = chapitre.toJson();

    await db.insert(table, mappedChapitre);
  }

  /// Enregistre plusieurs chapitres dans la base de données
  Future<void> storeMultiple(List<ChapitreModel> chapitres) async {
    final Database db = await _daofactory.getDatabaseInstance();
    
    db.transaction((trx) async {
      Batch batch = trx.batch();
      
      for(var chapitre in chapitres) {
        final Map<String, dynamic> mappedChapitre = chapitre.toJson();

        batch.insert(table, mappedChapitre);
      }

      await batch.commit();
    });
  }


  /// Récupère un chapitre de la base de données
  Future<ChapitreModel?> selectOne(int id) async {
    final Database db = await _daofactory.getDatabaseInstance();

    List<Map<String, dynamic>> results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1
    );

    if(results.isEmpty) return null;

    return ChapitreModel.fromJson(results.first);
  }

  /// Récupère toutes les chapitres d'une matiere de la base de données
  Future<List<ChapitreModel>> selectByMatiere(int id) async {
    final Database db = await _daofactory.getDatabaseInstance();

    // Récuperer les lignes
    List<Map<String, dynamic>> list = await db.query(
      table,
      where: 'matiere_id = ?',
      whereArgs: [id],
    );

    List<ChapitreModel> chapitres = [];
    for (var element in list) {
      chapitres.add(ChapitreModel.fromJson(element));
    }

    if (kDebugMode) {
      print(chapitres);
    }

    return chapitres;
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