import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import './dao_factory.dart';
import '../../models/matiere_model.dart';

class MatiereDao {
  final DaoFactory _daofactory;

  static const String table = 'Matieres';

  MatiereDao(this._daofactory);

  /// Enregistre une matiere dans la base de données
  Future<void> storeOne(MatiereModel matiere) async {
    final Database db = await _daofactory.getDatabaseInstance();
    
    final Map<String, Object?> mappedMatiere = matiere.toMap();

    await db.insert(table, mappedMatiere);
  }

  /// Enregistre plusieurs matieres dans la base de données
  Future<void> storeMultiple(List<MatiereModel> matieres) async {
    final Database db = await _daofactory.getDatabaseInstance();
    
    db.transaction((trx) async {
      Batch batch = trx.batch();
      
      for(var matiere in matieres) {
        final Map<String, Object?> mappedMatiere = matiere.toMap();

        batch.insert(table, mappedMatiere);
      }

      await batch.commit();
    });
  }


  /// Récupère une matière de la base de données
  Future<MatiereModel?> selectOne(int id) async {
    final Database db = await _daofactory.getDatabaseInstance();

    List<Map<String, Object?>> results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1
    );

    if(results.isEmpty) return null;

    return MatiereModel.fromMap(results.first);
  }

  /// Récupère toutes les matieres de la base de données
  Future<List<MatiereModel>> selectAll() async {
    final Database db = await _daofactory.getDatabaseInstance();

    // Récuperer les lignes
    List<Map<String, Object?>> list = await db.query(table);

    List<MatiereModel> matieres = [];
    for (var element in list) {
      matieres.add(MatiereModel.fromMap(element));
    }

    return matieres;
  }

  // /// Met à jour une matiere dans la base de données
  // Future<void> updateOne(MatiereModel matiere) async {
  //   final Database db = await _daofactory.getDatabaseInstance();
    
  //   final Map<String, Object?> mappedMatiere = matiere.toMap();

  //   await db.update(
  //     table, 
  //     mappedMatiere, 
  //     where: 'id = ?', 
  //     whereArgs: [matiere.getId()]
  //   );
  // }


  Future<void> delete(int id) async {
    final Database db = await _daofactory.getDatabaseInstance();

    db.delete(
      table, 
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}