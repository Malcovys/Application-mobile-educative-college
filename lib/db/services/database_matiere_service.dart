import 'package:application_mobile_educative_college/db/dao/dao_factory.dart';

import '../dao/matiere_dao.dart';
import '../../models/matiere_model.dart';

import '../../types/types.dart';

class DatabaseMatiereService {
  static late MatiereDao _matiereDao;
  
  static void initialize() {
    final DaoFactory daoFactory = DaoFactory();
    _matiereDao = daoFactory.getMatiereDao();
  }

  static Future<void> storeOneMatiereFromAPI(Map<String, Object?> data) async {
    await _matiereDao.storeOne(MatiereModel.fromMap(data));
  }

  static Future<void> storeMultipleMarieresFormAPI(List<Map<String, Object?>> data) async {
    List<MatiereModel> toStoredMatieres = [];
    
    for(var element in data) {
      toStoredMatieres.add(MatiereModel.fromMap(element));
    }

    await _matiereDao.storeMultiple(toStoredMatieres);
  }


  static Future<List<MatiereModel>> getAllStoredMatieres() async {
    return await _matiereDao.selectAll();
  }

  static Future<MatiereModel?> getStoredMatiereById(int id) async {
    return await _matiereDao.selectOne(id);
  }


  static Future<void> removeStoredMatiere(int id) async {
    await _matiereDao.delete(id);
  }


  static List<MatiereModel> _generateMatieres() {
    List<MatiereModel> matieres = [];

    matieres.addAll([
      MatiereModel.fromMap({
      'id': 1, 
      'nom': 'Physique & chimie',
      'niveau': Niveau.trois.value, 
      'description': '', 
      'created_at': DateTime.now(),
      'updated_at': DateTime.now()
    }),
      MatiereModel.fromMap({
      'id': 2, 
      'nom': 'Science de la vie et de la terre',
      'niveau': Niveau.trois, 
      'description': '', 
      'created_at': DateTime.now(),
      'updated_at': DateTime.now()
    }),
    ]) ;

    return matieres;
  }
}
