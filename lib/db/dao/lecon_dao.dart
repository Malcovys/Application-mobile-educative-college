import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import './dao_factory.dart';
import '../../models/lecon_model.dart';

class LeconDao  {
  final DaoFactory _daofactory;

  static const String table = 'Lecons';

  LeconDao (this._daofactory);

  /// Enregistre une leçon dans la base de données
  Future<void> storeOne(LeconModel lecon) async {
    final Database db = await _daofactory.getDatabaseInstance();
    
    final Map<String, dynamic> mappedLecon = lecon.toJson();

    await db.insert(table, mappedLecon);
  }

  /// Enregistre plusieurs leçons dans la base de données
  Future<void> storeMultiple(List<LeconModel> lecons) async {
    final Database db = await _daofactory.getDatabaseInstance();
    
    db.transaction((trx) async {
      Batch batch = trx.batch();
      
      for(var lecon in lecons) {
        final Map<String, dynamic> mappedLecon = lecon.toJson();

        batch.insert(table, mappedLecon);
      }

      await batch.commit();
    });
  }


  /// Récupère une leçon de la base de données
  Future<LeconModel?> selectOne(int id) async {
    final Database db = await _daofactory.getDatabaseInstance();

    List<Map<String, dynamic>> results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1
    );

    if(results.isEmpty) return null;

    return LeconModel.fromJson(results.first);
  }

  /// Récupère toutes les leçons d'un chapitre dans la base de données
  Future<List<LeconModel>> selectByChapitre(int id) async {
    final Database db = await _daofactory.getDatabaseInstance();

    // Récuperer les lignes
    List<Map<String, dynamic>> list = await db.query(
      table,
      where: 'chapitre_id = ?',
      whereArgs: [id],
    );

    List<LeconModel> lecons = [];
    for (var element in list) {
      lecons.add(LeconModel.fromJson(element));
    }

    print(lecons);

    return lecons;
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