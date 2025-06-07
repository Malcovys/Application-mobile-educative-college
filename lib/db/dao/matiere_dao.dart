import 'package:sqflite/sqflite.dart';

import './dao_factory.dart';
import '../../models/matiere_model.dart';

class MatiereDao {
  final DaoFactory _daofactory;

  static const String table = 'Matieres';

  MatiereDao(this._daofactory);

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

  Future<List<MatiereModel>> selectAll() async {
    List<MatiereModel> matieres = List.empty();

    final Database db = await _daofactory.getDatabaseInstance();

    List<Map<String, Object?>> list = await db.rawQuery("select * from ?", [table]);
  
    list.map((element) {
      MatiereModel matiere = MatiereModel.fromMap(element);
      matieres.add(matiere);
    });

    return matieres;
  }


  // Future<MatiereModel> detail(int id) async {

  // }
}