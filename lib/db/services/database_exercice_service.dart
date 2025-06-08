import '../dao/exercice_dao.dart';
import '../dao/dao_factory.dart';
import '../../models/exercice_model.dart';

class DatabaseExerciceService {
  static late ExerciceDao _exerciceDao;
  
  static void initialize() {
    final DaoFactory daoFactory = DaoFactory();
    _exerciceDao = daoFactory.getExerciceDao();
  }

  static Future<void> storeOneExerciceFromAPI(Map<String, Object?> data) async {
    await _exerciceDao.storeOne(ExerciceModel.fromJson(data));
  }

  static Future<void> storeMultipleExercicesFormAPI(List<Map<String, Object?>> data) async {
    List<ExerciceModel> toStoredExercices = [];
    
    for(var element in data) {
      toStoredExercices.add(ExerciceModel.fromJson(element));
    }

    await _exerciceDao.storeMultiple(toStoredExercices);
  }

  
  static Future<ExerciceModel?> getStoredExerciceById(int id) async {
    return await _exerciceDao.selectOne(id);
  }

  static Future<List<ExerciceModel>> getStoredExercicesOfLecon(int id) async {
    return await _exerciceDao.selectByLecon(id);
  }
  

  static Future<void> removeStoredExercice(int id) async {
    await _exerciceDao.delete(id);
  }


  static Future<void> seed() async {
    await _seedExercices();
  }

  static Future<void> _seedExercices() async {
    List<ExerciceModel> exercices = [];

    exercices.addAll([
      ExerciceModel.fromJson({
        'id': 1, 
        'chapitre_id': 1,
        'titre': '',
        'contenu': '', 
        'created_at': DateTime.now(),
        'updated_at': DateTime.now()
      }),
        ExerciceModel.fromJson({
        'id': 2, 
        "chapitre_id": 1,
        'titre': '',
        'contenu': '',
        'created_at': DateTime.now(),
        'updated_at': DateTime.now()
      }),
      ExerciceModel.fromJson({
        'id': 2, 
        'chapitre_id': 1,
        'titre': '',
        'contenu': '', 
        'created_at': DateTime.now(),
        'updated_at': DateTime.now()
      }),
    ]);

    await _exerciceDao.storeMultiple(exercices);
  }
}
