import 'package:sqflite/sqflite.dart';

import './dao_factory.dart';
import '../../models/chapitre_model.dart';

class ChapitreDao {
  final DaoFactory _daofactory;

  static const String table = 'Chapitre';

  ChapitreDao(this._daofactory);

  Future<void> storeMultiple(List<ChapitreModel> chapitres) async {
    final Database db = await _daofactory.getDatabaseInstance();
    
    db.transaction((trx) async {
      Batch batch = trx.batch();
      
      for(var chapitre in chapitres) {
        final Map<String, Object?> mappedChapitre = chapitre.toMap();

        batch.insert(table, mappedChapitre);
      }

      await batch.commit();
    });
  }

  Future<List<ChapitreModel>> selectAll() async {
    List<ChapitreModel> chapitres = List.empty();

    final Database db = await _daofactory.getDatabaseInstance();

    List<Map<String, Object?>> list = await db.rawQuery("select * from ?", [table]);
  
    list.map((element) {
      ChapitreModel matiere = ChapitreModel.fromMap(element);
      chapitres.add(matiere);
    });

    return chapitres;
  }


  // Future<MatiereModel> detail(int id) async {

  // }
}