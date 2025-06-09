import '../dao/exercice_resultat_dao.dart';
import '../dao/dao_factory.dart';
import '../../models/exercice_resultat_model.dart';

class DatabaseExerciceResultatService {
  static late ExerciceResultatDao _exerciceResultatDao;
  
  static void initialize() {
    final DaoFactory daoFactory = DaoFactory();
    _exerciceResultatDao = daoFactory.getExerciceResultatDao();
  }

  static Future<void> storeOneResultatFromAPI(Map<String, Object?> data) async {
    await _exerciceResultatDao.storeOne(ExerciceResultatModel.fromJson(data));
  }

  static Future<void> storeMultipleExerciceResultatsFormAPI(List<Map<String, Object?>> data) async {
    List<ExerciceResultatModel> toStoredExerciceResultats = [];
    
    for(var element in data) {
      toStoredExerciceResultats.add(ExerciceResultatModel.fromJson(element));
    }

    await _exerciceResultatDao.storeMultiple(toStoredExerciceResultats);
  }

  
  static Future<ExerciceResultatModel?> getStoredResultateById(int id) async {
    return await _exerciceResultatDao.selectOne(id);
  }

  static Future<List<ExerciceResultatModel>> getStoredResultatsOfExercice(int id) async {
    return await _exerciceResultatDao.selectByExercice(id);
  }
  

  static Future<void> removeStoredResultat(int id) async {
    await _exerciceResultatDao.delete(id);
  }


  static Future<void> seed() async {
    await _seedResultats();
  }

  static Future<void> _seedResultats() async {
    List<ExerciceResultatModel> resulats = [];

    resulats.addAll([
      ExerciceResultatModel.fromJson({
        'id': 1,
        'exercice_id': 1,
        'reponses': [
          {'question_idx': 1, 'selected': 'A', 'correct': true},
          {'question_idx': 2, 'selected': 'A', 'correct': false},
          {'question_idx': 3, 'selected': 'B', 'correct': false},
        ],
        'score': 10,
        'etat': ResultatEtat.sync,
        'date_de_soumission': DateTime.now()
      }),
    ]);

    await _exerciceResultatDao.storeMultiple(resulats);
  }
}
