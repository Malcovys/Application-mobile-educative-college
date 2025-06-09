import '../dao/dao_factory.dart';
import '../dao/chapitre_dao.dart';
import '../../models/chapitre_model.dart';

class DatabaseChapitreService {
  static late ChapitreDao _chapitreDao;
  
  static void initialize() {
    final DaoFactory daoFactory = DaoFactory();
    _chapitreDao = daoFactory.getChapitreDao();
  }

  static Future<void> storeOneChapitreFromAPI(Map<String, Object?> data) async {
    await _chapitreDao.storeOne(ChapitreModel.fromJson(data));
  }

  static Future<void> storeMultipleMarieresFormAPI(List<Map<String, Object?>> data) async {
    List<ChapitreModel> toStoredChapitres = [];
    
    for(var element in data) {
      toStoredChapitres.add(ChapitreModel.fromJson(element));
    }

    await _chapitreDao.storeMultiple(toStoredChapitres);
  }

  
  static Future<ChapitreModel?> getStoredChapitreById(int id) async {
    return await _chapitreDao.selectOne(id);
  }

  static Future<List<ChapitreModel>> getStoredChapitresOfMatiere(int id) async {
    return await _chapitreDao.selectByMatiere(id);
  }
  

  static Future<void> removeStoredChapitre(int id) async {
    await _chapitreDao.delete(id);
  }


  static Future<void> seed() async {
    await _seedChapitres();
  }

  static Future<void> _seedChapitres() async {
    List<ChapitreModel> chapitres = [];

    chapitres.addAll([
      ChapitreModel.fromJson({
        'id': 1, 
        "matiere_id": 1,
        'nom': 'Les états de la matière',
        'description': '', 
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      }),
        ChapitreModel.fromJson({
        'id': 2, 
        "matiere_id": 1,
        'nom': 'Les transformations chimiques',
        'description': '', 
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      }),
      ChapitreModel.fromJson({
        'id': 3, 
        "matiere_id": 1,
        'nom': "L'organisation de la matière dans l'Univers",
        'description': '', 
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String()
      }),
    ]);

    await _chapitreDao.storeMultiple(chapitres);
  }
}
